-- Policies base p_* (idempotentes) para tablas con RLS activo y sin cobertura adecuada.
-- Donde el esquema usa empresaid (no empresa_id), el aislamiento usa empresaid = public.current_empresa_id().
-- Tablas sin columna de empresa: EXISTS hacia bodegas / cabeceras según corresponda.

-- ---------------------------------------------------------------------------
-- Tenant: columna empresaid
-- ---------------------------------------------------------------------------

-- bodegas
DROP POLICY IF EXISTS "p_bodegas_select_tenant" ON public.bodegas;
DROP POLICY IF EXISTS "p_bodegas_insert_tenant" ON public.bodegas;
DROP POLICY IF EXISTS "p_bodegas_update_tenant" ON public.bodegas;
DROP POLICY IF EXISTS "p_bodegas_delete_admin" ON public.bodegas;
CREATE POLICY "p_bodegas_select_tenant" ON public.bodegas FOR SELECT TO authenticated
  USING (empresaid = public.current_empresa_id());
CREATE POLICY "p_bodegas_insert_tenant" ON public.bodegas FOR INSERT TO authenticated
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_bodegas_update_tenant" ON public.bodegas FOR UPDATE TO authenticated
  USING (empresaid = public.current_empresa_id())
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_bodegas_delete_admin" ON public.bodegas FOR DELETE TO authenticated
  USING (empresaid = public.current_empresa_id() AND public.app_role() IN ('admin', 'encargado'));

-- cajas
DROP POLICY IF EXISTS "p_cajas_select_tenant" ON public.cajas;
DROP POLICY IF EXISTS "p_cajas_insert_tenant" ON public.cajas;
DROP POLICY IF EXISTS "p_cajas_update_tenant" ON public.cajas;
DROP POLICY IF EXISTS "p_cajas_delete_admin" ON public.cajas;
CREATE POLICY "p_cajas_select_tenant" ON public.cajas FOR SELECT TO authenticated
  USING (empresaid = public.current_empresa_id());
CREATE POLICY "p_cajas_insert_tenant" ON public.cajas FOR INSERT TO authenticated
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_cajas_update_tenant" ON public.cajas FOR UPDATE TO authenticated
  USING (empresaid = public.current_empresa_id())
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_cajas_delete_admin" ON public.cajas FOR DELETE TO authenticated
  USING (empresaid = public.current_empresa_id() AND public.app_role() IN ('admin', 'encargado'));

-- config_app_empresas
DROP POLICY IF EXISTS "p_config_app_empresas_select_tenant" ON public.config_app_empresas;
DROP POLICY IF EXISTS "p_config_app_empresas_insert_tenant" ON public.config_app_empresas;
DROP POLICY IF EXISTS "p_config_app_empresas_update_tenant" ON public.config_app_empresas;
DROP POLICY IF EXISTS "p_config_app_empresas_delete_admin" ON public.config_app_empresas;
CREATE POLICY "p_config_app_empresas_select_tenant" ON public.config_app_empresas FOR SELECT TO authenticated
  USING (empresaid = public.current_empresa_id());
CREATE POLICY "p_config_app_empresas_insert_tenant" ON public.config_app_empresas FOR INSERT TO authenticated
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_config_app_empresas_update_tenant" ON public.config_app_empresas FOR UPDATE TO authenticated
  USING (empresaid = public.current_empresa_id())
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_config_app_empresas_delete_admin" ON public.config_app_empresas FOR DELETE TO authenticated
  USING (empresaid = public.current_empresa_id() AND public.app_role() IN ('admin', 'encargado'));

-- config_tipos_voucher
DROP POLICY IF EXISTS "p_config_tipos_voucher_select_tenant" ON public.config_tipos_voucher;
DROP POLICY IF EXISTS "p_config_tipos_voucher_insert_tenant" ON public.config_tipos_voucher;
DROP POLICY IF EXISTS "p_config_tipos_voucher_update_tenant" ON public.config_tipos_voucher;
DROP POLICY IF EXISTS "p_config_tipos_voucher_delete_admin" ON public.config_tipos_voucher;
CREATE POLICY "p_config_tipos_voucher_select_tenant" ON public.config_tipos_voucher FOR SELECT TO authenticated
  USING (empresaid = public.current_empresa_id());
CREATE POLICY "p_config_tipos_voucher_insert_tenant" ON public.config_tipos_voucher FOR INSERT TO authenticated
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_config_tipos_voucher_update_tenant" ON public.config_tipos_voucher FOR UPDATE TO authenticated
  USING (empresaid = public.current_empresa_id())
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_config_tipos_voucher_delete_admin" ON public.config_tipos_voucher FOR DELETE TO authenticated
  USING (empresaid = public.current_empresa_id() AND public.app_role() IN ('admin', 'encargado'));

