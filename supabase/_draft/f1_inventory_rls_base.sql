-- F1 · Inventario — RLS base por rol
-- ----------------------------------
-- BORRADOR DE DISEÑO (no ejecutar como migración histórica).
-- Copiar a `supabase/migrations/<timestamp>_nombre.sql` en rama temporal
-- después de revisar contra tu BD.
--
-- Alineado a esquema real introspectado (public.*):
--   bodegas.empresaid, zonasbodega solo bodegaid (tenant vía bodegas),
--   estanterias/filasestanteria/cubiculosfila sin empresa (tenant vía joins),
--   stockubicacion / movimientosinventario / traslados_encabezado: empresaid,
--   misiones_conteo: empresa_id (con guión bajo),
--   traslados_detalle.trasladoid, misiones_conteo_detalle.mision_id.
--
-- Suposiciones:
--   app_role() → 'admin', 'encargado', 'bodeguero', 'empleado', ...
--   current_empresa_id() / current_sucursal_id() leen user_profiles.
--   RLS ya habilitado en estas tablas.
--
-- Antes de migrar: si existen policies legacy (p. ej. nombres misiones_*),
-- documentar DROP explícito o consolidar para no acumular políticas duplicadas.


-- =========================================================
-- 1) BODEGAS
-- =========================================================

drop policy if exists p_bodegas_select_tenant on public.bodegas;

create policy p_bodegas_select_tenant on public.bodegas
  for select to authenticated
  using (
    auth.uid () is not null
    and empresaid = public.current_empresa_id ()
  );

drop policy if exists p_bodegas_write_admin_encargado on public.bodegas;

create policy p_bodegas_write_admin_encargado on public.bodegas
  for all to authenticated
  using (
    public.app_role () in ('admin', 'encargado')
    and empresaid = public.current_empresa_id ()
  )
  with check (
    public.app_role () in ('admin', 'encargado')
    and empresaid = public.current_empresa_id ()
  );


-- =========================================================
-- 2) ZONASBODEGA (sin empresaid; tenant vía bodegas)
-- =========================================================

drop policy if exists p_zonasbodega_select_tenant on public.zonasbodega;

create policy p_zonasbodega_select_tenant on public.zonasbodega
  for select to authenticated
  using (
    auth.uid () is not null
    and exists (
      select
        1
      from
        public.bodegas b
      where
        b.id = zonasbodega.bodegaid
        and b.empresaid = public.current_empresa_id ()
    )
  );

drop policy if exists p_zonasbodega_write_admin_encargado on public.zonasbodega;

create policy p_zonasbodega_write_admin_encargado on public.zonasbodega
  for all to authenticated
  using (
    public.app_role () in ('admin', 'encargado')
    and exists (
      select
        1
      from
        public.bodegas b
      where
        b.id = zonasbodega.bodegaid
        and b.empresaid = public.current_empresa_id ()
    )
  )
  with check (
    public.app_role () in ('admin', 'encargado')
    and exists (
      select
        1
      from
        public.bodegas b
      where
        b.id = zonasbodega.bodegaid
        and b.empresaid = public.current_empresa_id ()
    )
  );


-- =========================================================
-- 3) ESTANTERÍAS / FILAS / CUBÍCULOS (tenant vía jerarquía)
-- =========================================================

drop policy if exists p_estanterias_select_tenant on public.estanterias;

create policy p_estanterias_select_tenant on public.estanterias
  for select to authenticated
  using (
    auth.uid () is not null
    and exists (
      select
        1
      from
        public.zonasbodega z
        inner join public.bodegas b on b.id = z.bodegaid
      where
        z.id = estanterias.zonaid
        and b.empresaid = public.current_empresa_id ()
    )
  );

drop policy if exists p_filasestanteria_select_tenant on public.filasestanteria;

create policy p_filasestanteria_select_tenant on public.filasestanteria
  for select to authenticated
  using (
    auth.uid () is not null
    and exists (
      select
        1
      from
        public.estanterias e
        inner join public.zonasbodega z on z.id = e.zonaid
        inner join public.bodegas b on b.id = z.bodegaid
      where
        e.id = filasestanteria.estanteriaid
        and b.empresaid = public.current_empresa_id ()
    )
  );

drop policy if exists p_cubiculosfila_select_tenant on public.cubiculosfila;

create policy p_cubiculosfila_select_tenant on public.cubiculosfila
  for select to authenticated
  using (
    auth.uid () is not null
    and exists (
      select
        1
      from
        public.filasestanteria f
        inner join public.estanterias e on e.id = f.estanteriaid
        inner join public.zonasbodega z on z.id = e.zonaid
        inner join public.bodegas b on b.id = z.bodegaid
      where
        f.id = cubiculosfila.filaid
        and b.empresaid = public.current_empresa_id ()
    )
  );

