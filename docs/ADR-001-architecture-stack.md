# ADR-001 — Arquitectura y stack oficial (Monolito modular headless)

- **Estado**: Aceptado
- **Fecha**: 2026-04-15

## Contexto

Este repositorio implementa un **ERP + CRM transaccional** para operación real. El dominio exige:

- **Consistencia** (stock, compras, ventas, caja, estados).
- **Seguridad multi-tenant** (empresa/sucursal) con RBAC real.
- **Evolución incremental** sin destruir el producto cada 3 meses.
- Equipo pequeño: necesitamos **productividad**, no complejidad organizacional.

En la documentación histórica del repo hay señales contradictorias (cliente Android como “producto principal”, uso directo de Supabase desde el cliente, GraphQL, “una o más bases de datos”, offline-first “fase 5” vendido como si fuera trivial). Este ADR cierra esas ambigüedades y define una arquitectura única y ejecutable.

## Decisión

Adoptamos como arquitectura oficial:

- **Arquitectura general**: **monolito modular headless**.
- **Backend principal**: **FastAPI (Python 3.12+)** como API server.
- **Base de datos principal**: **PostgreSQL en Supabase** (fuente de verdad).
- **API**: **REST versionada** bajo **`/api/v1`** (pública e interna).
- **Frontends**: múltiples consumidores; el **primero es Web ERP**. Móvil queda **postergado** y limitado a casos concretos cuando tenga sentido.
- **Comunicación interna entre módulos**: **llamadas internas en Python** (no HTTP entre módulos).
- **Auth**: Supabase Auth emite JWT; FastAPI valida JWT (JWKS) y aplica claims/roles.
- **Autorización**: **RBAC** por roles de negocio (admin > encargado > empleado) + permisos por módulo/acción.

## Alcance del MVP

El MVP se define para poder ponerse en producción sin “prometer el futuro”:

### Entra al MVP (MVP = “primer uso real”)

- **Auth + perfiles + tenant**: empresa/sucursal, `profiles.app_role`, helpers de sesión.
- **Catálogos base**: productos + terceros (clientes/proveedores) mínimos para operar.
- **Inventario esencial**: existencias por sucursal/ubicación, movimientos básicos (recepción/ajuste/traslado simple).
- **Ventas básicas**: cotización/pedido/orden + reserva simple de stock + estados.
- **Compras básicas**: orden de compra + recepción.
- **Auditoría mínima**: `created_at/updated_at/created_by` donde aplique, log de eventos críticos (apéndice).
- **Frontend Web ERP**: UI para operación interna del negocio (back-office).

### Se aplaza explícitamente (NO MVP)

- **Contabilidad completa, RRHH, nómina**.
- **CRM “canales”** (WhatsApp, transcripción, inbox, audio).
- **Realtime** sofisticado.
- **Offline-first generalizado**.
- **Microservicios**.

## Arquitectura elegida

### Por qué NO microservicios (ahora)

- **Sobrecosto operativo**: despliegues múltiples, observabilidad distribuida, contratos entre servicios, colas, reintentos, backpressure, versionado interno.
- **Riesgo de incoherencia transaccional**: inventario/ventas/caja requieren transacciones y bloqueos coherentes; separar prematuramente fuerza consistencia eventual donde duele.
- **Equipo pequeño**: microservicios sin plataforma/DevOps fuerte es una fábrica de incidencias.

### Por qué SÍ monolito modular

- **Un solo deploy** y una sola trazabilidad (logs, métricas, errores).
- **Transacciones reales** cruzando límites cuando el negocio lo requiere (sin “sagas” prematuras).
- **Modularidad por dominio**: separación por paquetes y capas, evitando el “big ball of mud”.
- **Evolución**: si un módulo madura y requiere aislamiento, se extrae con evidencia (carga, límites claros, necesidad real).

## Estructura de módulos

Regla: **dominio primero**. Cada módulo contiene su propio API, dominio y persistencia (repositorios) y solo se integra con otros mediante interfaces.

Estructura sugerida:

```text
app/
  main.py
  core/
    config.py
    db.py
    security/
      jwt.py
      rbac.py
    errors.py
    logging.py
    observability.py
  modules/
    auth/
      api.py
      service.py
      models.py
    catalog/
      api.py
      domain.py
      repo.py
      schemas.py
    inventory/
      api.py
      domain.py
      repo.py
      schemas.py
      events.py
    sales/
      api.py
      domain.py
      repo.py
      schemas.py
      events.py
    purchases/
      api.py
      domain.py
      repo.py
      schemas.py
    crm/
      api.py
      domain.py
      repo.py
      schemas.py
    reports/
      api.py
      queries.py
      schemas.py
tests/
  unit/
  integration/
supabase/
  migrations/
  functions/
docs/
```

## Estrategia headless y frontends

- El backend (FastAPI) es el **único punto de entrada** para operaciones de negocio.
- El backend expone un contrato REST estable que soporta:
  - **Web ERP** (prioridad MVP).
  - POS/e-commerce futuros.
  - Móvil (si se decide) con casos acotados.

Esto evita:

- Reglas de negocio dispersas en múltiples clientes.
- Dependencia del UI para aplicar validaciones/consistencia.
- Acoplamiento caótico CRM↔ERP: ambos hablan con la **misma API**, y comparten dominio en el mismo proceso.

## Contrato de API

- Base path: **`/api/v1`**.
- Convenciones:
  - **Recursos**: plural, snake_case en query params, JSON camelCase o snake_case (elegir uno y mantenerlo; por defecto: snake_case en API para alineación con Postgres).
  - **Errores**: formato consistente (código interno, mensaje, detalles, request_id).
  - **Idempotencia**: endpoints críticos aceptan `Idempotency-Key` (ventas/compra/movimientos).
  - **Versionado**: `v1` no se rompe; cambios incompatibles van a `v2` con deprecación explícita.

