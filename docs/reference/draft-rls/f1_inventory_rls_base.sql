-- BORRADOR / DRAFT — no ejecutar como migración directamente
-- Documento de diseño de RLS. Ver migrations/ para la versión aplicada.

-- Fase 1 · Sprint 1
-- Base mínima de RLS para módulo inventario
-- No crea tablas; solo agrega policies sobre tablas reales

-- =========================================================
-- 1) BODEGAS
-- =========================================================

create policy "bodegas_select_authenticated"
on public.bodegas
for select
to authenticated
using (auth.uid() is not null);

create policy "bodegas_write_admin_encargado"
on public.bodegas
for insert
to authenticated
with check (
  exists (
    select 1
    from public.user_roles ur
    join public.roles r on r.id = ur.role_id
    where ur.user_id = auth.uid()
      and r.codigo in ('admin', 'encargado')
  )
);

create policy "bodegas_update_admin_encargado"
on public.bodegas
for update
to authenticated
using (
  exists (
    select 1
    from public.user_roles ur
    join public.roles r on r.id = ur.role_id
    where ur.user_id = auth.uid()
      and r.codigo in ('admin', 'encargado')
  )
)
with check (
  exists (
    select 1
    from public.user_roles ur
    join public.roles r on r.id = ur.role_id
    where ur.user_id = auth.uid()
      and r.codigo in ('admin', 'encargado')
  )
);

create policy "bodegas_delete_admin"
on public.bodegas
for delete
to authenticated
using (
  exists (
    select 1
    from public.user_roles ur
    join public.roles r on r.id = ur.role_id
    where ur.user_id = auth.uid()
      and r.codigo = 'admin'
  )
);

-- =========================================================
-- 2) ZONAS BODEGA
-- =========================================================

create policy "zonasbodega_select_authenticated"
on public.zonasbodega
for select
to authenticated
using (auth.uid() is not null);

create policy "zonasbodega_write_admin_encargado"
on public.zonasbodega
for insert
to authenticated
with check (
  exists (
    select 1
    from public.user_roles ur
    join public.roles r on r.id = ur.role_id
    where ur.user_id = auth.uid()
      and r.codigo in ('admin', 'encargado')
  )
);

create policy "zonasbodega_update_admin_encargado"
on public.zonasbodega
for update
to authenticated
using (
  exists (
    select 1
    from public.user_roles ur
    join public.roles r on r.id = ur.role_id
    where ur.user_id = auth.uid()
      and r.codigo in ('admin', 'encargado')
  )
)
with check (
  exists (
    select 1
    from public.user_roles ur
    join public.roles r on r.id = ur.role_id
    where ur.user_id = auth.uid()
      and r.codigo in ('admin', 'encargado')
  )
);

create policy "zonasbodega_delete_admin"
on public.zonasbodega
for delete
to authenticated
using (
  exists (
    select 1
    from public.user_roles ur
    join public.roles r on r.id = ur.role_id
    where ur.user_id = auth.uid()
      and r.codigo = 'admin'
  )
);

-- =========================================================
-- 3) STOCKUBICACION
-- =========================================================

create policy "stockubicacion_select_authenticated"
on public.stockubicacion
for select
to authenticated
using (auth.uid() is not null);

create policy "stockubicacion_insert_admin_encargado_bodeguero"
on public.stockubicacion
for insert
to authenticated
with check (
  exists (
    select 1
    from public.user_roles ur
    join public.roles r on r.id = ur.role_id
    where ur.user_id = auth.uid()
      and r.codigo in ('admin', 'encargado', 'bodeguero')
  )
);

create policy "stockubicacion_update_admin_encargado_bodeguero"
on public.stockubicacion
for update
to authenticated
using (
  exists (
    select 1
    from public.user_roles ur
    join public.roles r on r.id = ur.role_id
    where ur.user_id = auth.uid()
      and r.codigo in ('admin', 'encargado', 'bodeguero')
  )
)
with check (
  exists (
    select 1
    from public.user_roles ur
    join public.roles r on r.id = ur.role_id
    where ur.user_id = auth.uid()
      and r.codigo in ('admin', 'encargado', 'bodeguero')
  )
);

-- =========================================================
-- 4) MOVIMIENTOS INVENTARIO
-- =========================================================

create policy "movimientosinventario_select_authenticated"
on public.movimientosinventario
for select
to authenticated
using (auth.uid() is not null);

create policy "movimientosinventario_insert_operativo"
on public.movimientosinventario
for insert
to authenticated
with check (
  exists (
    select 1
    from public.user_roles ur
    join public.roles r on r.id = ur.role_id
    where ur.user_id = auth.uid()
      and r.codigo in ('admin', 'encargado', 'bodeguero', 'empleado')
  )
);

-- =========================================================
-- 5) TRASLADOS
-- =========================================================

create policy "traslados_encabezado_select_authenticated"
on public.traslados_encabezado
for select
to authenticated
using (auth.uid() is not null);

create policy "traslados_encabezado_insert_operativo"
on public.traslados_encabezado
for insert
to authenticated
with check (
  exists (
    select 1
    from public.user_roles ur
    join public.roles r on r.id = ur.role_id
    where ur.user_id = auth.uid()
      and r.codigo in ('admin', 'encargado', 'bodeguero', 'empleado')
  )
);

create policy "traslados_encabezado_update_admin_encargado"
on public.traslados_encabezado
for update
to authenticated
using (
  exists (
    select 1
    from public.user_roles ur
    join public.roles r on r.id = ur.role_id
    where ur.user_id = auth.uid()
      and r.codigo in ('admin', 'encargado')
  )
)
with check (
  exists (
    select 1
    from public.user_roles ur
    join public.roles r on r.id = ur.role_id
    where ur.user_id = auth.uid()
      and r.codigo in ('admin', 'encargado')
  )
);

create policy "traslados_detalle_select_authenticated"
on public.traslados_detalle
for select
to authenticated
using (auth.uid() is not null);

create policy "traslados_detalle_insert_operativo"
on public.traslados_detalle
for insert
to authenticated
with check (
  exists (
    select 1
    from public.user_roles ur
    join public.roles r on r.id = ur.role_id
    where ur.user_id = auth.uid()
      and r.codigo in ('admin', 'encargado', 'bodeguero', 'empleado')
  )
);

create policy "traslados_detalle_update_admin_encargado"
on public.traslados_detalle
for update
to authenticated
using (
  exists (
    select 1
    from public.user_roles ur
    join public.roles r on r.id = ur.role_id
    where ur.user_id = auth.uid()
      and r.codigo in ('admin', 'encargado')
  )
)
with check (
  exists (
    select 1
    from public.user_roles ur
    join public.roles r on r.id = ur.role_id
    where ur.user_id = auth.uid()
      and r.codigo in ('admin', 'encargado')
  )
);