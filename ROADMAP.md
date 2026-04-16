# ROADMAP — ERP + CRM (8 fases)

Documento ejecutable alineado con **`docs/ADR-001-architecture-stack.md`**. Sin ambigüedad de stack: **FastAPI + Python 3.12**, **PostgreSQL Supabase**, **Alembic**, **Supabase Auth + JWT**, **RBAC**, **REST `/api/v1`**, **Next.js 15** (web), **Expo** (móvil Fase 6), eventos **LISTEN/NOTIFY**, **sin microservicios**.

## Alcance MVP vs post‑MVP

| Alcance | Fases | Definición |
|---------|-------|------------|
| **MVP (producto mínimo viable)** | **0–3** | Usuario real usando el sistema en cada hito: fundación → catálogo/inventario/web → ventas/compras → CRM/WhatsApp. |
| **Post‑MVP planificado** | **4–7** | Contabilidad, RRHH, app Expo, reportes avanzados y estabilización. |
| **Condicional** | **8** | Offline-first **solo** con **`docs/ADR-002-offline-strategy.md`** aprobado antes de código. |

---

## FASE 0 — Fundación

| Campo | Valor |
|-------|--------|
| **Período** | 2 semanas |
| **Stack** | GitHub, Python 3.12, FastAPI, Supabase (Postgres + Auth), Alembic, Render (objetivo de deploy), GitHub Actions |
| **Frontend** | Sin aplicación Next.js de producto: la web ERP empieza en Fase 1. Prueba de login solo contra API o página mínima de smoke si hace falta para validar JWT |
| **Hito** | Cualquier desarrollador clona el repo, copia `.env.example` → `.env`, levanta API y ve **`GET /health`** OK con DB; **ADR-001** cerrado en repo |

| ID | Tarea | Horas | Prioridad |
|----|-------|-------|-----------|
| T0.1 | Repo GitHub, ramas `main` / `develop`, plantilla PR | 2 | Alta |
| T0.2 | Estructura `app/`, `tests/`, `alembic/`, `docs/`, `.env.example` | 4 | Alta |
| T0.3 | Proyecto Supabase: Postgres + Auth, `DATABASE_URL` documentada | 3 | Alta |
| T0.4 | Alembic inicial + primera migración (metadatos / tabla smoke) | 4 | Alta |
| T0.5 | FastAPI `main.py`, `GET /health` con consulta real a DB | 4 | Alta |
| T0.6 | Integración Supabase Auth: login email/contraseña, JWT en cliente de prueba | 8 | Alta |
| T0.7 | Módulo `auth`: validación JWT + lectura rol RBAC mínimo | 8 | Alta |
| T0.8 | GitHub Actions: lint + `pytest` (aunque sea un test smoke) | 4 | Alta |
| T0.9 | **`docs/ADR-001-architecture-stack.md`** revisado y marcado Aceptado | 4 | Alta |
| T0.10 | Documentación: cómo levantar local y variables obligatorias | 2 | Media |

**Hito (usuario real):** el desarrollador (tú o un par) **usa el entorno local un día completo** sin bloqueos documentados.

---

## FASE 1 — Catálogos + Inventario + Web básica

| Campo | Valor |
|-------|--------|
| **Período** | 2 meses |
| **Stack backend** | FastAPI, SQLAlchemy, Alembic, pytest, LISTEN/NOTIFY (si aplica en esta fase solo para prueba) |
| **Stack frontend** | **Next.js 15** App Router, TypeScript, en `apps/web/` |
| **Módulos backend** | `auth`, `catalog`, `inventory` completos con tests en lógica crítica |
| **Hito** | **Primer usuario real del negocio** opera catálogo, stock y traslados desde la web |

| ID | Tarea | Horas | Prioridad |
|----|-------|-------|-----------|
| T1.1 | Modelos y migraciones: productos, ubicaciones, zonas, stock | 16 | Alta |
| T1.2 | `catalog`: CRUD productos, listas de precio mínimas, terceros | 24 | Alta |
| T1.3 | `inventory`: stock por ubicación, movimientos, traslados, reservas básicas | 32 | Alta |
| T1.4 | Tests: reserva de stock, traslado, reglas de cantidad | 16 | Alta |
| T1.5 | Next.js: login, sesión con JWT, layout autenticado | 20 | Alta |
| T1.6 | Next.js: catálogo de productos, formularios alta/edición | 24 | Alta |
| T1.7 | Next.js: inventario (consulta, movimiento, traslado entre zonas) | 28 | Alta |
| T1.8 | Panel de roles (asignación visual de rol por usuario en UI mínima) | 12 | Alta |
| T1.9 | Deploy Render: API + web; variables y secretos | 8 | Alta |

