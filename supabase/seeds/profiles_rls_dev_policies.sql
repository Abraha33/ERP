-- =============================================================================
-- COPIAR Y PEGAR EN SUPABASE (SQL Editor, rol postgres)
-- =============================================================================
-- SOLO si existe la tabla public.profiles (p. ej. tras aplicar en tu proyecto la
-- migración supabase/migrations/20260322190000_draft_rls_core.sql).
--
-- ERROR 42P01: relation "public.profiles" does not exist
--   → Tu base usa otro nombre, muy a menudo public.user_profiles. NO uses este
--   archivo. Ejecuta en su lugar:
--     docs/sql/user_profiles_rls_dev_policies.sql
--
-- Comprueba en SQL Editor:
--   select table_name from information_schema.tables
--   where table_schema = 'public' and table_name in ('profiles','user_profiles');
-- =============================================================================

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS p_profiles_select_own ON public.profiles;

CREATE POLICY p_profiles_select_own ON public.profiles
  FOR SELECT TO authenticated
  USING (id = auth.uid ());

DROP POLICY IF EXISTS p_profiles_insert_own ON public.profiles;

CREATE POLICY p_profiles_insert_own ON public.profiles
  FOR INSERT TO authenticated
  WITH CHECK (id = auth.uid ());

DROP POLICY IF EXISTS p_profiles_update_own ON public.profiles;

CREATE POLICY p_profiles_update_own ON public.profiles
  FOR UPDATE TO authenticated
  USING (id = auth.uid ())
  WITH CHECK (id = auth.uid ());
