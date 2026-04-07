# Prompt de inicio de sesión — Cursor

Copia al abrir una sesión de trabajo en este monorepo (ajusta ramas y número de issue).

---

**Contexto:** Repo ERP Satélite — Expo + Supabase, RLS obligatorio en datos de negocio. Lee las reglas del proyecto en `.cursor/rules/project.mdc` y el estado en `docs/session-context.md`.

**Mi objetivo hoy:** [describir en 1–3 frases]

**Issue / ticket:** #[N] — título: [copiar]

**Rama:** `feature/...` o `db/...` (según `docs/git-branches.md`)

**Entorno Supabase:** [local CLI / proyecto staging / otro]

**Restricciones:**

- No introducir `service_role` en código de app.
- Cualquier SQL nuevo: migración versionada en `supabase/migrations/` y coherente con `docs/SECURITY_POLICIES.md`.
- Si toco perfiles: tener en cuenta `user_profiles` vs `profiles` (ver `docs/open-questions.md`).

**Entregable esperado:** [p. ej. PR con migración + pantalla X + prueba RLS descrita]

Sigue las convenciones del repo y minimiza el diff a lo necesario.

---

## Después de implementar

Pide revisión contra `docs/estimation-and-definition-of-done.md` y deja nota en el issue si queda deuda técnica.
