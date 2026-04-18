-- Renombra tablas camelCase a snake_case (ADR-001 / convención Postgres).
-- Reemplaza policies heredadas por nombres p_* y tenant via public.current_empresa_id().
-- Nota: columnas de negocio siguen en camelCase (p. ej. empresaid, facturaVentaId).

-- ---------------------------------------------------------------------------
-- facturasVenta -> facturas_venta
-- ---------------------------------------------------------------------------
DO $$
BEGIN
  IF to_regclass('public."facturasVenta"') IS NOT NULL THEN
    ALTER TABLE public."facturasVenta" RENAME TO facturas_venta;
  END IF;
END $$;

DROP POLICY IF EXISTS "facturasVenta_select" ON public.facturas_venta;
DROP POLICY IF EXISTS "facturasVenta_insert" ON public.facturas_venta;
DROP POLICY IF EXISTS "facturasVenta_update" ON public.facturas_venta;
DROP POLICY IF EXISTS "facturasVenta_delete" ON public.facturas_venta;
DROP POLICY IF EXISTS "p_facturas_venta_select_tenant" ON public.facturas_venta;
DROP POLICY IF EXISTS "p_facturas_venta_insert_tenant" ON public.facturas_venta;
DROP POLICY IF EXISTS "p_facturas_venta_update_tenant" ON public.facturas_venta;
DROP POLICY IF EXISTS "p_facturas_venta_delete_admin" ON public.facturas_venta;

CREATE POLICY "p_facturas_venta_select_tenant" ON public.facturas_venta
  FOR SELECT TO authenticated
  USING (empresaid = public.current_empresa_id());

CREATE POLICY "p_facturas_venta_insert_tenant" ON public.facturas_venta
  FOR INSERT TO authenticated
  WITH CHECK (empresaid = public.current_empresa_id());

CREATE POLICY "p_facturas_venta_update_tenant" ON public.facturas_venta
  FOR UPDATE TO authenticated
  USING (empresaid = public.current_empresa_id())
  WITH CHECK (empresaid = public.current_empresa_id());

CREATE POLICY "p_facturas_venta_delete_admin" ON public.facturas_venta
  FOR DELETE TO authenticated
  USING (
    empresaid = public.current_empresa_id()
    AND public.app_role() IN ('admin', 'encargado')
  );

-- ---------------------------------------------------------------------------
-- facturasVentaLineas -> facturas_venta_lineas
-- ---------------------------------------------------------------------------
DO $$
BEGIN
  IF to_regclass('public."facturasVentaLineas"') IS NOT NULL THEN
    ALTER TABLE public."facturasVentaLineas" RENAME TO facturas_venta_lineas;
  END IF;
END $$;

DROP POLICY IF EXISTS "facturasVentaLineas_select" ON public.facturas_venta_lineas;
DROP POLICY IF EXISTS "facturasVentaLineas_insert" ON public.facturas_venta_lineas;
DROP POLICY IF EXISTS "facturasVentaLineas_update" ON public.facturas_venta_lineas;
DROP POLICY IF EXISTS "facturasVentaLineas_delete" ON public.facturas_venta_lineas;
DROP POLICY IF EXISTS "p_facturas_venta_lineas_select_tenant" ON public.facturas_venta_lineas;
DROP POLICY IF EXISTS "p_facturas_venta_lineas_insert_tenant" ON public.facturas_venta_lineas;
DROP POLICY IF EXISTS "p_facturas_venta_lineas_update_tenant" ON public.facturas_venta_lineas;
DROP POLICY IF EXISTS "p_facturas_venta_lineas_delete_admin" ON public.facturas_venta_lineas;

CREATE POLICY "p_facturas_venta_lineas_select_tenant" ON public.facturas_venta_lineas
  FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1
      FROM public.facturas_venta fv
      WHERE fv.id = facturas_venta_lineas."facturaVentaId"
        AND fv.empresaid = public.current_empresa_id()
    )
  );

CREATE POLICY "p_facturas_venta_lineas_insert_tenant" ON public.facturas_venta_lineas
  FOR INSERT TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1
      FROM public.facturas_venta fv
      WHERE fv.id = facturas_venta_lineas."facturaVentaId"
        AND fv.empresaid = public.current_empresa_id()
    )
  );

