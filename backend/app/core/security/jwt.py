"""Validate Supabase Auth JWTs using the project's JWKS endpoint."""

import time
from typing import Any

import httpx
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from jose import jwk, jwt
from jose.exceptions import JWTError

from app.core.config import settings

_security = HTTPBearer(auto_error=False)

# JWKS cache with TTL (10 minutes) to survive key rotations
_jwks_cache: dict[str, Any] = {"doc": None, "fetched_at": 0.0}
_JWKS_TTL = 600  # seconds


def _jwks_url() -> str:
    return f"{settings.SUPABASE_URL.rstrip('/')}/auth/v1/.well-known/jwks.json"


async def _jwks_document() -> dict[str, Any]:
    """Fetch JWKS with a 10-minute TTL cache. Refreshes automatically on expiry."""
    now = time.monotonic()
    if _jwks_cache["doc"] is None or (now - _jwks_cache["fetched_at"]) > _JWKS_TTL:
        async with httpx.AsyncClient(timeout=10.0) as client:
            response = await client.get(_jwks_url())
            response.raise_for_status()
            _jwks_cache["doc"] = response.json()
            _jwks_cache["fetched_at"] = now
    return _jwks_cache["doc"]  # type: ignore[return-value]


async def _signing_key_for_token(token: str) -> Any:
    jwks = await _jwks_document()
    header = jwt.get_unverified_header(token)
    kid = header.get("kid")
    for key_data in jwks.get("keys", []):
        if key_data.get("kid") == kid:
            return jwk.construct(key_data)
    # kid not found — cache may be stale, force refresh and retry once
    _jwks_cache["fetched_at"] = 0.0
    jwks = await _jwks_document()
    for key_data in jwks.get("keys", []):
        if key_data.get("kid") == kid:
            return jwk.construct(key_data)
    raise JWTError("Signing key not found in JWKS")


async def decode_supabase_jwt(token: str) -> dict[str, Any]:
    """Decode and validate a Supabase-issued access token (RS256 + JWKS)."""
    key = await _signing_key_for_token(token)
    issuer = f"{settings.SUPABASE_URL.rstrip('/')}/auth/v1"
    return jwt.decode(
        token,
        key,
        algorithms=["RS256"],
        audience="authenticated",
        issuer=issuer,
    )


async def get_current_claims(
    creds: HTTPAuthorizationCredentials | None = Depends(_security),
) -> dict[str, Any]:
    if creds is None or creds.scheme.lower() != "bearer":
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Se requiere token Bearer",
        )
    try:
        return await decode_supabase_jwt(creds.credentials)
    except JWTError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token inválido o expirado",
        ) from None
