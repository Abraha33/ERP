-- =============================================================================
-- BORRADOR — no usar en producción sin revisión.
-- Fuente declarativa: docs/SECURITY_POLICIES.md
-- Supabase Postgres: RLS + esquema mínimo para productos, compras, OC,
-- traslados, clientes, proveedores.
--
-- Pendiente fuera de este archivo:
-- - Trigger auth → public.profiles
-- - Triggers columna-restringida (estado/nota en OC y traslados)
-- - Vistas para campos sensibles en clientes/proveedores
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Tipos
-- -----------------------------------------------------------------------------
CREATE TYPE public.doc_estado_oc AS ENUM (
  'BORRADOR',
  'ENVIADO',
  'PENDIENTE',
  'APROBADO',
  'RECHAZADO'
);

CREATE TYPE public.doc_estado_traslado AS ENUM (
  'BORRADOR',
  'ENVIADO',
  'PENDIENTE',
  'COMPLETADO',
  'CANCELADO'
);

-- -----------------------------------------------------------------------------
-- Perfiles (rol de app + tenant). auth.users existe en Supabase.
-- -----------------------------------------------------------------------------
CREATE TABLE public.profiles (
  id uuid PRIMARY KEY REFERENCES auth.users (id) ON DELETE CASCADE,
  empresa_id uuid NOT NULL,
  sucursal_id uuid,
  app_role text NOT NULL CHECK (app_role IN ('admin', 'encargado', 'empleado')),
  supervisor_id uuid REFERENCES public.profiles (id),
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_profiles_empresa ON public.profiles (empresa_id);
CREATE INDEX idx_profiles_supervisor ON public.profiles (supervisor_id);

-- -----------------------------------------------------------------------------
-- Tablas de negocio (columnas mínimas para RLS y FKs; ampliar con SAE_DATA_MAPPING)
-- -----------------------------------------------------------------------------
CREATE TABLE public.productos (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid (),
  empresa_id uuid NOT NULL,
  sku_codigo text,
  nombre text
);

CREATE TABLE public.compras_encabezado (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid (),
  empresa_id uuid NOT NULL,
  id_sucursal uuid NOT NULL
);

CREATE TABLE public.compras_detalle (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid (),
  id_compra uuid NOT NULL REFERENCES public.compras_encabezado (id) ON DELETE CASCADE
);

CREATE TABLE public.ordenes_compra_encabezado (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid (),
  empresa_id uuid NOT NULL,
  id_sucursal uuid NOT NULL,
  empleado_asignado_id uuid NOT NULL REFERENCES public.profiles (id),
  estado public.doc_estado_oc NOT NULL DEFAULT 'BORRADOR',
  nota_encargado text
);

CREATE TABLE public.ordenes_compra_detalle (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid (),
  id_orden_compra uuid NOT NULL REFERENCES public.ordenes_compra_encabezado (id) ON DELETE CASCADE,
  cod_producto text,
  cantidad numeric
);

CREATE TABLE public.traslados_encabezado (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid (),
  empresa_id uuid NOT NULL,
  id_sucursal_origen uuid NOT NULL,
  empleado_asignado_id uuid NOT NULL REFERENCES public.profiles (id),
  estado public.doc_estado_traslado NOT NULL DEFAULT 'BORRADOR',
  nota_traslado text
);

CREATE TABLE public.traslados_detalle (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid (),
  id_traslado uuid NOT NULL REFERENCES public.traslados_encabezado (id) ON DELETE CASCADE,
  cod_producto text,
  cantidad numeric
);

CREATE TABLE public.clientes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid (),
  empresa_id uuid NOT NULL,
  num_documento text,
  razon_social text
);

CREATE TABLE public.proveedores (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid (),
  empresa_id uuid NOT NULL,
  num_documento text,
  razon_social text
);

CREATE INDEX idx_compras_enc_emp_suc ON public.compras_encabezado (empresa_id, id_sucursal);
CREATE INDEX idx_oc_enc_emp_suc ON public.ordenes_compra_encabezado (empresa_id, id_sucursal);
CREATE INDEX idx_oc_enc_asignado ON public.ordenes_compra_encabezado (empleado_asignado_id);
CREATE INDEX idx_tr_enc_emp_suc ON public.traslados_encabezado (empresa_id, id_sucursal_origen);
CREATE INDEX idx_tr_enc_asignado ON public.traslados_encabezado (empleado_asignado_id);
CREATE INDEX idx_productos_empresa ON public.productos (empresa_id);
CREATE INDEX idx_clientes_empresa ON public.clientes (empresa_id);
CREATE INDEX idx_proveedores_empresa ON public.proveedores (empresa_id);

