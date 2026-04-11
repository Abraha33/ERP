# Estrategia de migraciones — backend (Postgres / Supabase)

## Fuente de verdad

- **Única:** carpeta `supabase/migrations/*.sql` en el monorepo.
- **Prohibido** (salvo emergencia documentada): crear o alterar tablas desde el dashboard de Supabase sin reflejar el cambio en una migración nueva.

## Flujo de trabajo

1. **Nueva versión de esquema:** `supabase migration new <nombre_descriptivo>` (CLI) o crear manualmente un archivo con prefijo timestamp `YYYYMMDDHHMMSS_...sql` coherente con el resto.
2. **Contenido:** DDL idiomático Postgres; preferir `IF NOT EXISTS` / `ADD COLUMN IF NOT EXISTS` / `DROP POLICY IF EXISTS` + `CREATE POLICY` cuando haga falta repetir en entornos locales rotos.
3. **Aplicar en cloud:** `supabase db push` (o pipeline del proyecto) contra el proyecto enlazado.
4. **CI local (Postgres vanilla):** `scripts/ci/apply_supabase_migrations.sh` aplica `supabase/ci/0000_local_pg_supabase_stubs.sql` y luego **todas** las migraciones en orden lexicográfico por nombre de archivo.

## Convenciones alineadas al repo

- Convenciones de columnas, tenant y RLS: `docs/reference/schema-conventions.md` y `.cursor/rules/project.mdc`.
- Nombres de policies: `p_<tabla>_<acción>_<rol>`.
- Triggers `updated_at`: función global `public.set_updated_at()` reutilizable.

## Olas de cambios (recomendado)

| Ola | Contenido |
|-----|-----------|
| **1 — Esquema** | `CREATE TABLE`, `ALTER ... ADD COLUMN`, índices, FKs, tipos/checks. |
| **2 — RLS** | `ENABLE ROW LEVEL SECURITY`, policies por rol (`admin` / `encargado` / `empleado`). |
| **3 — Datos** | Seeds solo para local (`supabase/seed.sql` o scripts dedicados), no mezclar con producción sin criterio explícito. |

Las migraciones pueden combinar olas 1+2 en un mismo archivo mientras el equipo sea pequeño; si crece el conflicto en review, separar por archivo.

## Riesgos conocidos del historial actual

- Existe un borrador grande (`20260322190000_draft_rls_core.sql`) con tablas y RLS ya definidos para `productos`, `clientes`, etc.
- Una migración posterior (`20260323213100_03_triggers_user_profiles.sql`) referencia `public.user_profiles`, tabla que **no** crea el borrador; el CI que aplica todas las migraciones en orden puede fallar hasta que esa cadena se corrija o la migración se alinee con `public.profiles`.
- **Regla práctica:** nuevas piezas del núcleo ERP deben ser **incrementales** (nuevos archivos timestamp) y no reescribir migraciones ya consideradas aplicadas en algún entorno.

## ERP núcleo vs CRM

- Tablas de **maestros y operación** (`productos`, `clientes`, `ubicaciones`, inventario, órdenes) pertenecen al **núcleo ERP**.
- El **CRM** (Fase 4) debe añadir tablas propias (conversaciones, casos, pipeline) con FK a `clientes` y a documentos de venta, sin duplicar el maestro de clientes.
