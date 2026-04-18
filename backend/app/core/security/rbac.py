"""Role helpers for FastAPI dependencies (business roles: admin > encargado > empleado)."""

from collections.abc import Callable
from typing import Annotated, Any

from fastapi import Depends, HTTPException, status

from app.core.security.jwt import get_current_claims

_ROLE_RANK: dict[str, int] = {"empleado": 0, "encargado": 1, "admin": 2}


def app_role_from_claims(claims: dict[str, Any]) -> str:
    meta = claims.get("user_metadata") or {}
    role = meta.get("app_role")
    if isinstance(role, str) and role in _ROLE_RANK:
        return role
    return "empleado"


def require_app_roles(*allowed: str) -> Callable[..., dict[str, Any]]:
    allowed_set = set(allowed)

    async def _dependency(
        claims: Annotated[dict[str, Any], Depends(get_current_claims)],
    ) -> dict[str, Any]:
        role = app_role_from_claims(claims)
        if role not in allowed_set:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Rol insuficiente para esta operación",
            )
        return claims

    return _dependency


def require_min_role(min_role: str) -> Callable[..., dict[str, Any]]:
    min_rank = _ROLE_RANK.get(min_role, 0)

    async def _dependency(
        claims: Annotated[dict[str, Any], Depends(get_current_claims)],
    ) -> dict[str, Any]:
        role = app_role_from_claims(claims)
        if _ROLE_RANK.get(role, 0) < min_rank:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Rol insuficiente para esta operación",
            )
        return claims

    return _dependency
