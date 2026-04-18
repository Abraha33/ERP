"""Role helpers and tenant claim extractors for FastAPI dependencies.

Roles de aplicación (orden de privilegio descendente):
    admin > encargado > auditor > cajero > bodeguero > empleado

Fuente de verdad: tabla public.roles en Supabase.
IDs fijos: admin=b010…, encargado=b020…, auditor=b050…,
           cajero=b030…, bodeguero=b040…, empleado=b060…

NOTA: app_role_from_claims() lee el rol desde JWT user_metadata.
Para que sea consistente con la DB, Supabase debe emitir el claim
'app_role' en el token via Custom Access Token Hook (auth hook)
que lea public.app_role() en cada login.
Sin ese hook, el rol en el JWT puede quedar desactualizado si
cambia en user_roles.
"""

from collections.abc import Callable
from typing import Annotated, Any
from uuid import UUID

from fastapi import Depends, HTTPException, status

from app.core.security.jwt import get_current_claims

# Ranking completo alineado con public.roles en Supabase
# Mayor número = mayor privilegio
_ROLE_RANK: dict[str, int] = {
    "empleado":  0,
    "bodeguero": 1,
    "cajero":    2,
    "auditor":   3,
    "encargado": 4,
    "admin":     5,
}

# Conjunto de roles válidos (igual que codigos en public.roles)
_VALID_ROLES = frozenset(_ROLE_RANK.keys())


# ---------------------------------------------------------------------------
# Claim extractors
# ---------------------------------------------------------------------------

def app_role_from_claims(claims: dict[str, Any]) -> str:
    """Lee app_role desde JWT user_metadata.

    Supabase incluye user_metadata en el access token.
    El valor debe ser uno de: admin, encargado, auditor, cajero, bodeguero, empleado.
    Si no viene o es inválido, retorna 'empleado' (rol mínimo) por seguridad.
    """
    meta = claims.get("user_metadata") or {}
    role = meta.get("app_role")
    if isinstance(role, str) and role.lower() in _VALID_ROLES:
        return role.lower()
    return "empleado"


def empresa_id_from_claims(claims: dict[str, Any]) -> UUID:
    """Extrae empresa_id (UUID) desde JWT user_metadata. Lanza 403 si no existe."""
    meta = claims.get("user_metadata") or {}
    raw = meta.get("empresa_id")
    if not raw:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Token no contiene empresa_id",
        )
    try:
        return UUID(str(raw))
    except ValueError:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="empresa_id inválido en token",
        ) from None


def sucursal_id_from_claims(claims: dict[str, Any]) -> UUID | None:
    """Extrae sucursal_id (UUID) desde JWT user_metadata. Retorna None si no existe."""
    meta = claims.get("user_metadata") or {}
    raw = meta.get("sucursal_id")
    if not raw:
        return None
    try:
        return UUID(str(raw))
    except ValueError:
        return None


# ---------------------------------------------------------------------------
# TenantContext — contexto completo de tenant + rol por request
# ---------------------------------------------------------------------------

class TenantContext:
    """Contexto de tenant y rol extraído del JWT. Se inyecta via Depends().

    Campos:
        user_id     — sub del JWT (UUID del usuario en auth.users)
        empresa_id  — UUID del tenant activo
        sucursal_id — UUID de la sucursal activa (puede ser None)
        role        — rol de app: admin|encargado|auditor|cajero|bodeguero|empleado
        claims      — dict completo de claims del JWT (para uso avanzado)
    """

    __slots__ = ("user_id", "empresa_id", "sucursal_id", "role", "claims")

    def __init__(self, claims: dict[str, Any]) -> None:
        self.claims = claims
        self.user_id: str = claims.get("sub", "")
        self.empresa_id: UUID = empresa_id_from_claims(claims)
        self.sucursal_id: UUID | None = sucursal_id_from_claims(claims)
        self.role: str = app_role_from_claims(claims)

    def has_role(self, *roles: str) -> bool:
        """True si el rol del usuario está en el conjunto dado."""
        return self.role in roles

    def has_min_role(self, min_role: str) -> bool:
        """True si el rol del usuario es >= al rol mínimo indicado."""
        return _ROLE_RANK.get(self.role, 0) >= _ROLE_RANK.get(min_role, 0)


async def get_tenant_context(
    claims: Annotated[dict[str, Any], Depends(get_current_claims)],
) -> TenantContext:
    """FastAPI dependency — resuelve claims JWT a TenantContext tipado.

    Uso en router:
        @router.get("/items")
        async def list_items(ctx: Annotated[TenantContext, Depends(get_tenant_context)]):
            empresa_id = ctx.empresa_id   # UUID listo para filtrar
            role       = ctx.role         # "admin" | "encargado" | ...
    """
    return TenantContext(claims)


# ---------------------------------------------------------------------------
# Guards reutilizables
# ---------------------------------------------------------------------------

def require_app_roles(*allowed: str) -> Callable[..., TenantContext]:
    """Factory: solo permite roles específicos.

    Ejemplo:
        Depends(require_app_roles("admin", "encargado"))
    """
    allowed_set = {r.lower() for r in allowed}

    async def _dep(
        ctx: Annotated[TenantContext, Depends(get_tenant_context)],
    ) -> TenantContext:
        if ctx.role not in allowed_set:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Rol insuficiente para esta operación",
            )
        return ctx

    return _dep


def require_min_role(min_role: str) -> Callable[..., TenantContext]:
    """Factory: permite rol mínimo y superiores.

    Ejemplo:
        Depends(require_min_role("encargado"))  # permite encargado + admin
    """
    min_rank = _ROLE_RANK.get(min_role.lower(), 0)

    async def _dep(
        ctx: Annotated[TenantContext, Depends(get_tenant_context)],
    ) -> TenantContext:
        if _ROLE_RANK.get(ctx.role, 0) < min_rank:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Rol insuficiente para esta operación",
            )
        return ctx

    return _dep
