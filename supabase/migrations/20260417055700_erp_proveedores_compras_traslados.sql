-- =============================================================================
-- Migration: 20260417055700_erp_proveedores_compras_traslados.sql
-- Tablas: proveedores, compras_encabezado, compras_detalle,
--         traslados_encabezado, traslados_detalle
-- Convenciones: idempotente, RLS por rol, trigger updated_at, soft delete,
--               sync_status, índices mínimos
-- =============================================================================

-- ---------------------------------------------------------------------------
-- 1. PROVEEDORES
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.proveedores (
    id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    empresa_id       uuid NOT NULL REFERENCES public.empresas(id) ON DELETE CASCADE,
    num_documento    text,
    razon_social     text NOT NULL,
    nombre_contacto  text,
    direccion        text,
    ciudad           text,
    departamento     text,
    pais             text DEFAULT 'Colombia',
    telefono         text,
    email            text,
    condicion_pago   text,
    activo           boolean NOT NULL DEFAULT true,
    sync_status      text NOT NULL DEFAULT 'SYNCED'
                         CHECK (sync_status IN ('SYNCED', 'PENDING', 'CONFLICT')),
    created_at       timestamptz NOT NULL DEFAULT now(),
    updated_at       timestamptz NOT NULL DEFAULT now(),
    deleted_at       timestamptz
);

CREATE INDEX IF NOT EXISTS proveedores_empresa_id_idx ON public.proveedores(empresa_id);
CREATE UNIQUE INDEX IF NOT EXISTS proveedores_empresa_doc_idx
    ON public.proveedores(empresa_id, num_documento)
    WHERE num_documento IS NOT NULL AND deleted_at IS NULL;

CREATE TRIGGER set_proveedores_updated_at
    BEFORE UPDATE ON public.proveedores
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- RLS proveedores
ALTER TABLE public.proveedores ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS proveedores_admin_all      ON public.proveedores;
DROP POLICY IF EXISTS proveedores_encargado_sel  ON public.proveedores;
DROP POLICY IF EXISTS proveedores_empleado_sel   ON public.proveedores;

CREATE POLICY proveedores_admin_all ON public.proveedores
    FOR ALL
    TO authenticated
    USING  (empresa_id = public.current_empresa_id() AND public.app_role() = 'admin')
    WITH CHECK (empresa_id = public.current_empresa_id() AND public.app_role() = 'admin');

CREATE POLICY proveedores_encargado_sel ON public.proveedores
    FOR SELECT
    TO authenticated
    USING (empresa_id = public.current_empresa_id()
           AND public.app_role() = 'encargado'
           AND deleted_at IS NULL);

CREATE POLICY proveedores_empleado_sel ON public.proveedores
    FOR SELECT
    TO authenticated
    USING (empresa_id = public.current_empresa_id()
           AND public.app_role() = 'empleado'
           AND deleted_at IS NULL);

-- ---------------------------------------------------------------------------
-- 2. COMPRAS_ENCABEZADO
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.compras_encabezado (
    id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    empresa_id     uuid NOT NULL REFERENCES public.empresas(id) ON DELETE CASCADE,
    ubicacion_id   uuid REFERENCES public.ubicaciones(id),
    proveedor_id   uuid REFERENCES public.proveedores(id),
    num_compra     text,
    fecha_compra   date NOT NULL DEFAULT current_date,
    tipo_compra    text NOT NULL DEFAULT 'PRODUCTOS'
                       CHECK (tipo_compra IN ('PRODUCTOS', 'GASTOS', 'GASTO_IMPORTACION')),
    estado         text NOT NULL DEFAULT 'BORRADOR'
                       CHECK (estado IN ('BORRADOR', 'APROBADO', 'NO_APROBADO')),
    moneda         text NOT NULL DEFAULT 'COP',
    forma_pago     text,
    nota           text,
    creado_por_id  uuid REFERENCES public.profiles(id),
    sync_status    text NOT NULL DEFAULT 'SYNCED'
                       CHECK (sync_status IN ('SYNCED', 'PENDING', 'CONFLICT')),
    created_at     timestamptz NOT NULL DEFAULT now(),
    updated_at     timestamptz NOT NULL DEFAULT now(),
    deleted_at     timestamptz
);

