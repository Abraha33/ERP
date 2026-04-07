-- 03_triggers_user_profiles.sql
-- ---------------------------------------------------------------------------
-- Sincroniza auth.users -> public.user_profiles al crear usuarios.
-- Esquema objetivo (confirmado):
-- - user_profiles.user_id uuid NOT NULL
-- - rol_principal text NOT NULL
-- - activo boolean NOT NULL
-- - empresa_id / sucursal_id son nullable (FK a empresas/sucursales)
--
-- Regla:
-- - crea (o completa) fila base de perfil al alta en Auth
-- - no fuerza empresa/sucursal para no romper FK en creación temprana
-- ---------------------------------------------------------------------------

create or replace function public.handle_new_auth_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_nombre text;
begin
  v_nombre := coalesce(
    nullif(trim(new.raw_user_meta_data ->> 'nombre'), ''),
    nullif(trim(new.raw_user_meta_data ->> 'full_name'), ''),
    nullif(trim(new.raw_user_meta_data ->> 'name'), ''),
    nullif(split_part(coalesce(new.email, ''), '@', 1), ''),
    'Usuario'
  );

  -- Patrón update+insert para evitar depender de UNIQUE/PK en user_id.
  update public.user_profiles
     set nombre = coalesce(user_profiles.nombre, v_nombre),
         activo = coalesce(user_profiles.activo, true),
         rol_principal = coalesce(nullif(trim(user_profiles.rol_principal), ''), 'empleado'),
         updated_at = now()
   where user_id = new.id;

  if not found then
    insert into public.user_profiles (
      user_id,
      id,
      nombre,
      activo,
      rol_principal,
      created_at
    )
    values (
      new.id,
      new.id,
      v_nombre,
      true,
      'empleado',
      now()
    );
  end if;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;

create trigger on_auth_user_created
after insert on auth.users
for each row
execute function public.handle_new_auth_user();

