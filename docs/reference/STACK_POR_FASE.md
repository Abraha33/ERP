# Stack tecnológico por fase del producto

Este documento **descompone el stack por etapa** del roadmap (14 meses): qué tecnologías entran en juego en cada fase, qué se **añade** respecto a la anterior y qué queda **pendiente de decidir** fuera de [ADR-001](../../ADR/ADR-001-stack-tecnologico.md).

**Línea base aceptada** (ADR-001 + revisión **2026-04-08**; detalle en [CURSOR_CONTEXT.md](../../CURSOR_CONTEXT.md)):

- Cliente: **Kotlin** + **Jetpack Compose** (Android), persistencia local con **Room** cuando aplique; sync en background con **WorkManager** (Fase 5).
- Acceso a datos: **Supabase Kotlin** (`supabase-kt` u oficial equivalente) con **RLS**; sin capa API propia intermedia para el CRUD habitual.
- BaaS: **Supabase** (PostgreSQL del proyecto, Auth, Storage, RLS, **Realtime**, **RPC**, Edge Functions).
- **Tiempo casi real:** **Supabase Realtime** para escenarios como **inventario** y **traslados**.
- **Operaciones complejas y transaccionales:** **Supabase RPC** (SQL), p. ej. **abrir/cerrar turno de caja**.
- **Integración SAE:** **scripts Python** (CLI) en `scripts/sae/`: **CSV/XLS** ↔ Supabase; **Playwright** opcional en `tools/scraper/`.
- **Worker HTTP / jobs largos:** **FastAPI** (`tools/worker/`) y **Edge Functions** como opciones (ver ADR-001).
- Offline (Fase 5): **Room** (SQLite) + sync bidireccional y columna `sync_status` (ver [schema-conventions.md](./schema-conventions.md)).
- CI/CD: **GitHub Actions**; builds Android con Gradle cuando el módulo `apps/android/` esté inicializado.

Cambios de stack global → actualizar ADR-001 y este archivo en el mismo commit.

---

## Resumen visual

| Fase | Nombre (roadmap) | Enfoque técnico principal |
|------|------------------|---------------------------|
| **0** | Fundación | Repo, documentación, análisis Excel/SAE, sin producto en producción. |
| **1** | App Satélite MVP | App campo + Supabase + importación Excel + **scraper** Python. |
| **2** | ERP básico | Misma base + módulos web/MVP catálogos, compras, ventas, inventario. |
| **3** | ERP completo | Misma base + contabilidad, RRHH, reportes avanzados, auditoría fuerte. |
| **4** | CRM | Misma base + **WhatsApp / Meta**, workers, transcripción, pipeline comercial. |
| **5** | Offline-first | **Room** + **WorkManager**, sync bidireccional, conflictos, UX sin red. |

---

## Fase 0 — Fundación (semanas 1–2)

