-- =============================================================================
-- MIGRACIÓN: proveedores, compras_encabezado, compras_detalle,
--            traslados_encabezado, traslados_detalle
-- Archivo : 20260417002800_erp_proveedores_compras_traslados.sql
-- Trigger : public.handle_updated_at() → columna updatedat
-- Enum    : traslado_estado = BORRADOR|ENVIADO|APROBADO|EN_TRANSITO|
--                             COMPLETADO|RECHAZADO|ANULADO
-- Tabla de perfiles: public.user_profiles (userid = auth.uid())
-- Helpers: public.current_empresa_id(), public.current_sucursal_id(),
--          public.app_role()
-- =============================================================================

-- ===========================================================================
-- 1. PROVEEDORES
-- ===========================================================================
ALTER TABLE public.proveedores
  ADD COLUMN IF NOT EXISTS activo      boolean     NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS sync_status text        NOT NULL DEFAULT 'SYNCED',
  ADD COLUMN IF NOT EXISTS deleted_at  timestamptz;

DO $$ BEGIN
  ALTER TABLE public.proveedores
    ADD CONSTRAINT proveedores_sync_status_check
    CHECK (sync_status IN ('SYNCED','PENDING','CONFLICT'));
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DROP TRIGGER IF EXISTS trg_updated_at_proveedores ON public.proveedores;
CREATE TRIGGER trg_updated_at_proveedores
  BEFORE UPDATE ON public.proveedores
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

CREATE INDEX IF NOT EXISTS idx_proveedores_empresa_id ON public.proveedores(empresa_id);
CREATE UNIQUE INDEX IF NOT EXISTS uidx_proveedores_doc
  ON public.proveedores(empresa_id, num_documento)
  WHERE deleted_at IS NULL AND num_documento IS NOT NULL;

ALTER TABLE public.proveedores ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS p_proveedores_select    ON public.proveedores;
DROP POLICY IF EXISTS p_proveedores_admin_all ON public.proveedores;

-- empleado + encargado: SELECT mismo empresa
CREATE POLICY p_proveedores_select ON public.proveedores
  FOR SELECT
  USING (
    empresa_id = public.current_empresa_id()
    AND deleted_at IS NULL
    AND public.app_role() IN ('empleado','encargado','admin')
  );

-- admin: ALL
CREATE POLICY p_proveedores_admin_all ON public.proveedores
  FOR ALL
  USING  (public.app_role() = 'admin' AND empresa_id = public.current_empresa_id())
  WITH CHECK (empresa_id = public.current_empresa_id());

-- ===========================================================================
-- 2. COMPRAS_ENCABEZADO
-- ===========================================================================
ALTER TABLE public.compras_encabezado
  ADD COLUMN IF NOT EXISTS sync_status text NOT NULL DEFAULT 'SYNCED',
  ADD COLUMN IF NOT EXISTS deleted_at  timestamptz;

DO $$ BEGIN
  ALTER TABLE public.compras_encabezado
    ADD CONSTRAINT compras_sync_status_check
    CHECK (sync_status IN ('SYNCED','PENDING','CONFLICT'));
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  ALTER TABLE public.compras_encabezado
    ADD CONSTRAINT compras_estado_check
    CHECK (estado_compra IN ('BORRADOR','APROBADO','NO_APROBADO'));
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$ BEGIN
  ALTER TABLE public.compras_encabezado
    ADD CONSTRAINT compras_tipo_check
    CHECK (tipo_compra IN ('PRODUCTOS','GASTOS','GASTO_IMPORTACION'));
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DROP TRIGGER IF EXISTS trg_updated_at_compras_enc ON public.compras_encabezado;
CREATE TRIGGER trg_updated_at_compras_enc
  BEFORE UPDATE ON public.compras_encabezado
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

CREATE INDEX IF NOT EXISTS idx_compras_enc_empresa   ON public.compras_encabezado(empresa_id);
CREATE INDEX IF NOT EXISTS idx_compras_enc_sucursal  ON public.compras_encabezado(id_sucursal);
CREATE INDEX IF NOT EXISTS idx_compras_enc_proveedor ON public.compras_encabezado(id_proveedor);
CREATE UNIQUE INDEX IF NOT EXISTS uidx_compras_num
  ON public.compras_encabezado(empresa_id, num_compra)
  WHERE deleted_at IS NULL;

ALTER TABLE public.compras_encabezado ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS p_compras_enc_encargado_select ON public.compras_encabezado;
DROP POLICY IF EXISTS p_compras_enc_admin_all        ON public.compras_encabezado;

