# Vista por sprints — T01 a T35 (~14 semanas)

**Última revisión:** 2026-04-08 (cliente **Kotlin + Compose + Room**; Supabase + Realtime + RPC; SAE vía scripts Python).

Este archivo es la **descomposición en sprints** para el arranque. El **plan maestro por fases** (fundación, App Satélite, ERP básico, ERP completo, CRM, offline — 14 meses) está en **[ROADMAP.md](../../ROADMAP.md)** en la raíz del repo. Las Fases 3 y 5 del plan maestro no están desglosadas aquí.

**Cómo se relaciona con [ROADMAP.md](../../ROADMAP.md)**

| Bloque en este archivo | Fase del plan maestro |
|------------------------|------------------------|
| Sprint 1 | Fase 0 fundación + inicio Fase 1 |
| Sprints 2–5 | Fase 1 **App Satélite** (MVP campo) |
| Sprint 6 | Traslape Fase 1 (web) / inicio Fase 2 **ERP básico** |
| Sprint 7 | Adelanto **CRM**; alcance completo de Fase 4 en el plan maestro |

**Stack canónico:** [ADR-001](../adr/ADR-001-stack-tecnologico.md). Offline (**Room** + **WorkManager**) según ADR solo en **Fase 5** del producto; hasta entonces el cliente Android usa **`/api/v1`** (FastAPI) con red, salvo nueva decisión en ADR.

## SPRINT 1: FUNDACION (Semana 1-2)
| Ticket | Tarea | Tech | Horas | Prioridad | Estado (marzo 2026) |
|--------|-------|------|-------|-----------|---------------------|
| T01 | Stack definido en README y ADR | Markdown, ADR | 2h | Alta | **Hecho** |
| T02 | Repo y entorno local listos (solo ramas permanentes **main** + **develop**) | Git, Node 20, Python 3.12 | 2h | Alta | **Hecho** (repo + CI typecheck/compile) |
| T03 | Supabase + tablas base + RLS | PostgreSQL, Supabase | 3h | Alta | **Pendiente** (proyecto/claves: en progreso en checklist §16 README) |
| T04 | Integración SAE: scripts Python (CSV/XLS ↔ Supabase) + Playwright solo si hace falta UI | Python 3.12, Supabase API / Postgres, Playwright opcional | 3h | Alta | **En progreso** |
| T05 | App Android: Compose + módulo Gradle base | Kotlin, Jetpack Compose | 2h | Alta | **En progreso** (`apps/android/` placeholder; carpeta legado `apps/mobile` hasta retirada) |

## SPRINT 2: BACKEND BASE (Semana 3-4)
| Ticket | Tarea | Tech | Horas | Prioridad |
|--------|-------|------|-------|-----------|
| T06 | Auth + roles (admin/encargado/empleado) | Supabase Auth, JWT | 3h | Alta |
| T07 | RLS por rol y por tienda | PostgreSQL RLS | 3h | Alta |
| T08 | CRUD productos (online; sync local = Fase 5) | Supabase, Kotlin | 4h | Alta |
| T09 | CRUD tiendas y zonas | PostgreSQL | 2h | Alta |
| T10 | CRUD perfiles de usuario | Supabase Auth | 2h | Alta |

## SPRINT 3: APP SATELITE MOVIL (Semana 5-6)
| Ticket | Tarea | Tech | Horas | Prioridad |
|--------|-------|------|-------|-----------|
| T11 | Pantalla login con 3 roles | Compose, Supabase Auth | 3h | Alta |
| T12 | Catalogo de productos (movil) | Compose, Material 3 | 4h | Alta |
| T13 | Detalle de producto + stock | Compose, Supabase Kotlin | 2h | Alta |
| T14 | Navegacion principal (tabs) | Navigation Compose | 2h | Alta |
| T15 | Modo offline basico | Room + WorkManager (Fase 5 producto) | 3h | Alta |

