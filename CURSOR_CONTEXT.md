# CURSOR CONTEXT — ERP SATELITE

## Proyecto
ERP+CRM construido por un solo founder (~25h/semana) en 14 meses. **Cliente de producto:** app Android (**Kotlin + Jetpack Compose**); backend **Supabase** (Postgres, Auth, RLS, Realtime, RPC).

**Stack de fundación:** [ADR-001](./ADR/ADR-001-stack-tecnologico.md) — **ACEPTADA** (revisión **2026-04-08**: Kotlin + Room + WorkManager para offline en Fase 5).

## Stack
- **Frontend:** **Kotlin**, **Jetpack Compose**, **Material 3**; módulo en `apps/android/` (inicializar Gradle cuando arranque desarrollo).
- **Persistencia local:** **Room** (cache y, en Fase 5, offline); **WorkManager** para sync en background.
- **BaaS:** **Supabase** (Postgres, Auth, Storage, **RLS**, **Realtime**, **RPC**, Edge Functions).
- **App → datos:** **Supabase Kotlin** con **RLS**; lógica transaccional en **RPC** cuando aplique.
- **Integración SAE:** scripts Python en **`scripts/sae/`** (CSV/XLS ↔ Supabase); **Playwright** opcional en `tools/scraper/`.
- **Worker HTTP (opcional):** **FastAPI** en `tools/worker/` (Python 3.12).
- **Offline (Fase 5):** **Room** + sync documentada; columna `sync_status` en Postgres según [docs/reference/schema-conventions.md](./docs/reference/schema-conventions.md).
- **CI/CD:** GitHub Actions; builds Android con Gradle cuando exista el proyecto.

**Variables de entorno:** [.env.example](./.env.example) en la raíz; nunca commitear `.env` ni `.env.local`.

## Milestone activo (documentación)
- **M0 — Workflow & Foundation:** [docs/milestones/M0-workflow-foundation.md](./docs/milestones/M0-workflow-foundation.md) (seguimiento W01–W08). Tras cerrar M0 → **Sprint 1 / Fase 1** en curso.
- **Último cierre documentado en este archivo:** revisión stack Android + ADR-001 (2026-04-08).

## Estructura (monorepo)
- `apps/android/` — app Kotlin (placeholder `.gitkeep` hasta crear proyecto).
- `supabase/migrations/` — única fuente de verdad DDL/RLS aplicada con CLI.
- `scripts/` — automatización tablero, SAE (`scripts/sae/`), etc.
- `tools/worker/`, `tools/scraper/` — FastAPI y Playwright opcionales.
- `worker/` — reservado (`.gitkeep`); ver README si se unifica con `tools/worker/`.

## Reglas Cursor
- Ver `.cursor/rules/project.mdc` (`alwaysApply: true`) + 8 recetas de comando en `.cursor/rules/*.mdc`.
- Commits: `feat|fix|db|chore|docs: … (#issue)` según convención del equipo.

## Roles de desarrollo (GitHub)
Labels `role/*` por ticket. Ramas permanentes: `main`, `develop`. Features: `feature/<issue>-<descripcion>`.
