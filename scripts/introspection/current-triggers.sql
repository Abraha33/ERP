-- =============================================================================
-- Introspección: triggers user-defined en public y auth
-- =============================================================================

-- Triggers en esquema public
select
  trg.tgrelid::regclass as on_table,
  trg.tgname as trigger_name,
  pg_get_triggerdef(trg.oid, true) as trigger_definition
from pg_trigger trg
join pg_class tbl on tbl.oid = trg.tgrelid
join pg_namespace nsp on nsp.oid = tbl.relnamespace
where not trg.tgisinternal
  and nsp.nspname = 'public'
order by trg.tgrelid::regclass::text, trg.tgname;

-- Triggers en auth.users (p. ej. sync a user_profiles)
select
  trg.tgname as trigger_name,
  pg_get_triggerdef(trg.oid, true) as trigger_definition
from pg_trigger trg
join pg_class tbl on tbl.oid = trg.tgrelid
join pg_namespace nsp on n.oid = tbl.relnamespace
where not trg.tgisinternal
  and nsp.nspname = 'auth'
  and tbl.relname = 'users'
order by trg.tgname;

-- Funciones en public relacionadas con auth / perfiles / triggers (heurística)
select
  p.proname as function_name,
  pg_get_functiondef(p.oid) as definition
from pg_proc p
join pg_namespace n on n.oid = p.pronamespace
where n.nspname = 'public'
  and p.prokind = 'f'
  and (
    p.proname ilike '%auth%'
    or p.proname ilike '%profile%'
    or p.proname ilike '%handle%'
    or p.proname ilike '%current_%'
    or p.proname ilike '%app_role%'
  )
order by p.proname;
