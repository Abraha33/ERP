# Ciclo de un ticket (8 pasos) — ERP Satélite

> **Nota:** En este repo, `docs/WORKFLOW.md` documenta las **automatizaciones del GitHub Project**. Este archivo describe el **flujo de trabajo humano** de un ticket de punta a punta.

Los pasos están alineados con el **Status** del Project (**Icebox**, **Backlog**, **Ready**, **In progress**, **In review**, **Done**) y con el cierre vía PR en `erp-satelite`.

## 1. Entrada y claridad

- El issue tiene **ID en título** según [TICKET_ID_CONVENTION.md](./TICKET_ID_CONVENTION.md).
- Objetivo, alcance y **no-objetivos** son legibles; dependencias enlazadas.
- **Milestone** (F0–F5) y **talla** asignados si el tablero los usa (ver [ticket-taxonomy.md](./ticket-taxonomy.md)).

## 2. Refinamiento (Ready)

- Criterios de aceptación redactados; riesgos (RLS, migración, breaking changes) identificados.
- Si toca BD: esquema previsto y **compatibilidad** con `profiles` / `user_profiles` revisada ([open-questions.md](./open-questions.md)).

## 3. Rama y alcance técnico

- Rama según [git-branches.md](./git-branches.md) (`feature/…`, `db/…`).
- Un ticket → una **intención** de PR (evitar mezclar migración masiva + UI grande sin necesidad).

## 4. Implementación (In progress)

- Código y migraciones siguen [project.mdc](../.cursor/rules/project.mdc) (stack, RLS, convenciones).
- Políticas nuevas o cambiadas: contrastar con [SECURITY_POLICIES.md](./SECURITY_POLICIES.md).

## 5. Verificación local

- App: emulador/dispositivo **Android** (`apps/android/`); web solo si un ticket explícito lo pide (stack TBD).
- Supabase local o proyecto de staging: RLS probado con usuario real (no solo `service_role`).
- Sin errores relevantes en consola / logs.

## 6. Revisión (In review)

- PR con descripción que enlace al issue; diff revisable.
- Si hay SQL: script reproducible y orden de aplicación claro.

## 7. Prueba de cierre

- Aplicar plantilla de [docs/agents/testing-prompt.md](./agents/testing-prompt.md) o checklist del issue.
- Registrar evidencia breve en el PR o en el issue (qué rol, qué tabla, qué flujo).

## 8. Merge y tablero (Done)

- Merge a `develop` (o flujo acordado); issue cerrado o **Status → Done** según automatizaciones ([WORKFLOW.md](./WORKFLOW.md)).
- Actualizar [session-context.md](./session-context.md) si cambia el estado del esquema o decisiones activas.

---

## Referencias cruzadas

- DoD y estimación: [estimation-and-definition-of-done.md](./estimation-and-definition-of-done.md).
- Checklist diaria: [daily-checklist.md](./daily-checklist.md).
