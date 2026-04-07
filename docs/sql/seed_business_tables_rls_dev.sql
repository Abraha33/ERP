-- =============================================================================
-- Seed amplio para dev: muchos productos + clientes/proveedores + compras/OC/traslados
-- Alineado con supabase/migrations/20260322190000_draft_rls_core.sql (RLS).
--
-- Perfil de usuario: el bloque inicial detecta la tabla que exista en tu proyecto:
--   - public.user_profiles + columna rol_principal (típico en Supabase custom)
--   - public.profiles + app_role (borrador de migración en este repo)
-- Si obtienes error de columna inexistente, adapta el INSERT a tu esquema
-- (p. ej. solo app_role en user_profiles).
-- Se usa UPDATE + INSERT (no ON CONFLICT) porque algunas instancias de user_profiles
-- no tienen PRIMARY KEY en id; 42P10 = falta constraint para ON CONFLICT.
--
-- Supabase → SQL Editor (rol postgres). Por defecto toma el usuario más antiguo de
-- auth.users (sin pegar UUID ni email). Opcional: seed_user_email o auth_user_uuid.
-- Ajusta los contadores n_* si quieres más/menos filas.
--
-- Idempotencia:
--   - productos / clientes / proveedores / OC / traslados: solo prefijo SEED-ERP-*.
--   - compras_encabezado / compras_detalle: el esquema no tiene columna «marca»;
--     al re-ejecutar se BORRAN TODAS las compras de esa empresa (solo para dev).
-- =============================================================================

DO $$
DECLARE
  -- Opcional: fuerza un usuario concreto. Si ambos son NULL, se usa el primero en auth.users.
  seed_user_email text := NULL; -- ej. 'yo@correo.com'
  auth_user_uuid uuid := NULL; -- ej. 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'::uuid

  auth_user_id uuid;

  -- Volúmenes (cámbialos aquí)
  n_productos int := 200;
  n_clientes int := 40;
  n_proveedores int := 25;
  n_compras_enc int := 5;
  n_lineas_compra int := 8;
  n_oc_enc int := 4;
  n_lineas_oc int := 12;
  n_tr_enc int := 4;
  n_lineas_tr int := 12;

  v_empresa uuid;
  v_sucursal uuid;
  i int;
  j int;
  v_compra uuid;
  v_oc uuid;
  v_tr uuid;
