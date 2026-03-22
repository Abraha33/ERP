-- =============================================================================
-- SOLO CI / Postgres local — NO ejecutar en el proyecto Supabase en la nube.
-- Las migraciones en supabase/migrations/ asumen auth.users, auth.uid() y el
-- rol "authenticated" como en Supabase. Este archivo los simula en Postgres vanilla.
-- =============================================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE SCHEMA IF NOT EXISTS auth;

-- Tabla mínima para FK de public.profiles → auth.users(id)
CREATE TABLE IF NOT EXISTS auth.users (
  id uuid PRIMARY KEY
);

-- RLS policies llaman auth.uid(); en CI no hay JWT — devuelve NULL estable
CREATE OR REPLACE FUNCTION auth.uid ()
  RETURNS uuid
  LANGUAGE sql
  STABLE
  AS $$
  SELECT
    NULL::uuid;

$$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT
      1
    FROM
      pg_roles
    WHERE
      rolname = 'authenticated') THEN
    CREATE ROLE authenticated;
  END IF;
END
$$;
