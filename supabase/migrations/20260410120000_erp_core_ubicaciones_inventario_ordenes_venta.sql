-- =============================================================================
-- ERP núcleo — ubicaciones, inventario por ubicación, órdenes de venta (MVP).
-- Extiende tablas ya definidas en migraciones previas (p. ej. productos, clientes).
-- CRM: maestro clientes sigue en ERP; futuras tablas crm_* referencian clientes.id.
-- Idempotente en lo posible (IF NOT EXISTS / IF EXISTS).
-- =============================================================================

create extension if not exists pgcrypto;

-- -----------------------------------------------------------------------------
-- Trigger updated_at (compartido)
-- -----------------------------------------------------------------------------
create or replace function public.set_updated_at ()
  returns trigger
  language plpgsql
  as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

-- -----------------------------------------------------------------------------
-- Tenant explícito (opcional FK desde profiles.empresa_id en el futuro)
-- -----------------------------------------------------------------------------
create table if not exists public.empresas (
  id uuid primary key default gen_random_uuid (),
  nombre text not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

-- -----------------------------------------------------------------------------
-- Ubicaciones / almacenes (locations)
-- -----------------------------------------------------------------------------
create table if not exists public.ubicaciones (
  id uuid primary key default gen_random_uuid (),
  empresa_id uuid not null,
  codigo text,
  nombre text not null,
  tipo_ubicacion text not null default 'ALMACEN' check (tipo_ubicacion in ('ALMACEN', 'TIENDA', 'TRANSITO', 'DEVOLUCIONES')),
  activo boolean not null default true,
  ubicacion_padre_id uuid references public.ubicaciones (id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  sync_status text not null default 'SYNCED' check (sync_status in ('SYNCED', 'PENDING', 'CONFLICT'))
);

create index if not exists idx_ubicaciones_empresa on public.ubicaciones (empresa_id);

drop trigger if exists tr_ubicaciones_updated_at on public.ubicaciones;

create trigger tr_ubicaciones_updated_at
  before update on public.ubicaciones
  for each row
  execute function public.set_updated_at ();

-- -----------------------------------------------------------------------------
-- Productos stub — ensure table exists before ALTER TABLE (idempotent)
-- La tabla real se crea completa en 20260418040000_real_schema_pull.sql.
-- Este stub garantiza que las migraciones intermedias no fallen si se aplican
-- en un DB limpio en orden cronológico.
-- -----------------------------------------------------------------------------
create table if not exists public.productos (
  id_producto uuid primary key default gen_random_uuid (),
  empresa_id  uuid,
  sku_codigo  text,
  nombre      text not null default '',
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- Columna `id` (alias uuid) que usan otras migraciones como FK
do $$
begin
  if not exists (
    select 1 from information_schema.columns
    where table_schema = 'public'
      and table_name   = 'productos'
      and column_name  = 'id'
  ) then
    alter table public.productos add column id uuid default gen_random_uuid ();
  end if;
end $$;

-- Clientes stub
create table if not exists public.clientes (
  id         uuid primary key default gen_random_uuid (),
  empresa_id uuid,
  nombre     text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
-- -----------------------------------------------------------------------------
-- Productos / clientes — alinear con schema-conventions (columnas opcionales)
-- -----------------------------------------------------------------------------
alter table public.productos
  add column if not exists descripcion text;

alter table public.productos
  add column if not exists unidad_medida text;

alter table public.productos
  add column if not exists activo boolean not null default true;

alter table public.productos
  add column if not exists created_at timestamptz not null default now();

alter table public.productos
  add column if not exists updated_at timestamptz not null default now();

alter table public.productos
  add column if not exists deleted_at timestamptz;

alter table public.productos
  add column if not exists sync_status text not null default 'SYNCED';

do $$
begin
  alter table public.productos
    add constraint productos_sync_status_check check (sync_status in ('SYNCED', 'PENDING', 'CONFLICT'));
exception
  when duplicate_object then null;
end $$;

drop trigger if exists tr_productos_updated_at on public.productos;

create trigger tr_productos_updated_at
  before update on public.productos
  for each row
  execute function public.set_updated_at ();

alter table public.clientes
  add column if not exists email text;

alter table public.clientes
  add column if not exists telefono text;

alter table public.clientes
  add column if not exists created_at timestamptz not null default now();

alter table public.clientes
  add column if not exists updated_at timestamptz not null default now();

alter table public.clientes
  add column if not exists deleted_at timestamptz;

alter table public.clientes
  add column if not exists sync_status text not null default 'SYNCED';

do $$
begin
  alter table public.clientes
    add constraint clientes_sync_status_check check (sync_status in ('SYNCED', 'PENDING', 'CONFLICT'));
exception
  when duplicate_object then null;
end $$;

drop trigger if exists tr_clientes_updated_at on public.clientes;

create trigger tr_clientes_updated_at
  before update on public.clientes
  for each row
  execute function public.set_updated_at ();

-- -----------------------------------------------------------------------------
-- Inventario: existencias por producto y ubicación (MVP)
-- -----------------------------------------------------------------------------
create table if not exists public.inventario_existencias (
  id uuid primary key default gen_random_uuid (),
  empresa_id uuid not null,
  producto_id uuid not null references public.productos (id) on delete restrict,
  ubicacion_id uuid not null references public.ubicaciones (id) on delete restrict,
  cantidad_disponible numeric(18, 4) not null default 0,
  cantidad_reservada numeric(18, 4) not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  sync_status text not null default 'SYNCED' check (sync_status in ('SYNCED', 'PENDING', 'CONFLICT')),
  constraint inventario_existencias_cantidades_nonneg check (cantidad_disponible >= 0
    and cantidad_reservada >= 0)
);

create index if not exists idx_inventario_existencias_empresa on public.inventario_existencias (empresa_id);

create index if not exists idx_inventario_existencias_producto on public.inventario_existencias (producto_id);

create index if not exists idx_inventario_existencias_ubicacion on public.inventario_existencias (ubicacion_id);

create unique index if not exists uq_inventario_existencias_emp_prod_ubic_activo on public.inventario_existencias (empresa_id, producto_id, ubicacion_id)
where
  deleted_at is null;

drop trigger if exists tr_inventario_existencias_updated_at on public.inventario_existencias;

create trigger tr_inventario_existencias_updated_at
  before update on public.inventario_existencias
  for each row
  execute function public.set_updated_at ();

-- -----------------------------------------------------------------------------
-- Órdenes de venta (MVP; canal CRM puede crearse encima vía API / Edge más adelante)
-- -----------------------------------------------------------------------------
create table if not exists public.ordenes_venta_encabezado (
  id uuid primary key default gen_random_uuid (),
  empresa_id uuid not null,
  cliente_id uuid not null references public.clientes (id) on delete restrict,
  ubicacion_id uuid references public.ubicaciones (id),
  numero_documento text,
  estado text not null default 'BORRADOR' check (estado in ('BORRADOR', 'CONFIRMADO', 'PREPARACION', 'DESPACHADO', 'ENTREGADO', 'CANCELADO', 'CERRADO')),
  moneda text not null default 'MXN',
  notas text,
  creado_por_id uuid references public.profiles (id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  sync_status text not null default 'SYNCED' check (sync_status in ('SYNCED', 'PENDING', 'CONFLICT'))
);

create index if not exists idx_ov_enc_empresa on public.ordenes_venta_encabezado (empresa_id);

create index if not exists idx_ov_enc_cliente on public.ordenes_venta_encabezado (cliente_id);

create index if not exists idx_ov_enc_estado on public.ordenes_venta_encabezado (empresa_id, estado);

drop trigger if exists tr_ordenes_venta_enc_updated_at on public.ordenes_venta_encabezado;

create trigger tr_ordenes_venta_enc_updated_at
  before update on public.ordenes_venta_encabezado
  for each row
  execute function public.set_updated_at ();

create table if not exists public.ordenes_venta_detalle (
  id uuid primary key default gen_random_uuid (),
  orden_venta_id uuid not null references public.ordenes_venta_encabezado (id) on delete cascade,
  producto_id uuid not null references public.productos (id) on delete restrict,
  cantidad numeric(18, 4) not null,
  precio_unitario numeric(18, 4) not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint ordenes_venta_detalle_cantidad_pos check (cantidad > 0)
);

create index if not exists idx_ov_det_orden on public.ordenes_venta_detalle (orden_venta_id);

create index if not exists idx_ov_det_producto on public.ordenes_venta_detalle (producto_id);

drop trigger if exists tr_ordenes_venta_det_updated_at on public.ordenes_venta_detalle;

create trigger tr_ordenes_venta_det_updated_at
  before update on public.ordenes_venta_detalle
  for each row
  execute function public.set_updated_at ();

-- -----------------------------------------------------------------------------
-- RLS (misma filosofía que draft: current_empresa_id / app_role)
-- Nota: si las funciones de sesión no existen aún, aplicar primero la migración que las define.
-- -----------------------------------------------------------------------------
alter table public.empresas enable row level security;

drop policy if exists p_empresas_select_tenant on public.empresas;

-- Solo lectura del tenant actual; altas de empresa vía service_role / SQL operativo.
create policy p_empresas_select_tenant on public.empresas
  for select to authenticated
  using (id = public.current_empresa_id ()
    and deleted_at is null);

drop policy if exists p_empresas_update_admin on public.empresas;

create policy p_empresas_update_admin on public.empresas
  for update to authenticated
  using (public.app_role () = 'admin'
    and id = public.current_empresa_id ())
  with check (public.app_role () = 'admin'
    and id = public.current_empresa_id ());

-- ubicaciones
alter table public.ubicaciones enable row level security;

drop policy if exists p_ubicaciones_select_staff on public.ubicaciones;

create policy p_ubicaciones_select_staff on public.ubicaciones
  for select to authenticated
  using (empresa_id = public.current_empresa_id ()
    and deleted_at is null
    and public.app_role () in ('empleado', 'encargado', 'admin'));

drop policy if exists p_ubicaciones_write_admin on public.ubicaciones;

create policy p_ubicaciones_write_admin on public.ubicaciones
  for all to authenticated
  using (public.app_role () = 'admin'
    and empresa_id = public.current_empresa_id ())
  with check (public.app_role () = 'admin'
    and empresa_id = public.current_empresa_id ());

-- inventario_existencias
alter table public.inventario_existencias enable row level security;

drop policy if exists p_inv_ext_select_staff on public.inventario_existencias;

create policy p_inv_ext_select_staff on public.inventario_existencias
  for select to authenticated
  using (empresa_id = public.current_empresa_id ()
    and deleted_at is null
    and public.app_role () in ('empleado', 'encargado', 'admin'));

drop policy if exists p_inv_ext_write_admin on public.inventario_existencias;

create policy p_inv_ext_write_admin on public.inventario_existencias
  for all to authenticated
  using (public.app_role () = 'admin'
    and empresa_id = public.current_empresa_id ())
  with check (public.app_role () = 'admin'
    and empresa_id = public.current_empresa_id ());

-- ordenes venta encabezado
alter table public.ordenes_venta_encabezado enable row level security;

drop policy if exists p_ov_enc_select_staff on public.ordenes_venta_encabezado;

create policy p_ov_enc_select_staff on public.ordenes_venta_encabezado
  for select to authenticated
  using (empresa_id = public.current_empresa_id ()
    and deleted_at is null
    and public.app_role () in ('empleado', 'encargado', 'admin'));

drop policy if exists p_ov_enc_insert_staff on public.ordenes_venta_encabezado;

create policy p_ov_enc_insert_staff on public.ordenes_venta_encabezado
  for insert to authenticated
  with check (empresa_id = public.current_empresa_id ()
    and public.app_role () in ('encargado', 'admin'));

drop policy if exists p_ov_enc_update_staff on public.ordenes_venta_encabezado;

create policy p_ov_enc_update_staff on public.ordenes_venta_encabezado
  for update to authenticated
  using (empresa_id = public.current_empresa_id ()
    and public.app_role () in ('encargado', 'admin'))
  with check (empresa_id = public.current_empresa_id ()
    and public.app_role () in ('encargado', 'admin'));

drop policy if exists p_ov_enc_delete_admin on public.ordenes_venta_encabezado;

create policy p_ov_enc_delete_admin on public.ordenes_venta_encabezado
  for delete to authenticated
  using (public.app_role () = 'admin'
    and empresa_id = public.current_empresa_id ());

-- ordenes venta detalle
alter table public.ordenes_venta_detalle enable row level security;

drop policy if exists p_ov_det_select_staff on public.ordenes_venta_detalle;

create policy p_ov_det_select_staff on public.ordenes_venta_detalle
  for select to authenticated
  using (exists (
    select
      1
    from
      public.ordenes_venta_encabezado o
    where
      o.id = ordenes_venta_detalle.orden_venta_id
      and o.empresa_id = public.current_empresa_id ()
      and o.deleted_at is null
      and public.app_role () in ('empleado', 'encargado', 'admin')));

drop policy if exists p_ov_det_write_staff on public.ordenes_venta_detalle;

create policy p_ov_det_write_staff on public.ordenes_venta_detalle
  for all to authenticated
  using (exists (
    select
      1
    from
      public.ordenes_venta_encabezado o
    where
      o.id = ordenes_venta_detalle.orden_venta_id
      and o.empresa_id = public.current_empresa_id ()
      and public.app_role () in ('encargado', 'admin')))
  with check (exists (
    select
      1
    from
      public.ordenes_venta_encabezado o
    where
      o.id = ordenes_venta_detalle.orden_venta_id
      and o.empresa_id = public.current_empresa_id ()
      and public.app_role () in ('encargado', 'admin')));

comment on table public.clientes is 'Maestro ERP de clientes; CRM añade tablas de relación encima (mensajes, casos, pipeline).';

comment on table public.ordenes_venta_encabezado is 'Pedido/OV núcleo ERP; canales (POS, CRM, e-commerce) crean filas aquí vía API.';

comment on table public.inventario_existencias is 'Stock por ubicación; reservas MVP en cantidad_reservada; ajustes y lotes en migraciones futuras.';
