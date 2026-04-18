-- =============================================================================
-- EJEMPLO — no ejecutar a ciegas: adapta nombre de tabla/columnas a tu proyecto.
-- Objetivo: al crearse auth.users, insertar user_profiles con empresa_id válido.
-- =============================================================================

-- 1) Inspeccionar triggers actuales en auth.users
-- SELECT tgname, pg_get_triggerdef(oid) FROM pg_trigger
-- WHERE tgrelid = 'auth.users'::regclass AND NOT tgisinternal;

-- 2) Función de ejemplo: lee empresa_id / sucursal_id / app_role desde raw_user_meta_data
CREATE OR REPLACE FUNCTION public.handle_new_user_profiles ()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SECURITY DEFINER
  SET search_path = public
  AS $$
DECLARE
  meta jsonb;
  e_id uuid;
  s_id uuid;
  role text;
  -- Opcional: empresa por defecto si no viene en metadata (SOLO dev / un tenant)
  default_empresa uuid := NULL; -- p.ej. 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'::uuid;
BEGIN
  meta := COALESCE(NEW.raw_user_meta_data, '{}'::jsonb);

  e_id := NULLIF(meta ->> 'empresa_id', '')::uuid;
  s_id := NULLIF(meta ->> 'sucursal_id', '')::uuid;
  role := COALESCE(NULLIF(meta ->> 'app_role', ''), 'empleado');

  e_id := COALESCE(e_id, default_empresa);

  IF e_id IS NULL THEN
    RAISE EXCEPTION 'user_profiles: falta empresa_id en user_metadata (clave empresa_id UUID) o define default_empresa en el trigger';
  END IF;

  INSERT INTO public.user_profiles (id, empresa_id, sucursal_id, app_role)
    VALUES (NEW.id, e_id, s_id, role)
  ON CONFLICT (id) DO UPDATE
    SET empresa_id = EXCLUDED.empresa_id,
    sucursal_id = EXCLUDED.sucursal_id,
    app_role = EXCLUDED.app_role;

  RETURN NEW;
END;

$$;

-- 3) Trigger (crear solo si no existe ya uno equivalente)
DROP TRIGGER IF EXISTS on_auth_user_created_user_profiles ON auth.users;

CREATE TRIGGER on_auth_user_created_user_profiles
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user_profiles ();

-- Notas:
-- - Si tus columnas se llaman distinto (p.ej. sin sucursal_id), ajusta el INSERT.
-- - Si la tabla es public.profiles, cambia user_profiles -> profiles y columnas.
-- - En Postgres 14 puede ser EXECUTE PROCEDURE en lugar de FUNCTION.