-- jornadas
DROP POLICY IF EXISTS "p_jornadas_select_tenant" ON public.jornadas;
DROP POLICY IF EXISTS "p_jornadas_insert_tenant" ON public.jornadas;
DROP POLICY IF EXISTS "p_jornadas_update_tenant" ON public.jornadas;
DROP POLICY IF EXISTS "p_jornadas_delete_admin" ON public.jornadas;
CREATE POLICY "p_jornadas_select_tenant" ON public.jornadas FOR SELECT TO authenticated
  USING (empresaid = public.current_empresa_id());
CREATE POLICY "p_jornadas_insert_tenant" ON public.jornadas FOR INSERT TO authenticated
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_jornadas_update_tenant" ON public.jornadas FOR UPDATE TO authenticated
  USING (empresaid = public.current_empresa_id())
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_jornadas_delete_admin" ON public.jornadas FOR DELETE TO authenticated
  USING (empresaid = public.current_empresa_id() AND public.app_role() IN ('admin', 'encargado'));

-- listasprecios
DROP POLICY IF EXISTS "p_listasprecios_select_tenant" ON public.listasprecios;
DROP POLICY IF EXISTS "p_listasprecios_insert_tenant" ON public.listasprecios;
DROP POLICY IF EXISTS "p_listasprecios_update_tenant" ON public.listasprecios;
DROP POLICY IF EXISTS "p_listasprecios_delete_admin" ON public.listasprecios;
CREATE POLICY "p_listasprecios_select_tenant" ON public.listasprecios FOR SELECT TO authenticated
  USING (empresaid = public.current_empresa_id());
CREATE POLICY "p_listasprecios_insert_tenant" ON public.listasprecios FOR INSERT TO authenticated
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_listasprecios_update_tenant" ON public.listasprecios FOR UPDATE TO authenticated
  USING (empresaid = public.current_empresa_id())
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_listasprecios_delete_admin" ON public.listasprecios FOR DELETE TO authenticated
  USING (empresaid = public.current_empresa_id() AND public.app_role() IN ('admin', 'encargado'));

-- marcas
DROP POLICY IF EXISTS "p_marcas_select_tenant" ON public.marcas;
DROP POLICY IF EXISTS "p_marcas_insert_tenant" ON public.marcas;
DROP POLICY IF EXISTS "p_marcas_update_tenant" ON public.marcas;
DROP POLICY IF EXISTS "p_marcas_delete_admin" ON public.marcas;
CREATE POLICY "p_marcas_select_tenant" ON public.marcas FOR SELECT TO authenticated
  USING (empresaid = public.current_empresa_id());
CREATE POLICY "p_marcas_insert_tenant" ON public.marcas FOR INSERT TO authenticated
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_marcas_update_tenant" ON public.marcas FOR UPDATE TO authenticated
  USING (empresaid = public.current_empresa_id())
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_marcas_delete_admin" ON public.marcas FOR DELETE TO authenticated
  USING (empresaid = public.current_empresa_id() AND public.app_role() IN ('admin', 'encargado'));

-- movimientos_caja
DROP POLICY IF EXISTS "p_movimientos_caja_select_tenant" ON public.movimientos_caja;
DROP POLICY IF EXISTS "p_movimientos_caja_insert_tenant" ON public.movimientos_caja;
DROP POLICY IF EXISTS "p_movimientos_caja_update_tenant" ON public.movimientos_caja;
DROP POLICY IF EXISTS "p_movimientos_caja_delete_admin" ON public.movimientos_caja;
CREATE POLICY "p_movimientos_caja_select_tenant" ON public.movimientos_caja FOR SELECT TO authenticated
  USING (empresaid = public.current_empresa_id());
CREATE POLICY "p_movimientos_caja_insert_tenant" ON public.movimientos_caja FOR INSERT TO authenticated
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_movimientos_caja_update_tenant" ON public.movimientos_caja FOR UPDATE TO authenticated
  USING (empresaid = public.current_empresa_id())
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_movimientos_caja_delete_admin" ON public.movimientos_caja FOR DELETE TO authenticated
  USING (empresaid = public.current_empresa_id() AND public.app_role() IN ('admin', 'encargado'));

