# Contexto de sesión — estado actual ERP

> Documento **vivo**. No sustituye el esquema real en Postgres; usar `scripts/introspection/`.

## Fase y milestone

- **M0 (Workflow & Foundation):** en ejecución — [milestones/M0-workflow-foundation.md](../docs/process/WORKFLOW.md). Al cerrar W01–W08 → **M0 cerrado**, **S1 / Fase 1** pendiente de arranque formal en tablero.
- **Stack cliente:** Kotlin + Compose + Room (offline Fase 5) — [ADR-001](./adr/ADR-001-stack-tecnologico.md).

`Actualizado: 2026-04-08`

## Tablas y objetos (repo)

| Área | Objetos | Notas |
|------|---------|--------|
| Perfiles | `public.profiles`, políticas `p_profiles_*` | Migración M0 `20260408130000_m0_001_profiles.sql` + borrador `20260322190000_*` |
| Auth → perfil app | `user_profiles` + trigger `handle_new_auth_user` | `20260323213100_03_triggers_user_profiles.sql` |
| Funciones sesión | `current_empresa_id`, `current_sucursal_id`, `app_role` | Definidas en borrador RLS; alinear con tabla de perfil real |
| Esquema | `pgcrypto` | `20260323213000_01_schema.sql` |

## Pendientes inmediatos (máx. 5)

1. Inicializar proyecto Gradle en `apps/android/`.
2. Unificar `profiles` vs `user_profiles` en políticas y funciones de sesión.
3. Aplicar migraciones en Supabase local y validar RLS (W07).
4. Completar checklist M0 (W06 PR de prueba, etc.).

## Decisiones activas

- Supabase como BaaS único para datos de producto; scripts Python para SAE.
- Roles de app: `admin` | `encargado` | `empleado` — [SECURITY_POLICIES.md](./SECURITY_POLICIES.md).

## Entornos

- Variables: [.env.example](../.env.example) en raíz.
- Migraciones: [SUPABASE_LOCAL_MIGRATION_FLOW.md](./SUPABASE_LOCAL_MIGRATION_FLOW.md).
