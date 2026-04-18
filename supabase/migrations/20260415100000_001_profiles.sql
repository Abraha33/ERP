-- =============================================================================
-- W07 — 001_profiles (issues #276–#279)
-- Tabla public.profiles según docs/reference/schema-conventions.md (W04)
-- y .cursor/rules/project.mdc (RLS, roles admin|encargado|empleado, tenant).
--
-- Idempotente: puede aplicarse después de borradores previos; usa IF NOT EXISTS
-- y DROP POLICY IF EXISTS.
--
-- RLS (#279):
--   - rol anon: política explícita SELECT con USING (false) → 0 filas.
--   - rol authenticated: solo fila propia (id = auth.uid()).
-- service_role bypass RLS (Supabase) para operaciones administrativas.
-- =============================================================================

-- Supabase roles: ensure they exist for CI/vanilla Postgres compatibility
do $$
begin
  if not exists (select 1 from pg_roles where rolname = 'anon') then
    create role anon nologin noinherit;
  end if;
  if not exists (select 1 from pg_roles where rolname = 'authenticated') then
    create role authenticated nologin noinherit;
  end if;
  if not exists (select 1 from pg_roles where rolname = 'service_role') then
    create role service_role nologin noinherit bypassrls;
  end if;
end
$$;


create extension if not exists pgcrypto;

-- Función global de updated_at (compartida con otras tablas)
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
-- Tabla
-- -----------------------------------------------------------------------------
create table if not exists public.profiles (
  id uuid not null primary key references auth.users (id) on delete cascade,
  empresa_id uuid not null,
  sucursal_id uuid,
  app_role text not null,
  supervisor_id uuid references public.profiles (id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  sync_status text not null default 'SYNCED'
);

-- Si una migración anterior creó la tabla sin columnas W04, completar
alter table public.profiles
  add column if not exists updated_at timestamptz not null default now();

alter table public.profiles
  add column if not exists deleted_at timestamptz;

alter table public.profiles
  add column if not exists sync_status text not null default 'SYNCED';

-- Columnas faltantes (por migración previa que usó CREATE TABLE IF NOT EXISTS sin ALTER)
alter table public.profiles add column if not exists supervisor_id uuid references public.profiles (id);
alter table public.profiles add column if not exists full_name text;


-- Constraints (AFTER adding columns to avoid "column does not exist" errors)
-- Check app_role (project.mdc)
do $$
begin
  alter table public.profiles
    add constraint profiles_app_role_check check (app_role in ('admin', 'encargado', 'empleado'));
exception
  when duplicate_object then null;
end $$;

do $$
begin
  alter table public.profiles
    add constraint profiles_sync_status_check check (sync_status in ('SYNCED', 'PENDING', 'CONFLICT'));
exception
  when duplicate_object then null;
end $$;
-- Índices
create index if not exists idx_profiles_empresa on public.profiles (empresa_id);

create index if not exists idx_profiles_supervisor on public.profiles (supervisor_id);

-- Trigger updated_at
drop trigger if exists tr_profiles_updated_at on public.profiles;

create trigger tr_profiles_updated_at
  before update on public.profiles
  for each row
  execute function public.set_updated_at ();

comment on table public.profiles is 'Perfil de app: auth user ↔ empresa/sucursal y app_role (admin|encargado|empleado). Convenciones W04.';

-- -----------------------------------------------------------------------------
-- Helpers de sesión (otras tablas RLS dependen de profiles)
-- -----------------------------------------------------------------------------
create or replace function public.current_empresa_id ()
  returns uuid
  language sql
  stable
  security definer
  set search_path = public
  as $$
  select
    empresa_id
  from
    public.profiles
  where
    id = auth.uid ();
$$;

create or replace function public.current_sucursal_id ()
  returns uuid
  language sql
  stable
  security definer
  set search_path = public
  as $$
  select
    sucursal_id
  from
    public.profiles
  where
    id = auth.uid ();
$$;

create or replace function public.app_role ()
  returns text
  language sql
  stable
  security definer
  set search_path = public
  as $$
  select
    app_role
  from
    public.profiles
  where
    id = auth.uid ();
$$;

-- -----------------------------------------------------------------------------
-- RLS
-- -----------------------------------------------------------------------------
alter table public.profiles enable row level security;

-- #279 — anon: ninguna fila visible (explícito para auditoría / pruebas)
drop policy if exists p_profiles_select_anon on public.profiles;

create policy p_profiles_select_anon on public.profiles
  for select to anon
  using (false);

-- authenticated: solo propia fila; ignorar soft-deleted en lectura estándar
drop policy if exists p_profiles_select_own on public.profiles;

create policy p_profiles_select_own on public.profiles
  for select to authenticated
  using (
    id = auth.uid ()
    and deleted_at is null);

drop policy if exists p_profiles_update_own on public.profiles;

create policy p_profiles_update_own on public.profiles
  for update to authenticated
  using (id = auth.uid())
  with check (id = auth.uid());

drop policy if exists p_profiles_insert_own on public.profiles;

create policy p_profiles_insert_own on public.profiles
  for insert to authenticated
  with check (id = auth.uid());
