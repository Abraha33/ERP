-- =============================================================================
-- Introspección: políticas RLS activas en public
-- =============================================================================

select
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
from pg_policies
where schemaname = 'public'
order by tablename, policyname;

-- Resumen: tablas con RLS on/off
select
  c.relname as table_name,
  c.relrowsecurity as rls_on,
  c.relforcerowsecurity as rls_forced
from pg_class c
join pg_namespace n on n.oid = c.relnamespace
where n.nspname = 'public'
  and c.relkind = 'r'
order by c.relname;
