# ROADMAP — Vista por sprints (primeras ~14 semanas)

**Última revisión:** 2026-03-22.

Este archivo **no** es el plan maestro del producto completo. El roadmap por **fases** (**Satélite → ERP básico → ERP completo → CRM → offline**, 14 **meses**) está en **[docs/ROADMAP_PRODUCTO_14_MESES.md](./docs/ROADMAP_PRODUCTO_14_MESES.md)**. Aquí hay una **descomposición en sprints T01–T35** pensada sobre todo para el arranque; Fases 3 y 5 del plan maestro no caben en estas siete filas.

**Cómo se relaciona con el plan maestro**

| Bloque en este archivo | Fase del plan maestro ([docs/ROADMAP_PRODUCTO_14_MESES.md](./docs/ROADMAP_PRODUCTO_14_MESES.md)) |
|------------------------|--------------------------------------------------------------------------------------------------|
| Sprint 1 | Fase 0 fundación + inicio Fase 1 |
| Sprints 2–5 | Fase 1 **App Satélite** (MVP campo) |
| Sprint 6 | Traslape Fase 1 (web) / inicio Fase 2 **ERP básico** |
| Sprint 7 | Adelanto **CRM**; el alcance completo de Fase 4 está en el roadmap maestro |

**Stack canónico:** [ADR-001](./ADR/ADR-001-stack-tecnologico.md). Offline (**WatermelonDB**) según ADR solo en **Fase 5** del producto; hasta entonces la app usa Supabase online salvo nueva decisión en ADR.

## SPRINT 1: FUNDACION (Semana 1-2)
| Ticket | Tarea | Tech | Horas | Prioridad | Estado (marzo 2026) |
|--------|-------|------|-------|-----------|---------------------|
| T01 | Stack definido en README y ADR | Markdown, ADR | 2h | Alta | **Hecho** |
| T02 | Repo y entorno local listos (solo ramas permanentes **main** + **develop**) | Git, Node 20, Python 3.12 | 2h | Alta | **Hecho** (repo + CI typecheck/compile) |
| T03 | Supabase + tablas base + RLS | PostgreSQL, Supabase | 3h | Alta | **Pendiente** (proyecto/claves: en progreso en checklist §16 README) |
| T04 | Scraper Python/Playwright vs SAE | Python 3.12, Playwright | 3h | Alta | **En progreso** (carpeta `scraper/` + stub; faltan flujos SAE) |
| T05 | App Expo (móvil + web): Router + NativeWind | Expo SDK 55+, TypeScript strict | 2h | Alta | **Hecho** (`apps/mobile`, plantilla tabs + NativeWind; `eas.json`) |

## SPRINT 2: BACKEND BASE (Semana 3-4)
| Ticket | Tarea | Tech | Horas | Prioridad |
|--------|-------|------|-------|-----------|
| T06 | Auth + roles (admin/encargado/empleado) | Supabase Auth, JWT | 3h | Alta |
| T07 | RLS por rol y por tienda | PostgreSQL RLS | 3h | Alta |
| T08 | CRUD productos (online; sync local = Fase 5) | Supabase, Expo | 4h | Alta |
| T09 | CRUD tiendas y zonas | PostgreSQL | 2h | Alta |
| T10 | CRUD perfiles de usuario | Supabase Auth | 2h | Alta |

## SPRINT 3: APP SATELITE MOVIL (Semana 5-6)
| Ticket | Tarea | Tech | Horas | Prioridad |
|--------|-------|------|-------|-----------|
| T11 | Pantalla login con 3 roles | Expo, Supabase Auth | 3h | Alta |
| T12 | Catalogo de productos (movil) | React Native, NativeWind | 4h | Alta |
| T13 | Detalle de producto + stock | Expo, Supabase | 2h | Alta |
| T14 | Navegacion principal (tabs) | Expo Router | 2h | Alta |
| T15 | Modo offline basico | WatermelonDB (Fase 5 producto) | 3h | Alta |