-- encargado: SELECT misma empresa + sucursal
CREATE POLICY p_compras_enc_encargado_select ON public.compras_encabezado
  FOR SELECT
  USING (
    public.app_role() = 'encargado'
    AND empresa_id  = public.current_empresa_id()
    AND id_sucursal = public.current_sucursal_id()
    AND deleted_at IS NULL
  );

-- admin: ALL
CREATE POLICY p_compras_enc_admin_all ON public.compras_encabezado
  FOR ALL
  USING  (public.app_role() = 'admin' AND empresa_id = public.current_empresa_id())
  WITH CHECK (empresa_id = public.current_empresa_id());

-- ===========================================================================
-- 3. COMPRAS_DETALLE
-- ===========================================================================
ALTER TABLE public.compras_detalle
  ADD COLUMN IF NOT EXISTS descuento_valor      numeric DEFAULT 0,
  ADD COLUMN IF NOT EXISTS costo_unitario_neto  numeric,
  ADD COLUMN IF NOT EXISTS costo_unitario_final numeric,
  ADD COLUMN IF NOT EXISTS subtotal_linea       numeric;

DROP TRIGGER IF EXISTS trg_updated_at_compras_det ON public.compras_detalle;
CREATE TRIGGER trg_updated_at_compras_det
  BEFORE UPDATE ON public.compras_detalle
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

CREATE INDEX IF NOT EXISTS idx_compras_det_compra   ON public.compras_detalle(id_compra);
CREATE INDEX IF NOT EXISTS idx_compras_det_producto ON public.compras_detalle(id_producto);

ALTER TABLE public.compras_detalle ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS p_compras_det_encargado_select ON public.compras_detalle;
DROP POLICY IF EXISTS p_compras_det_admin_all        ON public.compras_detalle;

-- encargado: SELECT vía encabezado
CREATE POLICY p_compras_det_encargado_select ON public.compras_detalle
  FOR SELECT
  USING (
    public.app_role() = 'encargado'
    AND EXISTS (
      SELECT 1 FROM public.compras_encabezado ce
      WHERE ce.id_compra   = compras_detalle.id_compra
        AND ce.empresa_id  = public.current_empresa_id()
        AND ce.id_sucursal = public.current_sucursal_id()
        AND ce.deleted_at IS NULL
    )
  );

-- admin: ALL vía encabezado
CREATE POLICY p_compras_det_admin_all ON public.compras_detalle
  FOR ALL
  USING (
    public.app_role() = 'admin'
    AND EXISTS (
      SELECT 1 FROM public.compras_encabezado ce
      WHERE ce.id_compra  = compras_detalle.id_compra
        AND ce.empresa_id = public.current_empresa_id()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.compras_encabezado ce
      WHERE ce.id_compra  = compras_detalle.id_compra
        AND ce.empresa_id = public.current_empresa_id()
    )
  );

-- ===========================================================================
-- 4. TRASLADOS_ENCABEZADO
-- Columnas camelCase existentes: empresaid, numtraslado, bodegaorigenid,
-- bodegadestinoid, estado (traslado_estado enum), motivotraslado, createdby
-- Añadimos aliases snake_case + columnas de control
-- ===========================================================================
ALTER TABLE public.traslados_encabezado
  ADD COLUMN IF NOT EXISTS empresa_id           uuid,
  ADD COLUMN IF NOT EXISTS ubicacion_origen_id  uuid,
  ADD COLUMN IF NOT EXISTS ubicacion_destino_id uuid,
  ADD COLUMN IF NOT EXISTS num_traslado         text,
  ADD COLUMN IF NOT EXISTS fecha_traslado       date,
  ADD COLUMN IF NOT EXISTS motivo               text,
  ADD COLUMN IF NOT EXISTS nota                 text,
  ADD COLUMN IF NOT EXISTS empleado_asignado_id uuid,
  ADD COLUMN IF NOT EXISTS creado_por_id        uuid,
  ADD COLUMN IF NOT EXISTS sync_status          text NOT NULL DEFAULT 'SYNCED',
  ADD COLUMN IF NOT EXISTS deleted_at           timestamptz;

