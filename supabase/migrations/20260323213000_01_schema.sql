-- 01_schema.sql (base estructural)
-- ---------------------------------------------------------------------------
-- Convención del proyecto:
--   01_schema.sql                  -> tablas, tipos, índices
--   03_triggers_user_profiles.sql  -> funciones/triggers
--   seeds/02_seed_dev.sql          -> datos de desarrollo (solo local)
--
-- Este archivo es el punto de entrada para el esquema base cuando inicies un
-- entorno nuevo. Mantén aquí DDL puro (CREATE/ALTER de estructura).
--
-- Nota:
-- - El proyecto ya tiene migraciones previas en esta carpeta.
-- - Si incorporas ese contenido aquí, hazlo de forma incremental y sin
--   eliminar el historial existente.
-- ---------------------------------------------------------------------------

-- Ejemplo mínimo de extensión común:
create extension if not exists pgcrypto;

-- TODO: mover/normalizar DDL base de tablas y tipos aquí.