## SPRINT 4: RECEPCION Y TRASLADOS (Semana 7-8)
| Ticket | Tarea | Tech | Horas | Prioridad |
|--------|-------|------|-------|-----------|
| T16 | Recepcion de mercancia | Expo, Supabase | 4h | Alta |
| T17 | Traslado entre zonas/tiendas | PostgreSQL triggers | 3h | Alta |
| T18 | Historial de movimientos | Supabase, JSONB | 3h | Alta |
| T19 | Ajuste de stock manual | Admin endpoint | 2h | Alta |
| T20 | Sync de movimientos offline | WatermelonDB (Fase 5) | 3h | Alta |

## SPRINT 5: MISIONES Y ARQUEO MVP (Semana 9-10)
| Ticket | Tarea | Tech | Horas | Prioridad |
|--------|-------|------|-------|-----------|
| T21 | Asignacion de misiones al empleado | Supabase Realtime | 3h | Alta |
| T22 | Ejecucion de mision (checklist) | Expo, Supabase (offline = Fase 5 producto) | 4h | Alta |
| T23 | Arqueo de caja | Expo, Supabase | 3h | Alta |
| T24 | Dashboard encargado (resumen dia) | Expo Web, PostgREST | 4h | Alta |
| T25 | Notificaciones push basicas | Expo Notifications | 2h | Media |

## SPRINT 6: WEB OFICINA (Semana 11-12)
| Ticket | Tarea | Tech | Horas | Prioridad |
|--------|-------|------|-------|-----------|
| T26 | Panel web admin (login) | Expo Web, NativeWind | 3h | Alta |
| T27 | Dashboard inventario global | PostgREST, Supabase | 4h | Alta |
| T28 | Gestion de usuarios desde web | Supabase Auth Admin | 3h | Media |
| T29 | Reportes exportables CSV | Python, Supabase | 3h | Media |
| T30 | Gestion de misiones desde web | Expo Web, Realtime | 3h | Media |

## SPRINT 7: CRM BASICO (Semana 13-14)
| Ticket | Tarea | Tech | Horas | Prioridad |
|--------|-------|------|-------|-----------|
| T31 | Tabla clientes + CRUD | PostgreSQL, Supabase | 3h | Media |
| T32 | Historial de compras por cliente | JSONB, PostgREST | 3h | Media |
| T33 | Notas y seguimiento de clientes | Supabase | 2h | Media |
| T34 | Alertas stock minimo | Supabase Edge Functions | 3h | Media |
| T35 | Reporte mensual automatico | Python, Resend | 3h | Baja |

## TECH STACK (ADR-001, resumen)
| Capa | Tecnologia |
|------|-----------|
| App móvil + web | React Native + Expo SDK 51+ (`apps/mobile`), TypeScript strict, Expo Router |
| UI | NativeWind (Tailwind) |
| BaaS / DB | Supabase (PostgreSQL, Auth, RLS, Storage, Realtime, Edge Functions) |
| Jobs pesados | FastAPI (Python 3.12) en `worker/` |
| Scraper SAE | Python 3.12 + Playwright en `scraper/` |
| Offline (Fase 5 producto) | WatermelonDB — ver roadmap maestro y [STACK_POR_FASE.md](./docs/STACK_POR_FASE.md) |
| CI / builds | GitHub Actions + Expo EAS |

## TIMELINE (relación con el plan maestro)
- **Fase 1 · App Satélite:** Sprints 2–5 de este archivo ≈ núcleo MVP campo (semanas ~3–10).
- **Fase 2 · ERP básico:** Sprint 6 aquí = primer bloque web/admin; meses 4–7 y módulos completos en [docs/ROADMAP_PRODUCTO_14_MESES.md](./docs/ROADMAP_PRODUCTO_14_MESES.md) §Fase 2.
- **Fase 4 · CRM:** Sprint 7 aquí = CRM básico; alcance completo CRM en roadmap maestro §Fase 4 (meses 11–12).
- **Fase 3 · ERP completo** y **Fase 5 · offline:** ver [docs/ROADMAP_PRODUCTO_14_MESES.md](./docs/ROADMAP_PRODUCTO_14_MESES.md) y [STACK_POR_FASE.md](./docs/STACK_POR_FASE.md); no están desglosados en estas siete sprints.