-- notificaciones_usuario
DROP POLICY IF EXISTS "p_notificaciones_usuario_select_tenant" ON public.notificaciones_usuario;
DROP POLICY IF EXISTS "p_notificaciones_usuario_insert_tenant" ON public.notificaciones_usuario;
DROP POLICY IF EXISTS "p_notificaciones_usuario_update_tenant" ON public.notificaciones_usuario;
DROP POLICY IF EXISTS "p_notificaciones_usuario_delete_admin" ON public.notificaciones_usuario;
CREATE POLICY "p_notificaciones_usuario_select_tenant" ON public.notificaciones_usuario FOR SELECT TO authenticated
  USING (empresaid = public.current_empresa_id());
CREATE POLICY "p_notificaciones_usuario_insert_tenant" ON public.notificaciones_usuario FOR INSERT TO authenticated
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_notificaciones_usuario_update_tenant" ON public.notificaciones_usuario FOR UPDATE TO authenticated
  USING (empresaid = public.current_empresa_id())
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_notificaciones_usuario_delete_admin" ON public.notificaciones_usuario FOR DELETE TO authenticated
  USING (empresaid = public.current_empresa_id() AND public.app_role() IN ('admin', 'encargado'));

-- novedades_inventario
DROP POLICY IF EXISTS "p_novedades_inventario_select_tenant" ON public.novedades_inventario;
DROP POLICY IF EXISTS "p_novedades_inventario_insert_tenant" ON public.novedades_inventario;
DROP POLICY IF EXISTS "p_novedades_inventario_update_tenant" ON public.novedades_inventario;
DROP POLICY IF EXISTS "p_novedades_inventario_delete_admin" ON public.novedades_inventario;
CREATE POLICY "p_novedades_inventario_select_tenant" ON public.novedades_inventario FOR SELECT TO authenticated
  USING (empresaid = public.current_empresa_id());
CREATE POLICY "p_novedades_inventario_insert_tenant" ON public.novedades_inventario FOR INSERT TO authenticated
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_novedades_inventario_update_tenant" ON public.novedades_inventario FOR UPDATE TO authenticated
  USING (empresaid = public.current_empresa_id())
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_novedades_inventario_delete_admin" ON public.novedades_inventario FOR DELETE TO authenticated
  USING (empresaid = public.current_empresa_id() AND public.app_role() IN ('admin', 'encargado'));

-- sugerencias_pedido
DROP POLICY IF EXISTS "p_sugerencias_pedido_select_tenant" ON public.sugerencias_pedido;
DROP POLICY IF EXISTS "p_sugerencias_pedido_insert_tenant" ON public.sugerencias_pedido;
DROP POLICY IF EXISTS "p_sugerencias_pedido_update_tenant" ON public.sugerencias_pedido;
DROP POLICY IF EXISTS "p_sugerencias_pedido_delete_admin" ON public.sugerencias_pedido;
CREATE POLICY "p_sugerencias_pedido_select_tenant" ON public.sugerencias_pedido FOR SELECT TO authenticated
  USING (empresaid = public.current_empresa_id());
CREATE POLICY "p_sugerencias_pedido_insert_tenant" ON public.sugerencias_pedido FOR INSERT TO authenticated
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_sugerencias_pedido_update_tenant" ON public.sugerencias_pedido FOR UPDATE TO authenticated
  USING (empresaid = public.current_empresa_id())
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_sugerencias_pedido_delete_admin" ON public.sugerencias_pedido FOR DELETE TO authenticated
  USING (empresaid = public.current_empresa_id() AND public.app_role() IN ('admin', 'encargado'));

-- tareas
DROP POLICY IF EXISTS "p_tareas_select_tenant" ON public.tareas;
DROP POLICY IF EXISTS "p_tareas_insert_tenant" ON public.tareas;
DROP POLICY IF EXISTS "p_tareas_update_tenant" ON public.tareas;
DROP POLICY IF EXISTS "p_tareas_delete_admin" ON public.tareas;
CREATE POLICY "p_tareas_select_tenant" ON public.tareas FOR SELECT TO authenticated
  USING (empresaid = public.current_empresa_id());
CREATE POLICY "p_tareas_insert_tenant" ON public.tareas FOR INSERT TO authenticated
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_tareas_update_tenant" ON public.tareas FOR UPDATE TO authenticated
  USING (empresaid = public.current_empresa_id())
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_tareas_delete_admin" ON public.tareas FOR DELETE TO authenticated
  USING (empresaid = public.current_empresa_id() AND public.app_role() IN ('admin', 'encargado'));

-- tipos_tarea
DROP POLICY IF EXISTS "p_tipos_tarea_select_tenant" ON public.tipos_tarea;
DROP POLICY IF EXISTS "p_tipos_tarea_insert_tenant" ON public.tipos_tarea;
DROP POLICY IF EXISTS "p_tipos_tarea_update_tenant" ON public.tipos_tarea;
DROP POLICY IF EXISTS "p_tipos_tarea_delete_admin" ON public.tipos_tarea;
CREATE POLICY "p_tipos_tarea_select_tenant" ON public.tipos_tarea FOR SELECT TO authenticated
  USING (empresaid = public.current_empresa_id());
