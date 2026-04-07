# Contexto de sesión — estado actual ERP

> Documento **vivo**: actualízalo al cerrar una sesión relevante o tras merge de migraciones. No sustituye el esquema real en Postgres; para eso usa `scripts/introspection/`.

**Última revisión sugerida:** al leer este archivo, confirma fecha en git o añade línea `Actualizado: YYYY-MM-DD` abajo.

## Tablas y objetos referenciados en el repo

| Área | Objetos (migraciones / docs) | Notas |
|------|------------------------------|--------|
| Auth → perfil | `public.handle_new_auth_user`, trigger `on_auth_user_created` | `supabase/migrations/20260323213100_03_triggers_user_profiles.sql` → **`user_profiles`** |
| Perfil / tenant (borrador RLS) | `public.profiles`, `current_empresa_id()`, `current_sucursal_id()`, `app_role()` | `20260322190000_draft_rls_core.sql` |
| Catálogo / ops (borrador) | `productos`, `clientes`, `proveedores` | RLS por `empresa_id` |
| Compras / OC / traslados (borrador) | `compras_encabezado|detalle`, `ordenes_compra_*`, `traslados_*` | Enums `doc_estado_oc`, `doc_estado_traslado` |
| Esquema base | `pgcrypto` en `01_schema` | DDL en consolidación |

## Pendientes conocidos (alineado a migraciones)

- Unificar o **puentear** `profiles` vs `user_profiles` en funciones de sesión y políticas.
- Tablas **`empresas`** / **`sucursales`** como catálogo formal (FK en perfiles); ver [open-questions.md](./open-questions.md).
- Triggers de **columnas restringidas** (estado/nota en OC y traslados) — mencionado en cabecera del borrador RLS.
- Semillas locales: `supabase/seeds/02_seed_dev.sql` (si existe en tu clone) — solo dev.

## Decisiones activas (no reabrir sin ADR/issue)

- Stack cliente: Expo + Supabase con RLS ([STACK_POR_FASE.md](./STACK_POR_FASE.md), ADR-001).
- Roles de app: `admin` | `encargado` | `empleado` ([SECURITY_POLICIES.md](./SECURITY_POLICIES.md)).
- IDs de issues: [TICKET_ID_CONVENTION.md](./TICKET_ID_CONVENTION.md).

## Entornos

- Variables: `.env.example` en raíz / `apps/mobile` (según paquete en uso).
- Flujo migraciones locales: [SUPABASE_LOCAL_MIGRATION_FLOW.md](./SUPABASE_LOCAL_MIGRATION_FLOW.md).

---

`Actualizado: 2026-04-07` (plantilla inicial; corregir al cambiar el estado real).
