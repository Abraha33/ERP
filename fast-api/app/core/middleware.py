"""Application middleware: CORS, request ID, and tenant context logging."""

import uuid

from fastapi import FastAPI, Request, Response
from fastapi.middleware.cors import CORSMiddleware
from starlette.middleware.base import BaseHTTPMiddleware, RequestResponseEndpoint

from app.core.config import settings


def register_middleware(app: FastAPI) -> None:
    """Register all middleware on the FastAPI app. Call once at startup."""

    # 1. CORS
    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.ALLOWED_ORIGINS,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    # 2. Request ID — injects X-Request-ID into every request/response
    app.add_middleware(RequestIDMiddleware)


class RequestIDMiddleware(BaseHTTPMiddleware):
    """Attach a unique X-Request-ID to every request and response.

    - Uses the incoming X-Request-ID header if provided by the client/gateway.
    - Otherwise generates a new UUID4.
    - Stored in request.state.request_id for use in error handlers and logs.
    """

    async def dispatch(
        self, request: Request, call_next: RequestResponseEndpoint
    ) -> Response:
        request_id = request.headers.get("X-Request-ID") or str(uuid.uuid4())
        request.state.request_id = request_id
        response: Response = await call_next(request)
        response.headers["X-Request-ID"] = request_id
        return response