CREATE POLICY "p_facturas_venta_lineas_update_tenant" ON public.facturas_venta_lineas
  FOR UPDATE TO authenticated
  USING (
    EXISTS (
      SELECT 1
      FROM public.facturas_venta fv
      WHERE fv.id = facturas_venta_lineas."facturaVentaId"
        AND fv.empresaid = public.current_empresa_id()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1
      FROM public.facturas_venta fv
      WHERE fv.id = facturas_venta_lineas."facturaVentaId"
        AND fv.empresaid = public.current_empresa_id()
    )
  );

CREATE POLICY "p_facturas_venta_lineas_delete_admin" ON public.facturas_venta_lineas
  FOR DELETE TO authenticated
  USING (
    EXISTS (
      SELECT 1
      FROM public.facturas_venta fv
      WHERE fv.id = facturas_venta_lineas."facturaVentaId"
        AND fv.empresaid = public.current_empresa_id()
    )
    AND public.app_role() IN ('admin', 'encargado')
  );

-- ---------------------------------------------------------------------------
-- ordenesVenta -> ordenes_venta
-- ---------------------------------------------------------------------------
DO $$
BEGIN
  IF to_regclass('public."ordenesVenta"') IS NOT NULL THEN
    ALTER TABLE public."ordenesVenta" RENAME TO ordenes_venta;
  END IF;
END $$;

DROP POLICY IF EXISTS "ordenesVenta_select" ON public.ordenes_venta;
DROP POLICY IF EXISTS "ordenesVenta_insert" ON public.ordenes_venta;
DROP POLICY IF EXISTS "ordenesVenta_update" ON public.ordenes_venta;
DROP POLICY IF EXISTS "ordenesVenta_delete" ON public.ordenes_venta;
DROP POLICY IF EXISTS "p_ordenes_venta_select_tenant" ON public.ordenes_venta;
DROP POLICY IF EXISTS "p_ordenes_venta_insert_tenant" ON public.ordenes_venta;
DROP POLICY IF EXISTS "p_ordenes_venta_update_tenant" ON public.ordenes_venta;
DROP POLICY IF EXISTS "p_ordenes_venta_delete_admin" ON public.ordenes_venta;

CREATE POLICY "p_ordenes_venta_select_tenant" ON public.ordenes_venta
  FOR SELECT TO authenticated
  USING (empresaid = public.current_empresa_id());

CREATE POLICY "p_ordenes_venta_insert_tenant" ON public.ordenes_venta
  FOR INSERT TO authenticated
  WITH CHECK (empresaid = public.current_empresa_id());

CREATE POLICY "p_ordenes_venta_update_tenant" ON public.ordenes_venta
  FOR UPDATE TO authenticated
  USING (empresaid = public.current_empresa_id())
  WITH CHECK (empresaid = public.current_empresa_id());

CREATE POLICY "p_ordenes_venta_delete_admin" ON public.ordenes_venta
  FOR DELETE TO authenticated
  USING (
    empresaid = public.current_empresa_id()
    AND public.app_role() IN ('admin', 'encargado')
  );

-- ---------------------------------------------------------------------------
-- pedidosVenta -> pedidos_venta
-- ---------------------------------------------------------------------------
DO $$
BEGIN
  IF to_regclass('public."pedidosVenta"') IS NOT NULL THEN
    ALTER TABLE public."pedidosVenta" RENAME TO pedidos_venta;
  END IF;
END $$;

DROP POLICY IF EXISTS "pedidosVenta_select" ON public.pedidos_venta;
DROP POLICY IF EXISTS "pedidosVenta_insert" ON public.pedidos_venta;
DROP POLICY IF EXISTS "pedidosVenta_update" ON public.pedidos_venta;
DROP POLICY IF EXISTS "pedidosVenta_delete" ON public.pedidos_venta;
DROP POLICY IF EXISTS "p_pedidos_venta_select_tenant" ON public.pedidos_venta;
DROP POLICY IF EXISTS "p_pedidos_venta_insert_tenant" ON public.pedidos_venta;
DROP POLICY IF EXISTS "p_pedidos_venta_update_tenant" ON public.pedidos_venta;
DROP POLICY IF EXISTS "p_pedidos_venta_delete_admin" ON public.pedidos_venta;

