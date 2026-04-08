# Preguntas abiertas (sin decisión final)

> Lista viva. Cada ítem debería convertirse en issue o ADR al cerrarse.

## Modelo de datos / Supabase

1. **`profiles` vs `user_profiles`:** ¿Un solo nombre físico y migración de políticas, o mantener ambos con vista/sincronización?
2. **Tabla `empresas`:** ¿Campos mínimos (razón social, NIT, activo), multi-tenant estricto desde F1 o solo UUID de prueba hasta F2?
3. **Tabla `sucursales`:** ¿FK obligatoria en perfil desde el primer login operativo o nullable hasta onboarding completado?
4. **Trigger post-auth:** ¿Exigir `empresa_id` en `raw_user_meta_data` en todos los entornos o solo producción? (Ver [SUPABASE_AUTH_USER_PROFILES.md](./SUPABASE_AUTH_USER_PROFILES.md).)
5. **Jerarquía `supervisor_id`:** ¿Se usa en F1 para RLS o solo a partir de F2?

## Producto / integración

6. **Facturación electrónica** por país: ¿proveedor externo, módulo interno o fuera de alcance hasta F3?
7. **SAE:** ¿Fuente de verdad única en importación batch o bidireccional desde F2?

## App

8. **Web vs móvil primero:** ¿Misma prioridad en QA para cada ticket o etiqueta explícita `client/web` / `client/mobile`?

## Proceso

9. **Un solo workflow de auto-add** en GitHub Free: ¿Filtro `is:issue` global o solo asignados?

---

Al resolver una pregunta: enlazar el issue/PR aquí y mover el detalle a [session-context.md](./session-context.md) si afecta al esquema.
