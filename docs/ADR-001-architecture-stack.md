# ADR-001 — Arquitectura y stack (ERP + CRM, producción)

## Estado

**Aceptado**

## Fecha

2026-04-16

## Contexto

Se construye un **ERP + CRM transaccional** para un negocio real, con un solo desarrollador. La decisión debe ser **única, ejecutable y coherente**: sin bifurcaciones que obliguen a reescribir el núcleo cada trimestre. Este ADR fija arquitectura, stack, módulos, contratos y fases para que cualquier sesión de trabajo (humana o asistida) sepa **qué está permitido** y **qué está prohibido**.

## Decisión

- **Arquitectura**: **monolito modular headless** (un proceso de aplicación backend, una base de datos transaccional principal).
- **Backend**: **FastAPI**, **Python 3.12**.
- **Base de datos**: **PostgreSQL** hospedado en **Supabase** (instancia única en MVP).
- **Migraciones de esquema**: **Alembic** (`alembic/`), ejecutadas contra la misma `DATABASE_URL` de Supabase.
- **API**: **REST** versionada bajo **`/api/v1`**. **GraphQL** no está en el roadmap.
- **Autenticación**: **Supabase Auth** (email/contraseña u otros proveedores soportados por Supabase) → **JWT** validado por el backend.
- **Autorización**: **RBAC** por roles de negocio (`admin` > `encargado` > `empleado`), con permisos por módulo y acción; detalle de claims/tablas en implementación, alineado a `profiles` y tenant (`empresa_id`, `sucursal_id`).
- **Comunicación entre módulos del monolito**: **solo llamadas internas en Python** (servicios/repos). **Prohibido** HTTP interno entre módulos.
- **Eventos internos (MVP)**: **PostgreSQL `LISTEN` / `NOTIFY`** para señalización entre el proceso API y los workers del mismo despliegue. **Sin Redis ni colas externas** en MVP.
- **Frontend web (primero)**: **Next.js 15** (App Router) — ERP web.
- **Frontend móvil (Fase 6)**: **Expo** + **React Native** (mismo contrato `/api/v1`, mismos JWT). **No** Android Studio nativo como stack de producto.
- **Construcción**: **modular desde el día 1**; regla operativa: **un módulo completo y usable en producción antes de abrir el siguiente** dentro del plan de fase.
- **Testing**: **pytest** obligatorio desde **Fase 1** en lógica crítica (stock, OV, OC, reglas de dominio).
- **CI/CD**: **GitHub Actions**. **Deploy**: **Render** (servicio web FastAPI + servicio web Next.js; workers como proceso separado en el mismo proveedor). *Railway queda descartado en este ADR para no duplicar plataformas.*
- **Offline-first**: **no** forma parte del MVP. Se retoma en **Fase 8** con **`docs/ADR-002-offline-strategy.md`** (redacción obligatoria antes de código).
- **Microservicios**: **no** mientras el equipo sea una sola persona.

### Cierres explícitos (lectura rápida para IA y humanos)

- **Por qué NO microservicios**: el dominio ERP es transaccional; distribuir el monolito antes de tiempo multiplica fallos de red, transacciones rotas y coste operativo. Con una persona, el riesgo supera cualquier beneficio teórico de escala.

- **Por qué NO Android Studio nativo y SÍ Expo**: un solo lenguaje de frontend (**TypeScript**), un solo contrato **REST**, un solo flujo de CI; nativo duplicaría stack, build y conocimiento sin aportar ventaja en Fase 6 para el alcance definido.

- **Por qué NO “primero completo, luego modular”**: un ERP sin módulos desde el día 1 converge a código imposible de testear; “modularizar después” es reescritura pagada dos veces.

- **Por qué offline-first es Fase 8 y no antes**: el sync bidireccional con conflictos exige invariantes de dominio estables; el núcleo debe estar en producción antes de añadir otro sistema de consistencia (el cliente offline).

- **Consistencia transaccional en el monolito**: las transacciones ACID abarcan las tablas necesarias en una sola unidad; los servicios de `sales` / `inventory` / `accounting` coordinan en **una** transacción de base de datos cuando el caso de uso lo exige.

- **Comunicación interna**: módulos se llaman por **interfaces Python** (`service` → `service` / `repository`), nunca por HTTP loopback.

- **Contabilidad y RRHH en el mismo monolito sin romper límites**: `accounting` y `hr` son **paquetes** con sus tablas y servicios; los asientos generados por ventas/compras/nómina se invocan desde **servicios** del módulo origen o desde facades internas, sin duplicar tablas maestras ni exponer “API interna” HTTP.

## Estructura de módulos (árbol de carpetas definitivo)

