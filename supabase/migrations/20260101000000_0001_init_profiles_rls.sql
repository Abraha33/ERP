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

-- Migración 0001: profiles, empresa, sucursal base + RLS
-- Aplicar con: supabase db push

create table if not exists public.empresas (
  id          uuid primary key default gen_random_uuid(),
  nombre      text not null,
  created_at  timestamptz not null default now()
);

create table if not exists public.sucursales (
  id          uuid primary key default gen_random_uuid(),
  empresa_id  uuid not null references public.empresas(id),
  nombre      text not null,
  created_at  timestamptz not null default now()
);

create table if not exists public.profiles (
  id            uuid primary key references auth.users(id) on delete cascade,
  empresa_id    uuid references public.empresas(id),
  sucursal_id   uuid references public.sucursales(id),
  app_role      text not null default 'empleado'
                check (app_role in ('admin','encargado','empleado')),
  full_name     text,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now()
);

-- Helpers de sesión
create or replace function public.current_empresa_id()
returns uuid language sql stable
as $$ select empresa_id from public.profiles where id = auth.uid() $$;

create or replace function public.current_sucursal_id()
returns uuid language sql stable
as $$ select sucursal_id from public.profiles where id = auth.uid() $$;

create or replace function public.app_role()
returns text language sql stable
as $$ select app_role from public.profiles where id = auth.uid() $$;

-- RLS
alter table public.profiles enable row level security;
alter table public.empresas enable row level security;
alter table public.sucursales enable row level security;

create policy p_profiles_select_own on public.profiles
  for select using (id = auth.uid());

create policy p_empresas_select_member on public.empresas
  for select using (id = public.current_empresa_id());

create policy p_sucursales_select_member on public.sucursales
  for select using (empresa_id = public.current_empresa_id());
