-- =============================================================================
-- Migration: 20260417000000_erp_proveedores_compras_traslados.sql
-- Tablas: proveedores, compras_encabezado, compras_detalle,
--         traslados_encabezado, traslados_detalle
-- Convenciones: idempotente, RLS por rol, trigger set_updated_at, soft delete
-- =============================================================================

-- ---------------------------------------------------------------------------
-- 1. PROVEEDORES
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.proveedores (
    id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    empresa_id        uuid NOT NULL REFERENCES public.empresas(id) ON DELETE CASCADE,
    num_documento     text,
    razon_social      text NOT NULL,
    nombre_contacto   text,
    direccion         text,
    ciudad            text,
    departamento      text,
    pais              text DEFAULT 'Colombia',
    telefono          text,
    email             text,
    condicion_pago    text,
    activo            boolean NOT NULL DEFAULT true,
    sync_status       text NOT NULL DEFAULT 'SYNCED'
                          CHECK (sync_status IN ('SYNCED','PENDING','CONFLICT')),
    created_at        timestamptz NOT NULL DEFAULT now(),
    updated_at        timestamptz NOT NULL DEFAULT now(),
    deleted_at        timestamptz
);

CREATE INDEX IF NOT EXISTS idx_proveedores_empresa_id   ON public.proveedores (empresa_id);
CREATE INDEX IF NOT EXISTS idx_proveedores_deleted_at   ON public.proveedores (deleted_at) WHERE deleted_at IS NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_proveedores_empresa_num_doc
    ON public.proveedores (empresa_id, num_documento)
    WHERE deleted_at IS NULL AND num_documento IS NOT NULL;

CREATE OR REPLACE TRIGGER trg_proveedores_updated_at
    BEFORE UPDATE ON public.proveedores
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

ALTER TABLE public.proveedores ENABLE ROW LEVEL SECURITY;

-- empleado: solo SELECT de su empresa
DROP POLICY IF EXISTS proveedores_select_empleado ON public.proveedores;
CREATE POLICY proveedores_select_empleado ON public.proveedores
    FOR SELECT
    TO authenticated
    USING (
        deleted_at IS NULL
        AND empresa_id = public.current_empresa_id()
        AND public.app_role() = 'empleado'
    );

-- encargado: solo SELECT de su empresa
DROP POLICY IF EXISTS proveedores_select_encargado ON public.proveedores;
CREATE POLICY proveedores_select_encargado ON public.proveedores
    FOR SELECT
    TO authenticated
    USING (
        deleted_at IS NULL
        AND empresa_id = public.current_empresa_id()
        AND public.app_role() = 'encargado'
    );

-- admin: ALL
DROP POLICY IF EXISTS proveedores_all_admin ON public.proveedores;
CREATE POLICY proveedores_all_admin ON public.proveedores
    FOR ALL
    TO authenticated
    USING (
        empresa_id = public.current_empresa_id()
        AND public.app_role() = 'admin'
    )
    WITH CHECK (
        empresa_id = public.current_empresa_id()
        AND public.app_role() = 'admin'
    );

-- ---------------------------------------------------------------------------
-- 2. COMPRAS_ENCABEZADO
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.compras_encabezado (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    empresa_id      uuid NOT NULL REFERENCES public.empresas(id) ON DELETE CASCADE,
    ubicacion_id    uuid REFERENCES public.ubicaciones(id),
    proveedor_id    uuid REFERENCES public.proveedores(id),
    num_compra      text,
    fecha_compra    date NOT NULL DEFAULT current_date,
    tipo_compra     text NOT NULL DEFAULT 'PRODUCTOS'
                        CHECK (tipo_compra IN ('PRODUCTOS','GASTOS','GASTO_IMPORTACION')),
    estado          text NOT NULL DEFAULT 'BORRADOR'
                        CHECK (estado IN ('BORRADOR','APROBADO','NO_APROBADO')),
    moneda          text NOT NULL DEFAULT 'COP',
    forma_pago      text,
    nota            text,
    creado_por_id   uuid REFERENCES public.profiles(id),
    sync_status     text NOT NULL DEFAULT 'SYNCED'
                        CHECK (sync_status IN ('SYNCED','PENDING','CONFLICT')),
    created_at      timestamptz NOT NULL DEFAULT now(),
    updated_at      timestamptz NOT NULL DEFAULT now(),
    deleted_at      timestamptz
);

