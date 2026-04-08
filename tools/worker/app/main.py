"""FastAPI worker (jobs pesados, importaciones). Sin tablas: solo health check."""
import os
from pathlib import Path

from dotenv import load_dotenv
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

_REPO_ROOT = Path(__file__).resolve().parents[2]
load_dotenv(_REPO_ROOT / ".env")

app = FastAPI(title="ERP Satélite worker", version="0.1.0")

_origins_raw = os.environ.get("ALLOWED_ORIGINS", "")
_origins = [o.strip() for o in _origins_raw.split(",") if o.strip()]
if _origins:
    app.add_middleware(
        CORSMiddleware,
        allow_origins=_origins,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}
