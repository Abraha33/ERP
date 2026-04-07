# Prompt / checklist — diagnóstico RLS y Supabase

Usar junto con los scripts en `scripts/introspection/*.sql` (ejecutar en **SQL Editor** del proyecto o `psql` con un rol que pueda leer catálogo).

## Checklist verbal (para pegar en el chat del agente)

1. Confirma qué tablas existen en `public` y si RLS está **enabled**.
2. Lista políticas de las tablas tocadas (`pg_policies`).
3. Verifica funciones `current_empresa_id`, `current_sucursal_id`, `app_role`: ¿leen `profiles` o `user_profiles`?
4. Comprueba que el usuario de prueba tiene fila de perfil con `empresa_id` (y `sucursal_id` si aplica).
5. Reproduce el fallo con el **mismo JWT** que usa la app (no service role).

## Queries rápidas (copiar al SQL Editor)

### ¿RLS activo?

```sql
select c.relname as table_name, c.relrowsecurity as rls_enabled
from pg_class c
join pg_namespace n on n.oid = c.relnamespace
where n.nspname = 'public' and c.relkind = 'r'
order by 1;
```

### Políticas de una tabla

```sql
select policyname, cmd, roles, qual, with_check
from pg_policies
where schemaname = 'public' and tablename = 'productos';
```

### Definición de funciones de sesión

```sql
select p.proname, pg_get_functiondef(p.oid)
from pg_proc p
join pg_namespace n on n.oid = p.pronamespace
where n.nspname = 'public'
  and p.proname in ('current_empresa_id', 'current_sucursal_id', 'app_role');
```

### Perfil del usuario actual (sesión Supabase)

```sql
select auth.uid() as uid;

select * from public.user_profiles where user_id = auth.uid() or id = auth.uid();
-- si usas profiles:
-- select * from public.profiles where id = auth.uid();
```

## Interpretación frecuente

- **`INSERT` rechazado con RLS:** revisar `WITH CHECK` y que `current_empresa_id()` no sea NULL.
- **NULL en funciones de sesión:** fila de perfil ausente o tabla/columna equivocada (`user_id` vs `id`).

Documentar hallazgos en el issue y actualizar `docs/session-context.md` si el esquema real diverge del repo.