DO $$ BEGIN
  ALTER TABLE public.traslados_encabezado
    ADD CONSTRAINT traslados_enc_sync_status_check
    CHECK (sync_status IN ('SYNCED','PENDING','CONFLICT'));
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- Backfill snake_case desde columnas camelCase
UPDATE public.traslados_encabezado SET
  empresa_id           = COALESCE(empresa_id,           empresaid),
  ubicacion_origen_id  = COALESCE(ubicacion_origen_id,  bodegaorigenid),
  ubicacion_destino_id = COALESCE(ubicacion_destino_id, bodegadestinoid),
  num_traslado         = COALESCE(num_traslado,         numtraslado),
  fecha_traslado       = COALESCE(fecha_traslado,       fechasolicitud::date),
  motivo               = COALESCE(motivo,               motivotraslado),
  creado_por_id        = COALESCE(creado_por_id,        createdby)
WHERE empresa_id IS NULL OR num_traslado IS NULL;

DROP TRIGGER IF EXISTS trg_updated_at_traslados_enc ON public.traslados_encabezado;
CREATE TRIGGER trg_updated_at_traslados_enc
  BEFORE UPDATE ON public.traslados_encabezado
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

CREATE INDEX IF NOT EXISTS idx_traslados_enc_empresa ON public.traslados_encabezado(empresa_id);
CREATE INDEX IF NOT EXISTS idx_traslados_enc_origen  ON public.traslados_encabezado(ubicacion_origen_id);
CREATE INDEX IF NOT EXISTS idx_traslados_enc_destino ON public.traslados_encabezado(ubicacion_destino_id);
CREATE UNIQUE INDEX IF NOT EXISTS uidx_traslados_num
  ON public.traslados_encabezado(empresa_id, num_traslado)
  WHERE deleted_at IS NULL;

ALTER TABLE public.traslados_encabezado ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS p_traslados_enc_empleado_select  ON public.traslados_encabezado;
DROP POLICY IF EXISTS p_traslados_enc_empleado_insert  ON public.traslados_encabezado;
DROP POLICY IF EXISTS p_traslados_enc_empleado_update  ON public.traslados_encabezado;
DROP POLICY IF EXISTS p_traslados_enc_empleado_delete  ON public.traslados_encabezado;
DROP POLICY IF EXISTS p_traslados_enc_encargado_select ON public.traslados_encabezado;
DROP POLICY IF EXISTS p_traslados_enc_encargado_update ON public.traslados_encabezado;
DROP POLICY IF EXISTS p_traslados_enc_admin_all        ON public.traslados_encabezado;

-- empleado: SELECT solo propios en BORRADOR
CREATE POLICY p_traslados_enc_empleado_select ON public.traslados_encabezado
  FOR SELECT
  USING (
    public.app_role() = 'empleado'
    AND empresa_id    = public.current_empresa_id()
    AND creado_por_id = auth.uid()
    AND deleted_at IS NULL
  );

-- empleado: INSERT solo en BORRADOR
CREATE POLICY p_traslados_enc_empleado_insert ON public.traslados_encabezado
  FOR INSERT
  WITH CHECK (
    public.app_role() = 'empleado'
    AND empresa_id = public.current_empresa_id()
    AND estado     = 'BORRADOR'
  );

-- empleado: UPDATE solo propios en BORRADOR
CREATE POLICY p_traslados_enc_empleado_update ON public.traslados_encabezado
  FOR UPDATE
  USING (
    public.app_role() = 'empleado'
    AND creado_por_id = auth.uid()
    AND empresa_id   = public.current_empresa_id()
    AND estado       = 'BORRADOR'
  )
  WITH CHECK (estado = 'BORRADOR');

-- empleado: DELETE solo propios en BORRADOR
CREATE POLICY p_traslados_enc_empleado_delete ON public.traslados_encabezado
  FOR DELETE
  USING (
    public.app_role() = 'empleado'
    AND creado_por_id = auth.uid()
    AND empresa_id   = public.current_empresa_id()
    AND estado       = 'BORRADOR'
  );

-- encargado: SELECT de su sucursal (origen o destino)
CREATE POLICY p_traslados_enc_encargado_select ON public.traslados_encabezado
  FOR SELECT
  USING (
    public.app_role() = 'encargado'
    AND empresa_id   = public.current_empresa_id()
    AND (ubicacion_origen_id  = public.current_sucursal_id()
      OR ubicacion_destino_id = public.current_sucursal_id())
    AND deleted_at IS NULL
  );

-- encargado: UPDATE → puede mover a ENVIADO/APROBADO/EN_TRANSITO/COMPLETADO/RECHAZADO/ANULADO
CREATE POLICY p_traslados_enc_encargado_update ON public.traslados_encabezado
  FOR UPDATE
  USING (
    public.app_role() = 'encargado'
    AND empresa_id   = public.current_empresa_id()
    AND (ubicacion_origen_id  = public.current_sucursal_id()
      OR ubicacion_destino_id = public.current_sucursal_id())
  )
  WITH CHECK (
    estado IN ('ENVIADO','APROBADO','EN_TRANSITO','COMPLETADO','RECHAZADO','ANULADO')
  );

