# ROADMAP — ERP + CRM (arquitectura oficial, MVP ejecutable)

Este roadmap es para **producción real** con equipo pequeño. No es un listado de deseos: cada fase tiene entregables verificables y un frontend prioritario.

**Arquitectura oficial (cerrada):** ver [ADR-001](./docs/ADR-001-architecture-stack.md).

## Resumen de fases (14 meses)

| Fase | Enfoque | Período | Frontend prioritario | Hito |
|------|---------|---------|----------------------|------|
| **0** | Fundación (repo, DB, auth, convención, CI) | Semana 1–2 | N/A | Base lista para construir el backend |
| **1** | **MVP Web ERP** (FastAPI + API v1 + módulos base) | Mes 1–4 | **Web ERP** | Primer uso real interno |
| **2** | ERP básico ampliado (compras/ventas/inventario “bien”) | Mes 5–8 | **Web ERP** | SAE parcialmente reemplazado |
| **3** | CRM núcleo (sin canales externos complejos) | Mes 9–10 | **Web ERP** | Gestión comercial básica |
| **4** | Operación y escalado (reportes, auditoría, performance) | Mes 11–12 | **Web ERP** | Estabilidad y control |
| **5** | Offline acotado / móvil (solo si hay caso de negocio) | Mes 13–14 | **Móvil (si aplica)** | Alcance offline definido y real |

> Nota dura: **offline-first generalizado** y “app móvil completa” NO son una fase automática. Entra solo si hay un caso de negocio claro y presupuesto de complejidad (conflictos, UX, soporte).

---

## FASE 0: FUNDACIÓN (Semana 1–2)

Objetivo: dejar listo el terreno para construir **FastAPI + API v1** sin decisiones “pendientes” que bloqueen el MVP.

### Entregables mínimos (no negociables)

- **ADR-001 aceptado** y referenciado como fuente de verdad.
- **Supabase**:
  - proyecto creado,
  - `supabase/migrations/` como única fuente de verdad,
  - helpers de sesión y RLS base.
- **CI**:
  - checks en PR (tests + migraciones aplican en Postgres limpio).
- **Convenciones de módulos**:
  - estructura `app/core` + `app/modules/*` definida (aunque esté vacía).
- **Contexto del repo**:
  - `CURSOR_CONTEXT.md` sin “por definir”.

---

## FASE 1: MVP WEB ERP (Mes 1–4)

Objetivo: **primer uso real interno** con backend consistente y una UI web mínima pero usable.

### Entregables mínimos (arquitectura + producto)

- **Backend FastAPI**:
  - `/api/v1` operativo con auth JWT (Supabase) + RBAC,
  - módulos: `auth`, `catalog`, `inventory`, `sales`, `purchases` (mínimo viable),
  - errores normalizados + `request_id`,
  - tests en lógica crítica.
- **DB**:
  - migraciones para tablas MVP + RLS,
  - seed mínimo para dev/staging.
- **Frontend Web ERP**:
  - login,
  - catálogos (listado + alta/edición mínima),
  - inventario básico (consulta + movimiento simple),
  - ventas y compras básicas (crear + listar + cambiar estado).

### Fuera de Fase 1 (aunque “suene útil”)

- CRM canales, transcripción, WhatsApp.
- Offline generalizado.
- App móvil completa.

---

---

## FASE 2: ERP BÁSICO AMPLIADO (Mes 5–8)

Objetivo: que compras/ventas/inventario sean **confiables** (no “demo”) y empiecen a reemplazar procesos del SAE.

- Catálogos: completar campos que afectan operación (UM, listas de precio mínimas, impuestos si aplica).
- Compras: OC → recepción con validaciones e idempotencia.
- Ventas: cotización → pedido/OV; reserva de stock; estados y trazabilidad.
- Inventario: movimientos auditables; ajustes con autorización; reportes básicos de stock.

Entregables arquitectónicos:

- Repos por módulo, límites claros (no “helpers” compartidos que mezclan dominios).
- Tabla `jobs/outbox` (si ya hay procesos async).
- Endpoints críticos con `Idempotency-Key`.

---

## FASE 3: CRM NÚCLEO (Mes 9–10)

Objetivo: CRM como **módulo** (no producto paralelo) sin canales externos caros.

- Pipeline simple (lead/oportunidad/estado).
- Historial por cliente (derivado de ventas y casos).
- Casos/tickets internos.

Regla: CRM consume el **mismo dominio** y tablas maestras; no crea “copias” caóticas de clientes/ventas.

---

## FASE 4: OPERACIÓN Y ESCALADO (Mes 11–12)

Objetivo: estabilidad, auditoría, rendimiento y operación diaria (lo que evita incendios en producción).

- Auditoría “de verdad” en operaciones críticas (movimientos, aprobaciones).
- Observabilidad mínima (logs estructurados, métricas básicas si aplica).
- Reportes operativos: stock, ventas, compras (sin BI enterprise).
- Endurecer RLS y pruebas de autorización.

---

## FASE 5: OFFLINE ACOTADO / MÓVIL (Mes 13–14)

Objetivo: resolver **un caso concreto** donde offline produce valor (p. ej. recepción en bodega sin señal), no “hacer todo offline”.

Alcance permitido:

- Solo **uno o dos flujos** críticos definidos (no el ERP completo).
- Sin prometer “no hay conflictos”: habrá conflictos y se diseña UX para resolverlos.

Entregables mínimos (si esta fase se ejecuta):

- ADR específico de offline (qué módulos, qué garantías, estrategia de conflictos).
- Sync incremental con idempotencia y trazabilidad.
- Pruebas de resiliencia (reintentos, reconexión, duplicados).
