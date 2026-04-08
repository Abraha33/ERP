# Estimación y Definition of Done (DoD)

## Definition of Done (genérico ERP Satélite)

Un ticket se considera **hecho** cuando:

1. **Funcionalidad:** Cumple los criterios de aceptación del issue sin regresiones obvias en el flujo tocado.
2. **Cliente:** Probado en **Android** y en **web** (`expo start --web`) si el cambio afecta UI o navegación compartida.
3. **Datos:** Si hay lectura/escritura a Supabase, **RLS verificado** con usuario de prueba (rol `empleado` / `encargado` / `admin` según el caso), no solo con `service_role`.
4. **Calidad:** Sin errores nuevos relevantes en consola; TypeScript sin errores en el paquete afectado.
5. **Repositorio:** PR revisado y mergeado a la rama acordada (`develop`); issue enlazado.
6. **Documentación:** Si cambia esquema, políticas o convenciones, actualizar `docs/session-context.md` o doc técnica enlazada en el mismo PR.
7. **Seguridad:** Sin secretos en código; variables solo vía entorno.

Ajustes por ticket (performance, i18n, analytics) se añaden en el issue como checklist explícito.

## Tabla de calibración (talla ↔ horas)

Valores orientativos para retrospectiva; ajustar trimestralmente según velocidad real del equipo.

| Talla | Horas típicas (1 dev) | Comentario |
|-------|------------------------|------------|
| XS | 0,5–2 h | Typos, copy, un flag, policy mínima |
| S | 2–6 h | Pantalla pequeña, migración trivial |
| M | 1–2 días | Feature vertical delgada |
| L | 3–5 días | Varios módulos o RLS complejo |
| XL | > 5 días | Debe dividirse antes de comprometerse |

## Errores comunes que invalidan el “Done”

- Políticas que usan `current_empresa_id()` pero la fila del usuario está solo en `user_profiles` y las funciones leen `profiles`.
- Migración aplicada solo en local sin nota de despliegue.
- Cerrar el issue sin merge o sin alinear **Status** del Project ([ticket-workflow.md](./ticket-workflow.md)).

## Referencias

- Plantilla issue: `.github/ISSUE_TEMPLATE/ticket.md`.
- Pruebas de cierre: [examples/closing-test-example.md](./examples/closing-test-example.md).