CREATE INDEX IF NOT EXISTS compras_enc_empresa_id_idx    ON public.compras_encabezado(empresa_id);
CREATE INDEX IF NOT EXISTS compras_enc_ubicacion_id_idx  ON public.compras_encabezado(ubicacion_id);
CREATE INDEX IF NOT EXISTS compras_enc_proveedor_id_idx  ON public.compras_encabezado(proveedor_id);
CREATE UNIQUE INDEX IF NOT EXISTS compras_enc_num_idx
    ON public.compras_encabezado(empresa_id, num_compra)
    WHERE num_compra IS NOT NULL AND deleted_at IS NULL;

CREATE TRIGGER set_compras_encabezado_updated_at
    BEFORE UPDATE ON public.compras_encabezado
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- RLS compras_encabezado
ALTER TABLE public.compras_encabezado ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS compras_enc_admin_all     ON public.compras_encabezado;
DROP POLICY IF EXISTS compras_enc_encargado_sel ON public.compras_encabezado;

CREATE POLICY compras_enc_admin_all ON public.compras_encabezado
    FOR ALL
    TO authenticated
    USING  (empresa_id = public.current_empresa_id() AND public.app_role() = 'admin')
    WITH CHECK (empresa_id = public.current_empresa_id() AND public.app_role() = 'admin');

CREATE POLICY compras_enc_encargado_sel ON public.compras_encabezado
    FOR SELECT
    TO authenticated
    USING (empresa_id = public.current_empresa_id()
           AND public.app_role() = 'encargado'
           AND deleted_at IS NULL
           AND ubicacion_id IN (
               SELECT id FROM public.ubicaciones
               WHERE empresa_id = public.current_empresa_id()
           ));

-- empleado: sin acceso (no policy creada → RLS bloquea por defecto)