CREATE POLICY "p_tipos_tarea_insert_tenant" ON public.tipos_tarea FOR INSERT TO authenticated
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_tipos_tarea_update_tenant" ON public.tipos_tarea FOR UPDATE TO authenticated
  USING (empresaid = public.current_empresa_id())
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_tipos_tarea_delete_admin" ON public.tipos_tarea FOR DELETE TO authenticated
  USING (empresaid = public.current_empresa_id() AND public.app_role() IN ('admin', 'encargado'));

-- turnos
DROP POLICY IF EXISTS "p_turnos_select_tenant" ON public.turnos;
DROP POLICY IF EXISTS "p_turnos_insert_tenant" ON public.turnos;
DROP POLICY IF EXISTS "p_turnos_update_tenant" ON public.turnos;
DROP POLICY IF EXISTS "p_turnos_delete_admin" ON public.turnos;
CREATE POLICY "p_turnos_select_tenant" ON public.turnos FOR SELECT TO authenticated
  USING (empresaid = public.current_empresa_id());
CREATE POLICY "p_turnos_insert_tenant" ON public.turnos FOR INSERT TO authenticated
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_turnos_update_tenant" ON public.turnos FOR UPDATE TO authenticated
  USING (empresaid = public.current_empresa_id())
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_turnos_delete_admin" ON public.turnos FOR DELETE TO authenticated
  USING (empresaid = public.current_empresa_id() AND public.app_role() IN ('admin', 'encargado'));

-- unidadesmedida
DROP POLICY IF EXISTS "p_unidadesmedida_select_tenant" ON public.unidadesmedida;
DROP POLICY IF EXISTS "p_unidadesmedida_insert_tenant" ON public.unidadesmedida;
DROP POLICY IF EXISTS "p_unidadesmedida_update_tenant" ON public.unidadesmedida;
DROP POLICY IF EXISTS "p_unidadesmedida_delete_admin" ON public.unidadesmedida;
CREATE POLICY "p_unidadesmedida_select_tenant" ON public.unidadesmedida FOR SELECT TO authenticated
  USING (empresaid = public.current_empresa_id());
CREATE POLICY "p_unidadesmedida_insert_tenant" ON public.unidadesmedida FOR INSERT TO authenticated
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_unidadesmedida_update_tenant" ON public.unidadesmedida FOR UPDATE TO authenticated
  USING (empresaid = public.current_empresa_id())
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_unidadesmedida_delete_admin" ON public.unidadesmedida FOR DELETE TO authenticated
  USING (empresaid = public.current_empresa_id() AND public.app_role() IN ('admin', 'encargado'));

-- user_sucursales
DROP POLICY IF EXISTS "p_user_sucursales_select_tenant" ON public.user_sucursales;
DROP POLICY IF EXISTS "p_user_sucursales_insert_tenant" ON public.user_sucursales;
DROP POLICY IF EXISTS "p_user_sucursales_update_tenant" ON public.user_sucursales;
DROP POLICY IF EXISTS "p_user_sucursales_delete_admin" ON public.user_sucursales;
CREATE POLICY "p_user_sucursales_select_tenant" ON public.user_sucursales FOR SELECT TO authenticated
  USING (empresaid = public.current_empresa_id());
CREATE POLICY "p_user_sucursales_insert_tenant" ON public.user_sucursales FOR INSERT TO authenticated
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_user_sucursales_update_tenant" ON public.user_sucursales FOR UPDATE TO authenticated
  USING (empresaid = public.current_empresa_id())
  WITH CHECK (empresaid = public.current_empresa_id());
CREATE POLICY "p_user_sucursales_delete_admin" ON public.user_sucursales FOR DELETE TO authenticated
  USING (empresaid = public.current_empresa_id() AND public.app_role() IN ('admin', 'encargado'));

-- ---------------------------------------------------------------------------
-- Tenant: columna empresa_id
-- ---------------------------------------------------------------------------

-- misiones_conteo
DROP POLICY IF EXISTS "p_misiones_conteo_select_tenant" ON public.misiones_conteo;
DROP POLICY IF EXISTS "p_misiones_conteo_insert_tenant" ON public.misiones_conteo;
DROP POLICY IF EXISTS "p_misiones_conteo_update_tenant" ON public.misiones_conteo;
DROP POLICY IF EXISTS "p_misiones_conteo_delete_admin" ON public.misiones_conteo;
CREATE POLICY "p_misiones_conteo_select_tenant" ON public.misiones_conteo FOR SELECT TO authenticated
  USING (empresa_id = public.current_empresa_id());
