---
name: Base de datos / migraciones
about: DDL, RLS, índices, triggers, seeds estructurales
title: '[T01] '
labels: role/database
---

## Objetivo

## Cambios de esquema

Tablas / columnas / tipos / FKs (listar).

## RLS

Políticas nuevas o modificadas; alineación con docs/SECURITY_POLICIES.md.

## Migración

Nombre de archivo propuesto: `supabase/migrations/…`

## Impacto en perfiles

¿Toca `user_profiles`, `profiles`, `empresa_id`, `sucursal_id`?

## Rollback / datos

¿Requiere backfill? ¿Ventana de mantenimiento?

## Definition of Done

- [ ] Migración aplicable en DB limpia
- [ ] RLS probado (matriz rol × tabla)
- [ ] docs/session-context.md actualizado
