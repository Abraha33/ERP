# Plantilla — pruebas de cierre de ticket

Copia en el cuerpo del PR o en un comentario del issue al terminar.

---

## Ticket

- **Issue:** #[N] — [título]
- **Rama:** [nombre]
- **Alcance:** [1 frase]

## Entorno

- **Supabase:** [URL proyecto o local]
- **Build app:** [Expo web / Android device / emulador]

## Casos probados

| # | Rol (app) | Acción | Tabla / pantalla | Resultado esperado | OK |
|---|-----------|--------|------------------|--------------------|----|
| 1 | empleado | | | | ☐ |
| 2 | encargado | | | | ☐ |
| 3 | admin | | | | ☐ |

## RLS

- [ ] Probado con **anon/authenticated** según flujo real (no solo service role).
- [ ] Usuario sin `empresa_id` en perfil: comportamiento documentado (error esperado / onboarding).

## Regresión

- [ ] Flujos colindantes: [listar]
- [ ] Sin errores nuevos en consola (web/Android).

## Deuda / seguimiento

- [ ] Ninguna — o enlazar issues: #…

**Evidencia:** capturas o logs pegados aquí (sin datos personales reales).

---

Ver ejemplo narrativo: [../examples/closing-test-example.md](../examples/closing-test-example.md).