**Hito:** usuario real ejecuta **al menos una semana** de operación sin Excel paralelo para esas funciones.

---

## FASE 2 — Ventas + Compras

| Campo | Valor |
|-------|--------|
| **Período** | 3 meses |
| **Stack** | Mismo backend; Next.js para flujos OV/OC |
| **Módulos backend** | `sales`, `purchases` con tests |
| **Hito** | **Ciclo completo compra‑venta** en producción con datos reales |

| ID | Tarea | Horas | Prioridad |
|----|-------|-------|-----------|
| T2.1 | `purchases`: OC, estados, recepciones, devoluciones proveedor | 40 | Alta |
| T2.2 | `sales`: cotizaciones, OV, picking/packing básico, facturación básica | 48 | Alta |
| T2.3 | Integración stock: reservas al confirmar OV, liberación al cancelar | 24 | Alta |
| T2.4 | Tests: OC → recepción; OV → factura; idempotencia en confirmación | 24 | Alta |
| T2.5 | Next.js: flujos OC, recepción, cotización, OV, listados | 48 | Alta |
| T2.6 | Devoluciones cliente/proveedor en UI mínima viable | 20 | Media |
| T2.7 | Workers: NOTificación post‑venta/compra si aplica (LISTEN/NOTIFY) | 12 | Media |

**Hito:** usuario real cierra **mes contable operativo** con compras y ventas entrando solo por el sistema.

---

## FASE 3 — CRM + WhatsApp

| Campo | Valor |
|-------|--------|
| **Período** | 2 meses |
| **Stack** | `crm` + WhatsApp Cloud API; worker para Whisper; LISTEN/NOTIFY |
| **Módulos backend** | `crm` completo con tests |
| **Hito** | **Equipo comercial** gestiona clientes y conversaciones **en producción** |

| ID | Tarea | Horas | Prioridad |
|----|-------|-------|-----------|
| T3.1 | Webhook WhatsApp, validación Meta, almacenamiento mensajes | 20 | Alta |
| T3.2 | Inbox, casos, pipeline de ventas, historial por cliente | 32 | Alta |
| T3.3 | Worker: transcripción audio (Whisper), `NOTIFY` a CRM | 24 | Alta |
| T3.4 | Pedido desde chat → `sales` vía **servicios Python** (no HTTP interno) | 24 | Alta |
| T3.5 | Next.js: bandeja CRM, pipeline, ficha cliente | 32 | Alta |
| T3.6 | Tests: creación de caso, vinculación a cliente, reglas de acceso RBAC | 16 | Alta |

**Hito:** al menos **un vendedor real** usa CRM diario una semana.

---

## FASE 4 — Contabilidad (post‑MVP)

| Campo | Valor |
|-------|--------|
| **Período** | 2 meses |
| **Stack** | Módulo `accounting`; asientos automáticos desde ventas/compras |
| **Frontend** | Next.js: plan de cuentas, libro, estados financieros |
| **Hito** | Contabilidad **generada automáticamente** desde operaciones; primer cierre revisado con contador |

| ID | Tarea | Horas | Prioridad |
|----|-------|-------|-----------|
| T4.1 | Plan de cuentas, asientos manuales/automáticos | 40 | Alta |
| T4.2 | P&L, balance, flujo de caja | 32 | Alta |
| T4.3 | Caja/tesorería, conciliación básica | 24 | Alta |
| T4.4 | Impuestos/retenciones según normativa local (parametrizable) | 32 | Alta |
| T4.5 | Tests: asiento desde OV/OC; cuadre de balance | 24 | Alta |
| T4.6 | Next.js: reportes contables y exportaciones | 24 | Alta |

**Hito:** **usuario real (contador o responsable)** valida números contra expectativa del negocio.

---

## FASE 5 — RRHH + Nómina (post‑MVP)

| Campo | Valor |
|-------|--------|
| **Período** | 2 meses |
| **Stack** | Módulo `hr` |
| **Frontend** | Next.js: empleados, ausencias, nómina |
| **Hito** | **Primer ciclo de nómina** pagado desde el sistema |