-- admin: ALL
CREATE POLICY p_traslados_enc_admin_all ON public.traslados_encabezado
  FOR ALL
  USING  (public.app_role() = 'admin' AND empresa_id = public.current_empresa_id())
  WITH CHECK (empresa_id = public.current_empresa_id());

-- ===========================================================================
-- 5. TRASLADOS_DETALLE
-- ===========================================================================
ALTER TABLE public.traslados_detalle
  ADD COLUMN IF NOT EXISTS traslado_id        uuid,
  ADD COLUMN IF NOT EXISTS producto_id        uuid,
  ADD COLUMN IF NOT EXISTS cantidad           numeric,
  ADD COLUMN IF NOT EXISTS costo_unitario_ref numeric,
  ADD COLUMN IF NOT EXISTS lote_codigo        text,
  ADD COLUMN IF NOT EXISTS caducidad_fecha    date,
  ADD COLUMN IF NOT EXISTS nota_linea         text;

-- Backfill snake_case desde columnas camelCase
UPDATE public.traslados_detalle SET
  traslado_id     = COALESCE(traslado_id, trasladoid),
  producto_id     = COALESCE(producto_id, productoid),
  cantidad        = COALESCE(cantidad,    cantidadsolicitada),
  lote_codigo     = COALESCE(lote_codigo, lote),
  caducidad_fecha = COALESCE(caducidad_fecha, fechavencimiento),
  nota_linea      = COALESCE(nota_linea,  notalinea)
WHERE traslado_id IS NULL OR producto_id IS NULL;

DROP TRIGGER IF EXISTS trg_updated_at_traslados_det ON public.traslados_detalle;
CREATE TRIGGER trg_updated_at_traslados_det
  BEFORE UPDATE ON public.traslados_detalle
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

CREATE INDEX IF NOT EXISTS idx_traslados_det_traslado ON public.traslados_detalle(traslado_id);
CREATE INDEX IF NOT EXISTS idx_traslados_det_producto ON public.traslados_detalle(producto_id);

ALTER TABLE public.traslados_detalle ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS p_traslados_det_empleado  ON public.traslados_detalle;
DROP POLICY IF EXISTS p_traslados_det_encargado ON public.traslados_detalle;
DROP POLICY IF EXISTS p_traslados_det_admin_all ON public.traslados_detalle;

-- empleado: ALL vía encabezado propio en BORRADOR
CREATE POLICY p_traslados_det_empleado ON public.traslados_detalle
  FOR ALL
  USING (
    public.app_role() = 'empleado'
    AND EXISTS (
      SELECT 1 FROM public.traslados_encabezado te
      WHERE te.id            = traslados_detalle.traslado_id
        AND te.creado_por_id = auth.uid()
        AND te.empresa_id    = public.current_empresa_id()
        AND te.estado        = 'BORRADOR'
        AND te.deleted_at IS NULL
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.traslados_encabezado te
      WHERE te.id            = traslados_detalle.traslado_id
        AND te.creado_por_id = auth.uid()
        AND te.empresa_id    = public.current_empresa_id()
        AND te.estado        = 'BORRADOR'
    )
  );

-- encargado: SELECT vía encabezado de su sucursal
CREATE POLICY p_traslados_det_encargado ON public.traslados_detalle
  FOR SELECT
  USING (
    public.app_role() = 'encargado'
    AND EXISTS (
      SELECT 1 FROM public.traslados_encabezado te
      WHERE te.id          = traslados_detalle.traslado_id
        AND te.empresa_id  = public.current_empresa_id()
        AND (te.ubicacion_origen_id  = public.current_sucursal_id()
          OR te.ubicacion_destino_id = public.current_sucursal_id())
        AND te.deleted_at IS NULL
    )
  );

-- admin: ALL vía encabezado
CREATE POLICY p_traslados_det_admin_all ON public.traslados_detalle
  FOR ALL
  USING (
    public.app_role() = 'admin'
    AND EXISTS (
      SELECT 1 FROM public.traslados_encabezado te
      WHERE te.id         = traslados_detalle.traslado_id
        AND te.empresa_id = public.current_empresa_id()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.traslados_encabezado te
      WHERE te.id         = traslados_detalle.traslado_id
        AND te.empresa_id = public.current_empresa_id()
    )
  );
