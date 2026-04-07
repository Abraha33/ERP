-- =============================================================================
-- Introspección: esquema public (tablas, columnas, PK, FK)
-- Ejecutar en SQL Editor (Supabase) o psql contra la base del proyecto.
-- =============================================================================

-- Tablas user-defined en public
select
  c.oid::regclass as table_name,
  c.relrowsecurity as rls_enabled,
  c.relforcerowsecurity as rls_force
from pg_class c
join pg_namespace n on n.oid = c.relnamespace
where n.nspname = 'public'
  and c.relkind = 'r'
  and not c.relispartition
order by c.relname;

-- Columnas (tipos, nullability, defaults)
select
  table_name,
  ordinal_position,
  column_name,
  data_type,
  udt_name,
  is_nullable,
  column_default
from information_schema.columns
where table_schema = 'public'
order by table_name, ordinal_position;

-- Claves primarias
select
  tc.table_name,
  kcu.column_name,
  tc.constraint_name
from information_schema.table_constraints tc
join information_schema.key_column_usage kcu
  on tc.constraint_name = kcu.constraint_name
  and tc.table_schema = kcu.table_schema
where tc.table_schema = 'public'
  and tc.constraint_type = 'primary key'
order by tc.table_name, kcu.ordinal_position;

-- Foreign keys (referencias salientes)
select
  tc.table_name as from_table,
  kcu.column_name as from_column,
  ccu.table_name as to_table,
  ccu.column_name as to_column,
  tc.constraint_name
from information_schema.table_constraints tc
join information_schema.key_column_usage kcu
  on tc.constraint_name = kcu.constraint_name
  and tc.table_schema = kcu.table_schema
join information_schema.constraint_column_usage ccu
  on ccu.constraint_name = tc.constraint_name
  and ccu.table_schema = tc.table_schema
where tc.table_schema = 'public'
  and tc.constraint_type = 'foreign key'
order by tc.table_name, kcu.ordinal_position;