CREATE POLICY "p_misiones_conteo_insert_tenant" ON public.misiones_conteo FOR INSERT TO authenticated
  WITH CHECK (empresa_id = public.current_empresa_id());
CREATE POLICY "p_misiones_conteo_update_tenant" ON public.misiones_conteo FOR UPDATE TO authenticated
  USING (empresa_id = public.current_empresa_id())
  WITH CHECK (empresa_id = public.current_empresa_id());
CREATE POLICY "p_misiones_conteo_delete_admin" ON public.misiones_conteo FOR DELETE TO authenticated
  USING (empresa_id = public.current_empresa_id() AND public.app_role() IN ('admin', 'encargado'));

-- tareas_turno
DROP POLICY IF EXISTS "p_tareas_turno_select_tenant" ON public.tareas_turno;
DROP POLICY IF EXISTS "p_tareas_turno_insert_tenant" ON public.tareas_turno;
DROP POLICY IF EXISTS "p_tareas_turno_update_tenant" ON public.tareas_turno;
DROP POLICY IF EXISTS "p_tareas_turno_delete_admin" ON public.tareas_turno;
CREATE POLICY "p_tareas_turno_select_tenant" ON public.tareas_turno FOR SELECT TO authenticated
  USING (empresa_id = public.current_empresa_id());
CREATE POLICY "p_tareas_turno_insert_tenant" ON public.tareas_turno FOR INSERT TO authenticated
  WITH CHECK (empresa_id = public.current_empresa_id());
CREATE POLICY "p_tareas_turno_update_tenant" ON public.tareas_turno FOR UPDATE TO authenticated
  USING (empresa_id = public.current_empresa_id())
  WITH CHECK (empresa_id = public.current_empresa_id());
CREATE POLICY "p_tareas_turno_delete_admin" ON public.tareas_turno FOR DELETE TO authenticated
  USING (empresa_id = public.current_empresa_id() AND public.app_role() IN ('admin', 'encargado'));

-- tipos_tarea_turno
DROP POLICY IF EXISTS "p_tipos_tarea_turno_select_tenant" ON public.tipos_tarea_turno;
DROP POLICY IF EXISTS "p_tipos_tarea_turno_insert_tenant" ON public.tipos_tarea_turno;
DROP POLICY IF EXISTS "p_tipos_tarea_turno_update_tenant" ON public.tipos_tarea_turno;
DROP POLICY IF EXISTS "p_tipos_tarea_turno_delete_admin" ON public.tipos_tarea_turno;
CREATE POLICY "p_tipos_tarea_turno_select_tenant" ON public.tipos_tarea_turno FOR SELECT TO authenticated
  USING (empresa_id = public.current_empresa_id());
CREATE POLICY "p_tipos_tarea_turno_insert_tenant" ON public.tipos_tarea_turno FOR INSERT TO authenticated
  WITH CHECK (empresa_id = public.current_empresa_id());
CREATE POLICY "p_tipos_tarea_turno_update_tenant" ON public.tipos_tarea_turno FOR UPDATE TO authenticated
  USING (empresa_id = public.current_empresa_id())
  WITH CHECK (empresa_id = public.current_empresa_id());
CREATE POLICY "p_tipos_tarea_turno_delete_admin" ON public.tipos_tarea_turno FOR DELETE TO authenticated
  USING (empresa_id = public.current_empresa_id() AND public.app_role() IN ('admin', 'encargado'));

-- turnos_caja
DROP POLICY IF EXISTS "p_turnos_caja_select_tenant" ON public.turnos_caja;
DROP POLICY IF EXISTS "p_turnos_caja_insert_tenant" ON public.turnos_caja;
DROP POLICY IF EXISTS "p_turnos_caja_update_tenant" ON public.turnos_caja;
DROP POLICY IF EXISTS "p_turnos_caja_delete_admin" ON public.turnos_caja;
CREATE POLICY "p_turnos_caja_select_tenant" ON public.turnos_caja FOR SELECT TO authenticated
  USING (empresa_id = public.current_empresa_id());
CREATE POLICY "p_turnos_caja_insert_tenant" ON public.turnos_caja FOR INSERT TO authenticated
  WITH CHECK (empresa_id = public.current_empresa_id());
CREATE POLICY "p_turnos_caja_update_tenant" ON public.turnos_caja FOR UPDATE TO authenticated
  USING (empresa_id = public.current_empresa_id())
  WITH CHECK (empresa_id = public.current_empresa_id());
