# tools/worker — Standalone Worker Process

Proceso FastAPI independiente para jobs pesados (importaciones SAE, scraper).

## Distinción con `backend/app/modules/workers/`

| | `backend/app/modules/workers/` | `tools/worker/` |
|---|---|---|
| Tipo | Módulo in-process del monolito | Proceso FastAPI independiente |
| Cuándo corre | Siempre, dentro del servidor principal | Solo cuando se lanza aparte |
| Uso actual | `job_consumer.py` — consume `jobs_outbox` | Health-check + futuros endpoints |
| Fase | Fase 0 (scaffold) | Fase 1+ (importaciones pesadas) |

## Estructura

```
tools/worker/
├── app/
│   └── main.py          # FastAPI app, health check
├── jobs/                # Procesadores de jobs (Fase 1+)
├── requirements.txt
└── README.md
```
