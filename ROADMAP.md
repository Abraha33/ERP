# ERP SATELITE - ROADMAP 14 MESES

## SPRINT 1: FUNDACION (Semana 1-2)
| Ticket | Tarea | Tech | Horas | Prioridad |
|--------|-------|------|-------|-----------|
| T01 | Stack definido en README y ADR | Markdown, ADR | 2h | Alta |
| T02 | Repo y entorno local listos (solo ramas permanentes **main** + **develop**) | Git, Node, Python | 2h | Alta |
| T03 | Supabase + tablas base + RLS | PostgreSQL, Supabase | 3h | Alta |
| T04 | Scraper Python/Playwright vs SAE | Python 3.12, Playwright | 3h | Alta |
| T05 | Expo app en blanco (movil + web) | React Native, NativeWind | 2h | Alta |

## SPRINT 2: BACKEND BASE (Semana 3-4)
| Ticket | Tarea | Tech | Horas | Prioridad |
|--------|-------|------|-------|-----------|
| T06 | Auth + roles (admin/encargado/empleado) | Supabase Auth, JWT | 3h | Alta |
| T07 | RLS por rol y por tienda | PostgreSQL RLS | 3h | Alta |
| T08 | CRUD productos con sync offline | WatermelonDB, Supabase | 4h | Alta |
| T09 | CRUD tiendas y zonas | PostgreSQL | 2h | Alta |
| T10 | CRUD perfiles de usuario | Supabase Auth | 2h | Alta |

## SPRINT 3: APP SATELITE MOVIL (Semana 5-6)
| Ticket | Tarea | Tech | Horas | Prioridad |
|--------|-------|------|-------|-----------|
| T11 | Pantalla login con 3 roles | Expo, Supabase Auth | 3h | Alta |
| T12 | Catalogo de productos (movil) | React Native, NativeWind | 4h | Alta |
| T13 | Detalle de producto + stock | Expo, Supabase | 2h | Alta |
| T14 | Navegacion principal (tabs) | Expo Router | 2h | Alta |
| T15 | Modo offline basico | WatermelonDB | 3h | Alta |

## SPRINT 4: RECEPCION Y TRASLADOS (Semana 7-8)
| Ticket | Tarea | Tech | Horas | Prioridad |
|--------|-------|------|-------|-----------|
| T16 | Recepcion de mercancia | Expo, Supabase | 4h | Alta |
| T17 | Traslado entre zonas/tiendas | PostgreSQL triggers | 3h | Alta |
| T18 | Historial de movimientos | Supabase, JSONB | 3h | Alta |
| T19 | Ajuste de stock manual | Admin endpoint | 2h | Alta |
| T20 | Sync de movimientos offline | WatermelonDB | 3h | Alta |

## SPRINT 5: MISIONES Y ARQUEO MVP (Semana 9-10)
| Ticket | Tarea | Tech | Horas | Prioridad |
|--------|-------|------|-------|-----------|
| T21 | Asignacion de misiones al empleado | Supabase Realtime | 3h | Alta |
| T22 | Ejecucion de mision (checklist) | Expo, WatermelonDB | 4h | Alta |
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

## TECH STACK
| Capa | Tecnologia |
|------|-----------|
| App movil + web | React Native + Expo (mismo repo) |
| UI | NativeWind (Tailwind) |
| Offline | WatermelonDB |
| Backend/DB | Supabase (PostgreSQL, Auth, Storage, Realtime) |
| Scraper | Python 3.12 + Playwright |
| DevOps | Git + GitHub Actions |
| IA | Cursor AI |

## TIMELINE
- APP SATELITE MVP: Sprint 5 - Semana 10
- WEB OFICINA: Sprint 6 - Semana 12
- CRM COMPLETO: Sprint 7 - Semana 14
