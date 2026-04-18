"""Role helpers and tenant claim extractors for FastAPI dependencies.

Business roles: admin > encargado > empleado
Tenant claims: empresa_id, sucursal_id (extracted from JWT user_metadata)
"""

from collections.abc import Callable
from typing import Annotated, Any
from uuid import UUID

from fastapi import Depends, HTTPException, status

from app.core.security.jwt import get_current_claims

_ROLE_RANK: dict[str, int] = {"empleado": 0, "encargado": 1, "admin": 2}


# ---------------------------------------------------------------------------
# Claim extractors
# ---------------------------------------------------------------------------

def app_role_from_claims(claims: dict[str, Any]) -> str:
    meta = claims.get("user_metadata") or {}
    role = meta.get("app_role")
    if isinstance(role, str) and role in _ROLE_RANK:
        return role
    return "empleado"


def empresa_id_from_claims(claims: dict[str, Any]) -> UUID:
    """Extract empresa_id (UUID) from JWT user_metadata. Raises 403 if missing."""
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
    """Extract sucursal_id (UUID) from JWT user_metadata. Returns None if absent."""
    meta = claims.get("user_metadata") or {}
    raw = meta.get("sucursal_id")
    if not raw:
        return None
    try:
        return UUID(str(raw))
    except ValueError:
        return None


# ---------------------------------------------------------------------------
# Reusable FastAPI dependency — injects full tenant context
# ---------------------------------------------------------------------------

class TenantContext:
    """Parsed tenant + role context injected into route handlers via Depends."""

    __slots__ = ("user_id", "empresa_id", "sucursal_id", "role", "claims")

    def __init__(self, claims: dict[str, Any]) -> None:
        self.claims = claims
        self.user_id: str = claims.get("sub", "")
        self.empresa_id: UUID = empresa_id_from_claims(claims)
        self.sucursal_id: UUID | None = sucursal_id_from_claims(claims)
        self.role: str = app_role_from_claims(claims)


async def get_tenant_context(
    claims: Annotated[dict[str, Any], Depends(get_current_claims)],
) -> TenantContext:
    """FastAPI dependency — resolves JWT claims into a typed TenantContext.

    Usage in a router:
        @router.get("/items")
        async def list_items(ctx: Annotated[TenantContext, Depends(get_tenant_context)]):
            # ctx.empresa_id, ctx.sucursal_id, ctx.role all available
    """
    return TenantContext(claims)


# ---------------------------------------------------------------------------
# Role-based access guards
# ---------------------------------------------------------------------------

def require_app_roles(*allowed: str) -> Callable[..., TenantContext]:
    """Dependency factory: allow only specific roles.

    Example:
        Depends(require_app_roles("admin", "encargado"))
    """
    allowed_set = set(allowed)

    async def _dependency(
        ctx: Annotated[TenantContext, Depends(get_tenant_context)],
    ) -> TenantContext:
        if ctx.role not in allowed_set:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Rol insuficiente para esta operación",
            )
        return ctx

    return _dependency


def require_min_role(min_role: str) -> Callable[..., TenantContext]:
    """Dependency factory: allow roles at or above a minimum rank.

    Example:
        Depends(require_min_role("encargado"))  # allows encargado + admin
    """
    min_rank = _ROLE_RANK.get(min_role, 0)

    async def _dependency(
        ctx: Annotated[TenantContext, Depends(get_tenant_context)],
    ) -> TenantContext:
        if _ROLE_RANK.get(ctx.role, 0) < min_rank:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Rol insuficiente para esta operación",
            )
        return ctx

    return _dependency