-- -----------------------------------------------------------------------------
-- Funciones de sesión (SECURITY DEFINER: leen profiles sin depender de RLS)
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.current_empresa_id ()
  RETURNS uuid
  LANGUAGE sql
  STABLE
  SECURITY DEFINER
  SET search_path = public
  AS $$
  SELECT
    empresa_id
  FROM
    public.profiles
  WHERE
    id = auth.uid ();

$$;

CREATE OR REPLACE FUNCTION public.current_sucursal_id ()
  RETURNS uuid
  LANGUAGE sql
  STABLE
  SECURITY DEFINER
  SET search_path = public
  AS $$
  SELECT
    sucursal_id
  FROM
    public.profiles
  WHERE
    id = auth.uid ();

$$;

CREATE OR REPLACE FUNCTION public.app_role ()
  RETURNS text
  LANGUAGE sql
  STABLE
  SECURITY DEFINER
  SET search_path = public
  AS $$
  SELECT
    app_role
  FROM
    public.profiles
  WHERE
    id = auth.uid ();

$$;

-- Subordinados directos e indirectos (para políticas futuras)
CREATE OR REPLACE FUNCTION public.empleados_del_encargado (p_encargado uuid)
  RETURNS SETOF uuid
  LANGUAGE sql
  STABLE
  SECURITY DEFINER
  SET search_path = public
  AS $$
  WITH RECURSIVE sub AS (
    SELECT
      id
    FROM
      public.profiles
    WHERE
      supervisor_id = p_encargado
    UNION ALL
    SELECT
      p.id
    FROM
      public.profiles p
      INNER JOIN sub s ON p.supervisor_id = s.id
  )
SELECT
  id
FROM
  sub;

$$;

COMMENT ON FUNCTION public.empleados_del_encargado (uuid) IS 'IDs de empleados bajo un encargado (árbol supervisor_id).';

-- Predicados reutilizables
CREATE OR REPLACE FUNCTION public.oc_visible_encargado (p_oc uuid)
  RETURNS boolean
  LANGUAGE sql
  STABLE
  SECURITY DEFINER
  SET search_path = public
  AS $$
  SELECT
    EXISTS (
      SELECT
        1
      FROM
        public.ordenes_compra_encabezado o
      WHERE
        o.id = p_oc
        AND o.empresa_id = public.current_empresa_id ()
        AND o.id_sucursal = public.current_sucursal_id ());

$$;

CREATE OR REPLACE FUNCTION public.traslado_visible_encargado (p_tr uuid)
  RETURNS boolean
  LANGUAGE sql
  STABLE
  SECURITY DEFINER
  SET search_path = public
  AS $$
  SELECT
    EXISTS (
      SELECT
        1
      FROM
        public.traslados_encabezado t
      WHERE
        t.id = p_tr
        AND t.empresa_id = public.current_empresa_id ()
        AND t.id_sucursal_origen = public.current_sucursal_id ());

$$;

-- -----------------------------------------------------------------------------
-- RLS: profiles (cada usuario ve y actualiza solo su fila)
-- -----------------------------------------------------------------------------
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY p_profiles_select_own ON public.profiles
  FOR SELECT TO authenticated
  USING (id = auth.uid ());

CREATE POLICY p_profiles_update_own ON public.profiles
  FOR UPDATE TO authenticated
  USING (id = auth.uid ())
  WITH CHECK (id = auth.uid ());

CREATE POLICY p_profiles_insert_own ON public.profiles
  FOR INSERT TO authenticated
  WITH CHECK (id = auth.uid ());

-- -----------------------------------------------------------------------------
-- productos
-- -----------------------------------------------------------------------------
ALTER TABLE public.productos ENABLE ROW LEVEL SECURITY;

CREATE POLICY p_productos_select_empleado ON public.productos
  FOR SELECT TO authenticated
  USING (public.app_role () = 'empleado'
    AND empresa_id = public.current_empresa_id ());

CREATE POLICY p_productos_select_encargado ON public.productos
  FOR SELECT TO authenticated
  USING (public.app_role () = 'encargado'
    AND empresa_id = public.current_empresa_id ());

