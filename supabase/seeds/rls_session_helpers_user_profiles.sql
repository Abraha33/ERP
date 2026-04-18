-- =============================================================================
-- COPIAR Y PEGAR EN SUPABASE (SQL Editor, rol postgres)
-- =============================================================================
-- Las políticas del borrador del repo comparan app_role() = 'admin' (minúsculas)
empresa_id = current_empresa_id().
--Si esas funciones leen public.profiles
-- pero tu fila está en public.user_profiles → devuelven NULL y fallan INSERT en
-- productos, clientes, proveedores, compras, OC, traslados.
--
-- Este script redefine current_empresa_id, current_sucursal_id y app_role para
-- leer user_profiles. Detecta columnas en tiempo de creación (id vs user_id,
-- rol_principal vs app_role). app_role() devuelve el rol en minúsculas para
-- coincidir con las políticas ('Admin' en BD → 'admin').
--
-- Después de ejecutar:
--   1) Settings → API → Reload schema (o espera unos segundos).
--   2) Confirma que tu fila tiene empresa_id relleno y rol tipo admin:
--        SELECT id, user_id, empresa_id, sucursal_id, rol_principal, app_role
--        FROM public.user_profiles;
--   3) Si sigue fallando, revisa si tus políticas usan otras funciones:
--        SELECT policyname, cmd, qual, with_check
--        FROM pg_policies WHERE schemaname = 'public' AND tablename = 'productos';
-- =============================================================================

CREATE OR REPLACE FUNCTION public.current_empresa_id ()
  RETURNS uuid
  LANGUAGE plpgsql
  STABLE
  SECURITY DEFINER
  SET search_path = public
  AS $$
DECLARE
  r uuid;
  has_uid boolean;
  has_id boolean;
BEGIN
  SELECT
    EXISTS (
      SELECT
        1
      FROM
        information_schema.columns
      WHERE
        table_schema = 'public'
        AND table_name = 'user_profiles'
        AND column_name = 'user_id'),
    EXISTS (
      SELECT
        1
      FROM
        information_schema.columns
      WHERE
        table_schema = 'public'
        AND table_name = 'user_profiles'
        AND column_name = 'id') INTO has_uid,
    has_id;

  IF has_uid AND has_id THEN
    EXECUTE $q$
      SELECT p.empresa_id
      FROM public.user_profiles p
      WHERE p.user_id IS NOT DISTINCT FROM auth.uid ()
        OR p.id IS NOT DISTINCT FROM auth.uid ()
      LIMIT 1
    $q$ INTO r;
  ELSIF has_uid THEN
    EXECUTE $q$
      SELECT p.empresa_id
      FROM public.user_profiles p
      WHERE p.user_id IS NOT DISTINCT FROM auth.uid ()
      LIMIT 1
    $q$ INTO r;
  ELSIF has_id THEN
    EXECUTE $q$
      SELECT p.empresa_id
      FROM public.user_profiles p
      WHERE p.id IS NOT DISTINCT FROM auth.uid ()
      LIMIT 1
    $q$ INTO r;
  END IF;

  RETURN r;
END;

$$;

CREATE OR REPLACE FUNCTION public.current_sucursal_id ()
  RETURNS uuid
  LANGUAGE plpgsql
  STABLE
  SECURITY DEFINER
  SET search_path = public
  AS $$
DECLARE
  r uuid;
  has_uid boolean;
  has_id boolean;
BEGIN
  SELECT
    EXISTS (
      SELECT
        1
      FROM
        information_schema.columns
      WHERE
        table_schema = 'public'
        AND table_name = 'user_profiles'
        AND column_name = 'user_id'),
    EXISTS (
      SELECT
        1
      FROM
        information_schema.columns
      WHERE
        table_schema = 'public'
        AND table_name = 'user_profiles'
        AND column_name = 'id') INTO has_uid,
    has_id;

  IF has_uid AND has_id THEN
    EXECUTE $q$
      SELECT p.sucursal_id
      FROM public.user_profiles p
      WHERE p.user_id IS NOT DISTINCT FROM auth.uid ()
        OR p.id IS NOT DISTINCT FROM auth.uid ()
      LIMIT 1
    $q$ INTO r;
  ELSIF has_uid THEN
    EXECUTE $q$
      SELECT p.sucursal_id
      FROM public.user_profiles p
      WHERE p.user_id IS NOT DISTINCT FROM auth.uid ()
      LIMIT 1
    $q$ INTO r;
  ELSIF has_id THEN
    EXECUTE $q$
      SELECT p.sucursal_id
      FROM public.user_profiles p
      WHERE p.id IS NOT DISTINCT FROM auth.uid ()
      LIMIT 1
    $q$ INTO r;
  END IF;

  RETURN r;
END;

$$;

CREATE OR REPLACE FUNCTION public.app_role ()
  RETURNS text
  LANGUAGE plpgsql
  STABLE
  SECURITY DEFINER
  SET search_path = public
  AS $$
DECLARE
  r text;
  has_rp boolean;
  has_ar boolean;
  has_uid boolean;
  has_id boolean;
  q text;
BEGIN
  SELECT
    EXISTS (
      SELECT
        1
      FROM
        information_schema.columns
      WHERE
        table_schema = 'public'
        AND table_name = 'user_profiles'
        AND column_name = 'rol_principal'),
    EXISTS (
      SELECT
        1
      FROM
        information_schema.columns
      WHERE
        table_schema = 'public'
        AND table_name = 'user_profiles'
        AND column_name = 'app_role'),
    EXISTS (
      SELECT
        1
      FROM
        information_schema.columns
      WHERE
        table_schema = 'public'
        AND table_name = 'user_profiles'
        AND column_name = 'user_id'),
    EXISTS (
      SELECT
        1
      FROM
        information_schema.columns
      WHERE
        table_schema = 'public'
        AND table_name = 'user_profiles'
        AND column_name = 'id') INTO has_rp,
    has_ar,
    has_uid,
    has_id;

  IF has_rp AND has_ar THEN
    q := $q$
      SELECT lower(NULLIF(trim(COALESCE(p.rol_principal::text, p.app_role::text)), ''))
      FROM public.user_profiles p
      WHERE %s
      LIMIT 1
    $q$;
  ELSIF has_rp THEN
    q := $q$
      SELECT lower(NULLIF(trim(p.rol_principal::text), ''))
      FROM public.user_profiles p
      WHERE %s
      LIMIT 1
    $q$;
  ELSIF has_ar THEN
    q := $q$
      SELECT lower(NULLIF(trim(p.app_role::text), ''))
      FROM public.user_profiles p
      WHERE %s
      LIMIT 1
    $q$;
  ELSE
    RETURN NULL;
  END IF;

  IF has_uid AND has_id THEN
    q := format(
      q,
      'p.user_id IS NOT DISTINCT FROM auth.uid () OR p.id IS NOT DISTINCT FROM auth.uid ()');
  ELSIF has_uid THEN
    q := format(q, 'p.user_id IS NOT DISTINCT FROM auth.uid ()');
  ELSIF has_id THEN
    q := format(q, 'p.id IS NOT DISTINCT FROM auth.uid ()');
  ELSE
    RETURN NULL;
  END IF;

  EXECUTE q INTO r;

  RETURN r;
END;

$$;

GRANT EXECUTE ON FUNCTION public.current_empresa_id () TO authenticated;

GRANT EXECUTE ON FUNCTION public.current_sucursal_id () TO authenticated;

GRANT EXECUTE ON FUNCTION public.app_role () TO authenticated;
