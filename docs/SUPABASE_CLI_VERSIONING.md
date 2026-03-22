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
