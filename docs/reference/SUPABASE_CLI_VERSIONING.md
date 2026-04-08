# Supabase CLI — versionado de base de datos y funciones

Objetivo: manejar **schema, RLS, policies y Edge Functions** como código en Git, con despliegue reproducible desde CI.

## 1) Estructura versionada

- `supabase/migrations/*.sql` → cambios de DB (tablas, índices, RLS, policies, funciones SQL).
- `supabase/functions/*` → Edge Functions.
- `.github/workflows/supabase-deploy.yml` → deploy automático a Supabase.

## 2) Crear una nueva migración (siempre en Git)

```bash
npx -y supabase migration new add_compras_indexes
```

Edita el archivo generado en `supabase/migrations/` y agrega SQL (DDL/RLS/policies).

## 3) Probar localmente en Postgres de CI (opcional)

```bash
bash scripts/ci/apply_supabase_migrations.sh
```

Ese script usa stubs locales para `auth.users`, `auth.uid()` y el rol `authenticated` (solo entorno local/CI).

## 4) Aplicar migraciones al proyecto Supabase remoto

Necesitas el connection string remoto (secreto `SUPABASE_DB_URL` en GitHub Actions) o ejecución manual local:

```bash
npx -y supabase db push --db-url "$SUPABASE_DB_URL" --include-all --yes
```

## 5) Edge Function (tu ejemplo)

Crear:

```bash
npx -y supabase functions new hello-world
```

Deploy:

```bash
npx -y supabase functions deploy hello-world --project-ref fwegtmgcuuyjryffkmxb --use-api --yes
```

Invoke:

```bash
curl -L -X POST "https://fwegtmgcuuyjryffkmxb.supabase.co/functions/v1/hello-world" \
  -H "Authorization: Bearer <YOUR_ANON_KEY>" \
  -H "Content-Type: application/json" \
  --data "{\"name\":\"Functions\"}"
```

## 6) GitHub Actions (despliegue automatizado)

Workflow: `.github/workflows/supabase-deploy.yml`

- Job `db_push`: aplica migraciones (`supabase db push`) cuando cambian `supabase/migrations/**`.
- Job `functions_deploy`: despliega funciones cuando cambian `supabase/functions/**`.
- También se puede ejecutar manual con `workflow_dispatch`.

## 7) Secrets/Variables requeridos en GitHub

- `SUPABASE_DB_URL` (secret): URL de Postgres remoto.
- `SUPABASE_ACCESS_TOKEN` (secret): token de Supabase CLI para deploy de funciones.
- `SUPABASE_PROJECT_REF` (variable, opcional): si no existe, usa `fwegtmgcuuyjryffkmxb`.

## 8) Regla operativa

Nunca editar esquema directamente en SQL Editor sin migración equivalente en `supabase/migrations/`.  
Si se hace un hotfix manual, crear inmediatamente la migración espejo y subirla a Git.

## 9) Health check RLS (anon + usuarios de prueba)

Script: `scripts/rls-diagnostics/rls_diagnostics.ts` — hace login por rol y prueba `SELECT`/`INSERT` acordes al borrador en `supabase/migrations/`.

```bash
cd scripts/rls-diagnostics
npm install
npm run diag
```

Configura en `.env` raíz: `SUPABASE_URL`, `SUPABASE_ANON_KEY` (y variables públicas de cliente definidas en `.env.example`), `RLS_TEST_*` emails/password y `RLS_TEST_EMPRESA_ID` / `RLS_TEST_SUCURSAL_ID`. Cada usuario de prueba debe tener fila en `public.profiles` con `empresa_id`, `sucursal_id` y `app_role`.

Salida: JSON en stdout; código de salida ≠ 0 si algún test falla. `turnos_caja` queda como *skip* hasta existir la tabla en migraciones.

## 10) Invitar usuario y error `empresa_id` en `user_profiles`

Si al invitar desde el Dashboard falla con **not-null `empresa_id`**, el trigger que crea la fila de perfil no está recibiendo el UUID de empresa. Guía y SQL de ejemplo: [SUPABASE_AUTH_USER_PROFILES.md](./SUPABASE_AUTH_USER_PROFILES.md).

## 11) Pantalla dev Supabase en cliente legado (solo desarrollo)

En la carpeta **`apps/mobile/`** (stack anterior, no es la línea Kotlin), con variables públicas de Supabase en `.env`, en desarrollo puede existir una ruta tipo **Dev: Supabase health / RLS** para `SELECT` cortos y login de prueba. El producto nuevo vive en **`apps/android/`**; documenta ahí el equivalente cuando exista. En release, las herramientas de diagnóstico no deben exponerse.