CREATE POLICY "p_turnos_caja_delete_admin" ON public.turnos_caja FOR DELETE TO authenticated
  USING (empresa_id = public.current_empresa_id() AND public.app_role() IN ('admin', 'encargado'));

-- role_permissions (empresa_id; aislamiento por tenant)
DROP POLICY IF EXISTS "p_role_permissions_select_tenant" ON public.role_permissions;
DROP POLICY IF EXISTS "p_role_permissions_insert_tenant" ON public.role_permissions;
DROP POLICY IF EXISTS "p_role_permissions_update_tenant" ON public.role_permissions;
DROP POLICY IF EXISTS "p_role_permissions_delete_admin" ON public.role_permissions;
CREATE POLICY "p_role_permissions_select_tenant" ON public.role_permissions FOR SELECT TO authenticated
  USING (empresa_id = public.current_empresa_id());
CREATE POLICY "p_role_permissions_insert_tenant" ON public.role_permissions FOR INSERT TO authenticated
  WITH CHECK (empresa_id = public.current_empresa_id());
CREATE POLICY "p_role_permissions_update_tenant" ON public.role_permissions FOR UPDATE TO authenticated
  USING (empresa_id = public.current_empresa_id())
  WITH CHECK (empresa_id = public.current_empresa_id());
CREATE POLICY "p_role_permissions_delete_admin" ON public.role_permissions FOR DELETE TO authenticated
  USING (empresa_id = public.current_empresa_id() AND public.app_role() IN ('admin', 'encargado'));

-- ---------------------------------------------------------------------------
-- Tenant vía EXISTS (sin empresa en fila)
-- ---------------------------------------------------------------------------

-- estanterias -> bodega vía zonasbodega
DROP POLICY IF EXISTS "p_estanterias_select_tenant" ON public.estanterias;
DROP POLICY IF EXISTS "p_estanterias_insert_tenant" ON public.estanterias;
DROP POLICY IF EXISTS "p_estanterias_update_tenant" ON public.estanterias;
DROP POLICY IF EXISTS "p_estanterias_delete_admin" ON public.estanterias;
CREATE POLICY "p_estanterias_select_tenant" ON public.estanterias FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1
      FROM public.zonasbodega z
      JOIN public.bodegas b ON b.id = z.bodegaid
      WHERE z.id = estanterias.zonaid
        AND b.empresaid = public.current_empresa_id()
    )
  );
CREATE POLICY "p_estanterias_insert_tenant" ON public.estanterias FOR INSERT TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1
      FROM public.zonasbodega z
      JOIN public.bodegas b ON b.id = z.bodegaid
      WHERE z.id = estanterias.zonaid
        AND b.empresaid = public.current_empresa_id()
    )
  );
CREATE POLICY "p_estanterias_update_tenant" ON public.estanterias FOR UPDATE TO authenticated
  USING (
    EXISTS (
      SELECT 1
      FROM public.zonasbodega z
      JOIN public.bodegas b ON b.id = z.bodegaid
      WHERE z.id = estanterias.zonaid
        AND b.empresaid = public.current_empresa_id()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1
      FROM public.zonasbodega z
      JOIN public.bodegas b ON b.id = z.bodegaid
      WHERE z.id = estanterias.zonaid
        AND b.empresaid = public.current_empresa_id()
    )
  );
CREATE POLICY "p_estanterias_delete_admin" ON public.estanterias FOR DELETE TO authenticated
  USING (
    EXISTS (
      SELECT 1
      FROM public.zonasbodega z
      JOIN public.bodegas b ON b.id = z.bodegaid
      WHERE z.id = estanterias.zonaid
        AND b.empresaid = public.current_empresa_id()
    )
    AND public.app_role() IN ('admin', 'encargado')
  );

-- zonasbodega -> bodegas.empresaid
DROP POLICY IF EXISTS "p_zonasbodega_select_tenant" ON public.zonasbodega;
DROP POLICY IF EXISTS "p_zonasbodega_insert_tenant" ON public.zonasbodega;
DROP POLICY IF EXISTS "p_zonasbodega_update_tenant" ON public.zonasbodega;
DROP POLICY IF EXISTS "p_zonasbodega_delete_admin" ON public.zonasbodega;
CREATE POLICY "p_zonasbodega_select_tenant" ON public.zonasbodega FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.bodegas b
      WHERE b.id = zonasbodega.bodegaid
        AND b.empresaid = public.current_empresa_id()
    )
  );
