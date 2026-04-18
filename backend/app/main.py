from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.core.errors import add_exception_handlers

app = FastAPI(
    title="ERP Satélite API",
    version="0.1.0",
    docs_url="/api/docs" if settings.ENV != "production" else None,
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

add_exception_handlers(app)


@app.get("/health")
async def health():
    return {"status": "ok", "env": settings.ENV}