CREATE INDEX IF NOT EXISTS idx_compras_enc_empresa_id    ON public.compras_encabezado (empresa_id);
CREATE INDEX IF NOT EXISTS idx_compras_enc_ubicacion_id  ON public.compras_encabezado (ubicacion_id);
CREATE INDEX IF NOT EXISTS idx_compras_enc_proveedor_id  ON public.compras_encabezado (proveedor_id);
CREATE INDEX IF NOT EXISTS idx_compras_enc_deleted_at    ON public.compras_encabezado (deleted_at) WHERE deleted_at IS NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_compras_enc_empresa_num
    ON public.compras_encabezado (empresa_id, num_compra)
    WHERE deleted_at IS NULL AND num_compra IS NOT NULL;

CREATE OR REPLACE TRIGGER trg_compras_encabezado_updated_at
    BEFORE UPDATE ON public.compras_encabezado
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

ALTER TABLE public.compras_encabezado ENABLE ROW LEVEL SECURITY;

-- empleado: sin acceso
-- encargado: SELECT de su empresa + su sucursal
DROP POLICY IF EXISTS compras_enc_select_encargado ON public.compras_encabezado;
CREATE POLICY compras_enc_select_encargado ON public.compras_encabezado
    FOR SELECT
    TO authenticated
    USING (
        deleted_at IS NULL
        AND empresa_id = public.current_empresa_id()
        AND public.app_role() = 'encargado'
        AND (
            ubicacion_id IS NULL
            OR ubicacion_id IN (
                SELECT id FROM public.ubicaciones
                WHERE empresa_id = public.current_empresa_id()
            )
        )
    );

-- admin: ALL
DROP POLICY IF EXISTS compras_enc_all_admin ON public.compras_encabezado;
CREATE POLICY compras_enc_all_admin ON public.compras_encabezado
    FOR ALL
    TO authenticated
    USING (
        empresa_id = public.current_empresa_id()
        AND public.app_role() = 'admin'
    )
    WITH CHECK (
        empresa_id = public.current_empresa_id()
        AND public.app_role() = 'admin'
    );