CREATE POLICY "p_zonasbodega_insert_tenant" ON public.zonasbodega FOR INSERT TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.bodegas b
      WHERE b.id = zonasbodega.bodegaid
        AND b.empresaid = public.current_empresa_id()
    )
  );
CREATE POLICY "p_zonasbodega_update_tenant" ON public.zonasbodega FOR UPDATE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.bodegas b
      WHERE b.id = zonasbodega.bodegaid
        AND b.empresaid = public.current_empresa_id()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.bodegas b
      WHERE b.id = zonasbodega.bodegaid
        AND b.empresaid = public.current_empresa_id()
    )
  );
CREATE POLICY "p_zonasbodega_delete_admin" ON public.zonasbodega FOR DELETE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.bodegas b
      WHERE b.id = zonasbodega.bodegaid
        AND b.empresaid = public.current_empresa_id()
    )
    AND public.app_role() IN ('admin', 'encargado')
  );

-- listaspreciosdetalle -> listasprecios.empresaid
DROP POLICY IF EXISTS "p_listaspreciosdetalle_select_tenant" ON public.listaspreciosdetalle;
DROP POLICY IF EXISTS "p_listaspreciosdetalle_insert_tenant" ON public.listaspreciosdetalle;
DROP POLICY IF EXISTS "p_listaspreciosdetalle_update_tenant" ON public.listaspreciosdetalle;
DROP POLICY IF EXISTS "p_listaspreciosdetalle_delete_admin" ON public.listaspreciosdetalle;
CREATE POLICY "p_listaspreciosdetalle_select_tenant" ON public.listaspreciosdetalle FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.listasprecios lp
      WHERE lp.id = listaspreciosdetalle.listaid
        AND lp.empresaid = public.current_empresa_id()
    )
  );
CREATE POLICY "p_listaspreciosdetalle_insert_tenant" ON public.listaspreciosdetalle FOR INSERT TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.listasprecios lp
      WHERE lp.id = listaspreciosdetalle.listaid
        AND lp.empresaid = public.current_empresa_id()
    )
  );
CREATE POLICY "p_listaspreciosdetalle_update_tenant" ON public.listaspreciosdetalle FOR UPDATE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.listasprecios lp
      WHERE lp.id = listaspreciosdetalle.listaid
        AND lp.empresaid = public.current_empresa_id()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.listasprecios lp
      WHERE lp.id = listaspreciosdetalle.listaid
        AND lp.empresaid = public.current_empresa_id()
    )
  );
CREATE POLICY "p_listaspreciosdetalle_delete_admin" ON public.listaspreciosdetalle FOR DELETE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.listasprecios lp
      WHERE lp.id = listaspreciosdetalle.listaid
        AND lp.empresaid = public.current_empresa_id()
    )
    AND public.app_role() IN ('admin', 'encargado')
  );

-- misiones_conteo_detalle -> misiones_conteo.empresa_id
DROP POLICY IF EXISTS "p_misiones_conteo_detalle_select_tenant" ON public.misiones_conteo_detalle;
DROP POLICY IF EXISTS "p_misiones_conteo_detalle_insert_tenant" ON public.misiones_conteo_detalle;
DROP POLICY IF EXISTS "p_misiones_conteo_detalle_update_tenant" ON public.misiones_conteo_detalle;
DROP POLICY IF EXISTS "p_misiones_conteo_detalle_delete_admin" ON public.misiones_conteo_detalle;
CREATE POLICY "p_misiones_conteo_detalle_select_tenant" ON public.misiones_conteo_detalle FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.misiones_conteo m
      WHERE m.id = misiones_conteo_detalle.mision_id
        AND m.empresa_id = public.current_empresa_id()
    )
  );
CREATE POLICY "p_misiones_conteo_detalle_insert_tenant" ON public.misiones_conteo_detalle FOR INSERT TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.misiones_conteo m
      WHERE m.id = misiones_conteo_detalle.mision_id
        AND m.empresa_id = public.current_empresa_id()
    )
  );
CREATE POLICY "p_misiones_conteo_detalle_update_tenant" ON public.misiones_conteo_detalle FOR UPDATE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.misiones_conteo m
      WHERE m.id = misiones_conteo_detalle.mision_id
        AND m.empresa_id = public.current_empresa_id()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.misiones_conteo m
      WHERE m.id = misiones_conteo_detalle.mision_id
        AND m.empresa_id = public.current_empresa_id()
    )
  );
CREATE POLICY "p_misiones_conteo_detalle_delete_admin" ON public.misiones_conteo_detalle FOR DELETE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.misiones_conteo m
      WHERE m.id = misiones_conteo_detalle.mision_id
        AND m.empresa_id = public.current_empresa_id()
    )
    AND public.app_role() IN ('admin', 'encargado')
  );