```text
app/
├── main.py
├── core/
│   ├── config.py
│   ├── db.py
│   ├── security/
│   │   ├── jwt.py
│   │   └── rbac.py
│   ├── middleware.py
│   └── errors.py
├── modules/
│   ├── auth/
│   ├── catalog/
│   ├── inventory/
│   ├── sales/
│   ├── purchases/
│   ├── accounting/
│   ├── hr/
│   ├── crm/
│   ├── reports/
│   └── workers/
tests/
├── unit/
└── integration/
alembic/
docs/
│   ├── ADR-001-architecture-stack.md
│   └── ADR-002-offline-strategy.md   # Fase 8; no escribir antes
```

Cada módulo bajo `app/modules/<nombre>/` incluye obligatoriamente:

- `router.py` — rutas HTTP, dependencias, validación de entrada/salida con Pydantic.
- `service.py` — reglas de negocio; **no** conoce HTTP.
- `repository.py` — SQLAlchemy / SQL; **sin** reglas de negocio.
- `schemas.py` — modelos Pydantic de request/response (camelCase en JSON hacia fuera).
- `models.py` — modelos SQLAlchemy (tablas).

El **`router` no ejecuta queries**. El **`repository` no decide políticas de negocio**. El **`service` orquesta** transacciones y llama a otros servicios en Python si hace falta.

## Patrón de capas internas (responsabilidades exactas)

| Capa | Responsabilidad | Prohibido |
|------|-----------------|-----------|
| `router.py` | Mapear HTTP ↔ DTOs, status codes, deps de auth | Lógica de negocio, queries directas |
| `service.py` | Reglas, invariantes, orquestación, transacciones | Detalles HTTP, SQL crudo si se evita el repo |
| `repository.py` | Persistencia, queries, mapeo ORM | Reglas de negocio |
| `schemas.py` | Contratos de datos | Acceso a BD |
| `models.py` | Esquema relacional | Lógica de negocio |

## Estrategia headless y frontends

- **Headless**: toda lógica y persistencia transaccional viven en **FastAPI**. Los frontends son **consumidores** de `/api/v1`.
- **Orden**: **Next.js primero** porque concentra el valor de back-office, permisos, maestros y operación diaria; permite validar el modelo de datos y RBAC antes de meter complejidad de campo.
- **Expo segundo (Fase 6)** porque reutiliza la **misma API** y JWT; las pantallas móviles son vistas del mismo dominio, no un segundo backend.
- **Sin duplicar lógica**: validaciones duras (stock, estados, totales, impuestos) solo en **backend**. Los clientes solo UX y formato.

## Contrato de API

- **Base path**: `/api/v1`.
- **Recursos**: nombres en **plural** (`/api/v1/products`, `/api/v1/stock-movements`).
- **Query params**: **snake_case** (`page_size`, `sort_by`, `cursor`).
- **JSON de cuerpo y respuesta (salvo errores estándar)**: **camelCase** en propiedades (`orderId`, `lineItems`).
- **Paginación**: por defecto **cursor** (`cursor` + `limit`, máximo 100 salvo contrato explícito). `limit`/`offset` solo donde el volumen esté acotado por negocio (p. ej. catálogos pequeños en admin).
- **Errores** (cuerpo JSON consistente):

```json
{
  "error": "STOCK_INSUFFICIENT",
  "detail": "Cantidad solicitada supera stock disponible en la ubicación."
}
```

Códigos HTTP: uso estándar (`200`, `201`, `400`, `404`, `409`, `422`, `500`). El campo `error` es un **código estable** para i18n y logs; `detail` es mensaje humano.

- **Versionado**: **`/api/v2`** solo ante **cambios incompatibles** en contrato. `v1` se mantiene estable o se depreca con ventana anunciada.

## Autenticación y autorización

- **Supabase Auth** emite JWT. El backend valida firma (JWKS de Supabase), expiración y audiencia.
- **RBAC**: roles de negocio en `profiles` (o equivalente); permisos por recurso/acción evaluados en `service` + políticas centralizadas en `core/security/rbac.py`.
- **Multi-tenant**: toda lectura/escritura filtrada por `empresa_id` / `sucursal_id` según sesión. **Prohibido** hardcodear UUIDs de tenant en código.

## Persistencia y migraciones

- **Una sola BD** en MVP: PostgreSQL (Supabase).
- **Alembic** es la **única fuente de verdad** del esquema gestionado por la app (`alembic/versions/`).
- **Consistencia transaccional**: operaciones que deben ser atómicas (p. ej. confirmar OV + movimiento de stock + asiento futuro) se ejecutan en **una transacción** en el `service`, con bloqueos a nivel fila donde el dominio lo exija (`SELECT … FOR UPDATE` vía repository).

## Eventos internos: LISTEN / NOTIFY (MVP)