CREATE POLICY "p_pedidos_venta_select_tenant" ON public.pedidos_venta
  FOR SELECT TO authenticated
  USING (empresaid = public.current_empresa_id());

CREATE POLICY "p_pedidos_venta_insert_tenant" ON public.pedidos_venta
  FOR INSERT TO authenticated
  WITH CHECK (empresaid = public.current_empresa_id());

CREATE POLICY "p_pedidos_venta_update_tenant" ON public.pedidos_venta
  FOR UPDATE TO authenticated
  USING (empresaid = public.current_empresa_id())
  WITH CHECK (empresaid = public.current_empresa_id());

CREATE POLICY "p_pedidos_venta_delete_admin" ON public.pedidos_venta
  FOR DELETE TO authenticated
  USING (
    empresaid = public.current_empresa_id()
    AND public.app_role() IN ('admin', 'encargado')
  );

-- ---------------------------------------------------------------------------
-- pedidosVentaLineas -> pedidos_venta_lineas
-- ---------------------------------------------------------------------------
DO $$
BEGIN
  IF to_regclass('public."pedidosVentaLineas"') IS NOT NULL THEN
    ALTER TABLE public."pedidosVentaLineas" RENAME TO pedidos_venta_lineas;
  END IF;
END $$;

DROP POLICY IF EXISTS "pedidosVentaLineas_select" ON public.pedidos_venta_lineas;
DROP POLICY IF EXISTS "pedidosVentaLineas_insert" ON public.pedidos_venta_lineas;
DROP POLICY IF EXISTS "pedidosVentaLineas_update" ON public.pedidos_venta_lineas;
DROP POLICY IF EXISTS "pedidosVentaLineas_delete" ON public.pedidos_venta_lineas;
DROP POLICY IF EXISTS "p_pedidos_venta_lineas_select_tenant" ON public.pedidos_venta_lineas;
DROP POLICY IF EXISTS "p_pedidos_venta_lineas_insert_tenant" ON public.pedidos_venta_lineas;
DROP POLICY IF EXISTS "p_pedidos_venta_lineas_update_tenant" ON public.pedidos_venta_lineas;
DROP POLICY IF EXISTS "p_pedidos_venta_lineas_delete_admin" ON public.pedidos_venta_lineas;

CREATE POLICY "p_pedidos_venta_lineas_select_tenant" ON public.pedidos_venta_lineas
  FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1
      FROM public.pedidos_venta pv
      WHERE pv.id = pedidos_venta_lineas."pedidoVentaId"
        AND pv.empresaid = public.current_empresa_id()
    )
  );

CREATE POLICY "p_pedidos_venta_lineas_insert_tenant" ON public.pedidos_venta_lineas
  FOR INSERT TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1
      FROM public.pedidos_venta pv
      WHERE pv.id = pedidos_venta_lineas."pedidoVentaId"
        AND pv.empresaid = public.current_empresa_id()
    )
  );

CREATE POLICY "p_pedidos_venta_lineas_update_tenant" ON public.pedidos_venta_lineas
  FOR UPDATE TO authenticated
  USING (
    EXISTS (
      SELECT 1
      FROM public.pedidos_venta pv
      WHERE pv.id = pedidos_venta_lineas."pedidoVentaId"
        AND pv.empresaid = public.current_empresa_id()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1
      FROM public.pedidos_venta pv
      WHERE pv.id = pedidos_venta_lineas."pedidoVentaId"
        AND pv.empresaid = public.current_empresa_id()
    )
  );

CREATE POLICY "p_pedidos_venta_lineas_delete_admin" ON public.pedidos_venta_lineas
  FOR DELETE TO authenticated
  USING (
    EXISTS (
      SELECT 1
      FROM public.pedidos_venta pv
      WHERE pv.id = pedidos_venta_lineas."pedidoVentaId"
        AND pv.empresaid = public.current_empresa_id()
    )
    AND public.app_role() IN ('admin', 'encargado')
  );
