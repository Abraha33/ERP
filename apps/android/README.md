# apps/android — App Android (Fase 5)

> **Estado:** scaffold reservado — aún no inicializado.

Este directorio contendrá la app Android del ERP (campo: recepción, traslados, conteos, arqueo), construida con **Kotlin + Jetpack Compose**.

## Stack planeado

| Capa | Tecnología |
|------|-----------|
| Lenguaje | Kotlin 1.9+ |
| UI | Jetpack Compose |
| BD local | Room (SQLite) — Fase 5 offline-first |
| Sync | WorkManager + `sync_status` column |
| Red | Retrofit / Ktor → `/api/v1` (FastAPI) |
| Auth | Supabase Auth (`supabase-kt`) |
| Build | Gradle (Kotlin DSL) |

## Inicialización (cuando entre en scope — Fase 5)

1. Abrir Android Studio → "New Project" → "Empty Compose Activity"
2. Apuntar al directorio `apps/android/`
3. Configurar `local.properties` con SDK path (no commitear)
4. Añadir dependencias Supabase en `build.gradle.kts`

## Referencias

- [ADR-001](../../docs/adr/ADR-001-stack-tecnologico.md) — decisiones de stack global
- [ROADMAP.md](../../ROADMAP.md) — Fase 5 tickets T5.x
- [STACK_POR_FASE.md](../../docs/reference/STACK_POR_FASE.md) — Fase 5 offline-first
