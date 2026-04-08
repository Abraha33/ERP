# Milestone M0 · Workflow & Foundation

**Título (GitHub):** `M0 · Workflow & Foundation`  
**Descripción:** Validar que el método de trabajo, stack documentado y estructura del repo están operativos antes de escribir código de producto.  
**Due date:** +1 semana desde la creación del hito en GitHub.

**Total estimado M0:** ~8,5 h · **Bloquea:** todo S1 en adelante.

**Issues en GitHub:** cuerpos en `docs/milestones/m0-issues/`. **Números (repo `Abraha33/ERP`, abril 2026):**

| Issue | # |
|-------|---|
| W01 | [#269](https://github.com/Abraha33/ERP/issues/269) |
| W02 | [#270](https://github.com/Abraha33/ERP/issues/270) |
| W03 | [#271](https://github.com/Abraha33/ERP/issues/271) |
| W04 | [#272](https://github.com/Abraha33/ERP/issues/272) |
| W05 | [#273](https://github.com/Abraha33/ERP/issues/273) |
| W06 | [#275](https://github.com/Abraha33/ERP/issues/275) |
| W07 | [#276](https://github.com/Abraha33/ERP/issues/276) |
| W07a | [#277](https://github.com/Abraha33/ERP/issues/277) |
| W07b | [#278](https://github.com/Abraha33/ERP/issues/278) |
| W07c | [#279](https://github.com/Abraha33/ERP/issues/279) |
| W08 | [#280](https://github.com/Abraha33/ERP/issues/280) |

---

## W01 — Actualizar ADR-001 con stack real (Kotlin + Room)

**Talla:** S | **Horas:** 1,5 h | **Prioridad:** Alta

**Tareas:**

- [ ] ADR-001 refleja Kotlin + Jetpack Compose + Room + WorkManager
- [ ] Eliminar referencias a Expo SDK y WatermelonDB en docs activos
- [ ] `docs/planning/ROADMAP_SPRINTS.md` alineado con ADR-001
- [ ] `CURSOR_CONTEXT.md` actualizado

**Prueba de cierre:** Búsqueda `WatermelonDB` y `Expo SDK` no retorna hits en docs activos (`docs/`, `README`, plantillas `.github`, `.cursor/rules`).

---

## W02 — Estructura monorepo: apps/android/ + supabase/ + scripts/

**Talla:** S | **Horas:** 1 h | **Prioridad:** Alta

**Tareas:**

- [ ] Crear `apps/android/` con `.gitkeep` o proyecto base Kotlin
- [ ] Confirmar `supabase/` con `migrations/` y `config.toml`
- [ ] Confirmar `scripts/` con estructura import/export SAE
- [ ] `worker/` con `.gitkeep` (opcional, documentado)

**Prueba de cierre:** `git ls-files` muestra las 4 carpetas raíz del monorepo (`apps/android/`, `supabase/`, `scripts/`, `worker/`).

---

## W03 — Commitear `.env.example` con variables canónicas

**Talla:** XS | **Horas:** 0,5 h | **Prioridad:** Alta

**Tareas:**

- [ ] `.env.example` en raíz con las 14 variables del stack (o el conjunto canónico acordado en ADR)
- [ ] `.gitignore` incluye `.env` y `.env.local`
- [ ] README apunta a `.env.example`

**Prueba de cierre:** `.env.example` existe en `main`, `.env` no aparece en `git status`.

---

## W04 — schema-conventions.md: UUID, soft delete, sync_status, updated_at

**Talla:** S | **Horas:** 1 h | **Prioridad:** Alta

**Tareas:**

- [ ] Crear `docs/reference/schema-conventions.md`
- [ ] Documentar: UUID `gen_random_uuid()`, `deleted_at`, trigger `updated_at`
- [ ] Documentar `sync_status`: `SYNCED` / `PENDING` / `CONFLICT`
- [ ] Ejemplo de tabla compliant (`productos`)

**Prueba de cierre:** Cursor puede leer el doc y aplicar las convenciones sin preguntar.

---

## W05 — Cursor rules operativas en flujo real

**Talla:** S | **Horas:** 1 h | **Prioridad:** Alta

**Tareas:**

- [ ] Abrir Cursor en el repo y verificar que las **9** rules `.mdc` se cargan (ver lista en `docs/process/cursor-rules-M0.md`)
- [ ] Ejecutar un prompt simple y confirmar que respeta las reglas
- [ ] Documentar cualquier rule que genere conflicto

**Prueba de cierre:** Cursor genera código Kotlin sin proponer React Native.

**Notas:** `docs/process/cursor-rules-M0.md`

---

## W06 — Workflow git end-to-end: feature → PR → develop

**Talla:** S | **Horas:** 0,5 h | **Prioridad:** Alta

**Tareas:**

- [ ] Crear rama `feat/w06-git-test` desde `develop`
- [ ] Cambio mínimo (ej. línea en README)
- [ ] Abrir PR hacia `develop` con plantilla correcta
- [ ] Merge y confirmar `develop` actualizado

**Prueba de cierre:** PR mergeado visible en GitHub, rama `feat` eliminada.

---

## W07 — Ticket de prueba real: migración mínima Supabase

**Talla:** M | **Horas:** 2 h | **Prioridad:** Alta

**Sub-issues (issues separados en GitHub):**

| ID | Contenido |
|----|-----------|
| **W07a** | Crear migración lógica `001_profiles` (archivo versionado en `supabase/migrations/` con prefijo de tiempo) siguiendo W04 |
| **W07b** | Aplicar localmente con `supabase db push` (o flujo local acordado) |
| **W07c** | Verificar RLS mínima (rol admin/servicio puede leer; **anon** no ve filas sin sesión válida) |

**Prueba de cierre:** `supabase db diff` sin pendientes. Query con `anon_key` a `public.profiles` → 0 filas (RLS activa).

**Referencia en repo:** `supabase/migrations/20260408130000_m0_001_profiles.sql` (revisar solape con migraciones previas).

---

## W08 — session-context.md + CURSOR_CONTEXT.md post-M0

**Talla:** XS | **Horas:** 0,5 h | **Prioridad:** Alta

**Tareas:**

- [ ] `docs/session-context.md` refleja fase activa: M0 cerrado, S1 pendiente
- [ ] `CURSOR_CONTEXT.md` con stack correcto y último issue cerrado

**Prueba de cierre:** Al pegar `CURSOR_CONTEXT.md` en Cursor, el agente sabe en qué fase está sin preguntar.
