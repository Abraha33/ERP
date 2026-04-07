# Ejemplo de issue completo — ERP Satélite

> Ilustrativo; los IDs y rutas son ficticios excepto donde coinciden con convenciones del repo.

---

**Título:** `[T14] Alta de sucursales con RLS por empresa`

## Objetivo

Permitir que un **admin** cree y liste sucursales de su empresa; **encargado** y **empleado** solo lectura de sucursales asignadas en su perfil.

## Contexto

- Hoy `user_profiles.sucursal_id` es nullable; no existe tabla `sucursales` en producción.
- Políticas futuras de OC/traslados asumen `sucursal_id` válido.

## Criterios de aceptación

1. Tabla `public.sucursales` con `id`, `empresa_id`, `nombre`, `activo`, `created_at`.
2. FK desde `user_profiles.sucursal_id` → `sucursales(id)` (o decisión explícita de aplazar FK).
3. RLS: SELECT según rol (`SECURITY_POLICIES` alineado).
4. Pantalla mínima en app o seed SQL documentado para demo local.

## Fuera de alcance

- Reasignación masiva de usuarios entre sucursales.
- Soft-delete y auditoría completa.

## Dependencias

- Bloqueado por: decisión en [open-questions.md](../open-questions.md) sobre tabla `empresas`.
- Relacionado: #123 (modelo empresa).

## Tech

- Migración: `supabase/migrations/YYYYMMDDHHMMSS_sucursales.sql`
- App: `app/(app)/settings/sucursales.tsx` (ruta orientativa, ver [modules.md](../modules.md))

## Horas estimadas

**M** (ver [estimation-and-definition-of-done.md](../estimation-and-definition-of-done.md))

## Checklist

- [ ] Migración aplicada en local desde cero
- [ ] RLS probado (admin / encargado / empleado)
- [ ] `session-context.md` actualizado

## Definition of Done

Ver [estimation-and-definition-of-done.md](../estimation-and-definition-of-done.md) — incluye Android + web si hay UI.

---

**Labels sugeridos:** `role/database`, `role/frontend`, `priority/P2`, `module/catalogo`  
**Milestone:** F2 · ERP básico (ejemplo)