CREATE POLICY p_productos_select_admin ON public.productos
  FOR SELECT TO authenticated
  USING (public.app_role () = 'admin'
    AND empresa_id = public.current_empresa_id ());

CREATE POLICY p_productos_insert_admin ON public.productos
  FOR INSERT TO authenticated
  WITH CHECK (public.app_role () = 'admin'
  AND empresa_id = public.current_empresa_id ());

CREATE POLICY p_productos_update_admin ON public.productos
  FOR UPDATE TO authenticated
  USING (public.app_role () = 'admin'
    AND empresa_id = public.current_empresa_id ())
  WITH CHECK (public.app_role () = 'admin'
    AND empresa_id = public.current_empresa_id ());

CREATE POLICY p_productos_delete_admin ON public.productos
  FOR DELETE TO authenticated
  USING (public.app_role () = 'admin'
    AND empresa_id = public.current_empresa_id ());

-- -----------------------------------------------------------------------------
-- compras_encabezado / compras_detalle
-- -----------------------------------------------------------------------------
ALTER TABLE public.compras_encabezado ENABLE ROW LEVEL SECURITY;

CREATE POLICY p_compras_enc_select_encargado ON public.compras_encabezado
  FOR SELECT TO authenticated
  USING (public.app_role () = 'encargado'
    AND empresa_id = public.current_empresa_id ()
    AND id_sucursal = public.current_sucursal_id ());

CREATE POLICY p_compras_enc_select_admin ON public.compras_encabezado
  FOR SELECT TO authenticated
  USING (public.app_role () = 'admin'
    AND empresa_id = public.current_empresa_id ());

CREATE POLICY p_compras_enc_insert_admin ON public.compras_encabezado
  FOR INSERT TO authenticated
  WITH CHECK (public.app_role () = 'admin'
  AND empresa_id = public.current_empresa_id ());

CREATE POLICY p_compras_enc_update_admin ON public.compras_encabezado
  FOR UPDATE TO authenticated
  USING (public.app_role () = 'admin'
    AND empresa_id = public.current_empresa_id ())
  WITH CHECK (public.app_role () = 'admin'
    AND empresa_id = public.current_empresa_id ());

CREATE POLICY p_compras_enc_delete_admin ON public.compras_encabezado
  FOR DELETE TO authenticated
  USING (public.app_role () = 'admin'
    AND empresa_id = public.current_empresa_id ());

ALTER TABLE public.compras_detalle ENABLE ROW LEVEL SECURITY;

CREATE POLICY p_compras_det_select_encargado ON public.compras_detalle
  FOR SELECT TO authenticated
  USING (public.app_role () = 'encargado'
    AND EXISTS (
      SELECT
        1
      FROM
        public.compras_encabezado c
      WHERE
        c.id = compras_detalle.id_compra
        AND c.empresa_id = public.current_empresa_id ()
        AND c.id_sucursal = public.current_sucursal_id ()));

CREATE POLICY p_compras_det_all_admin ON public.compras_detalle
  FOR ALL TO authenticated
  USING (public.app_role () = 'admin'
    AND EXISTS (
      SELECT
        1
      FROM
        public.compras_encabezado c
      WHERE
        c.id = compras_detalle.id_compra
        AND c.empresa_id = public.current_empresa_id ()))
  WITH CHECK (public.app_role () = 'admin'
    AND EXISTS (
      SELECT
        1
      FROM
        public.compras_encabezado c
      WHERE
        c.id = compras_detalle.id_compra
        AND c.empresa_id = public.current_empresa_id ()));

-- -----------------------------------------------------------------------------
-- ordenes_compra_encabezado
-- -----------------------------------------------------------------------------
ALTER TABLE public.ordenes_compra_encabezado ENABLE ROW LEVEL SECURITY;

CREATE POLICY p_oc_enc_select_empleado ON public.ordenes_compra_encabezado
  FOR SELECT TO authenticated
  USING (public.app_role () = 'empleado'
    AND empresa_id = public.current_empresa_id ()
    AND empleado_asignado_id = auth.uid ());

CREATE POLICY p_oc_enc_insert_empleado ON public.ordenes_compra_encabezado
  FOR INSERT TO authenticated
  WITH CHECK (public.app_role () = 'empleado'
    AND empresa_id = public.current_empresa_id ()
    AND id_sucursal = public.current_sucursal_id ()
    AND empleado_asignado_id = auth.uid ()
    AND estado IN ('BORRADOR', 'ENVIADO'));

