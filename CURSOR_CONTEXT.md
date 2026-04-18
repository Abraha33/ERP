# CURSOR CONTEXT — ERP/CRM (producción) — Fuente única de verdad

Este archivo define el contexto operativo del repo para desarrollo con Cursor/IA. Si hay contradicción con otro documento, **este archivo y el ADR-001 mandan**.

## Arquitectura oficial

- **Arquitectura**: **monolito modular headless**.
- **API**: REST versionada bajo **`/api/v1`**.
- **Backend principal**: **FastAPI (Python 3.12+)**.
- **DB principal**: **PostgreSQL en Supabase** (única BD en MVP).
- **Frontend prioritario (MVP)**: **Web ERP**.
- **Móvil**: postergado; solo entra por casos concretos con ADR propio.

Referencia: [ADR-001](./docs/adr/ADR-001-stack-tecnologico.md).

## Stack (decisiones cerradas)

- **Backend**: FastAPI + Pydantic; ejecución en contenedor (Docker) para dev/staging/prod.
- **DB**: Supabase Postgres + Supabase Auth; RLS en tablas expuestas.
- **Frontend Web**: **React + TypeScript + Vite** (ERP web). (No se negocia en MVP: el primer cliente es web.)
- **Testing**: `pytest` obligatorio en lógica crítica (unit + integration).
- **CI**: GitHub Actions (tests + verificación de migraciones).
- **CD**:
  - DB/Edge Functions: workflow Supabase en `main`.
  - Backend FastAPI: despliegue de contenedor en Render desde `main`.

## Auth, autorización y multi-tenant

- **Auth**: Supabase Auth emite JWT; FastAPI valida JWT (JWKS) y resuelve sesión.
- **Autorización**: RBAC por roles de negocio (admin > encargado > empleado) + permisos por módulo.
- **Tenant**: siempre filtrar por `empresa_id` / `sucursal_id`; **prohibido hardcodear UUIDs**.
- **Defensa en profundidad**: backend aplica RBAC + BD aplica RLS.

## Estructura de carpetas (objetivo)

Fuente: ADR-001. Estructura esperada para backend:

- `app/core/`: configuración, DB, seguridad, errores, logging.
- `app/modules/<dominio>/`: módulo por dominio (API, dominio, repos, schemas).
- `tests/unit/`, `tests/integration/`.
- `supabase/migrations/`: única fuente de verdad de DDL/RLS.
- `docs/`: ADRs y documentación operativa.

Frontend web (cuando se inicie):

- `apps/web/`: React + TS + Vite.

## Convenciones de nombres

- **Python**: paquetes en minúsculas; módulos en snake_case; clases en PascalCase.
- **API**:
  - path: `/api/v1/...`
  - recursos en plural.
- **SQL**:
  - tablas en snake_case plural,
  - policies RLS: `p_<tabla>_<accion>_<rol>`.

## Estrategia de errores (API)

- Respuesta de error consistente en JSON con:
  - `code` (interno),
  - `message` (humano),
  - `details` (opcional),
  - `request_id`.
- No filtrar stacktraces en prod.
- Logs estructurados incluyen `request_id` para trazabilidad.

## Arquitectura por módulos (reglas de acoplamiento)

- Un módulo no “llama por HTTP” a otro módulo del mismo monolito.
- Integración entre módulos:
  - por **interfaces** (servicios/repos) y eventos de dominio in-process,
  - no por imports cruzados arbitrarios.
- CRM es **módulo**, no “app aparte”. No se permiten duplicaciones de “clientes/ventas” en tablas paralelas.

## CI/CD (repositorio)

- `pull_request` y `push` en `main/develop`:
  - ejecutar tests,
  - validar migraciones aplican sobre Postgres limpio (schema check).
- `push` en `main` sobre `supabase/**`:
  - `supabase db push`,
  - `supabase functions deploy` (si aplica).

## Política de ramas

- Ramas permanentes: `main`, `develop`.
- Features: `feature/<issue>-<descripcion>`.
- Prohibido push directo a `main`.

## Offline (enfoque realista)

- Offline-first **no es requisito del MVP**.
- Si entra, entra **acotado a 1–2 flujos**, con ADR propio (conflictos, idempotencia, UX).
