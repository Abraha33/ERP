# CURSOR CONTEXT - ERP SATELITE

## Proyecto
ERP+CRM construido por un solo founder (25h/semana) en 14 meses.
Un solo codebase React Native + Expo para App móvil (campo) y Web (oficina).

**Stack de fundación:** [ADR-001](./ADR/ADR-001-stack-tecnologico.md) — **ACEPTADA** (2026-03-22).

## Stack
- **Frontend:** React Native + **Expo SDK 51+**, TypeScript `strict`, **NativeWind**, **Expo Router**
- **BaaS:** **Supabase** (Postgres del proyecto, Auth email/contraseña, Storage, **RLS**, **Realtime**, **RPC**, Edge Functions)
- **App → datos:** Supabase **client SDK** (JS/TS en Expo) con **RLS**; lógica transaccional compleja en **RPC** (SQL). Un cliente Dart usaría el SDK Dart equivalente contra el mismo proyecto.
- **Tiempo real:** **Supabase Realtime** para casos como **inventario** y **traslados**.
- **Integración SAE:** **scripts Python** (CSV/XLS ↔ Supabase vía API o Postgres directo); export inverso a archivos para el SAE. **No** se asume FastAPI para este flujo.
- **Playwright / scraper (opcional):** Python 3.12 + **Playwright** 1.40+ solo cuando haga falta la UI legacy
- **Worker HTTP (opcional):** **FastAPI** (Python 3.12) para jobs que exijan servidor persistente o deps pesadas; ver ADR-001 (Edge vs FastAPI)
- **Offline (solo Fase 5):** **WatermelonDB** — no introducir en app productiva antes; ver [docs/STACK_POR_FASE.md](./docs/STACK_POR_FASE.md)
- **CI/CD:** GitHub Actions + **Expo EAS** (tokens en secrets, no en repo)
- **IA:** Cursor AI

**Variables de entorno:** nombres canónicos en [`.env.example`](./.env.example); nunca commitear `.env`.

**Fundación Fase 0 (estado):** proyecto **Supabase** (URL/keys), **`.env` local** y alineación **Expo/FastAPI** con esos valores — **en progreso**. Análisis **Excel SAE** — [docs/EXCEL_ANALYSIS.md](./docs/EXCEL_ANALYSIS.md) — **en progreso**. ADR y plantilla `.env.example` ya cerrados a nivel documentación.

Desglose **por etapa** (ERP básico, completo, CRM, offline): siempre [docs/STACK_POR_FASE.md](./docs/STACK_POR_FASE.md).

## Estructura (canónica — alinear con `.cursor/rules/project.mdc`)
app/                    → Next.js App Router
supabase/migrations/    → Única fuente de verdad BD
supabase/functions/     → Edge Functions
tools/scraper/          → Python/Playwright (auxiliar)
tools/worker/           → Python/FastAPI (auxiliar, opcional)
scripts/introspection/  → SQL de diagnóstico
docs/legacy/            → Borradores huérfanos (p. ej. SQL que antes vivían bajo `database/`)
apps/mobile/            → Expo (satélite / legado en este monorepo, si aplica)
ADR/                    → Architecture Decision Records
docs/                   → Documentación técnica

## Reglas Cursor
- Siempre TypeScript estricto
- NativeWind para todos los estilos
- Supabase client en lib/supabase.ts
- Variables de entorno solo desde app.config.ts
- Commits: feat|fix|docs|chore(scope): descripcion

## Roles de desarrollo (GitHub)
Labels `role/*` por ticket: frontend, backend, database, platform, integration, qa-release, crm, offline-sync, security, docs-adr. Ramas: solo `main` y `develop` permanentes en remoto. Ver [README §3.2–§4](./README.md#32-ramas-git-solo-main-y-develop).
