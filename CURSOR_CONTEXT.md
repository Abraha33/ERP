# CURSOR CONTEXT - ERP SATELITE

## Proyecto
ERP+CRM construido por un solo founder (25h/semana) en 14 meses.
Un solo codebase React Native + Expo para App móvil (campo) y Web (oficina).

**Stack de fundación:** [ADR-001](./ADR/ADR-001-stack-tecnologico.md) — **ACEPTADA** (2026-03-22).

## Stack
- **Frontend:** React Native + **Expo SDK 51+**, TypeScript `strict`, **NativeWind**, **Expo Router**
- **BaaS:** **Supabase** (Postgres del proyecto, Auth email/contraseña, Storage, RLS, Realtime, Edge Functions)
- **Worker / jobs pesados:** **FastAPI** (Python 3.12): importación grande, tareas largas; ver ADR-001 (Edge vs FastAPI)
- **Scraper SAE (Fase 1):** Python 3.12 + **Playwright** 1.40+
- **Offline (solo Fase 5):** **WatermelonDB** — no introducir en app productiva antes; ver [docs/STACK_POR_FASE.md](./docs/STACK_POR_FASE.md)
- **CI/CD:** GitHub Actions + **Expo EAS** (tokens en secrets, no en repo)
- **IA:** Cursor AI

**Variables de entorno:** nombres canónicos en [`.env.example`](./.env.example); nunca commitear `.env`.

**Fundación Fase 0 (estado):** proyecto **Supabase** (URL/keys), **`.env` local** y alineación **Expo/FastAPI** con esos valores — **en progreso**. Análisis **Excel SAE** — [docs/EXCEL_ANALYSIS.md](./docs/EXCEL_ANALYSIS.md) — **en progreso**. ADR y plantilla `.env.example` ya cerrados a nivel documentación.

Desglose **por etapa** (ERP básico, completo, CRM, offline): siempre [docs/STACK_POR_FASE.md](./docs/STACK_POR_FASE.md).

## Estructura
app/          → React Native + Expo
scraper/      → Python/Playwright
database/
  migrations/ → SQL migraciones
  policies/   → RLS policies
ADR/          → Architecture Decision Records
docs/         → Documentacion tecnica

## Reglas Cursor
- Siempre TypeScript estricto
- NativeWind para todos los estilos
- Supabase client en lib/supabase.ts
- Variables de entorno solo desde app.config.ts
- Commits: feat|fix|docs|chore(scope): descripcion

## Roles de desarrollo (GitHub)
Labels `role/*` por ticket: frontend, backend, database, platform, integration, qa-release, crm, offline-sync, security, docs-adr. Ramas: solo `main` y `develop` permanentes en remoto. Ver [README §3.2–§4](./README.md#32-ramas-git-solo-main-y-develop).