drop policy if exists p_estanterias_write_admin_encargado on public.estanterias;

create policy p_estanterias_write_admin_encargado on public.estanterias
  for all to authenticated
  using (
    public.app_role () in ('admin', 'encargado')
    and exists (
      select
        1
      from
        public.zonasbodega z
        inner join public.bodegas b on b.id = z.bodegaid
      where
        z.id = estanterias.zonaid
        and b.empresaid = public.current_empresa_id ()
    )
  )
  with check (
    public.app_role () in ('admin', 'encargado')
    and exists (
      select
        1
      from
        public.zonasbodega z
        inner join public.bodegas b on b.id = z.bodegaid
      where
        z.id = estanterias.zonaid
        and b.empresaid = public.current_empresa_id ()
    )
  );

drop policy if exists p_filasestanteria_write_admin_encargado on public.filasestanteria;

create policy p_filasestanteria_write_admin_encargado on public.filasestanteria
  for all to authenticated
  using (
    public.app_role () in ('admin', 'encargado')
    and exists (
      select
        1
      from
        public.estanterias e
        inner join public.zonasbodega z on z.id = e.zonaid
        inner join public.bodegas b on b.id = z.bodegaid
      where
        e.id = filasestanteria.estanteriaid
        and b.empresaid = public.current_empresa_id ()
    )
  )
  with check (
    public.app_role () in ('admin', 'encargado')
    and exists (
      select
        1
      from
        public.estanterias e
        inner join public.zonasbodega z on z.id = e.zonaid
        inner join public.bodegas b on b.id = z.bodegaid
      where
        e.id = filasestanteria.estanteriaid
        and b.empresaid = public.current_empresa_id ()
    )
  );

drop policy if exists p_cubiculosfila_write_admin_encargado on public.cubiculosfila;

create policy p_cubiculosfila_write_admin_encargado on public.cubiculosfila
  for all to authenticated
  using (
    public.app_role () in ('admin', 'encargado')
    and exists (
      select
        1
      from
        public.filasestanteria f
        inner join public.estanterias e on e.id = f.estanteriaid
        inner join public.zonasbodega z on z.id = e.zonaid
        inner join public.bodegas b on b.id = z.bodegaid
      where
        f.id = cubiculosfila.filaid
        and b.empresaid = public.current_empresa_id ()
    )
  )
  with check (
    public.app_role () in ('admin', 'encargado')
    and exists (
      select
        1
      from
        public.filasestanteria f
        inner join public.estanterias e on e.id = f.estanteriaid
        inner join public.zonasbodega z on z.id = e.zonaid
        inner join public.bodegas b on b.id = z.bodegaid
      where
        f.id = cubiculosfila.filaid
        and b.empresaid = public.current_empresa_id ()
    )
  );


-- =========================================================
-- 4) STOCKUBICACION
-- =========================================================

drop policy if exists p_stockubicacion_select_tenant on public.stockubicacion;

create policy p_stockubicacion_select_tenant on public.stockubicacion
  for select to authenticated
  using (
    auth.uid () is not null
    and empresaid = public.current_empresa_id ()
  );

drop policy if exists p_stockubicacion_write_operativo on public.stockubicacion;

create policy p_stockubicacion_write_operativo on public.stockubicacion
  for all to authenticated
  using (
    public.app_role () in ('admin', 'encargado', 'bodeguero', 'empleado')
    and empresaid = public.current_empresa_id ()
  )
  with check (
    public.app_role () in ('admin', 'encargado', 'bodeguero', 'empleado')
    and empresaid = public.current_empresa_id ()
  );


-- =========================================================
-- 5) MOVIMIENTOS DE INVENTARIO
-- =========================================================

drop policy if exists p_movinv_select_tenant on public.movimientosinventario;

create policy p_movinv_select_tenant on public.movimientosinventario
  for select to authenticated
  using (
    auth.uid () is not null
    and empresaid = public.current_empresa_id ()
  );

drop policy if exists p_movinv_insert_operativo on public.movimientosinventario;

create policy p_movinv_insert_operativo on public.movimientosinventario
  for insert to authenticated
  with check (
    public.app_role () in ('admin', 'encargado', 'bodeguero', 'empleado')
    and empresaid = public.current_empresa_id ()
  );


-- =========================================================
-- 6) TRASLADOS (detalle: trasladoid → encabezado.id)
-- =========================================================

drop policy if exists p_tr_enc_select_tenant on public.traslados_encabezado;

create policy p_tr_enc_select_tenant on public.traslados_encabezado
  for select to authenticated
  using (
    auth.uid () is not null
    and empresaid = public.current_empresa_id ()
  );

