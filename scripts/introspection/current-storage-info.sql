-- =============================================================================
-- Introspección: Storage (Supabase) — buckets y objetos agregados
-- Requiere esquema storage (proyecto Supabase).
-- =============================================================================

-- Buckets
select
  id,
  name,
  public,
  file_size_limit,
  allowed_mime_types,
  created_at,
  updated_at
from storage.buckets
order by name;

-- Políticas de storage (RLS sobre storage.objects)
select
  schemaname,
  tablename,
  policyname,
  cmd,
  roles,
  qual,
  with_check
from pg_policies
where schemaname = 'storage'
order by tablename, policyname;

-- Conteo de objetos por bucket (puede ser costoso en buckets grandes)
select
  bucket_id,
  count(*) as object_count,
  min(created_at) as first_created,
  max(created_at) as last_created
from storage.objects
group by bucket_id
order by bucket_id;
