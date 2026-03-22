"""Punto de entrada del scraper SAE (Playwright). Sin flujos aún: solo carga .env del repo."""
import os
from pathlib import Path

from dotenv import load_dotenv

_REPO_ROOT = Path(__file__).resolve().parents[1]
load_dotenv(_REPO_ROOT / ".env")


def main() -> None:
    base = os.environ.get("SAE_BASE_URL", "").strip()
    if not base:
        print("Define SAE_BASE_URL (y credenciales) en .env en la raíz de erp-satelite.")
        return
    print(f"SAE_BASE_URL configurada ({base[:32]}…). Añade aquí los flujos Playwright.")


if __name__ == "__main__":
    main()
