# CURSOR CONTEXT — ERP Satélite

**Estado actual del proyecto (editar al inicio de cada sesión)**

| Campo | Valor |
|-------|--------|
| **Fase activa** | [EDITAR] |
| **Sprint activo** | [EDITAR] |
| **Último issue completado** | [EDITAR] |
| **Trabajando en** | [EDITAR] |

---

## Nombre del proyecto

**ERP Satélite** (ERP + CRM integrado).

## Descripción en una línea

Sistema **ERP + CRM** transaccional para operación real de negocio (inventario, compras, ventas, CRM), construido **módulo a módulo** con **FastAPI** y **Next.js**, consumido también por **Expo** en fase de campo.

## Arquitectura

**Monolito modular headless**: un backend FastAPI, una PostgreSQL; frontends solo consumen **`/api/v1`**.

## Backend

- **Framework**: FastAPI  
- **Lenguaje**: Python **3.12**  
- **Estructura**: `app/core/`, `app/modules/<módulo>/` con `router.py` → `service.py` → `repository.py`, más `schemas.py`, `models.py`.

## Base de datos

**PostgreSQL** en **Supabase**. **Una sola BD** en MVP/post‑MVP hasta que un ADR futuro justifique otra cosa.

## Migraciones

**Alembic** (`alembic/`). Las revisiones aplican contra `DATABASE_URL` de Supabase.

## Autenticación

**Supabase Auth** + **JWT** validados en el backend (JWKS).

## Autorización

**RBAC** por roles de negocio: `admin` > `encargado` > `empleado`, con permisos por módulo/recurso. Detalle y mapeo en **`docs/ADR-001-architecture-stack.md`**.

## Frontend principal (primero)

**Next.js 15**, **App Router**, **TypeScript**. Ubicación prevista: `apps/web/`.

## Frontend móvil (Fase 6)

**Expo** + **React Native** + **TypeScript**. Misma API **`/api/v1`**, mismos JWT. **No** Android Studio nativo.

## Lenguajes

- Backend: **Python 3.12**  
- Frontends: **TypeScript**

## Estructura de carpetas del backend (árbol completo)

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
├── ADR-001-architecture-stack.md
└── ADR-002-offline-strategy.md   # Solo Fase 8; no implementar offline antes
```

## Patrón por módulo (obligatorio)

| Archivo | Rol |
|---------|-----|
| `router.py` | HTTP, status, validación Pydantic |
| `service.py` | Reglas de negocio, transacciones |
| `repository.py` | Acceso a datos |
| `schemas.py` | DTOs API |
| `models.py` | SQLAlchemy |

El **router** no hace queries. El **repository** no contiene lógica de negocio. El **service** no conoce HTTP.

## Convenciones de nombres

- **Python**: `snake_case` (módulos, funciones, variables).  
- **TypeScript / JSON expuesto**: **camelCase** en propiedades de dominio en respuestas/requests según `schemas`.  
- **Endpoints REST**: recursos en **plural**; **snake_case** en query params (`order_id`, `page_size`).  
- **Tablas SQL**: `snake_case` plural.

## Manejo de errores (API)

- HTTP: **200**, **201**, **400**, **404**, **409**, **422**, **500** según caso.  
- Cuerpo JSON:

```json
{
  "error": "CODIGO_ESTABLE",
  "detail": "Mensaje legible para humanos."
}
```

## Testing

- **pytest**; tests de integración con **fixtures transaccionales** y **rollback** por test (no vaciar BD con truncate en cada test salvo suites específicas de migración).

## CI/CD y deploy

- **CI**: **GitHub Actions** (lint → test → artefacto listo para deploy).  
- **Deploy**: **Render** (servicios: API FastAPI, web Next.js, worker). *No mantener dos plataformas de deploy sin ADR.*

## Ramas Git

- **`main`**: producción estable; solo recibe merge desde **`develop`** al cerrar fase o hito estable.  
- **`develop`**: integración diaria; todo el trabajo de feature se mergea aquí.  
- Features: `feature/<issue>-<descripcion>`.

## Offline-first

**Fase 8**, post‑MVP. Requiere **`docs/ADR-002-offline-strategy.md`** aprobado **antes** de escribir código offline. **No implementar** en Fases 0–7.

## Módulos del sistema

`auth`, `catalog`, `inventory`, `sales`, `purchases`, `accounting`, `hr`, `crm`, `reports`, `workers`.

## Referencia de arquitectura

**`docs/ADR-001-architecture-stack.md`** — decisión cerrada; si algo contradice este archivo, gana el ADR y hay que corregir el resto.

## Reglas Cursor del repo

Ver `.cursor/rules/project.mdc` y reglas en `.cursor/rules/*.mdc` donde no choquen con este contexto; en caso de choque, **este archivo + ADR-001**.