-- tareas_detalle_traslado -> tareas.empresaid
DROP POLICY IF EXISTS "p_tareas_detalle_traslado_select_tenant" ON public.tareas_detalle_traslado;
DROP POLICY IF EXISTS "p_tareas_detalle_traslado_insert_tenant" ON public.tareas_detalle_traslado;
DROP POLICY IF EXISTS "p_tareas_detalle_traslado_update_tenant" ON public.tareas_detalle_traslado;
DROP POLICY IF EXISTS "p_tareas_detalle_traslado_delete_admin" ON public.tareas_detalle_traslado;
CREATE POLICY "p_tareas_detalle_traslado_select_tenant" ON public.tareas_detalle_traslado FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.tareas t
      WHERE t.id = tareas_detalle_traslado.tareaid
        AND t.empresaid = public.current_empresa_id()
    )
  );
CREATE POLICY "p_tareas_detalle_traslado_insert_tenant" ON public.tareas_detalle_traslado FOR INSERT TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.tareas t
      WHERE t.id = tareas_detalle_traslado.tareaid
        AND t.empresaid = public.current_empresa_id()
    )
  );
CREATE POLICY "p_tareas_detalle_traslado_update_tenant" ON public.tareas_detalle_traslado FOR UPDATE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.tareas t
      WHERE t.id = tareas_detalle_traslado.tareaid
        AND t.empresaid = public.current_empresa_id()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.tareas t
      WHERE t.id = tareas_detalle_traslado.tareaid
        AND t.empresaid = public.current_empresa_id()
    )
  );
CREATE POLICY "p_tareas_detalle_traslado_delete_admin" ON public.tareas_detalle_traslado FOR DELETE TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.tareas t
      WHERE t.id = tareas_detalle_traslado.tareaid
        AND t.empresaid = public.current_empresa_id()
    )
    AND public.app_role() IN ('admin', 'encargado')
  );

-- ---------------------------------------------------------------------------
-- Sistema / auditoría (patrón pedido)
-- ---------------------------------------------------------------------------

-- audit_log: SELECT/INSERT autenticados sin filtro empresa; DELETE solo admin
DROP POLICY IF EXISTS "p_audit_log_select_auth" ON public.audit_log;
DROP POLICY IF EXISTS "p_audit_log_insert_auth" ON public.audit_log;
DROP POLICY IF EXISTS "p_audit_log_delete_admin" ON public.audit_log;
CREATE POLICY "p_audit_log_select_auth" ON public.audit_log FOR SELECT TO authenticated USING (true);
CREATE POLICY "p_audit_log_insert_auth" ON public.audit_log FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "p_audit_log_delete_admin" ON public.audit_log FOR DELETE TO authenticated
  USING (public.app_role() = 'admin');

-- import_errors
DROP POLICY IF EXISTS "p_import_errors_select_auth" ON public.import_errors;
DROP POLICY IF EXISTS "p_import_errors_insert_auth" ON public.import_errors;
DROP POLICY IF EXISTS "p_import_errors_delete_admin" ON public.import_errors;
CREATE POLICY "p_import_errors_select_auth" ON public.import_errors FOR SELECT TO authenticated USING (true);
CREATE POLICY "p_import_errors_insert_auth" ON public.import_errors FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "p_import_errors_delete_admin" ON public.import_errors FOR DELETE TO authenticated
  USING (public.app_role() = 'admin');

-- import_log
DROP POLICY IF EXISTS "p_import_log_select_auth" ON public.import_log;
DROP POLICY IF EXISTS "p_import_log_insert_auth" ON public.import_log;
DROP POLICY IF EXISTS "p_import_log_delete_admin" ON public.import_log;
CREATE POLICY "p_import_log_select_auth" ON public.import_log FOR SELECT TO authenticated USING (true);
CREATE POLICY "p_import_log_insert_auth" ON public.import_log FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "p_import_log_delete_admin" ON public.import_log FOR DELETE TO authenticated
  USING (public.app_role() = 'admin');

-- ---------------------------------------------------------------------------
-- Diagnóstico manual (post-migración)
-- ---------------------------------------------------------------------------

-- DIAGNÓSTICO POST-MIGRACIÓN: tablas con RLS ON y sin policies (debe devolver 0 filas)
-- SELECT c.relname FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace
-- WHERE n.nspname='public' AND c.relkind='r' AND c.relrowsecurity=true
-- AND c.relname NOT IN (SELECT DISTINCT tablename FROM pg_policies WHERE schemaname='public')
-- ORDER BY c.relname;
