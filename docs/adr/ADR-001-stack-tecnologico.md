# ADR-001 — ERP Satélite — Stack tecnológico completo

**Proyecto:** ERP Satélite  
**Decisor:** Abraha33  
**Fecha original:** 2026-04-07  
**Última revisión:** 2026-04-18 — **W02 / repo-cleanup**: móvil de producto = **Android Studio + Kotlin + Compose**; dominio ERP desde la app vía **REST `/api/v1`** (FastAPI) con **JWT de Supabase Auth** — **sin** PostgREST ni `anon key` en el APK para tablas de negocio (alineado a monolito headless y `.cursor/context/CONTEXT.md`).  
**Revisión previa:** 2026-04-10 — **W01** (issue **#269**): alinear ADR con README, ROADMAP y CONTEXT.  
**Estado:** ACEPTADO  

El desglose **por fase** del producto sigue en [STACK_POR_FASE.md](../reference/STACK_POR_FASE.md). Este ADR es la **fuente de verdad** del stack global del monorepo.

> **Nota de ruta:** el archivo canónico es este: [`docs/adr/ADR-001-stack-tecnologico.md`](./ADR-001-stack-tecnologico.md) (enlaces desde [README.md](../../README.md) y [.cursor/context/CONTEXT.md](../../.cursor/context/CONTEXT.md)). Si en un issue se cita `ADR-001-architecture-stack.md` o `ADR/ADR-001-stack-tecnologico.md`, usar este mismo documento.

---

## Decisiones explícitas (resumen ejecutivo)

Las siguientes decisiones están **cerradas** y deben reflejarse en código y migraciones sin reinterpretar:

| Ámbito | Decisión |
|--------|----------|
| **Stack móvil (producto)** | **Android nativo** en **Android Studio:** **Kotlin** + **Jetpack Compose** + **Material 3**. Alcance **solo Android** (sin iOS). Carpeta de producto: **`apps/android/`**. **Expo / React Native** no son stack de producto (solo legado en `apps/mobile/` hasta retirada). |
| **Persistencia local** | **Room** (SQLite) como capa local oficial: caché y modelos locales desde fases tempranas; en **Fase 5** (roadmap) lectura **offline-first** desde Room y sync hacia servidor vía **`/api/v1`** (detalle en tickets / ADR offline cuando exista). **WorkManager** para trabajo en segundo plano (sync, reintentos). |
| **Cliente de red (app móvil producto)** | **HTTP a `/api/v1`** (p. ej. **Retrofit** o **Ktor**) contra **FastAPI**; **Bearer JWT** de **Supabase Auth** validado en backend. **Sin** PostgREST, Realtime ni `anon key` en el APK para dominio ERP. **No exponer `service_role` en el APK.** |
| **Backend / BaaS** | **FastAPI** expone **`/api/v1`** (negocio, RBAC). **Supabase:** **PostgreSQL**, **Auth** (JWT), **Storage**, **Edge Functions**, **Realtime**, **RPC**. Sin microservicios propios por defecto. |
| **Base de datos (cloud)** | **PostgreSQL** gestionado por Supabase. **RLS obligatoria** en todas las tablas expuestas a PostgREST (y defensa en profundidad para cualquier otro consumidor). Roles de aplicación: **admin > encargado > empleado** (`app_role` en `profiles`). Funciones de sesión de referencia: `public.current_empresa_id()`, `public.current_sucursal_id()`, `public.app_role()`. Convenciones de columnas: [schema-conventions.md](../reference/schema-conventions.md). |
| **Migraciones** | **Única fuente de verdad:** `supabase/migrations/`. Flujo: **`supabase migration new <nombre>`** → editar SQL → **`supabase db push`**. **No** alterar el esquema de producción desde el dashboard de Supabase salvo emergencia documentada. Validación en CI cuando aplique el job que aplica migraciones sobre Postgres. |
| **Integración SAE / Excel** | Scripts **Python** en **`scripts/sae/`** (CSV/XLS ↔ Supabase). |
| **Scraper opcional** | **Playwright** (Python 3.12) en **`tools/scraper/`**. |
| **Worker HTTP / jobs** | **`backend/app/modules/workers/`** (in-process, job_consumer). Sin proceso HTTP separado hasta que un ticket lo justifique. `backend/app/modules/workers/` eliminado. |
| **Cliente móvil legado** | La carpeta **`apps/mobile/`** (stack JS/Expo) es **legado** y **no** es objetivo de producto; no proponerla como stack de producción. |
| **CI/CD** | **GitHub Actions**; build Android con **Gradle** cuando exista el proyecto en `apps/android/`. |

---

## Resumen ejecutivo

ERP Satélite es un sistema ERP + CRM construido por un solo desarrollador (~25 horas/semana) con un horizonte de **14 meses** dividido en **5 fases** (ver [ROADMAP.md](../../ROADMAP.md)). La arquitectura adoptada es un **monolito modular headless** (**FastAPI** + **PostgreSQL en Supabase**), con **web ERP** como primer cliente y una **app Android nativa (Kotlin + Compose + Room + WorkManager)** como cliente de campo **post‑MVP**, integrada por **`/api/v1`**. La decisión prioriza velocidad de iteración, reducción de superficie de mantenimiento y uso intensivo de asistentes IA como copiloto de desarrollo.

---

## 1. Arquitectura global

**Estilo:** Monolito modular **headless** — reglas de negocio y API pública en **FastAPI** (`/api/v1`); **PostgreSQL en Supabase** como fuente de verdad; módulos por dominio (inventario, ventas, CRM, etc.), sin microservicios independientes.

**No se usa:**

- **Kubernetes** — complejidad innecesaria para un solo desarrollador.
- **Docker obligatorio** — opcional solo para empaquetar workers Python/Playwright en VPS o para `supabase start` en local.

**Patrón BFF (Backend for Frontend):** **Supabase Edge Functions** (TypeScript/Deno) solo cuando un ticket justifique agregación o webhooks; la **app Android** obtiene datos de negocio vía **`/api/v1`** (FastAPI), no como cliente PostgREST.

**Patrón datos en app:** antes de Fase 5 la app puede ser **online-first**, usando **Room** donde aporte (caché, lecturas repetidas, preparación del modelo offline). En **Fase 5 (producto)** el patrón objetivo es **offline-first**: la app **lee desde Room** y sincroniza con el servidor mediante **WorkManager** y **`/api/v1`**. El diseño de tablas en servidor y `sync_status` ya prepara el contrato (ver [schema-conventions](../reference/schema-conventions.md)).

---

## 2. Tabla de decisiones por capa

| Capa | Tecnología elegida | Alternativa descartada | Razón |
|------|-------------------|------------------------|--------|
| **App móvil** | Android nativo — **Kotlin + Jetpack Compose + Material 3** | Expo / React Native | Developer orientado a Android; alcance **solo Android** (sin iOS); alineado a `project.mdc` |
| **DB local** | **Room** (SQLite) | BD local JS de terceros | Oficial en Android con Kotlin; misma pila que el cliente de producto |
| **Sync background** | **WorkManager** + **Retrofit** o **Ktor** hacia **`/api/v1`** | Background fetch no nativo | Integración con ciclo de vida y políticas de red Android; dominio centralizado en FastAPI |
| **DB cloud** | **Supabase PostgreSQL** | Firebase Firestore | Postgres relacional; **RLS** nativo; migraciones versionadas en repo |
| **Auth** | **Supabase Auth** (email + contraseña MVP) | Firebase Auth | Integrado con RLS y mismo proyecto |
| **RLS y seguridad** | **Supabase Row Level Security** | Middleware propio en app | Seguridad declarativa en Postgres; políticas `p_<tabla>_<acción>_<rol>` |
| **Lógica transaccional** | **FastAPI** (`/api/v1`) como capa principal de negocio; **SQL Functions / RPC** en Supabase donde el ticket lo defina | Solo RPC desde cliente móvil | Reglas y RBAC auditables en Python; RPC atómico cerca de los datos cuando aplique |
| **BFF / agregación** | **FastAPI** para la app móvil; **Edge Functions** opcional para web u orquestación corta | Duplicar reglas en cliente móvil | Un contrato REST para Android; Edge solo si aporta sin divergencia de reglas |
| **Integración SAE / Excel** | **Scripts Python** (CLI) en `scripts/sae/` | Edge Functions para ETL pesado | Archivos grandes; limpieza compleja; sin servidor persistente |
| **Scraper legacy SAE** | **Playwright** (Python 3.12) en `tools/scraper/` | Puppeteer (Node) | Alineado a scripts Python existentes |
| **Worker / jobs** | **`backend/app/modules/workers/`** (in-process) | Proceso HTTP separado | Simplicidad: un solo proceso hasta que un ticket justifique separarlo |
| **Web admin (futuro)** | **Next.js / React** (Fase 2+) | Angular | Ecosistema Supabase JS; mismo backend |
| **CI/CD** | **GitHub Actions** + **Gradle** (build Android cuando exista `apps/android/`) | GitLab CI | Repo en GitHub; sin Expo EAS para el producto móvil |
| **Migraciones DB** | **Supabase CLI** — SQL versionado en `supabase/migrations/`; `supabase migration new` + `supabase db push` | Prisma como fuente de schema | Una sola fuente de verdad en el monorepo; coincide con `project.mdc` |
| **Realtime** | **Supabase Realtime** | WebSockets propios | Activar solo donde aporte (inventario, notificaciones) |
| **Almacenamiento archivos** | **Supabase Storage** | AWS S3 | Incluido en el proyecto Supabase |

---

## 3. Stack detallado por componente

### 3.1 App móvil (Android)

- **IDE:** Android Studio  
- **Lenguaje:** Kotlin  
- **UI:** Jetpack Compose (**Material 3**)  
- **Arquitectura:** MVVM + Repository; **no** concentrar lógica de negocio compleja solo en Composables — usar dominio / UseCases / ViewModels  
- **DB local:** **Room** (SQLite) — caché y preparación offline; en Fase 5 espejo parcial de tablas críticas y fuente de lectura en campo  
- **Red (dominio ERP):** **Retrofit** o **Ktor** contra la **API REST `/api/v1`** del backend FastAPI  
- **Auth:** flujo **Supabase Auth** (JWT); el token se envía al backend como **Bearer** en las llamadas a `/api/v1`  
- **Sync:** **WorkManager** — workers que procesan filas con `sync_status = PENDING` cuando hay red (contrato alineado con servidor vía API)  
- **Campos habituales en Room (cuando se modele sync):** `id` (UUID), `created_at`, `updated_at`, `sync_status` (`SYNCED` / `PENDING` / `CONFLICT`) — alinear con [schema-conventions](../reference/schema-conventions.md)  

**Ubicación en monorepo:** `apps/android/`. La carpeta `apps/mobile/` es **legado** hasta retirada explícita (**prohibido** promoverla como stack de producto; ver `project.mdc`).

### 3.2 Base de datos cloud (Supabase PostgreSQL)

- **Motor:** PostgreSQL (gestionado por Supabase)  
- **UUIDs:** `uuid` con `gen_random_uuid()` donde aplique  
- **Timestamps:** `created_at`, `updated_at` con trigger automático (convención en repo)  
- **Borrado lógico:** `deleted_at` en tablas críticas cuando el dominio/sync lo requieran  
- **RLS:** activado en tablas expuestas al cliente; políticas basadas en sesión y perfil  
- **Migraciones:** solo `supabase/migrations/*.sql` versionadas; ver **Decisiones explícitas** arriba  
- **Entorno local:** `supabase start` (Docker) cuando se use flujo local completo  
- **Tenant:** no hardcodear `empresa_id` ni `sucursal_id` en cliente; derivar de perfil/sesión según diseño RLS  

### 3.3 Lógica de negocio

| Mecanismo | Cuándo usarlo | Ejemplo |
|-----------|---------------|---------|
| **FastAPI (`/api/v1`)** | Reglas de negocio, RBAC, contrato de la app Android y web | CRUD módulos ERP, comandos transaccionales |
| **RPC (SQL functions)** | Operaciones atómicas multi-tabla invocadas desde **FastAPI** o jobs de confianza | Recepción + stock + log |
| **Edge Functions (TS/Deno)** | Webhooks cortos; BFF web si un ticket lo define | `get_mobile_dashboard` |
| **Scripts Python (CLI)** | Import/export Excel SAE; ETL batch | `scripts/sae/` |
| **FastAPI worker (opcional)** | Job HTTP persistente; dependencias pesadas | Worker en `backend/app/modules/workers/` |

### 3.4 Integración SAE

- **Entrada:** Excel/CSV exportado del SAE legacy  
- **Procesamiento:** Python (`pandas`, `openpyxl`, etc.) según ticket  
- **Destino:** Supabase vía **PostgREST** con `service_role` **solo** en entornos de confianza, o `DATABASE_URL` en scripts locales — **nunca** empaquetar `service_role` en el APK  
- **Export inverso:** generación de archivos compatibles con SAE desde Postgres/Supabase  
- **Playwright:** solo si el SAE no entrega export útil; ejecución local, CI o VPS  

### 3.5 Offline y sincronización (énfasis Fase 5)

- **Estrategia objetivo Fase 5:** offline-first — Room como fuente de lectura en campo; **Postgres (Supabase)** como fuente de verdad en servidor; **sincronización vía `/api/v1`** (no PostgREST desde el APK)  
- **Escritura:** Room con `sync_status = PENDING` → WorkManager sube con red contra FastAPI  
- **Descarga:** incremental por `updated_at` / cursor expuesto en API (detalle en tickets Fase 5)  
- **Conflictos:** last-write-wins por `updated_at` salvo ADR / ticket específico  
- **Idempotencia:** UUID generado en cliente antes de insert remoto cuando aplique  

### 3.6 Autenticación y roles

- **Auth MVP:** email + contraseña (Supabase Auth)  
- **Sesión:** JWT presentado a **FastAPI** en cada request a `/api/v1`; sin exponer `service_role` en el APK  

| Rol | Permisos principales (resumen) |
|-----|--------------------------------|
| `admin` | Catálogos, usuarios, reportes, configuración |
| `encargado` | Aprobar traslados, arqueo, descuadres |
| `empleado` | Recepción, traslados, misiones de conteo |

- **SSO / magic link:** reservado para fases posteriores (p. ej. CRM)  

### 3.7 CI/CD

- **Pipeline:** GitHub Actions  
- **Gates:** lint/build Kotlin (**ktlint** / detekt según se configure) + tests cuando existan + validación de migraciones SQL en CI si está activo en el repo  
- **Supabase:** despliegue de migraciones a staging/prod según política del equipo (`db push` o flujo documentado)  
- **Ramas:** solo `main` y `develop` permanentes en remoto; features efímeras (`feature/<issue>-<descripcion>`)  
- **Secretos:** GitHub Secrets + `.env` local; nunca en git  

---

## 4. Variables de entorno

**Lista canónica y nombres exactos:** [`.env.example`](../../.env.example) en la raíz del monorepo (Supabase, `DATABASE_URL`, rutas SAE, Playwright, worker opcional, CRM placeholder, `ERP_ENVIRONMENT`, CI, `ANDROID_APPLICATION_ID`).

**Cliente Android:** inyectar **URL base de la API** (`/api/v1`) y credenciales de **Supabase Auth** (p. ej. URL del proyecto para el flujo de login) vía **Gradle** (`local.properties` / **BuildConfig** / variantes). **No** empaquetar `anon key` para consultar PostgREST desde el APK; el dominio ERP va por FastAPI.

**No duplicar** el inventario largo aquí: mantener **una** fuente en `.env.example` y actualizar este ADR solo cuando cambie la política de capas.

---

## 5. Roadmap técnico por fase

Alineado a [ROADMAP.md](../../ROADMAP.md): Fase 0 fundación → Fase 1 App Satélite → Fases 2–3 ERP → Fase 4 CRM → Fase 5 offline-first.

### Fase 0 — Fundación (semanas 1–2)

| Ticket | Tarea |
|--------|--------|
| T0.1 | Proyecto Supabase cloud; URL y keys |
| T0.2 | Schema inicial en `supabase/migrations/` (productos, zonas, perfiles, stock, etc.) |
| T0.3 | RLS con políticas mínimas por rol |
| T0.4 | `.env.example` con nombres canónicos |
| T0.5 | Análisis Excel SAE → [`EXCEL_ANALYSIS.md`](../legacy/EXCEL_ANALYSIS.md) |
| T0.6 | ADR-001 + [`.cursor/context/CONTEXT.md`](../../.cursor/context/CONTEXT.md) alineados |

### Fase 1 — App Satélite MVP (meses 1–3)

| Sprint | Foco |
|--------|------|
| S1 | Schema Fase 1 + RPC + RLS + triggers `updated_at` |
| S2 | Android: proyecto base Gradle en `apps/android/`, auth, navegación por rol |
| S3 | Catálogo de productos, recepción |
| S4 | Traslados + aprobación encargado |
| S5 | Misiones de conteo + arqueo de caja |
| S6 | Importación Excel SAE (Python) + Edge Function BFF si aplica |

### Fase 2 — ERP básico (meses 4–7)

Catálogos extendidos, compras, ventas, inventario en tiempo real, **web admin Next.js** para back-office.

### Fase 3 — ERP completo (meses 8–10)

Contabilidad, RRHH, reportes gerenciales, auditoría.

### Fase 4 — CRM (meses 11–12)

WhatsApp Cloud API, transcripción, casos/pipeline, SSO/magic link según producto. **CRM como módulo** sobre el núcleo ERP (maestros y documentos en Postgres/RLS).

### Fase 5 — Offline-first (meses 13–14)

Room como fuente primaria en campo, WorkManager sync bidireccional, conflictos e indicadores de estado; pruebas sin red.

---

## 6. Diagrama de arquitectura (texto)

```
┌─────────────────────────────────────────────────────────────┐
│                        CLIENTES                             │
│                                                             │
│  ┌─────────────────────────┐   ┌──────────────────────────┐ │
│  │  Android (Kotlin)       │   │  Web ERP (React/Next)    │ │
│  │  Compose + M3           │   │  Fase 2+                 │ │
│  │  Room + WorkManager     │   └──────────────┬───────────┘ │
│  │  HTTP → /api/v1         │                  │ HTTP/JS     │
│  └────────────┬────────────┘                  │             │
└───────────────┼───────────────────────────────┼─────────────┘
                │                               │
                └───────────────┬───────────────┘
                                │
                    ┌───────────▼───────────┐
                    │  FastAPI (/api/v1)  │
                    │  RBAC + dominio     │
                    └───────────┬───────────┘
                                │
┌───────────────────────────────▼─────────────────────────────┐
│                     SUPABASE                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────────────┐ │
│  │  Auth (JWT)  │  │  Edge Fns    │  │  Storage          │ │
│  └──────────────┘  └──────┬───────┘  └───────────────────┘ │
│                           │                                 │
│  ┌────────────────────────▼────────────────────────────┐   │
│  │     PostgreSQL + RLS + Realtime + RPC               │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
┌───────▼───────┐  ┌───────▼───────┐  ┌──────▼────────┐
│ Scripts Python│  │  Playwright   │  │  FastAPI      │
│  SAE import   │  │  scraper SAE  │  │  worker opt.  │
└───────────────┘  └───────────────┘  └───────────────┘
```

---

## 7. Reglas operativas

- **Nunca** commitear `.env`; usar [`.env.example`](../../.env.example) como plantilla.  
- **Soft delete** (`deleted_at`) en tablas críticas cuando el dominio lo requiera para sync.  
- **UUIDs** como PK donde se acuerde; convenciones en [schema-conventions](../reference/schema-conventions.md).  
- **`updated_at`** con trigger en tablas de negocio según migraciones del repo.  
- **TypeScript strict** en Edge Functions; **Kotlin** en Android; **Python 3.12** en scripts/worker.  
- **RLS obligatorio** en tablas expuestas a PostgREST u otros consumidores con credenciales distintas a la app móvil vía `/api/v1`.  
- **Monorepo:** `apps/android/`, `backend/`, `supabase/` (migraciones como única fuente DDL), `scripts/` (incl. `scripts/sae/`), `backend/app/modules/workers/` y `tools/scraper/` opcionales, `docs/` (incl. `docs/adr/`).  

---

## Opciones históricas (referencia)

- Cliente móvil en **JavaScript multiplataforma** y BD local JS para offline: **deprecado** como objetivo de producto (2026-04); el repo puede conservar `apps/mobile/` como legado hasta eliminación.

---

## Regla práctica: Edge Functions vs RPC vs Python vs FastAPI

| RPC (Postgres) | Edge Functions | Scripts Python | FastAPI |
|----------------|----------------|----------------|---------|
| Transacciones atómicas invocadas desde backend o contextos de confianza | BFF, webhooks cortos | CSV/XLS SAE, ETL | Dominio `/api/v1`, jobs largos, HTTP persistente (worker opt.) |

---

## Consecuencias

**Positivas:** menos superficie que microservicios; un solo Postgres como verdad; Android nativo con Room y WorkManager alineados a políticas de red y offline; reglas de `project.mdc` y ADR coherentes.  

**Negativas:** límites de tier Supabase al crecer; dos clientes posibles (Android + Next) a gestionar; carpeta legado `apps/mobile/` hasta limpieza.

---

## Checklist post-ADR

1. [x] [`.env.example`](../../.env.example) en raíz.  
2. [x] [.cursor/context/CONTEXT.md](../../.cursor/context/CONTEXT.md) alineado (revisar tras cada cierre de fase).  
3. [x] [README.md](../../README.md) y [STACK_POR_FASE.md](../reference/STACK_POR_FASE.md) coherentes con este ADR.  
4. [x] Revisión W01 (2026-04-10): decisiones explícitas y stack **Kotlin + Compose + Material 3 + Room + WorkManager** reflejados aquí y en `.cursor/rules/project.mdc`.  
5. [x] Revisión W02 (2026-04-18): móvil por **`/api/v1`** + Android Studio; sin PostgREST en APK para dominio ERP.  
6. [ ] Proyecto Supabase operativo y `.env` local sin secretos en git.  
7. [ ] Módulo `apps/android/` con Gradle cuando arranque desarrollo de producto.  
