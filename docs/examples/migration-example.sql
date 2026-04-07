-- =============================================================================
-- EJEMPLO EDUCATIVO — no ejecutar ciego en producción
-- Objetivo: empresas + sucursales + RLS mínimo + referencia desde user_profiles
-- Ajustar nombres si tu proyecto ya tiene tablas parciales (evitar duplicados).
-- =============================================================================

create extension if not exists pgcrypto;

-- -----------------------------------------------------------------------------
-- Catálogo tenant
-- -----------------------------------------------------------------------------
create table if not exists public.empresas (
  id uuid primary key default gen_random_uuid (),
  razon_social text not null,
  activo boolean not null default true,
  created_at timestamptz not null default now ()
);

create table if not exists public.sucursales (
  id uuid primary key default gen_random_uuid (),
  empresa_id uuid not null references public.empresas (id) on delete restrict,
  nombre text not null,
  activo boolean not null default true,
  created_at timestamptz not null default now ()
);

create index if not exists idx_sucursales_empresa on public.sucursales (empresa_id);

-- Suponiendo user_profiles ya existe (trigger auth):
alter table public.user_profiles
  add column if not exists empresa_id uuid references public.empresas (id);

alter table public.user_profiles
  add column if not exists sucursal_id uuid references public.sucursales (id);

-- -----------------------------------------------------------------------------
-- RLS
-- -----------------------------------------------------------------------------
alter table public.empresas enable row level security;
alter table public.sucursales enable row level security;

-- Funciones de sesión: deben coincidir con tu tabla real (profiles vs user_profiles).
-- Aquí asumimos helpers ya expuestos como current_empresa_id() y app_role().

drop policy if exists empresas_select_same on public.empresas;
create policy empresas_select_same on public.empresas
  for select
  using (id = public.current_empresa_id ());

drop policy if exists empresas_admin_all on public.empresas;
create policy empresas_admin_all on public.empresas
  for all
  using (public.app_role () = 'admin' and id = public.current_empresa_id ())
  with check (public.app_role () = 'admin' and id = public.current_empresa_id ());

drop policy if exists sucursales_select_tenant on public.sucursales;
create policy sucursales_select_tenant on public.sucursales
  for select
  using (empresa_id = public.current_empresa_id ());

drop policy if exists sucursales_admin_write on public.sucursales;
create policy sucursales_admin_write on public.sucursales
  for insert
  with check (public.app_role () = 'admin' and empresa_id = public.current_empresa_id ());

drop policy if exists sucursales_admin_update on public.sucursales;
create policy sucursales_admin_update on public.sucursales
  for update
  using (public.app_role () = 'admin' and empresa_id = public.current_empresa_id ())
  with check (public.app_role () = 'admin' and empresa_id = public.current_empresa_id ());

-- Notas:
-- 1) Ajustar políticas para encargado/empleado según docs/SECURITY_POLICIES.md
-- 2) Si current_empresa_id() lee otra tabla, unificar antes de aplicar
-- 3) En producción: grants a authenticated, índices, tests de WITH CHECK
