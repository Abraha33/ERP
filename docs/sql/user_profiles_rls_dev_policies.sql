-- =============================================================================
-- COPIAR Y PEGAR EN SUPABASE (SQL Editor, rol postgres)
-- =============================================================================
-- 1. Abre este archivo en el repo (o copia TODO el contenido).
-- 2. Supabase Dashboard → SQL Editor → New query.
-- 3. Pega y ejecuta (Run).
--
-- Corrige el error de la app móvil:
--   "new row violates row-level security policy for table user_profiles"
-- permitiendo que cada usuario autenticado inserte/lea/actualice SOLO su fila
-- (id = auth.uid()).
--
-- Si tu tabla usa user_id (no id) como referencia a auth: docs/sql/user_profiles_rls_dev_policies_user_id.sql
--
-- ERROR 42P01: relation "public.user_profiles" does not exist
--   → Crea la tabla en tu proyecto o usa public.profiles + docs/sql/profiles_rls_dev_policies.sql
--
-- Si tu tabla se llama public.profiles (no user_profiles), usa en su lugar:
--   docs/sql/profiles_rls_dev_policies.sql
--
-- Si empresa_id referencia public.empresas, crea antes la empresa/sucursal;
-- UUID sueltos pueden fallar por FK aunque RLS esté bien.
-- =============================================================================

ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS p_user_profiles_select_own ON public.user_profiles;

CREATE POLICY p_user_profiles_select_own ON public.user_profiles
  FOR SELECT TO authenticated
  USING (id = auth.uid ());

DROP POLICY IF EXISTS p_user_profiles_insert_own ON public.user_profiles;

CREATE POLICY p_user_profiles_insert_own ON public.user_profiles
  FOR INSERT TO authenticated
  WITH CHECK (id = auth.uid ());

DROP POLICY IF EXISTS p_user_profiles_update_own ON public.user_profiles;

CREATE POLICY p_user_profiles_update_own ON public.user_profiles
  FOR UPDATE TO authenticated
  USING (id = auth.uid ())
  WITH CHECK (id = auth.uid ());
