-- =============================================================================
-- COPIAR Y PEGAR EN SUPABASE (SQL Editor, rol postgres)
-- =============================================================================
-- Variante para tablas user_profiles donde la referencia a auth.users está en
-- la columna user_id (NO en id). Si obtienes "null value in column user_id" o
-- políticas que no permiten acceso, usa este script en lugar del estándar.
--
-- Usa user_id = auth.uid() en lugar de id = auth.uid().
-- Si tu tabla tiene id como PK surrogada y user_id como FK a auth.users, este
-- es el script correcto.
-- =============================================================================

ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS p_user_profiles_select_own ON public.user_profiles;

CREATE POLICY p_user_profiles_select_own ON public.user_profiles
  FOR SELECT TO authenticated
  USING (user_id = auth.uid ());

DROP POLICY IF EXISTS p_user_profiles_insert_own ON public.user_profiles;

CREATE POLICY p_user_profiles_insert_own ON public.user_profiles
  FOR INSERT TO authenticated
  WITH CHECK (user_id = auth.uid ());

DROP POLICY IF EXISTS p_user_profiles_update_own ON public.user_profiles;

CREATE POLICY p_user_profiles_update_own ON public.user_profiles
  FOR UPDATE TO authenticated
  USING (user_id = auth.uid ())
  WITH CHECK (user_id = auth.uid ());
