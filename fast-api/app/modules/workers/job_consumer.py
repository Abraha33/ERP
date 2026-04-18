"""Stub del consumidor de jobs_outbox (patrón cola en Postgres, sin Redis).

El worker HTTP opcional que vivía en ``tools/worker`` se reemplaza por este
módulo dentro del monolito FastAPI para Fase 0.
"""


async def run_once() -> None:
    """Un ciclo de consumo — no-op en el scaffold."""
    return None