CREATE POLICY p_oc_enc_update_empleado ON public.ordenes_compra_encabezado
  FOR UPDATE TO authenticated
  USING (public.app_role () = 'empleado'
    AND empresa_id = public.current_empresa_id ()
    AND empleado_asignado_id = auth.uid ()
    AND estado = 'BORRADOR')
  WITH CHECK (public.app_role () = 'empleado'
    AND empresa_id = public.current_empresa_id ()
    AND empleado_asignado_id = auth.uid ()
    AND estado IN ('BORRADOR', 'ENVIADO'));

CREATE POLICY p_oc_enc_delete_empleado ON public.ordenes_compra_encabezado
  FOR DELETE TO authenticated
  USING (public.app_role () = 'empleado'
    AND empresa_id = public.current_empresa_id ()
    AND empleado_asignado_id = auth.uid ()
    AND estado = 'BORRADOR');

CREATE POLICY p_oc_enc_select_encargado ON public.ordenes_compra_encabezado
  FOR SELECT TO authenticated
  USING (public.app_role () = 'encargado'
    AND empresa_id = public.current_empresa_id ()
    AND id_sucursal = public.current_sucursal_id ());

CREATE POLICY p_oc_enc_insert_encargado ON public.ordenes_compra_encabezado
  FOR INSERT TO authenticated
  WITH CHECK (public.app_role () = 'encargado'
    AND empresa_id = public.current_empresa_id ()
    AND id_sucursal = public.current_sucursal_id ());

CREATE POLICY p_oc_enc_update_encargado ON public.ordenes_compra_encabezado
  FOR UPDATE TO authenticated
  USING (public.app_role () = 'encargado'
    AND empresa_id = public.current_empresa_id ()
    AND id_sucursal = public.current_sucursal_id ()
    AND estado IN ('ENVIADO', 'PENDIENTE'))
  WITH CHECK (public.app_role () = 'encargado'
    AND empresa_id = public.current_empresa_id ()
    AND id_sucursal = public.current_sucursal_id ());

CREATE POLICY p_oc_enc_all_admin ON public.ordenes_compra_encabezado
  FOR ALL TO authenticated
  USING (public.app_role () = 'admin'
    AND empresa_id = public.current_empresa_id ())
  WITH CHECK (public.app_role () = 'admin'
    AND empresa_id = public.current_empresa_id ());

-- -----------------------------------------------------------------------------
-- ordenes_compra_detalle
-- -----------------------------------------------------------------------------
ALTER TABLE public.ordenes_compra_detalle ENABLE ROW LEVEL SECURITY;

CREATE POLICY p_oc_det_select_empleado ON public.ordenes_compra_detalle
  FOR SELECT TO authenticated
  USING (public.app_role () = 'empleado'
    AND EXISTS (
      SELECT
        1
      FROM
        public.ordenes_compra_encabezado o
      WHERE
        o.id = ordenes_compra_detalle.id_orden_compra
        AND o.empresa_id = public.current_empresa_id ()
        AND o.empleado_asignado_id = auth.uid ()));

CREATE POLICY p_oc_det_insert_empleado ON public.ordenes_compra_detalle
  FOR INSERT TO authenticated
  WITH CHECK (public.app_role () = 'empleado'
    AND EXISTS (
      SELECT
        1
      FROM
        public.ordenes_compra_encabezado o
      WHERE
        o.id = ordenes_compra_detalle.id_orden_compra
        AND o.empresa_id = public.current_empresa_id ()
        AND o.id_sucursal = public.current_sucursal_id ()
        AND o.empleado_asignado_id = auth.uid ()
        AND o.estado IN ('BORRADOR', 'ENVIADO')));

CREATE POLICY p_oc_det_update_empleado ON public.ordenes_compra_detalle
  FOR UPDATE TO authenticated
  USING (public.app_role () = 'empleado'
    AND EXISTS (
      SELECT
        1
      FROM
        public.ordenes_compra_encabezado o
      WHERE
        o.id = ordenes_compra_detalle.id_orden_compra
        AND o.empleado_asignado_id = auth.uid ()
        AND o.estado = 'BORRADOR'))
  WITH CHECK (public.app_role () = 'empleado'
    AND EXISTS (
      SELECT
        1
      FROM
        public.ordenes_compra_encabezado o
      WHERE
        o.id = ordenes_compra_detalle.id_orden_compra
        AND o.empleado_asignado_id = auth.uid ()
        AND o.estado = 'BORRADOR'));