- Tras commits relevantes, el dominio puede emitir `NOTIFY canal`, con payload JSON mínimo (p. ej. tipo de evento + id de agregado).
- Los **workers** (`app/modules/workers/`) mantienen conexiones long‑lived `LISTEN` y reaccionan (transcripción, envío de email, regeneración de reporte). **No** se usa HTTP entre API y worker del mismo monolito para estos eventos.
- **Sin Redis ni SQS en MVP**: si el volumen de `NOTIFY` satura, se mide en producción y solo entonces se propone ADR de cola externa.

## Workers y tareas asíncronas

Van en **`app/modules/workers/`** (y procesos desplegados como **worker** separado en Render, mismo repo):

- Transcripción (Whisper u otro proveedor), notificaciones, facturación electrónica, reportes pesados, alertas de stock derivadas de eventos.
- Tareas **largas o con APIs externas** no bloquean el request HTTP: el request persiste estado y emite `NOTIFY` o marca job en tabla si hiciera falta complemento; la regla de producto es **LISTEN/NOTIFY primero**, tabla de jobs solo si un flujo requiere reintento explícito persistente.

## Testing

- **pytest** para unit e integration.
- **Fixtures transaccionales**: cada test de integración abre transacción, ejecuta caso, **hace rollback** al final; **no** truncar esquema completo en cada test salvo suite aislada de migración.
- **Obligatorio** cuando exista el código correspondiente: pruebas de **reserva de stock**, **creación y transición de OV**, **OC y recepción**, **asientos** (Fase 4), **cálculo de nómina** (Fase 5). Sin tests en estas áreas, el cambio no se considera listo.

## CI/CD (pipeline mínimo viable)

1. **Lint** (Python: ruff o equivalente; TS: eslint en `apps/web` cuando exista).
2. **Test** (`pytest`).
3. **Deploy** a **Render** en rama `main` (API + Next + worker) con variables de entorno configuradas en el panel.

`develop` integra el trabajo diario; `main` solo recibe merge desde `develop` al cerrar una fase o hito estable acordado.

## Decisiones descartadas y por qué

| Decisión descartada | Razón |
|---------------------|--------|
| **Microservicios** | Coste operativo y de consistencia transaccional inaceptable para una persona; el cuello de botella hoy es producto, no “escala horizontal”. |
| **Android Studio / Kotlin nativo** | Duplica stack y despliegue; **Expo** comparte TypeScript con Next.js y consume la misma API. |
| **“Primero completo, luego modular”** | En ERP es la vía segura al “big ball of mud”; modularidad tarde es reescritura. |
| **GraphQL** | Complejidad de contrato y caching sin beneficio claro para transacciones ERP en esta etapa. |
| **Múltiples bases de datos en MVP** | Particionar datos antes de tener volumen medido es deuda sin retorno. |
| **Redis / colas externas en MVP** | Añaden infraestructura y fallos que no se justifican hasta tener métricas de carga. |

**Offline-first** no está descartado; está **pospuesto**. La razón es técnica: sincronización bidireccional con resolución de conflictos es uno de los problemas más complejos en ingeniería de software. Construirlo antes de que el core ERP esté estable en producción sería construir sobre arena. Se retoma en **Fase 8** con **ADR-002** dedicado. Alcance inicial propuesto: lectura offline primero, escritura después. No iniciar sin ese ADR aprobado.

## Módulos post-MVP planificados (por fase)

| Módulo | Fase (roadmap) |
|--------|----------------|
| `accounting` | 4 |
| `hr` | 5 |
| App móvil Expo (consume API; no es módulo backend aparte) | 6 |
| `reports` (avanzado) | 7 |
| Offline-first (cliente + estrategia sync) | 8 (`ADR-002`) |

El **MVP** de producto incluye **Fases 0–3** (fundación, catálogo+inventario+web, ventas+compras, CRM+WhatsApp) con usuario real en cada hito.

## Consecuencias

- **Positivas**: un despliegue, trazabilidad simple, transacciones reales, un solo lugar para reglas de negocio, frontends delgados.
- **Negativas**: el monolito crece; exige disciplina de módulos y revisiones de fronteras. El uso de `LISTEN/NOTIFY` requiere cuidado con reconexiones y workers (healthchecks).

## Riesgos conocidos

- **Saturación de NOTIFY** o pérdida de eventos si el worker está caído: mitigar con supervisión de proceso y, si hace falta, tabla de compensación (segunda iteración, no MVP inicial).
- **RLS en Supabase** si se expone PostgREST además del backend: políticas alineadas con RBAC o desactivar acceso directo cliente a tablas sensibles.
- **Alcance ERP completo**: subestimar nómina o contabilidad genera retrabajo; las fases 4–5 tienen hitos de “primer ciclo real” antes de abrir la siguiente.

## Próximos ADR

- **`docs/ADR-002-offline-strategy.md`**: obligatorio antes de cualquier código de Fase 8.
