# Supabase Local Migration Flow

Flujo recomendado para mantener **local y remoto alineados**.

## 1) Inicializar y levantar local

- `supabase init` (si el proyecto no está inicializado).
- `supabase start`.

## 2) Convención de archivos

- `supabase/migrations/*_01_schema.sql`
  - Tablas, tipos, índices, constraints.
- `supabase/seeds/02_seed_dev.sql`
  - Datos de desarrollo/local.
- `supabase/migrations/*_03_triggers_user_profiles.sql`
  - Funciones y triggers (ej. sincronización Auth -> user_profiles).
- Futuro:
  - `*_1x_rls_policies.sql`
  - `*_2x_extra_triggers.sql`

## 3) Regla operativa

- Cambios de BD **siempre** vía archivos SQL versionados.
- Evitar SQL manual no versionado en Dashboard para no desalinear entornos.

## 4) Comandos típicos

- Aplicar cambios locales desde cero:
  - `supabase db reset`
- Ver estado:
  - `supabase status`
- (Opcional) crear nueva migración:
  - `supabase migration new nombre_corto`

## 5) Seed local

`supabase/config.toml` ya apunta a:

- `./seeds/02_seed_dev.sql`

Se ejecuta en `supabase db reset`.