CREATE POLICY p_oc_det_delete_empleado ON public.ordenes_compra_detalle
  FOR DELETE TO authenticated
  USING (public.app_role () = 'empleado'
    AND EXISTS (
      SELECT
        1
      FROM
        public.ordenes_compra_encabezado o
      WHERE
        o.id = ordenes_compra_detalle.id_orden_compra
        AND o.empleado_asignado_id = auth.uid ()
        AND o.estado = 'BORRADOR'));

CREATE POLICY p_oc_det_select_encargado ON public.ordenes_compra_detalle
  FOR SELECT TO authenticated
  USING (public.app_role () = 'encargado'
    AND public.oc_visible_encargado (ordenes_compra_detalle.id_orden_compra));

CREATE POLICY p_oc_det_insert_encargado ON public.ordenes_compra_detalle
  FOR INSERT TO authenticated
  WITH CHECK (public.app_role () = 'encargado'
    AND public.oc_visible_encargado (ordenes_compra_detalle.id_orden_compra)
    AND EXISTS (
      SELECT
        1
      FROM
        public.ordenes_compra_encabezado o
      WHERE
        o.id = ordenes_compra_detalle.id_orden_compra
        AND o.estado IN ('BORRADOR', 'ENVIADO', 'PENDIENTE')));

CREATE POLICY p_oc_det_update_encargado ON public.ordenes_compra_detalle
  FOR UPDATE TO authenticated
  USING (public.app_role () = 'encargado'
    AND public.oc_visible_encargado (ordenes_compra_detalle.id_orden_compra)
    AND EXISTS (
      SELECT
        1
      FROM
        public.ordenes_compra_encabezado o
      WHERE
        o.id = ordenes_compra_detalle.id_orden_compra
        AND o.estado IN ('BORRADOR', 'ENVIADO', 'PENDIENTE')))
  WITH CHECK (public.app_role () = 'encargado'
    AND public.oc_visible_encargado (ordenes_compra_detalle.id_orden_compra));

CREATE POLICY p_oc_det_delete_encargado ON public.ordenes_compra_detalle
  FOR DELETE TO authenticated
  USING (public.app_role () = 'encargado'
    AND public.oc_visible_encargado (ordenes_compra_detalle.id_orden_compra)
    AND EXISTS (
      SELECT
        1
      FROM
        public.ordenes_compra_encabezado o
      WHERE
        o.id = ordenes_compra_detalle.id_orden_compra
        AND o.estado IN ('BORRADOR', 'ENVIADO', 'PENDIENTE')));

CREATE POLICY p_oc_det_all_admin ON public.ordenes_compra_detalle
  FOR ALL TO authenticated
  USING (public.app_role () = 'admin'
    AND EXISTS (
      SELECT
        1
      FROM
        public.ordenes_compra_encabezado o
      WHERE
        o.id = ordenes_compra_detalle.id_orden_compra
        AND o.empresa_id = public.current_empresa_id ()))
  WITH CHECK (public.app_role () = 'admin'
    AND EXISTS (
      SELECT
        1
      FROM
        public.ordenes_compra_encabezado o
      WHERE
        o.id = ordenes_compra_detalle.id_orden_compra
        AND o.empresa_id = public.current_empresa_id ()));

-- -----------------------------------------------------------------------------
-- traslados_encabezado
-- -----------------------------------------------------------------------------
ALTER TABLE public.traslados_encabezado ENABLE ROW LEVEL SECURITY;

CREATE POLICY p_tr_enc_select_empleado ON public.traslados_encabezado
  FOR SELECT TO authenticated
  USING (public.app_role () = 'empleado'
    AND empresa_id = public.current_empresa_id ()
    AND empleado_asignado_id = auth.uid ());

CREATE POLICY p_tr_enc_insert_empleado ON public.traslados_encabezado
  FOR INSERT TO authenticated
  WITH CHECK (public.app_role () = 'empleado'
    AND empresa_id = public.current_empresa_id ()
    AND id_sucursal_origen = public.current_sucursal_id ()
    AND empleado_asignado_id = auth.uid ()
    AND estado IN ('BORRADOR', 'ENVIADO'));