## SPRINT 4: RECEPCION Y TRASLADOS (Semana 7-8)
| Ticket | Tarea | Tech | Horas | Prioridad |
|--------|-------|------|-------|-----------|
| T16 | Recepcion de mercancia | Compose, Supabase | 4h | Alta |
| T17 | Traslado entre zonas/tiendas | PostgreSQL triggers | 3h | Alta |
| T18 | Historial de movimientos | Supabase, JSONB | 3h | Alta |
| T19 | Ajuste de stock manual | Admin endpoint | 2h | Alta |
| T20 | Sync de movimientos offline | Room + WorkManager (Fase 5) | 3h | Alta |

## SPRINT 5: MISIONES Y ARQUEO MVP (Semana 9-10)
| Ticket | Tarea | Tech | Horas | Prioridad |
|--------|-------|------|-------|-----------|
| T21 | Asignacion de misiones al empleado | Supabase Realtime | 3h | Alta |
| T22 | Ejecucion de mision (checklist) | Compose, Supabase (offline = Fase 5 producto) | 4h | Alta |
| T23 | Arqueo de caja | Compose, Supabase | 3h | Alta |
| T24 | Dashboard encargado (resumen dia) | Compose, PostgREST | 4h | Alta |
| T25 | Notificaciones push basicas | FCM + WorkManager | 2h | Media |

## SPRINT 6: WEB OFICINA (Semana 11-12)
| Ticket | Tarea | Tech | Horas | Prioridad |
|--------|-------|------|-------|-----------|
| T26 | Panel web admin (login) | TBD (ADR futuro) o pantallas admin en app | 3h | Alta |
| T27 | Dashboard inventario global | PostgREST, Supabase | 4h | Alta |
| T28 | Gestion de usuarios desde web | Supabase Auth Admin | 3h | Media |
| T29 | Reportes exportables CSV | Python, Supabase | 3h | Media |
| T30 | Gestion de misiones desde web | TBD stack web + Realtime | 3h | Media |

## SPRINT 7: CRM BASICO (Semana 13-14)
| Ticket | Tarea | Tech | Horas | Prioridad |
|--------|-------|------|-------|-----------|
| T31 | Tabla clientes + CRUD | PostgreSQL, Supabase | 3h | Media |
| T32 | Historial de compras por cliente | JSONB, PostgREST | 3h | Media |
| T33 | Notas y seguimiento de clientes | Supabase | 2h | Media |
| T34 | Alertas stock minimo | Supabase Edge Functions | 3h | Media |
| T35 | Reporte mensual automatico | Python, Resend | 3h | Baja |

## TECH STACK (ADR-001 + revisión 2026-04-08, resumen)
| Capa | Tecnologia |
|------|-----------|
| App móvil | Kotlin + Jetpack Compose (`apps/android/`) |
| Persistencia local | Room (cache / Fase 5 offline) |
| Acceso datos (app) | Supabase Kotlin, RLS; operaciones multi-paso vía **RPC** |
| BaaS / DB | Supabase (PostgreSQL, Auth, RLS, Storage, **Realtime**, RPC, Edge Functions) |
| Tiempo real (ej. inventario / traslados) | Supabase **Realtime** |
| Integración SAE | **Scripts Python** en `scripts/sae/` (CSV/XLS ↔ Supabase) |
| UI legacy / scraper opcional | Python 3.12 + Playwright en `tools/scraper/` |
| Jobs pesados / HTTP persistente | FastAPI en `tools/worker/` — **opcional** |
| Offline (Fase 5 producto) | Room + WorkManager — ver [ROADMAP.md](../../ROADMAP.md) y [STACK_POR_FASE.md](../reference/STACK_POR_FASE.md) |
| CI / builds | GitHub Actions + Gradle (Android) |

## TIMELINE (relación con el plan maestro)
- **Fase 1 · App Satélite:** Sprints 2–5 de este archivo ≈ núcleo MVP campo (semanas ~3–10).
- **Fase 2 · ERP básico:** Sprint 6 aquí = primer bloque web/admin; meses 4–7 y módulos completos en [ROADMAP.md](../../ROADMAP.md).
- **Fase 4 · CRM:** Sprint 7 aquí = CRM básico; alcance completo en [ROADMAP.md](../../ROADMAP.md) § Fase 4.
- **Fase 3 · ERP completo** y **Fase 5 · offline:** ver [ROADMAP.md](../../ROADMAP.md) y [STACK_POR_FASE.md](../reference/STACK_POR_FASE.md).
