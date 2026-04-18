"""Validate Supabase Auth JWTs using the project's JWKS endpoint."""

from functools import lru_cache
from typing import Any

import httpx
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from jose import jwt, jwk
from jose.exceptions import JWTError

from app.core.config import settings

_security = HTTPBearer(auto_error=False)


def _jwks_url() -> str:
    return f"{settings.SUPABASE_URL.rstrip('/')}/auth/v1/.well-known/jwks.json"


@lru_cache(maxsize=1)
def _jwks_document(url: str) -> dict[str, Any]:
    with httpx.Client(timeout=10.0) as client:
        response = client.get(url)
        response.raise_for_status()
        return response.json()


def _signing_key_for_token(token: str) -> Any:
    jwks = _jwks_document(_jwks_url())
    header = jwt.get_unverified_header(token)
    kid = header.get("kid")
    for key_data in jwks.get("keys", []):
        if key_data.get("kid") == kid:
            return jwk.construct(key_data)
    raise JWTError("Signing key not found in JWKS")


def decode_supabase_jwt(token: str) -> dict[str, Any]:
    """Decode and validate a Supabase-issued access token (RS256 + JWKS)."""
    key = _signing_key_for_token(token)
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
        return decode_supabase_jwt(creds.credentials)
    except JWTError:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token inválido o expirado",
        ) from None