CREATE POLICY p_tr_enc_update_empleado ON public.traslados_encabezado
  FOR UPDATE TO authenticated
  USING (public.app_role () = 'empleado'
    AND empresa_id = public.current_empresa_id ()
    AND empleado_asignado_id = auth.uid ()
    AND estado = 'BORRADOR')
  WITH CHECK (public.app_role () = 'empleado'
    AND empresa_id = public.current_empresa_id ()
    AND empleado_asignado_id = auth.uid ()
    AND estado IN ('BORRADOR', 'ENVIADO'));

CREATE POLICY p_tr_enc_delete_empleado ON public.traslados_encabezado
  FOR DELETE TO authenticated
  USING (public.app_role () = 'empleado'
    AND empresa_id = public.current_empresa_id ()
    AND empleado_asignado_id = auth.uid ()
    AND estado = 'BORRADOR');

CREATE POLICY p_tr_enc_select_encargado ON public.traslados_encabezado
  FOR SELECT TO authenticated
  USING (public.app_role () = 'encargado'
    AND empresa_id = public.current_empresa_id ()
    AND id_sucursal_origen = public.current_sucursal_id ());

CREATE POLICY p_tr_enc_insert_encargado ON public.traslados_encabezado
  FOR INSERT TO authenticated
  WITH CHECK (public.app_role () = 'encargado'
    AND empresa_id = public.current_empresa_id ()
    AND id_sucursal_origen = public.current_sucursal_id ());

CREATE POLICY p_tr_enc_update_encargado ON public.traslados_encabezado
  FOR UPDATE TO authenticated
  USING (public.app_role () = 'encargado'
    AND empresa_id = public.current_empresa_id ()
    AND id_sucursal_origen = public.current_sucursal_id ()
    AND estado IN ('ENVIADO', 'PENDIENTE'))
  WITH CHECK (public.app_role () = 'encargado'
    AND empresa_id = public.current_empresa_id ()
    AND id_sucursal_origen = public.current_sucursal_id ());

CREATE POLICY p_tr_enc_all_admin ON public.traslados_encabezado
  FOR ALL TO authenticated
  USING (public.app_role () = 'admin'
    AND empresa_id = public.current_empresa_id ())
  WITH CHECK (public.app_role () = 'admin'
    AND empresa_id = public.current_empresa_id ());

-- -----------------------------------------------------------------------------
-- traslados_detalle
-- -----------------------------------------------------------------------------
ALTER TABLE public.traslados_detalle ENABLE ROW LEVEL SECURITY;

CREATE POLICY p_tr_det_select_empleado ON public.traslados_detalle
  FOR SELECT TO authenticated
  USING (public.app_role () = 'empleado'
    AND EXISTS (
      SELECT
        1
      FROM
        public.traslados_encabezado t
      WHERE
        t.id = traslados_detalle.id_traslado
        AND t.empresa_id = public.current_empresa_id ()
        AND t.empleado_asignado_id = auth.uid ()));

CREATE POLICY p_tr_det_insert_empleado ON public.traslados_detalle
  FOR INSERT TO authenticated
  WITH CHECK (public.app_role () = 'empleado'
    AND EXISTS (
      SELECT
        1
      FROM
        public.traslados_encabezado t
      WHERE
        t.id = traslados_detalle.id_traslado
        AND t.empresa_id = public.current_empresa_id ()
        AND t.id_sucursal_origen = public.current_sucursal_id ()
        AND t.empleado_asignado_id = auth.uid ()
        AND t.estado IN ('BORRADOR', 'ENVIADO')));

CREATE POLICY p_tr_det_update_empleado ON public.traslados_detalle
  FOR UPDATE TO authenticated
  USING (public.app_role () = 'empleado'
    AND EXISTS (
      SELECT
        1
      FROM
        public.traslados_encabezado t
      WHERE
        t.id = traslados_detalle.id_traslado
        AND t.empleado_asignado_id = auth.uid ()
        AND t.estado = 'BORRADOR'))
  WITH CHECK (public.app_role () = 'empleado'
    AND EXISTS (
      SELECT
        1
      FROM
        public.traslados_encabezado t
      WHERE
        t.id = traslados_detalle.id_traslado
        AND t.empleado_asignado_id = auth.uid ()
        AND t.estado = 'BORRADOR'));