| ID | Tarea | Horas | Prioridad |
|----|-------|-------|-----------|
| T5.1 | Maestro empleados, organigrama básico | 16 | Alta |
| T5.2 | Turnos, horas, ausencias, vacaciones, incapacidades | 32 | Alta |
| T5.3 | Cálculo nómina: base, deducciones, bonos, horas extra | 40 | Alta |
| T5.4 | Archivos banco / exportación pagos | 16 | Alta |
| T5.5 | Tests: cálculo nómina casos borde | 24 | Alta |
| T5.6 | Next.js: flujos RRHH y aprobaciones | 24 | Alta |

**Hito:** **empleados reales** reciben pago trazable desde el sistema.

---

## FASE 6 — App móvil Expo (post‑MVP)

| Campo | Valor |
|-------|--------|
| **Período** | 2 meses |
| **Stack** | **Expo** + React Native + TypeScript; consumo **`/api/v1`** |
| **Frontend** | App Expo en `apps/mobile/` o `apps/expo/` (definir carpeta al iniciar) |
| **Hito** | **Empleados de campo** operan desde el teléfono sin papel |

| ID | Tarea | Horas | Prioridad |
|----|-------|-------|-----------|
| T6.1 | Proyecto Expo, auth JWT compartido con Supabase | 16 | Alta |
| T6.2 | Pantallas: traslados, arqueo de caja, recepciones | 32 | Alta |
| T6.3 | Misiones de conteo, consulta stock | 24 | Alta |
| T6.4 | Manejo de errores red, UX offline degradado (sin sync completo) | 16 | Media |
| T6.5 | Tests E2E móviles mínimos o contrato API | 16 | Media |

**Hito:** al menos **dos usuarios de campo** usan la app en producción una semana.

---

## FASE 7 — Reportes avanzados + Pulido + Producción estable (post‑MVP)

| Campo | Valor |
|-------|--------|
| **Período** | 2 meses |
| **Stack** | `reports` (solo lectura), workers maduros, índices PostgreSQL |
| **Frontend** | Next.js: dashboards, KPIs, export Excel/PDF |
| **Hito** | Sistema **estable** sin intervención manual diaria en deploy |

| ID | Tarea | Horas | Prioridad |
|----|-------|-------|-----------|
| T7.1 | `reports`: KPIs por área, exports | 32 | Alta |
| T7.2 | Optimización queries: índices, EXPLAIN, paginación | 24 | Alta |
| T7.3 | Workers: notificaciones email/push, reportes pesados | 24 | Alta |
| T7.4 | Observabilidad: logs estructurados, alertas | 16 | Alta |
| T7.5 | Runbook operación (backup, rollback, incidentes) | 12 | Alta |

**Hito:** **dueño o gerente** usa dashboards semanalmente para decisiones.

---

## FASE 8 — Offline-first (condicional)

| Campo | Valor |
|-------|--------|
| **Período** | 3+ meses |
| **Prerequisito** | **`docs/ADR-002-offline-strategy.md` aprobado**. Sin ADR, **cero código** de sync offline. |
| **Stack candidato** | SQLite en cliente Expo + sincronización con PostgreSQL vía cola; detalle solo en ADR-002 |
| **Hito** | App **funciona sin conexión** en el alcance definido por ADR-002 y **sincroniza sin pérdida ni duplicación** al recuperar red |

| ID | Tarea | Horas | Prioridad |
|----|-------|-------|-----------|
| T8.1 | Redactar y aprobar **ADR-002** | 16 | Alta |
| T8.2 | Implementar scope ADR (lectura primero; escritura después si ADR lo permite) | 120+ | Alta |
| T8.3 | Pruebas de conflictos y regresión | 40 | Alta |

**Advertencia:** sincronización bidireccional con resolución de conflictos es de las tareas más difíciles del proyecto. Subestimarla es el fallo típico.

---

## Fuera del MVP pero en roadmap

| Capacidad | Fase |
|-----------|------|
| Contabilidad completa | 4 |
| RRHH y nómina | 5 |
| App Expo | 6 |
| Reportes gerenciales avanzados | 7 |
| Offline-first | 8 |

---

## Reglas que no se negocian

- **Microservicios**: no.  
- **HTTP entre módulos del monolito**: no.  
- **GraphQL**: no en roadmap.  
- **Offline-first antes de Fase 8**: no.  
- **Múltiples BD en MVP**: no.
