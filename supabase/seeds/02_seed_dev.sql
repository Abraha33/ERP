-- 02_seed_dev.sql
-- ---------------------------------------------------------------------------
-- Seed de desarrollo local.
-- Se ejecuta en `supabase db reset` porque está referenciado en config.toml.
--
-- Recomendación:
-- - Datos mínimos e idempotentes.
-- - Nada sensible.
-- - Pensado para flujos QA/RLS en local.
-- ---------------------------------------------------------------------------

-- Placeholder intencional: agrega inserts de catálogo/demo según módulo.
-- Ejemplo:
-- insert into public.mi_tabla (id, nombre)
-- values ('00000000-0000-0000-0000-000000000001', 'demo')
-- on conflict do nothing;