CREATE POLICY p_tr_det_delete_empleado ON public.traslados_detalle
  FOR DELETE TO authenticated
  USING (public.app_role () = 'empleado'
    AND EXISTS (
      SELECT
        1
      FROM
        public.traslados_encabezado t
      WHERE
        t.id = traslados_detalle.id_traslado
        AND t.empleado_asignado_id = auth.uid ()
        AND t.estado = 'BORRADOR'));

CREATE POLICY p_tr_det_select_encargado ON public.traslados_detalle
  FOR SELECT TO authenticated
  USING (public.app_role () = 'encargado'
    AND public.traslado_visible_encargado (traslados_detalle.id_traslado));

CREATE POLICY p_tr_det_insert_encargado ON public.traslados_detalle
  FOR INSERT TO authenticated
  WITH CHECK (public.app_role () = 'encargado'
    AND public.traslado_visible_encargado (traslados_detalle.id_traslado)
    AND EXISTS (
      SELECT
        1
      FROM
        public.traslados_encabezado t
      WHERE
        t.id = traslados_detalle.id_traslado
        AND t.estado IN ('BORRADOR', 'ENVIADO', 'PENDIENTE')));

CREATE POLICY p_tr_det_update_encargado ON public.traslados_detalle
  FOR UPDATE TO authenticated
  USING (public.app_role () = 'encargado'
    AND public.traslado_visible_encargado (traslados_detalle.id_traslado)
    AND EXISTS (
      SELECT
        1
      FROM
        public.traslados_encabezado t
      WHERE
        t.id = traslados_detalle.id_traslado
        AND t.estado IN ('BORRADOR', 'ENVIADO', 'PENDIENTE')))
  WITH CHECK (public.app_role () = 'encargado'
    AND public.traslado_visible_encargado (traslados_detalle.id_traslado));

CREATE POLICY p_tr_det_delete_encargado ON public.traslados_detalle
  FOR DELETE TO authenticated
  USING (public.app_role () = 'encargado'
    AND public.traslado_visible_encargado (traslados_detalle.id_traslado)
    AND EXISTS (
      SELECT
        1
      FROM
        public.traslados_encabezado t
      WHERE
        t.id = traslados_detalle.id_traslado
        AND t.estado IN ('BORRADOR', 'ENVIADO', 'PENDIENTE')));

CREATE POLICY p_tr_det_all_admin ON public.traslados_detalle
  FOR ALL TO authenticated
  USING (public.app_role () = 'admin'
    AND EXISTS (
      SELECT
        1
      FROM
        public.traslados_encabezado t
      WHERE
        t.id = traslados_detalle.id_traslado
        AND t.empresa_id = public.current_empresa_id ()))
  WITH CHECK (public.app_role () = 'admin'
    AND EXISTS (
      SELECT
        1
      FROM
        public.traslados_encabezado t
      WHERE
        t.id = traslados_detalle.id_traslado
        AND t.empresa_id = public.current_empresa_id ()));

-- -----------------------------------------------------------------------------
-- clientes / proveedores
-- -----------------------------------------------------------------------------
ALTER TABLE public.clientes ENABLE ROW LEVEL SECURITY;

CREATE POLICY p_clientes_select_staff ON public.clientes
  FOR SELECT TO authenticated
  USING (public.app_role () IN ('empleado', 'encargado')
    AND empresa_id = public.current_empresa_id ());

CREATE POLICY p_clientes_all_admin ON public.clientes
  FOR ALL TO authenticated
  USING (public.app_role () = 'admin'
    AND empresa_id = public.current_empresa_id ())
  WITH CHECK (public.app_role () = 'admin'
    AND empresa_id = public.current_empresa_id ());

ALTER TABLE public.proveedores ENABLE ROW LEVEL SECURITY;

CREATE POLICY p_proveedores_select_staff ON public.proveedores
  FOR SELECT TO authenticated
  USING (public.app_role () IN ('empleado', 'encargado')
    AND empresa_id = public.current_empresa_id ());

CREATE POLICY p_proveedores_all_admin ON public.proveedores
  FOR ALL TO authenticated
  USING (public.app_role () = 'admin'
    AND empresa_id = public.current_empresa_id ())
  WITH CHECK (public.app_role () = 'admin'
    AND empresa_id = public.current_empresa_id ());

-- -----------------------------------------------------------------------------
-- Grants (rol Supabase)
-- -----------------------------------------------------------------------------
GRANT USAGE ON SCHEMA public TO authenticated;

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO authenticated;

GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO authenticated;

GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO authenticated;