-- ---------------------------------------------------------------------------
-- 3. COMPRAS_DETALLE
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.compras_detalle (
    id                      uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    compra_id               uuid NOT NULL REFERENCES public.compras_encabezado(id) ON DELETE CASCADE,
    producto_id             uuid REFERENCES public.productos(id),
    cantidad                numeric(18,4) NOT NULL DEFAULT 1,
    costo_unitario_bruto    numeric(18,4) NOT NULL DEFAULT 0,
    descuento_valor         numeric(18,4) NOT NULL DEFAULT 0,
    costo_unitario_neto     numeric(18,4) GENERATED ALWAYS AS
                                (costo_unitario_bruto - descuento_valor) STORED,
    nombre_impuesto         text,
    costo_unitario_final    numeric(18,4) NOT NULL DEFAULT 0,
    subtotal_linea          numeric(18,4) GENERATED ALWAYS AS
                                (cantidad * costo_unitario_final) STORED,
    created_at              timestamptz NOT NULL DEFAULT now(),
    updated_at              timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_compras_det_compra_id    ON public.compras_detalle (compra_id);
CREATE INDEX IF NOT EXISTS idx_compras_det_producto_id  ON public.compras_detalle (producto_id);

CREATE OR REPLACE TRIGGER trg_compras_detalle_updated_at
    BEFORE UPDATE ON public.compras_detalle
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

ALTER TABLE public.compras_detalle ENABLE ROW LEVEL SECURITY;

-- encargado: SELECT vía encabezado de su empresa/sucursal
DROP POLICY IF EXISTS compras_det_select_encargado ON public.compras_detalle;
CREATE POLICY compras_det_select_encargado ON public.compras_detalle
    FOR SELECT
    TO authenticated
    USING (
        public.app_role() = 'encargado'
        AND compra_id IN (
            SELECT id FROM public.compras_encabezado
            WHERE empresa_id = public.current_empresa_id()
              AND deleted_at IS NULL
        )
    );

-- admin: ALL vía encabezado
DROP POLICY IF EXISTS compras_det_all_admin ON public.compras_detalle;
CREATE POLICY compras_det_all_admin ON public.compras_detalle
    FOR ALL
    TO authenticated
    USING (
        public.app_role() = 'admin'
        AND compra_id IN (
            SELECT id FROM public.compras_encabezado
            WHERE empresa_id = public.current_empresa_id()
        )
    )
    WITH CHECK (
        public.app_role() = 'admin'
        AND compra_id IN (
            SELECT id FROM public.compras_encabezado
            WHERE empresa_id = public.current_empresa_id()
        )
    );

-- ---------------------------------------------------------------------------
-- 4. TRASLADOS_ENCABEZADO
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.traslados_encabezado (
    id                    uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    empresa_id            uuid NOT NULL REFERENCES public.empresas(id) ON DELETE CASCADE,
    ubicacion_origen_id   uuid REFERENCES public.ubicaciones(id),
    ubicacion_destino_id  uuid REFERENCES public.ubicaciones(id),
    num_traslado          text,
    fecha_traslado        date NOT NULL DEFAULT current_date,
    estado                text NOT NULL DEFAULT 'BORRADOR'
                              CHECK (estado IN ('BORRADOR','ENVIADO','PENDIENTE','COMPLETADO','CANCELADO')),
    motivo                text,
    nota                  text,
    empleado_asignado_id  uuid REFERENCES public.profiles(id),
    creado_por_id         uuid REFERENCES public.profiles(id),
    sync_status           text NOT NULL DEFAULT 'SYNCED'
                              CHECK (sync_status IN ('SYNCED','PENDING','CONFLICT')),
    created_at            timestamptz NOT NULL DEFAULT now(),
    updated_at            timestamptz NOT NULL DEFAULT now(),
    deleted_at            timestamptz
);

CREATE INDEX IF NOT EXISTS idx_traslados_enc_empresa_id           ON public.traslados_encabezado (empresa_id);
CREATE INDEX IF NOT EXISTS idx_traslados_enc_origen_id            ON public.traslados_encabezado (ubicacion_origen_id);
CREATE INDEX IF NOT EXISTS idx_traslados_enc_destino_id           ON public.traslados_encabezado (ubicacion_destino_id);
CREATE INDEX IF NOT EXISTS idx_traslados_enc_empleado_asignado_id ON public.traslados_encabezado (empleado_asignado_id);
CREATE INDEX IF NOT EXISTS idx_traslados_enc_deleted_at           ON public.traslados_encabezado (deleted_at) WHERE deleted_at IS NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_traslados_enc_empresa_num
    ON public.traslados_encabezado (empresa_id, num_traslado)
    WHERE deleted_at IS NULL AND num_traslado IS NOT NULL;

CREATE OR REPLACE TRIGGER trg_traslados_encabezado_updated_at
    BEFORE UPDATE ON public.traslados_encabezado
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

ALTER TABLE public.traslados_encabezado ENABLE ROW LEVEL SECURITY;

-- empleado: SELECT + INSERT + UPDATE + DELETE solo sus propios traslados en BORRADOR
DROP POLICY IF EXISTS traslados_enc_select_empleado ON public.traslados_encabezado;
CREATE POLICY traslados_enc_select_empleado ON public.traslados_encabezado
    FOR SELECT
    TO authenticated
    USING (
        deleted_at IS NULL
        AND empresa_id = public.current_empresa_id()
        AND public.app_role() = 'empleado'
        AND creado_por_id = auth.uid()
    );

DROP POLICY IF EXISTS traslados_enc_insert_empleado ON public.traslados_encabezado;
CREATE POLICY traslados_enc_insert_empleado ON public.traslados_encabezado
    FOR INSERT
    TO authenticated
    WITH CHECK (
        empresa_id = public.current_empresa_id()
        AND public.app_role() = 'empleado'
        AND creado_por_id = auth.uid()
        AND estado = 'BORRADOR'
    );

DROP POLICY IF EXISTS traslados_enc_update_empleado ON public.traslados_encabezado;
CREATE POLICY traslados_enc_update_empleado ON public.traslados_encabezado
    FOR UPDATE
    TO authenticated
    USING (
        deleted_at IS NULL
        AND empresa_id = public.current_empresa_id()
        AND public.app_role() = 'empleado'
        AND creado_por_id = auth.uid()
        AND estado = 'BORRADOR'
    )
    WITH CHECK (
        empresa_id = public.current_empresa_id()
        AND public.app_role() = 'empleado'
        AND creado_por_id = auth.uid()
        AND estado = 'BORRADOR'
    );

DROP POLICY IF EXISTS traslados_enc_delete_empleado ON public.traslados_encabezado;
CREATE POLICY traslados_enc_delete_empleado ON public.traslados_encabezado
    FOR DELETE
    TO authenticated
    USING (
        deleted_at IS NULL
        AND empresa_id = public.current_empresa_id()
        AND public.app_role() = 'empleado'
        AND creado_por_id = auth.uid()
        AND estado = 'BORRADOR'
    );

-- encargado: SELECT de su empresa, UPDATE a estados ENVIADO/PENDIENTE de su sucursal
DROP POLICY IF EXISTS traslados_enc_select_encargado ON public.traslados_encabezado;
CREATE POLICY traslados_enc_select_encargado ON public.traslados_encabezado
    FOR SELECT
    TO authenticated
    USING (
        deleted_at IS NULL
        AND empresa_id = public.current_empresa_id()
        AND public.app_role() = 'encargado'
    );

DROP POLICY IF EXISTS traslados_enc_update_encargado ON public.traslados_encabezado;
CREATE POLICY traslados_enc_update_encargado ON public.traslados_encabezado
    FOR UPDATE
    TO authenticated
    USING (
        deleted_at IS NULL
        AND empresa_id = public.current_empresa_id()
        AND public.app_role() = 'encargado'
        AND estado IN ('ENVIADO','PENDIENTE')
    )
    WITH CHECK (
        empresa_id = public.current_empresa_id()
        AND public.app_role() = 'encargado'
        AND estado IN ('ENVIADO','PENDIENTE','COMPLETADO')
    );

-- admin: ALL
DROP POLICY IF EXISTS traslados_enc_all_admin ON public.traslados_encabezado;
CREATE POLICY traslados_enc_all_admin ON public.traslados_encabezado
    FOR ALL
    TO authenticated
    USING (
        empresa_id = public.current_empresa_id()
        AND public.app_role() = 'admin'
    )
    WITH CHECK (
        empresa_id = public.current_empresa_id()
        AND public.app_role() = 'admin'
    );

-- ---------------------------------------------------------------------------
-- 5. TRASLADOS_DETALLE
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.traslados_detalle (
    id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    traslado_id       uuid NOT NULL REFERENCES public.traslados_encabezado(id) ON DELETE CASCADE,
    producto_id       uuid REFERENCES public.productos(id),
    cantidad          numeric(18,4) NOT NULL DEFAULT 1,
    costo_unitario_ref numeric(18,4),
    lote_codigo       text,
    caducidad_fecha   date,
    nota_linea        text,
    created_at        timestamptz NOT NULL DEFAULT now(),
    updated_at        timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_traslados_det_traslado_id  ON public.traslados_detalle (traslado_id);
CREATE INDEX IF NOT EXISTS idx_traslados_det_producto_id  ON public.traslados_detalle (producto_id);

CREATE OR REPLACE TRIGGER trg_traslados_detalle_updated_at
    BEFORE UPDATE ON public.traslados_detalle
    FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

ALTER TABLE public.traslados_detalle ENABLE ROW LEVEL SECURITY;

-- empleado: hereda del encabezado (sus propios traslados en BORRADOR)
DROP POLICY IF EXISTS traslados_det_select_empleado ON public.traslados_detalle;
CREATE POLICY traslados_det_select_empleado ON public.traslados_detalle
    FOR SELECT
    TO authenticated
    USING (
        public.app_role() = 'empleado'
        AND traslado_id IN (
            SELECT id FROM public.traslados_encabezado
            WHERE empresa_id = public.current_empresa_id()
              AND creado_por_id = auth.uid()
              AND deleted_at IS NULL
        )
    );

DROP POLICY IF EXISTS traslados_det_insert_empleado ON public.traslados_detalle;
CREATE POLICY traslados_det_insert_empleado ON public.traslados_detalle
    FOR INSERT
    TO authenticated
    WITH CHECK (
        public.app_role() = 'empleado'
        AND traslado_id IN (
            SELECT id FROM public.traslados_encabezado
            WHERE empresa_id = public.current_empresa_id()
              AND creado_por_id = auth.uid()
              AND estado = 'BORRADOR'
              AND deleted_at IS NULL
        )
    );

DROP POLICY IF EXISTS traslados_det_update_empleado ON public.traslados_detalle;
CREATE POLICY traslados_det_update_empleado ON public.traslados_detalle
    FOR UPDATE
    TO authenticated
    USING (
        public.app_role() = 'empleado'
        AND traslado_id IN (
            SELECT id FROM public.traslados_encabezado
            WHERE empresa_id = public.current_empresa_id()
              AND creado_por_id = auth.uid()
              AND estado = 'BORRADOR'
              AND deleted_at IS NULL
        )
    )
    WITH CHECK (
        public.app_role() = 'empleado'
        AND traslado_id IN (
            SELECT id FROM public.traslados_encabezado
            WHERE empresa_id = public.current_empresa_id()
              AND creado_por_id = auth.uid()
              AND estado = 'BORRADOR'
              AND deleted_at IS NULL
        )
    );

DROP POLICY IF EXISTS traslados_det_delete_empleado ON public.traslados_detalle;
CREATE POLICY traslados_det_delete_empleado ON public.traslados_detalle
    FOR DELETE
    TO authenticated
    USING (
        public.app_role() = 'empleado'
        AND traslado_id IN (
            SELECT id FROM public.traslados_encabezado
            WHERE empresa_id = public.current_empresa_id()
              AND creado_por_id = auth.uid()
              AND estado = 'BORRADOR'
              AND deleted_at IS NULL
        )
    );

-- encargado: hereda del encabezado de su empresa
DROP POLICY IF EXISTS traslados_det_select_encargado ON public.traslados_detalle;
CREATE POLICY traslados_det_select_encargado ON public.traslados_detalle
    FOR SELECT
    TO authenticated
    USING (
        public.app_role() = 'encargado'
        AND traslado_id IN (
            SELECT id FROM public.traslados_encabezado
            WHERE empresa_id = public.current_empresa_id()
              AND deleted_at IS NULL
        )
    );

DROP POLICY IF EXISTS traslados_det_update_encargado ON public.traslados_detalle;
CREATE POLICY traslados_det_update_encargado ON public.traslados_detalle
    FOR UPDATE
    TO authenticated
    USING (
        public.app_role() = 'encargado'
        AND traslado_id IN (
            SELECT id FROM public.traslados_encabezado
            WHERE empresa_id = public.current_empresa_id()
              AND estado IN ('ENVIADO','PENDIENTE')
              AND deleted_at IS NULL
        )
    )
    WITH CHECK (
        public.app_role() = 'encargado'
        AND traslado_id IN (
            SELECT id FROM public.traslados_encabezado
            WHERE empresa_id = public.current_empresa_id()
              AND deleted_at IS NULL
        )
    );

-- admin: ALL vía encabezado
DROP POLICY IF EXISTS traslados_det_all_admin ON public.traslados_detalle;
CREATE POLICY traslados_det_all_admin ON public.traslados_detalle
    FOR ALL
    TO authenticated
    USING (
        public.app_role() = 'admin'
        AND traslado_id IN (
            SELECT id FROM public.traslados_encabezado
            WHERE empresa_id = public.current_empresa_id()
        )
    )
    WITH CHECK (
        public.app_role() = 'admin'
        AND traslado_id IN (
            SELECT id FROM public.traslados_encabezado
            WHERE empresa_id = public.current_empresa_id()
        )
    );

-- =============================================================================
-- FIN DE MIGRACIÓN
-- =============================================================================
