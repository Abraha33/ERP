# CURSOR CONTEXT - ERP SATELITE

## Proyecto
ERP+CRM construido por un solo founder (25h/semana) en 14 meses.
Un solo codebase React Native + Expo para App movil (campo) y Web (oficina).

## Stack
- Frontend: React Native + Expo SDK, NativeWind, Expo Router
- Offline (**solo Fase 5**): WatermelonDB — no mezclar antes; ver [docs/STACK_POR_FASE.md](./docs/STACK_POR_FASE.md)
- Backend: Supabase (PostgreSQL 16, Auth, Storage, Realtime, Edge Functions)
- Scraper (**Fase 1 Satélite**): Python 3.12 + Playwright
- DevOps: GitHub Actions
- IA: Cursor AI

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