-- ---------------------------------------------------------------------------
-- 3. COMPRAS_DETALLE
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.compras_detalle (
    id                    uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    compra_id             uuid NOT NULL REFERENCES public.compras_encabezado(id) ON DELETE CASCADE,
    producto_id           uuid REFERENCES public.productos(id),
    cantidad              numeric(14,4) NOT NULL DEFAULT 0,
    costo_unitario_bruto  numeric(14,4) NOT NULL DEFAULT 0,
    descuento_valor       numeric(14,4) NOT NULL DEFAULT 0,
    costo_unitario_neto   numeric(14,4) GENERATED ALWAYS AS
                              (costo_unitario_bruto - descuento_valor) STORED,
    nombre_impuesto       text,
    costo_unitario_final  numeric(14,4) NOT NULL DEFAULT 0,
    subtotal_linea        numeric(14,4) GENERATED ALWAYS AS
                              (cantidad * costo_unitario_final) STORED,
    created_at            timestamptz NOT NULL DEFAULT now(),
    updated_at            timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS compras_det_compra_id_idx   ON public.compras_detalle(compra_id);
CREATE INDEX IF NOT EXISTS compras_det_producto_id_idx ON public.compras_detalle(producto_id);

CREATE TRIGGER set_compras_detalle_updated_at
    BEFORE UPDATE ON public.compras_detalle
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- RLS compras_detalle
ALTER TABLE public.compras_detalle ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS compras_det_admin_all     ON public.compras_detalle;
DROP POLICY IF EXISTS compras_det_encargado_sel ON public.compras_detalle;

CREATE POLICY compras_det_admin_all ON public.compras_detalle
    FOR ALL
    TO authenticated
    USING (
        public.app_role() = 'admin'
        AND EXISTS (
            SELECT 1 FROM public.compras_encabezado e
            WHERE e.id = compra_id
              AND e.empresa_id = public.current_empresa_id()
        )
    )
    WITH CHECK (
        public.app_role() = 'admin'
        AND EXISTS (
            SELECT 1 FROM public.compras_encabezado e
            WHERE e.id = compra_id
              AND e.empresa_id = public.current_empresa_id()
        )
    );

CREATE POLICY compras_det_encargado_sel ON public.compras_detalle
    FOR SELECT
    TO authenticated
    USING (
        public.app_role() = 'encargado'
        AND EXISTS (
            SELECT 1 FROM public.compras_encabezado e
            WHERE e.id = compra_id
              AND e.empresa_id = public.current_empresa_id()
              AND e.deleted_at IS NULL
              AND e.ubicacion_id IN (
                  SELECT id FROM public.ubicaciones
                  WHERE empresa_id = public.current_empresa_id()
              )
        )
    );

-- empleado: sin acceso

-- ---------------------------------------------------------------------------
-- 4. TRASLADOS_ENCABEZADO
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.traslados_encabezado (
    id                   uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    empresa_id           uuid NOT NULL REFERENCES public.empresas(id) ON DELETE CASCADE,
    ubicacion_origen_id  uuid NOT NULL REFERENCES public.ubicaciones(id),
    ubicacion_destino_id uuid NOT NULL REFERENCES public.ubicaciones(id),
    num_traslado         text,
    fecha_traslado       date NOT NULL DEFAULT current_date,
    estado               text NOT NULL DEFAULT 'BORRADOR'
                             CHECK (estado IN ('BORRADOR','ENVIADO','PENDIENTE','COMPLETADO','CANCELADO')),
    motivo               text,
    nota                 text,
    empleado_asignado_id uuid REFERENCES public.profiles(id),
    creado_por_id        uuid REFERENCES public.profiles(id),
    sync_status          text NOT NULL DEFAULT 'SYNCED'
                             CHECK (sync_status IN ('SYNCED', 'PENDING', 'CONFLICT')),
    created_at           timestamptz NOT NULL DEFAULT now(),
    updated_at           timestamptz NOT NULL DEFAULT now(),
    deleted_at           timestamptz
);

CREATE INDEX IF NOT EXISTS traslados_enc_empresa_id_idx   ON public.traslados_encabezado(empresa_id);
CREATE INDEX IF NOT EXISTS traslados_enc_origen_idx       ON public.traslados_encabezado(ubicacion_origen_id);
CREATE INDEX IF NOT EXISTS traslados_enc_destino_idx      ON public.traslados_encabezado(ubicacion_destino_id);
CREATE INDEX IF NOT EXISTS traslados_enc_creado_por_idx   ON public.traslados_encabezado(creado_por_id);
CREATE UNIQUE INDEX IF NOT EXISTS traslados_enc_num_idx
    ON public.traslados_encabezado(empresa_id, num_traslado)
    WHERE num_traslado IS NOT NULL AND deleted_at IS NULL;

CREATE TRIGGER set_traslados_encabezado_updated_at
    BEFORE UPDATE ON public.traslados_encabezado
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- RLS traslados_encabezado
ALTER TABLE public.traslados_encabezado ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS traslados_enc_admin_all          ON public.traslados_encabezado;
DROP POLICY IF EXISTS traslados_enc_encargado_sel_upd  ON public.traslados_encabezado;
DROP POLICY IF EXISTS traslados_enc_empleado_own       ON public.traslados_encabezado;

-- Admin: acceso total dentro de su empresa
CREATE POLICY traslados_enc_admin_all ON public.traslados_encabezado
    FOR ALL
    TO authenticated
    USING  (empresa_id = public.current_empresa_id() AND public.app_role() = 'admin')
    WITH CHECK (empresa_id = public.current_empresa_id() AND public.app_role() = 'admin');

-- Encargado: SELECT + UPDATE (pasar a ENVIADO/PENDIENTE) dentro de su empresa
CREATE POLICY traslados_enc_encargado_sel_upd ON public.traslados_encabezado
    FOR ALL
    TO authenticated
    USING (
        empresa_id = public.current_empresa_id()
        AND public.app_role() = 'encargado'
        AND deleted_at IS NULL
    )
    WITH CHECK (
        empresa_id = public.current_empresa_id()
        AND public.app_role() = 'encargado'
        AND estado IN ('ENVIADO', 'PENDIENTE')
    );

-- Empleado: CRUD solo sobre sus propios traslados en BORRADOR
CREATE POLICY traslados_enc_empleado_own ON public.traslados_encabezado
    FOR ALL
    TO authenticated
    USING (
        empresa_id = public.current_empresa_id()
        AND public.app_role() = 'empleado'
        AND creado_por_id = auth.uid()
        AND deleted_at IS NULL
    )
    WITH CHECK (
        empresa_id = public.current_empresa_id()
        AND public.app_role() = 'empleado'
        AND creado_por_id = auth.uid()
        AND estado = 'BORRADOR'
    );

-- ---------------------------------------------------------------------------
-- 5. TRASLADOS_DETALLE
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.traslados_detalle (
    id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    traslado_id      uuid NOT NULL REFERENCES public.traslados_encabezado(id) ON DELETE CASCADE,
    producto_id      uuid REFERENCES public.productos(id),
    cantidad         numeric(14,4) NOT NULL DEFAULT 0,
    costo_unitario_ref numeric(14,4),
    lote_codigo      text,
    caducidad_fecha  date,
    nota_linea       text,
    created_at       timestamptz NOT NULL DEFAULT now(),
    updated_at       timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS traslados_det_traslado_id_idx  ON public.traslados_detalle(traslado_id);
CREATE INDEX IF NOT EXISTS traslados_det_producto_id_idx  ON public.traslados_detalle(producto_id);

CREATE TRIGGER set_traslados_detalle_updated_at
    BEFORE UPDATE ON public.traslados_detalle
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- RLS traslados_detalle (hereda lógica del encabezado vía EXISTS)
ALTER TABLE public.traslados_detalle ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS traslados_det_admin_all        ON public.traslados_detalle;
DROP POLICY IF EXISTS traslados_det_encargado_sel    ON public.traslados_detalle;
DROP POLICY IF EXISTS traslados_det_empleado_own     ON public.traslados_detalle;

CREATE POLICY traslados_det_admin_all ON public.traslados_detalle
    FOR ALL
    TO authenticated
    USING (
        public.app_role() = 'admin'
        AND EXISTS (
            SELECT 1 FROM public.traslados_encabezado e
            WHERE e.id = traslado_id
              AND e.empresa_id = public.current_empresa_id()
        )
    )
    WITH CHECK (
        public.app_role() = 'admin'
        AND EXISTS (
            SELECT 1 FROM public.traslados_encabezado e
            WHERE e.id = traslado_id
              AND e.empresa_id = public.current_empresa_id()
        )
    );

CREATE POLICY traslados_det_encargado_sel ON public.traslados_detalle
    FOR SELECT
    TO authenticated
    USING (
        public.app_role() = 'encargado'
        AND EXISTS (
            SELECT 1 FROM public.traslados_encabezado e
            WHERE e.id = traslado_id
              AND e.empresa_id = public.current_empresa_id()
              AND e.deleted_at IS NULL
        )
    );

CREATE POLICY traslados_det_empleado_own ON public.traslados_detalle
    FOR ALL
    TO authenticated
    USING (
        public.app_role() = 'empleado'
        AND EXISTS (
            SELECT 1 FROM public.traslados_encabezado e
            WHERE e.id = traslado_id
              AND e.empresa_id = public.current_empresa_id()
              AND e.creado_por_id = auth.uid()
              AND e.deleted_at IS NULL
        )
    )
    WITH CHECK (
        public.app_role() = 'empleado'
        AND EXISTS (
            SELECT 1 FROM public.traslados_encabezado e
            WHERE e.id = traslado_id
              AND e.empresa_id = public.current_empresa_id()
              AND e.creado_por_id = auth.uid()
              AND e.estado = 'BORRADOR'
        )
    );

-- =============================================================================
-- FIN DE MIGRACIÓN
-- =============================================================================