| Capa | Tecnologías | Notas |
|------|-------------|--------|
| Código / colaboración | Git, GitHub; solo ramas permanentes `main` / `develop` | Ver [README §3.2](../README.md#32-ramas-git-solo-main-y-develop). |
| Automatización tablero | `gh` CLI, scripts Python/PowerShell en `scripts/` | Project 11, workflows documentados. |
| Decisiones | Markdown, **ADR-001** | Stack global **aceptado**; variables en `.env.example`. |
| Datos fuente | Excel/CSV del SAE, documentación en `EXCEL_ANALYSIS` | Carga hacia Supabase vía **scripts Python** (no API propia obligatoria). |

**Estado fundación:** proyecto **Supabase**, **`.env` / entornos locales** (Android, `tools/worker/`) y **[EXCEL_ANALYSIS.md](../legacy/EXCEL_ANALYSIS.md)** — **en progreso**; ADR y `.env.example` en raíz.

**Nuevo respecto a “nada”:** solo tooling y documentación.

---

## Fase 1 — App Satélite MVP + scraper (meses 1–3)

Objetivo: operaciones de campo (recepción, traslados, conteos, arqueo) alimentadas por datos del SAE (Excel + scraper cuando aplique).

| Capa | Tecnologías | Notas |
|------|-------------|--------|
| **App móvil** | Kotlin, Jetpack Compose, Room (cache), Supabase Kotlin | Proyecto en `apps/android/`; emulador o dispositivo físico. |
| **Backend cloud + contrato de app** | Supabase (Postgres, Auth, RLS, Storage, **Realtime**, **RPC**) | Lectura/escritura desde la app con **SDK** y RLS; reglas transaccionales en **RPC** cuando el flujo lo requiera. |
| **Jobs / hosting extra** | **Edge Functions** (webhooks, tareas cortas); **FastAPI** solo si un job exige servidor Python persistente | Criterio en [ADR-001](../../ADR/ADR-001-stack-tecnologico.md). |
| **Scraper / UI legacy (opcional)** | Python 3.12, Playwright | `tools/scraper/`; solo cuando el SAE no entregue datos por archivo. |
| **Importación / exportación SAE** | **Scripts Python** (CSV/XLS ↔ Supabase por API o Postgres directo) | Sin obligación de exponer FastAPI para este flujo; alineado a T1.1.5–T1.1.6. |
| **Observabilidad mínima** | Logs Supabase, GitHub Actions (CI básico) | Tests smoke según madurez. |

**Nuevo respecto a Fase 0:** runtime de app, base de datos de producto, scraper, pipeline Excel.

---

## Fase 2 — ERP básico (meses 4–7)

Objetivo: sustituir **parcialmente** el SAE con catálogos, compras, ventas, inventario en tiempo casi real.

| Capa | Tecnologías | Notas |
|------|-------------|--------|
| Cliente | Misma app Android + eventual **cliente web** (Compose Multiplatform o stack web en ADR futuro) | Ampliar pantallas; decidir web en ADR si entra en alcance. |
| Datos | Supabase: más tablas, RLS por módulo, migraciones SQL versionadas, **Realtime/RPC** según módulo | `database/migrations/`, `database/policies/` (o `supabase/migrations/` según convención del repo). |
| Facturación / fiscal | **A definir por país** (ej. DIAN electrónica si aplica) | Puede ser integración externa, microservicio o proveedor; documentar en ADR cuando entre en alcance. |
| Reportes MVP | Export CSV/Excel, vistas SQL, gráficos ligeros en Compose (**Vico** u otra lib Kotlin — elegir en ticket) | Evitar BI pesado hasta Fase 3 si no es necesario. |
| Background | Edge Functions y/o **colas** ligeras (pg_cron, Supabase scheduled functions) | Para jobs de inventario, alertas stock. |

**Nuevo respecto a Fase 1:** módulos ERP amplios, posible librería de gráficos, integraciones fiscales (TBD).

---

## Fase 3 — ERP completo (meses 8–10)

Objetivo: cierre funcional vs SAE (contabilidad, RRHH, reportes gerenciales, auditoría).

| Capa | Tecnologías | Notas |
|------|-------------|--------|
| Lógica contable / RRHH | Postgres (funciones, vistas materializadas), capa dominio en **Kotlin** (app) o Edge Functions | Mantener reglas auditables en BD cuando sea posible. |
| Reportes avanzados | **Opción A:** Metabase / Superset **contra Postgres** (solo lectura) · **Opción B:** reportes en app + exports programados | Elegir según costo de hosting y complejidad. |
| Auditoría | Tablas de auditoría, triggers, `updated_by`, posible **event log** append-only | Sin imponer Event Sourcing completo salvo necesidad. |
| Seguridad | Revisión RLS, rotación de secretos, roles finos | Puede implicar **Supabase Auth** + claims personalizados. |

**Nuevo respecto a Fase 2:** motor contable/RRHH en profundidad, BI opcional, trazabilidad fuerte.

---

## Fase 4 — CRM (meses 11–12)

Objetivo: canal comercial (WhatsApp), casos, pipeline, historial cliente unificado sobre el ERP.

| Capa | Tecnologías | Notas |
|------|-------------|--------|
| Canales | **WhatsApp Cloud API** (Meta), webhooks HTTPS | Endpoints en Edge Functions o FastAPI según ADR. |
| Media / voz | Supabase Storage + API de transcripción (**OpenAI Whisper** u otro proveedor) | Encajar con política de datos personales. |
| Tiempo real | Supabase Realtime (opcional) para inbox / notificaciones | |
| Workers | Cola de trabajos: **Edge Functions + tabla de jobs** o worker Python/Node en CI/hosting | Para mensajes entrantes y jobs largos. |
| App | Misma app Android (+ web si se añade): bandeja conversaciones, CRM UI | Labels GitHub `role/crm`. |

**Nuevo respecto a Fase 3:** integración Meta, workers/async, posible proveedor IA para audio.

---

## Fase 5 — Offline-first (meses 13–14)

Objetivo: la app de campo **funciona sin internet** y sincroniza con el cloud sin perder datos.

| Capa | Tecnologías | Notas |
|------|-------------|--------|
| BD local | **Room** (SQLite) en Android | Modelos espejo de tablas críticas; columna `sync_status` (ver [schema-conventions.md](./schema-conventions.md)). |
| Sync | Pull/push incremental, **WorkManager**, **conflictos por `updated_at`** (u otra estrategia documentada) | Alineado a tickets T5.x de [ROADMAP.md](../../ROADMAP.md). |
| Red | **ConnectivityManager** / callbacks de red, cola de escrituras | UX: indicadores de estado de sync. |
| Backend | Sin cambio obligatorio de proveedor: Supabase sigue siendo fuente de verdad | Puede añadirse **compresión** o **delta sync** en API. |

**Nuevo respecto a Fase 4:** capa local completa, motor de sync y resolución de conflictos (no sustituir Postgres cloud).

---

## Cómo usar este documento

1. **Al planificar un sprint:** revisa la fase del milestone y limita nuevas dependencias a lo listado (o actualiza este doc + ADR).
2. **Al cerrar ADR-001:** copia la “decisión final” al README y marca aquí las celdas “A definir” con la opción elegida.
3. **Con Cursor / IA:** enlaza [CURSOR_CONTEXT.md](../../CURSOR_CONTEXT.md) + **esta página** para no mezclar tecnologías de fases futuras en código actual.

---

## Referencias

- [ROADMAP.md](../../ROADMAP.md) — plan maestro: fases 0–5 y tickets T0.x–T5.x.
- [ROADMAP_SPRINTS.md](../planning/ROADMAP_SPRINTS.md) — vista por sprints T01–T35 (arranque).
- [ADR-001](../../ADR/ADR-001-stack-tecnologico.md) — decisión única del stack base.
- [docs/Esqueleto.md](./Esqueleto.md) — alcance funcional por módulo.
