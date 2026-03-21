# CURSOR CONTEXT - ERP SATELITE

## Proyecto
ERP+CRM construido por un solo founder (25h/semana) en 14 meses.
Un solo codebase React Native + Expo para App movil (campo) y Web (oficina).

## Stack
- Frontend: React Native + Expo SDK, NativeWind, Expo Router
- Offline: WatermelonDB
- Backend: Supabase (PostgreSQL 16, Auth, Storage, Realtime, Edge Functions)
- Scraper: Python 3.12 + Playwright
- DevOps: GitHub Actions
- IA: Cursor AI

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
Labels `role/*` por ticket: frontend, backend, database, platform, integration, qa-release, crm, offline-sync, security, docs-adr. Ramas: `main` (estable), `develop` (integracion), `feature/...` desde `develop`. Ver [README §3.2–§4](./README.md#32-fork-vs-ramas-git-y-flujo-main--develop).