BEGIN
  IF auth_user_uuid IS NOT NULL THEN
    auth_user_id := auth_user_uuid;
  ELSIF seed_user_email IS NOT NULL AND length(trim(seed_user_email)) > 0 THEN
    SELECT
      id INTO auth_user_id
    FROM
      auth.users
    WHERE
      lower(email) = lower(trim(seed_user_email))
    LIMIT 1;
    IF auth_user_id IS NULL THEN
      RAISE EXCEPTION 'No hay usuario en auth.users con email %', seed_user_email;
    END IF;
  ELSE
    SELECT
      id INTO auth_user_id
    FROM
      auth.users
    ORDER BY
      created_at ASC
    LIMIT 1;
    IF auth_user_id IS NULL THEN
      RAISE EXCEPTION 'auth.users está vacío: crea un usuario en Authentication y vuelve a ejecutar.';
    END IF;
  END IF;

  RAISE NOTICE 'Seed usando auth.users.id = %', auth_user_id;

  IF to_regclass('public.user_profiles') IS NOT NULL THEN
    IF EXISTS (
      SELECT 1 FROM information_schema.columns
      WHERE table_schema = 'public' AND table_name = 'user_profiles' AND column_name = 'user_id'
    ) THEN
      UPDATE public.user_profiles
      SET
        empresa_id = COALESCE(empresa_id, gen_random_uuid ()),
        sucursal_id = COALESCE(sucursal_id, gen_random_uuid ()),
        rol_principal = 'admin'
      WHERE
        user_id = auth_user_id;

      IF NOT FOUND THEN
        INSERT INTO public.user_profiles (user_id, empresa_id, sucursal_id, rol_principal)
        VALUES (auth_user_id, gen_random_uuid (), gen_random_uuid (), 'admin');
      END IF;

      SELECT p.empresa_id, p.sucursal_id INTO STRICT v_empresa, v_sucursal
      FROM public.user_profiles p
      WHERE p.user_id = auth_user_id;
    ELSE
      UPDATE public.user_profiles
      SET
        empresa_id = COALESCE(empresa_id, gen_random_uuid ()),
        sucursal_id = COALESCE(sucursal_id, gen_random_uuid ()),
        rol_principal = 'admin'
      WHERE
        id = auth_user_id;

      IF NOT FOUND THEN
        INSERT INTO public.user_profiles (id, empresa_id, sucursal_id, rol_principal)
        VALUES (auth_user_id, gen_random_uuid (), gen_random_uuid (), 'admin');
      END IF;

      SELECT p.empresa_id, p.sucursal_id INTO STRICT v_empresa, v_sucursal
      FROM public.user_profiles p
      WHERE p.id = auth_user_id;
    END IF;
  ELSIF to_regclass('public.profiles') IS NOT NULL THEN
    UPDATE public.profiles
    SET
      empresa_id = COALESCE(empresa_id, gen_random_uuid ()),
      sucursal_id = COALESCE(sucursal_id, gen_random_uuid ()),
      app_role = 'admin'
    WHERE
      id = auth_user_id;

    IF NOT FOUND THEN
      INSERT INTO public.profiles (id, empresa_id, sucursal_id, app_role)
      VALUES (auth_user_id, gen_random_uuid (), gen_random_uuid (), 'admin');
    END IF;

    SELECT
      p.empresa_id,
      p.sucursal_id INTO STRICT v_empresa,
      v_sucursal
    FROM
      public.profiles p
    WHERE
      p.id = auth_user_id;
  ELSE
    RAISE EXCEPTION
      'No existe public.user_profiles ni public.profiles. Crea una de las dos o aplica la migración del repo.';
  END IF;

  -- Limpieza seed anterior (solo prefijos SEED-ERP- en esta empresa)
  DELETE FROM public.traslados_detalle
  WHERE id_traslado IN (
      SELECT
        id
      FROM
        public.traslados_encabezado
      WHERE
        empresa_id = v_empresa
        AND nota_traslado LIKE 'SEED-ERP%');

  DELETE FROM public.traslados_encabezado
  WHERE empresa_id = v_empresa
    AND nota_traslado LIKE 'SEED-ERP%';

  DELETE FROM public.ordenes_compra_detalle
  WHERE id_orden_compra IN (
      SELECT
        id
      FROM
        public.ordenes_compra_encabezado
      WHERE
        empresa_id = v_empresa
        AND nota_encargado LIKE 'SEED-ERP%');

  DELETE FROM public.ordenes_compra_encabezado
  WHERE empresa_id = v_empresa
    AND nota_encargado LIKE 'SEED-ERP%';

  DELETE FROM public.compras_detalle
  WHERE id_compra IN (
      SELECT
        id
      FROM
        public.compras_encabezado
      WHERE
        empresa_id = v_empresa);

  DELETE FROM public.compras_encabezado
  WHERE empresa_id = v_empresa;

  DELETE FROM public.productos
  WHERE empresa_id = v_empresa
    AND sku_codigo LIKE 'SEED-ERP-P-%';

  DELETE FROM public.clientes
  WHERE empresa_id = v_empresa
    AND num_documento LIKE 'SEED-ERP-C-%';

  DELETE FROM public.proveedores
  WHERE empresa_id = v_empresa
    AND num_documento LIKE 'SEED-ERP-V-%';

  -- Productos (todos los N)
  FOR i IN 1..n_productos LOOP
    INSERT INTO public.productos (empresa_id, sku_codigo, nombre)
      VALUES (v_empresa, 'SEED-ERP-P-' || lpad(i::text, 5, '0'), 'Producto demo ' || i);
  END LOOP;

  -- Clientes
  FOR i IN 1..n_clientes LOOP
    INSERT INTO public.clientes (empresa_id, num_documento, razon_social)
      VALUES (v_empresa, 'SEED-ERP-C-' || lpad(i::text, 5, '0'), 'Cliente demo ' || i);
  END LOOP;

  -- Proveedores
  FOR i IN 1..n_proveedores LOOP
    INSERT INTO public.proveedores (empresa_id, num_documento, razon_social)
      VALUES (v_empresa, 'SEED-ERP-V-' || lpad(i::text, 5, '0'), 'Proveedor demo ' || i);
  END LOOP;

  -- Compras + detalle (líneas referencian SKUs existentes)
  FOR i IN 1..n_compras_enc LOOP
    INSERT INTO public.compras_encabezado (empresa_id, id_sucursal)
      VALUES (v_empresa, v_sucursal)
    RETURNING
      id INTO v_compra;

    -- compras_detalle en la migración base solo tiene id_compra (sin línea de producto).
    FOR j IN 1..n_lineas_compra LOOP
      INSERT INTO public.compras_detalle (id_compra)
        VALUES (v_compra);
    END LOOP;
  END LOOP;

  -- Órdenes de compra + detalle
  FOR i IN 1..n_oc_enc LOOP
    INSERT INTO public.ordenes_compra_encabezado (empresa_id, id_sucursal, empleado_asignado_id, estado, nota_encargado)
      VALUES (v_empresa, v_sucursal, auth_user_id, 'BORRADOR', 'SEED-ERP-OC-' || i::text)
    RETURNING
      id INTO v_oc;

    FOR j IN 1..n_lineas_oc LOOP
      INSERT INTO public.ordenes_compra_detalle (id_orden_compra, cod_producto, cantidad)
        VALUES (v_oc, 'SEED-ERP-P-' || lpad((1 + ((i * 7 + j) % n_productos))::text, 5, '0'), (j)::numeric);
    END LOOP;
  END LOOP;

  -- Traslados + detalle
  FOR i IN 1..n_tr_enc LOOP
    INSERT INTO public.traslados_encabezado (empresa_id, id_sucursal_origen, empleado_asignado_id, estado, nota_traslado)
      VALUES (v_empresa, v_sucursal, auth_user_id, 'BORRADOR', 'SEED-ERP-TR-' || i::text)
    RETURNING
      id INTO v_tr;

    FOR j IN 1..n_lineas_tr LOOP
      INSERT INTO public.traslados_detalle (id_traslado, cod_producto, cantidad)
        VALUES (v_tr, 'SEED-ERP-P-' || lpad((1 + ((i * 5 + j) % n_productos))::text, 5, '0'), (j)::numeric);
    END LOOP;
  END LOOP;

  RAISE NOTICE 'Seed OK. empresa=% productos=% clientes=% prov=% compras=% oc=% traslados=%',
    v_empresa,
    n_productos,
    n_clientes,
    n_proveedores,
    n_compras_enc,
    n_oc_enc,
    n_tr_enc;
END;

$$;
