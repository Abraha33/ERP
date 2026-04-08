# Milestone M0 — Fase 0 · Workflow & Foundation

**Título:** Fase 0-Workflow & Foundation  
**Descripción:** Validar que el método de trabajo, stack documentado y estructura del repo están operativos antes de escribir código de producto.  
**Due date:** +1 semana desde la fecha de creación del hito en el tablero.

**Total estimado M0:** ~8.5h · **Bloquea:** todo S1 en adelante.

---

## W01 — Actualizar ADR-001 con stack real (Kotlin + Room)

**Talla:** S | **Horas:** 1.5h | **Prioridad:** Alta

**Tareas:**

- [ ] ADR-001 refleja Kotlin + Jetpack Compose + Room + WorkManager
- [ ] Eliminar referencias al stack móvil **JS legado** y a la **BD local JS de Fase 5** en docs activos (ver criterio de búsqueda abajo)
- [ ] ROADMAP_SPRINTS.md alineado con ADR-001
- [ ] CURSOR_CONTEXT.md actualizado

**Prueba de cierre:** Búsqueda de los **nombres propios del stack móvil anterior** (documentados en el checklist W01 del tablero / issue enlazado) no retorna hits en `docs/`, `README`, plantillas GitHub ni `.cursor/rules` salvo mención explícita “histórico/deprecado”.

---

## W02 — Estructura monorepo: apps/android/ + supabase/ + scripts/

**Talla:** S | **Horas:** 1h | **Prioridad:** Alta

**Tareas:**

- [ ] Crear `apps/android/` con `.gitkeep` o proyecto base Kotlin
- [ ] Confirmar `supabase/` con `migrations/` y `config.toml`
- [ ] Confirmar `scripts/` con estructura import/export SAE
- [ ] `worker/` con `.gitkeep` (opcional, documentado)

**Prueba de cierre:** `git ls-files` muestra las 4 carpetas raíz del monorepo.

---

## W03 — Commitear `.env.example` con variables canónicas

**Talla:** XS | **Horas:** 0.5h | **Prioridad:** Alta

**Tareas:**

- [ ] `.env.example` en raíz con las 14 variables del stack
- [ ] `.gitignore` incluye `.env` y `.env.local`
- [ ] README apunta a `.env.example`

**Prueba de cierre:** `.env.example` existe en `main`, `.env` no aparece en `git status`.

---

## W04 — schema-conventions.md: UUID, soft delete, sync_status, updated_at

**Talla:** S | **Horas:** 1h | **Prioridad:** Alta

**Tareas:**

- [ ] Crear `docs/reference/schema-conventions.md`
- [ ] Documentar: `UUID` `gen_random_uuid()`, `deleted_at`, `updated_at` trigger
- [ ] Documentar `sync_status`: `SYNCED` / `PENDING` / `CONFLICT`
- [ ] Ejemplo de tabla compliant (`productos`)

**Prueba de cierre:** Cursor puede leer el doc y aplicar las convenciones sin preguntar.

---

## W05 — Cursor rules operativas en flujo real

**Talla:** S | **Horas:** 1h | **Prioridad:** Alta

**Tareas:**

- [ ] Abrir Cursor en el repo y verificar que las 9 rules se cargan
- [ ] Ejecutar un prompt simple y confirmar que respeta las reglas
- [ ] Documentar cualquier rule que genere conflicto

**Prueba de cierre:** Cursor genera código Kotlin sin proponer React Native.

**Notas:** Ver `docs/process/cursor-rules-M0.md`.

---

## W06 — Workflow git end-to-end: feature → PR → develop

**Talla:** S | **Horas:** 0.5h | **Prioridad:** Alta

**Tareas:**

- [ ] Crear rama `feat/w06-git-test` desde `develop`
- [ ] Hacer cambio mínimo (ej. agregar línea en README)
- [ ] Abrir PR hacia `develop` con template correcto
- [ ] Merge y confirmar `develop` actualizado

**Prueba de cierre:** PR mergeado visible en GitHub, rama `feat` eliminada.

---

## W07 — Ticket de prueba real: migración mínima Supabase

**Talla:** M | **Horas:** 2h | **Prioridad:** Alta

**Sub-issues:**

- W07a: Crear migración `001_profiles` (archivo versionado en `supabase/migrations/`) con convenciones de W04
- W07b: Aplicar localmente con `supabase db push` (o `db reset` en dev)
- W07c: Verificar RLS mínima (admin puede leer, anon no)

**Prueba de cierre:** `supabase db diff` no muestra pendientes. Query con `anon_key` a `profiles` retorna 0 rows (RLS activa).

**Implementación en repo:** `supabase/migrations/20260408130000_m0_001_profiles.sql` (ajustar si choca con migraciones borrador previas).

---

## W08 — session-context.md + CURSOR_CONTEXT.md post-M0

**Talla:** XS | **Horas:** 0.5h | **Prioridad:** Alta

**Tareas:**

- [ ] `docs/session-context.md` refleja fase activa: M0 cerrado, S1 pendiente
- [ ] `CURSOR_CONTEXT.md` con stack correcto y último issue cerrado

**Prueba de cierre:** Al pegar `CURSOR_CONTEXT.md` en Cursor, el agente sabe en qué fase está sin preguntar.