## Autenticación y autorización

### Autenticación (Supabase Auth + JWT)

- Supabase Auth gestiona usuarios y emite JWT.
- FastAPI valida JWT contra **JWKS** de Supabase y extrae:
  - `sub` (user id).
  - `empresa_id` / `sucursal_id` (claims o resolución via DB).
  - `app_role` (desde `profiles`).

### Autorización (RBAC)

- RBAC por roles de negocio:
  - `admin`: todo.
  - `encargado`: operación y aprobaciones dentro de su sucursal/empresa.
  - `empleado`: operación limitada.
- La autorización se aplica:
  - **en el backend** (FastAPI) para UX y coherencia.
  - **en la BD** con **RLS** en tablas expuestas (defensa en profundidad).

## Persistencia y migraciones

- **PostgreSQL (Supabase)** es la única BD en MVP.
- **Fuente de verdad de schema**: `supabase/migrations/` (CLI).
- Reglas obligatorias:
  - Migraciones siempre versionadas; no cambios manuales en dashboard salvo emergencia documentada.
  - RLS habilitada en tablas expuestas; policies con convención `p_<tabla>_<accion>_<rol>`.
  - Helpers de sesión: `public.current_empresa_id()`, `public.current_sucursal_id()`, `public.app_role()`.

## Eventos internos y procesos asíncronos

### Eventos internos (in-process)

En MVP usamos un **event bus simple dentro del monolito**:

- Un “evento de dominio” es una clase/objeto en Python (p. ej. `StockAdjusted`, `OrderConfirmed`).
- Los handlers viven en el mismo proceso y se ejecutan **sin HTTP**.
- Objetivo: desacoplar reacciones internas sin meter infraestructura de mensajería.

### Asíncrono (jobs) sin introducir un sistema de colas externo

Para tareas que no deben bloquear la request (emails, generación de reportes, integraciones):

- Usamos una **tabla `jobs`/`outbox` en Postgres** + un **worker** (proceso Python) que consume con `SELECT ... FOR UPDATE SKIP LOCKED`.
- Ventajas: cero proveedores extra, transaccional, auditable, reintentos controlables.

**LISTEN/NOTIFY** queda como optimización posterior (reduce polling) cuando haya evidencia de necesidad.

## Estrategia de testing

Testing es obligatorio desde el inicio en lógica crítica:

- **Unit tests** (pytest): reglas de negocio (stock, reservas, estados, permisos).
- **Integration tests**: API + DB (migraciones aplicadas) validando flujos end-to-end del backend.
- **Contract tests**: esquemas de request/response para endpoints críticos de `/api/v1` para evitar rupturas de clientes.

“E2E UI” para web se añade cuando el frontend exista; no bloquea el backend MVP.

## Observabilidad y operación

Mínimo operativo desde MVP:

- **Logs estructurados** (JSON) con `request_id` y `user_id` cuando exista.
- **Health**: `/health` (liveness) y `/ready` (DB reachability).
- **Errores**: captura centralizada con stacktrace en entorno no-prod; en prod, mensajes sanitizados + `request_id`.

## CI/CD

Decisión concreta:

- **CI** en GitHub Actions:
  - Ejecutar tests Python (unit + integration).
  - Validar que `supabase/migrations/` aplica sobre Postgres limpio (schema check).
- **CD (DB y Edge Functions)**: workflow existente de Supabase (`supabase db push` / `supabase functions deploy`) al merge en `main`.
- **CD (FastAPI)**: despliegue de contenedor en **Render** desde `main` (auto-deploy) con variables de entorno en Render. (Si se necesita “infra como código”, se crea `render.yaml` en ADR posterior).

## Decisiones descartadas

- **GraphQL en MVP**: descartado. Añade complejidad de esquema/resolvers/cache sin beneficio inmediato para ERP transaccional.
- **Acceso directo del frontend a Supabase como forma principal de negocio**: descartado para MVP. Se evita negocio disperso en clientes y bypass de reglas en API.
- **Múltiples bases de datos** en MVP: descartado. Una sola BD transaccional.
- **Offline-first “general”** en MVP: descartado. Solo se re-evalúa con casos concretos y esfuerzo presupuestado.

## Consecuencias

- Todo feature nuevo debe ubicarse en un **módulo** claro (`catalog`, `inventory`, `sales`, etc.).
- Reglas transaccionales críticas viven en backend y/o Postgres, no en el frontend.
- El frontend web se construye contra `/api/v1` desde el día 1.

## Riesgos conocidos

- **RLS + RBAC doble capa**: si se diseña mal, puede generar inconsistencias (API permite, RLS niega). Mitigación: políticas simples + tests de autorización.
- **Worker con tabla jobs**: requiere disciplina (idempotencia, reintentos, dead-letter). Mitigación: estados explícitos y límites de reintento.
- **MVP demasiado grande**: ERP tiende a inflarse. Mitigación: módulos recortados y “no-MVP” explícito (arriba).

## Próximos ADR dependientes

- **ADR-002 — Estilo de persistencia en FastAPI** (SQLAlchemy/SQLModel vs SQL directo + repos; decisión única).
- **ADR-003 — Convenciones de API y errores** (snake_case/camelCase, códigos de error, idempotencia).
- **ADR-004 — Estrategia de despliegue FastAPI** (Render vs Fly.io vs ECS; infraestructura como código).
- **ADR-005 — Offline acotado** (qué casos, qué módulos, qué garantías; estrategia de conflictos real).

