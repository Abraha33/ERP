-- =============================================================================
-- S1 — Post-auth alineado a public.profiles + triggers updated_at faltantes.
-- No modifica migraciones históricas. Idempotente donde aplica.
--
-- 1) handle_new_auth_user: deja de usar public.user_profiles (tabla inexistente).
--    Inserta en profiles solo si raw_user_meta_data incluye empresa_id (uuid).
--    Sin empresa_id el trigger no falla (alta Auth válida; perfil vía admin/service).
-- 2) Columnas updated_at (y created_at donde faltan) + tr_*_updated_at en tablas
--    del draft que aún no las tenían.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Auth → profiles
-- -----------------------------------------------------------------------------
create or replace function public.handle_new_auth_user ()
  returns trigger
  language plpgsql
  security definer
  set search_path = public
  as $$
declare
  v_empresa_id uuid;
  v_sucursal_id uuid;
  v_role text;
begin
  begin
    v_empresa_id := (nullif(trim(new.raw_user_meta_data ->> 'empresa_id'), ''))::uuid;
  exception
    when invalid_text_representation then
      v_empresa_id := null;
  end;

  if v_empresa_id is null then
    return new;
  end if;

  begin
    v_sucursal_id := (nullif(trim(new.raw_user_meta_data ->> 'sucursal_id'), ''))::uuid;
  exception
    when invalid_text_representation then
      v_sucursal_id := null;
  end;

  v_role := coalesce(
    nullif(lower(trim(new.raw_user_meta_data ->> 'app_role')), ''),
    'empleado');

  if v_role not in ('admin', 'encargado', 'empleado') then
    v_role := 'empleado';
  end if;

  insert into public.profiles (
    id,
    empresa_id,
    sucursal_id,
    app_role,
    created_at,
    updated_at,
    deleted_at,
    sync_status)
  values (
    new.id,
    v_empresa_id,
    v_sucursal_id,
    v_role,
    now(),
    now(),
    null,
    'SYNCED')
on conflict (id)
  do update set
    updated_at = now();

  return new;
end;
$$;

comment on function public.handle_new_auth_user () is 'Alta Auth: crea/actualiza public.profiles si empresa_id viene en user_metadata; si no, no-op.';

-- -----------------------------------------------------------------------------
-- Columnas estándar (draft sin auditoría de fila)
-- -----------------------------------------------------------------------------
alter table public.proveedores
  add column if not exists created_at timestamptz not null default now();

alter table public.proveedores
  add column if not exists updated_at timestamptz not null default now();

alter table public.compras_encabezado
  add column if not exists created_at timestamptz not null default now();

alter table public.compras_encabezado
  add column if not exists updated_at timestamptz not null default now();

alter table public.compras_detalle
  add column if not exists created_at timestamptz not null default now();

alter table public.compras_detalle
  add column if not exists updated_at timestamptz not null default now();

alter table public.ordenes_compra_encabezado
  add column if not exists created_at timestamptz not null default now();

alter table public.ordenes_compra_encabezado
  add column if not exists updated_at timestamptz not null default now();

alter table public.ordenes_compra_detalle
  add column if not exists created_at timestamptz not null default now();

alter table public.ordenes_compra_detalle
  add column if not exists updated_at timestamptz not null default now();

alter table public.traslados_encabezado
  add column if not exists created_at timestamptz not null default now();

alter table public.traslados_encabezado
  add column if not exists updated_at timestamptz not null default now();

alter table public.traslados_detalle
  add column if not exists created_at timestamptz not null default now();

alter table public.traslados_detalle
  add column if not exists updated_at timestamptz not null default now();

-- -----------------------------------------------------------------------------
-- Triggers (set_updated_at ya existe en cadena previa)
-- -----------------------------------------------------------------------------
drop trigger if exists tr_empresas_updated_at on public.empresas;

create trigger tr_empresas_updated_at
  before update on public.empresas
  for each row
  execute function public.set_updated_at ();

drop trigger if exists tr_proveedores_updated_at on public.proveedores;

create trigger tr_proveedores_updated_at
  before update on public.proveedores
  for each row
  execute function public.set_updated_at ();

drop trigger if exists tr_compras_encabezado_updated_at on public.compras_encabezado;

create trigger tr_compras_encabezado_updated_at
  before update on public.compras_encabezado
  for each row
  execute function public.set_updated_at ();

drop trigger if exists tr_compras_detalle_updated_at on public.compras_detalle;

create trigger tr_compras_detalle_updated_at
  before update on public.compras_detalle
  for each row
  execute function public.set_updated_at ();

drop trigger if exists tr_ordenes_compra_enc_updated_at on public.ordenes_compra_encabezado;

create trigger tr_ordenes_compra_enc_updated_at
  before update on public.ordenes_compra_encabezado
  for each row
  execute function public.set_updated_at ();

drop trigger if exists tr_ordenes_compra_det_updated_at on public.ordenes_compra_detalle;

create trigger tr_ordenes_compra_det_updated_at
  before update on public.ordenes_compra_detalle
  for each row
  execute function public.set_updated_at ();

drop trigger if exists tr_traslados_enc_updated_at on public.traslados_encabezado;

create trigger tr_traslados_enc_updated_at
  before update on public.traslados_encabezado
  for each row
  execute function public.set_updated_at ();

drop trigger if exists tr_traslados_det_updated_at on public.traslados_detalle;

create trigger tr_traslados_det_updated_at
  before update on public.traslados_detalle
  for each row
  execute function public.set_updated_at ();