drop policy if exists p_tr_enc_insert_operativo on public.traslados_encabezado;

create policy p_tr_enc_insert_operativo on public.traslados_encabezado
  for insert to authenticated
  with check (
    public.app_role () in ('admin', 'encargado', 'bodeguero', 'empleado')
    and empresaid = public.current_empresa_id ()
  );

drop policy if exists p_tr_enc_update_admin_encargado on public.traslados_encabezado;

create policy p_tr_enc_update_admin_encargado on public.traslados_encabezado
  for update to authenticated
  using (
    public.app_role () in ('admin', 'encargado')
    and empresaid = public.current_empresa_id ()
  )
  with check (
    public.app_role () in ('admin', 'encargado')
    and empresaid = public.current_empresa_id ()
  );

drop policy if exists p_tr_det_select_tenant on public.traslados_detalle;

create policy p_tr_det_select_tenant on public.traslados_detalle
  for select to authenticated
  using (
    auth.uid () is not null
    and exists (
      select
        1
      from
        public.traslados_encabezado te
      where
        te.id = traslados_detalle.trasladoid
        and te.empresaid = public.current_empresa_id ()
    )
  );

drop policy if exists p_tr_det_insert_operativo on public.traslados_detalle;

create policy p_tr_det_insert_operativo on public.traslados_detalle
  for insert to authenticated
  with check (
    public.app_role () in ('admin', 'encargado', 'bodeguero', 'empleado')
    and exists (
      select
        1
      from
        public.traslados_encabezado te
      where
        te.id = traslados_detalle.trasladoid
        and te.empresaid = public.current_empresa_id ()
    )
  );

drop policy if exists p_tr_det_update_admin_encargado on public.traslados_detalle;

create policy p_tr_det_update_admin_encargado on public.traslados_detalle
  for update to authenticated
  using (
    public.app_role () in ('admin', 'encargado')
    and exists (
      select
        1
      from
        public.traslados_encabezado te
      where
        te.id = traslados_detalle.trasladoid
        and te.empresaid = public.current_empresa_id ()
    )
  )
  with check (
    public.app_role () in ('admin', 'encargado')
    and exists (
      select
        1
      from
        public.traslados_encabezado te
      where
        te.id = traslados_detalle.trasladoid
        and te.empresaid = public.current_empresa_id ()
    )
  );


-- =========================================================
-- 7) MISIONES DE CONTEO (empresa_id en encabezado; mision_id en detalle)
-- =========================================================
-- Ojo: en remoto pueden existir policies previas (misiones_*). Al migrar,
-- valorar DROP de las antiguas para evitar acumulación OR de políticas.

drop policy if exists p_misiones_conteo_select_tenant on public.misiones_conteo;

create policy p_misiones_conteo_select_tenant on public.misiones_conteo
  for select to authenticated
  using (
    auth.uid () is not null
    and empresa_id = public.current_empresa_id ()
  );

drop policy if exists p_misiones_conteo_insert_admin_encargado on public.misiones_conteo;

create policy p_misiones_conteo_insert_admin_encargado on public.misiones_conteo
  for insert to authenticated
  with check (
    public.app_role () in ('admin', 'encargado')
    and empresa_id = public.current_empresa_id ()
  );

drop policy if exists p_misiones_conteo_update_admin_encargado on public.misiones_conteo;

create policy p_misiones_conteo_update_admin_encargado on public.misiones_conteo
  for update to authenticated
  using (
    public.app_role () in ('admin', 'encargado')
    and empresa_id = public.current_empresa_id ()
  )
  with check (
    public.app_role () in ('admin', 'encargado')
    and empresa_id = public.current_empresa_id ()
  );

drop policy if exists p_misiones_conteo_detalle_select_tenant on public.misiones_conteo_detalle;

create policy p_misiones_conteo_detalle_select_tenant on public.misiones_conteo_detalle
  for select to authenticated
  using (
    auth.uid () is not null
    and exists (
      select
        1
      from
        public.misiones_conteo mc
      where
        mc.id = misiones_conteo_detalle.mision_id
        and mc.empresa_id = public.current_empresa_id ()
    )
  );

drop policy if exists p_misiones_conteo_detalle_insert_operativo on public.misiones_conteo_detalle;

create policy p_misiones_conteo_detalle_insert_operativo on public.misiones_conteo_detalle
  for insert to authenticated
  with check (
    public.app_role () in ('admin', 'encargado', 'bodeguero', 'empleado')
    and exists (
      select
        1
      from
        public.misiones_conteo mc
      where
        mc.id = misiones_conteo_detalle.mision_id
        and mc.empresa_id = public.current_empresa_id ()
    )
  );
