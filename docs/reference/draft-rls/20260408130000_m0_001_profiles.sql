-- =============================================================================
-- M0 W07 — public.profiles + columnas de convención (schema-conventions.md)
-- Idempotente: compatible con migración borrador previa que ya creó profiles.
-- =============================================================================

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  empresa_id uuid not null,
  sucursal_id uuid,
  app_role text not null check (app_role in ('admin', 'encargado', 'empleado')),
  supervisor_id uuid references public.profiles (id),
  created_at timestamptz not null default now()
);

alter table public.profiles
  add column if not exists deleted_at timestamptz;

alter table public.profiles
  add column if not exists updated_at timestamptz not null default now();

alter table public.profiles
  add column if not exists sync_status text not null default 'SYNCED';

do $$
begin
  alter table public.profiles
    add constraint profiles_sync_status_check check (sync_status in ('SYNCED', 'PENDING', 'CONFLICT'));
exception
  when duplicate_object then null;
end $$;

create index if not exists idx_profiles_empresa on public.profiles (empresa_id);

alter table public.profiles enable row level security;

drop policy if exists p_profiles_select_own on public.profiles;
create policy p_profiles_select_own on public.profiles
  for select to authenticated
  using (id = auth.uid());

drop policy if exists p_profiles_update_own on public.profiles;
create policy p_profiles_update_own on public.profiles
  for update to authenticated
  using (id = auth.uid())
  with check (id = auth.uid());

drop policy if exists p_profiles_insert_own on public.profiles;
create policy p_profiles_insert_own on public.profiles
  for insert to authenticated
  with check (id = auth.uid());
