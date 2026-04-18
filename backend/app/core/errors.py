from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
import uuid


def add_exception_handlers(app: FastAPI):
    @app.exception_handler(Exception)
    async def global_handler(request: Request, exc: Exception):
        return JSONResponse(
            status_code=500,
            content={
                "error": "INTERNAL_ERROR",
                "detail": "Error interno del servidor",
                "request_id": str(uuid.uuid4()),
            },
        )
