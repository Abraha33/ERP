# ADR-001 — ERP Satélite — Stack tecnológico completo

**Proyecto:** ERP Satélite  
**Decisor:** Abraha33  
**Fecha:** 2026-04-07  
**Estado:** ACEPTADO  

El desglose **por fase** del producto sigue en [docs/reference/STACK_POR_FASE.md](../docs/reference/STACK_POR_FASE.md). Este ADR es la **fuente de verdad** del stack global.

---

## Resumen ejecutivo

ERP Satélite es un sistema ERP + CRM construido por un solo desarrollador (~25 horas/semana) con un horizonte de **14 meses** dividido en **5 fases**. La arquitectura adoptada es un **monolito modular centrado en Supabase**, con una **app Android nativa** como cliente principal de campo. La decisión prioriza velocidad de iteración, reducción de superficie de mantenimiento y uso intensivo de asistentes IA como copiloto de desarrollo.

---

## 1. Arquitectura global

**Estilo:** Monolito modular — un solo backend lógico centrado en Supabase, con módulos por dominio (inventario, misiones, arqueos, ventas, CRM), sin microservicios independientes.

**No se usa:**

- **Kubernetes** — complejidad innecesaria para un solo desarrollador.
- **Docker obligatorio** — opcional solo para empaquetar workers Python/Playwright en VPS o para `supabase start` en local.

**Patrón BFF (Backend for Frontend):** **Supabase Edge Functions** (TypeScript/Deno) como capa de agregación para la app Android cuando una pantalla requiera ensamblar datos; evita múltiples round-trips desde el cliente.

**Patrón offline-first (Fase 5 producto):** La app Android **lee desde Room** (local) y sincroniza con Supabase en segundo plano mediante **WorkManager**. Antes de Fase 5 la app puede ser online-first; el diseño de tablas y `sync_status` en servidor ya prepara el contrato (ver [schema-conventions](../docs/reference/schema-conventions.md)).

---

## 2. Tabla de decisiones por capa

| Capa | Tecnología elegida | Alternativa descartada | Razón |
|------|-------------------|------------------------|--------|
| **App móvil** | Android nativo — **Kotlin + Jetpack Compose** | Expo / React Native | Developer orientado a Android; alcance **solo Android** (sin iOS) |
| **DB local (offline)** | **Room** (SQLite) | BD local JS de terceros | Nativo de Android; madurez con Kotlin |
| **Sync background** | **WorkManager** + **Supabase Kotlin** / **Ktor** o **Retrofit** según ticket | Background fetch no nativo | Integración con ciclo de vida y políticas de red Android |
| **DB cloud** | **Supabase PostgreSQL** | Firebase Firestore | Postgres relacional; **RLS** nativo; migraciones versionadas |
| **Auth** | **Supabase Auth** (email + contraseña MVP) | Firebase Auth | Integrado con RLS y mismo proyecto |
| **RLS y seguridad** | **Supabase Row Level Security** | Middleware propio en app | Seguridad declarativa en Postgres |
| **Lógica transaccional** | **SQL Functions / RPC** en Supabase | FastAPI como orquestador por defecto | Operaciones atómicas cerca de los datos |
| **BFF móvil** | **Supabase Edge Functions** (TypeScript/Deno) | FastAPI dedicado | Bajo overhead; sin servidor extra para casos BFF |
| **Integración SAE / Excel** | **Scripts Python** (CLI) en `scripts/sae/` | Edge Functions para ETL pesado | Archivos grandes; limpieza compleja; sin servidor persistente |
| **Scraper legacy SAE** | **Playwright** (Python 3.12) en `tools/scraper/` | Puppeteer (Node) | Alineado a scripts Python existentes |
| **Worker HTTP (opcional)** | **FastAPI** (Python 3.12) en `tools/worker/` | NestJS | Solo si un flujo requiere servidor HTTP persistente |
| **Web admin (futuro)** | **Next.js / React** (Fase 2+) | Angular | Ecosistema Supabase JS; mismo backend |
| **CI/CD** | **GitHub Actions** + **Gradle** (build Android cuando exista `apps/android/`) | GitLab CI | Repo ya en GitHub; sin Expo EAS (no hay app Expo en producto) |
| **Migraciones DB** | **Supabase CLI** (`supabase db push` / migraciones SQL en repo) | Prisma como fuente de schema | SQL versionado en `supabase/migrations/` |
| **Realtime** | **Supabase Realtime** | WebSockets propios | Activar solo donde aporte (inventario, notificaciones) |
| **Almacenamiento archivos** | **Supabase Storage** | AWS S3 | Incluido en el proyecto Supabase |

---

## 3. Stack detallado por componente

### 3.1 App móvil (Android)

- **Lenguaje:** Kotlin  
- **UI:** Jetpack Compose (Material 3 recomendado)  
- **Arquitectura:** MVVM + Repository  
- **DB local:** Room (SQLite) — espejo parcial de tablas críticas hacia Fase 5  
- **Red:** cliente **Supabase Kotlin**; **Ktor** o **Retrofit** si hace falta para Edge Functions o endpoints HTTP concretos  
- **Auth:** Supabase Auth SDK (Kotlin)  
- **Sync:** WorkManager — workers que procesan filas con `sync_status = PENDING` cuando hay red  
- **Campos habituales en Room (Fase 5):** `id` (UUID), `created_at`, `updated_at`, `sync_status` (`SYNCED` / `PENDING` / `CONFLICT`) — alinear con [schema-conventions](../docs/reference/schema-conventions.md)  

**Ubicación en monorepo:** `apps/android/`. La carpeta `apps/mobile/` es **legado** hasta retirada explícita.

### 3.2 Base de datos cloud (Supabase PostgreSQL)

- **Motor:** PostgreSQL (gestionado por Supabase)  
- **UUIDs:** `uuid` con `gen_random_uuid()` donde aplique  
- **Timestamps:** `created_at`, `updated_at` con trigger automático (convención en repo)  
- **Borrado lógico:** `deleted_at` en tablas críticas para sync offline  
- **RLS:** activado en tablas expuestas al cliente; políticas basadas en sesión y perfil (ver convención de nombres en docs de seguridad)  
- **Migraciones:** `supabase/migrations/*.sql` versionadas  
- **Entorno local:** `supabase start` (Docker) cuando se use flujo local completo  

### 3.3 Lógica de negocio

| Mecanismo | Cuándo usarlo | Ejemplo |
|-----------|---------------|---------|
| **RPC (SQL functions)** | Operaciones atómicas multi-tabla desde cliente autenticado | Recepción + stock + log |
| **Edge Functions (TS/Deno)** | BFF: agregar datos para pantallas; webhooks cortos | `get_mobile_dashboard` |
| **Scripts Python (CLI)** | Import/export Excel SAE; ETL batch | `scripts/sae/` |
| **FastAPI (opcional)** | Job HTTP persistente; dependencias pesadas | Worker en `tools/worker/` |

### 3.4 Integración SAE

- **Entrada:** Excel/CSV exportado del SAE legacy  
- **Procesamiento:** Python (`pandas`, `openpyxl`, etc.) según ticket  
- **Destino:** Supabase vía **PostgREST** con `service_role` **solo** en entornos de confianza, o `DATABASE_URL` en scripts locales  
- **Export inverso:** generación de archivos compatibles con SAE desde Postgres/Supabase  
- **Playwright:** solo si el SAE no entrega export útil; ejecución local, CI o VPS  

### 3.5 Offline y sincronización (énfasis Fase 5)

- **Estrategia:** offline-first — Room como fuente de lectura en campo; Supabase como fuente de verdad  
- **Escritura:** Room con `sync_status = PENDING` → WorkManager sube con red  
- **Descarga:** incremental por `updated_at` / cursor de sync (detalle en tickets Fase 5)  
- **Conflictos:** last-write-wins por `updated_at` salvo ADR específico  
- **Idempotencia:** UUID generado en cliente antes de insert remoto cuando aplique  

### 3.6 Autenticación y roles

- **Auth MVP:** email + contraseña (Supabase Auth)  
- **Sesión:** JWT gestionado por el SDK; sin exponer `service_role` en el APK  

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
- **Ramas:** solo `main` y `develop` permanentes en remoto; features efímeras  
- **Secretos:** GitHub Secrets + `.env` local; nunca en git  

---

## 4. Variables de entorno

**Lista canónica y nombres exactos:** [`.env.example`](../.env.example) en la raíz del monorepo (Supabase, `DATABASE_URL`, rutas SAE, Playwright, worker opcional, CRM placeholder, `ERP_ENVIRONMENT`, CI, `ANDROID_APPLICATION_ID`).

**Cliente Android:** inyectar URL/anon key vía **Gradle** (`local.properties` / **BuildConfig** / variantes), no depender de prefijos de entorno de otros stacks.

**No duplicar** el inventario largo aquí: mantener **una** fuente en `.env.example` y actualizar este ADR solo cuando cambie la política de capas.

---

## 5. Roadmap técnico por fase

### Fase 0 — Fundación (semanas 1–2)

| Ticket | Tarea |
|--------|--------|
| T0.1 | Proyecto Supabase cloud; URL y keys |
| T0.2 | Schema inicial en `supabase/migrations/` (productos, zonas, perfiles, stock, etc.) |
| T0.3 | RLS con políticas mínimas por rol |
| T0.4 | `.env.example` con nombres canónicos |
| T0.5 | Análisis Excel SAE → [`docs/legacy/EXCEL_ANALYSIS.md`](../docs/legacy/EXCEL_ANALYSIS.md) |
| T0.6 | ADR-001 + [`CURSOR_CONTEXT.md`](../CURSOR_CONTEXT.md) alineados |

### Fase 1 — App Satélite MVP (meses 1–3)

| Sprint | Foco |
|--------|------|
| S1 | Schema Fase 1 + RPC + RLS + triggers `updated_at` |
| S2 | Android: proyecto base, auth, navegación por rol |
| S3 | Catálogo de productos, recepción |
| S4 | Traslados + aprobación encargado |
| S5 | Misiones de conteo + arqueo de caja |
| S6 | Importación Excel SAE (Python) + Edge Function BFF si aplica |

### Fase 2 — ERP básico (meses 4–7)

Catálogos extendidos, compras, ventas, inventario en tiempo real, **web admin Next.js** para back-office.

### Fase 3 — ERP completo (meses 8–10)

Contabilidad, RRHH, reportes gerenciales, auditoría.

### Fase 4 — CRM (meses 11–12)

WhatsApp Cloud API, transcripción, casos/pipeline, SSO/magic link según producto.

### Fase 5 — Offline-first (meses 13–14)

Room como fuente primaria en campo, WorkManager sync bidireccional, conflictos e indicadores de estado; pruebas sin red.

---

## 6. Diagrama de arquitectura (texto)

```
┌─────────────────────────────────────────────────────────────┐
│                        CLIENTES                             │
│                                                             │
│  ┌─────────────────────────┐   ┌──────────────────────────┐ │
│  │  Android App (Kotlin)   │   │   Web Admin (Next.js)      │ │
│  │  Jetpack Compose        │   │   Fase 2+                  │ │
│  │  Room (offline Fase 5)  │   └──────────────┬─────────────┘ │
│  │  WorkManager (sync)     │                  │             │
│  └────────────┬────────────┘                  │             │
│               │ SDK Kotlin / HTTP             │ SDK JS      │
└───────────────┼───────────────────────────────┼─────────────┘
                │                               │
┌───────────────▼───────────────────────────────▼─────────────┐
│                     SUPABASE                                 │
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────────────┐ │
│  │  Auth        │  │  Edge Fns    │  │  Storage          │ │
│  │  JWT + RLS   │  │  BFF (TS)    │  │                   │ │
│  └──────────────┘  └──────┬───────┘  └───────────────────┘ │
│                           │                                 │
│  ┌────────────────────────▼────────────────────────────┐   │
│  │     PostgreSQL + RLS + Realtime + RPC                 │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
┌───────▼───────┐  ┌───────▼───────┐  ┌──────▼────────┐
│ Scripts Python│  │  Playwright   │  │  FastAPI      │
│  SAE import   │  │  scraper SAE  │  │  (opcional)   │
└───────────────┘  └───────────────┘  └───────────────┘
```

---

## 7. Reglas operativas

- **Nunca** commitear `.env`; usar [`.env.example`](../.env.example) como plantilla.  
- **Soft delete** (`deleted_at`) en tablas críticas cuando el dominio lo requiera para sync.  
- **UUIDs** como PK donde se acuerde; convenciones en [schema-conventions](../docs/reference/schema-conventions.md).  
- **`updated_at`** con trigger en tablas de negocio según migraciones del repo.  
- **TypeScript strict** en Edge Functions; **Kotlin** en Android; **Python 3.12** en scripts/worker.  
- **RLS obligatorio** en tablas expuestas al cliente.  
- **Monorepo:** `apps/android/`, `supabase/`, `scripts/` (incl. `scripts/sae/`), `tools/worker/` y `tools/scraper/` opcionales, `worker/` en raíz solo si se documenta como stub, `docs/`, `ADR/`.  

---

## Opciones históricas (referencia)

- Cliente móvil en **JavaScript multiplataforma** y BD local JS para offline: **deprecado** como objetivo de producto (2026-04); el repo puede conservar `apps/mobile/` como legado hasta eliminación.

---

## Regla práctica: Edge Functions vs RPC vs Python vs FastAPI

| RPC (Postgres) | Edge Functions | Scripts Python | FastAPI |
|----------------|----------------|----------------|---------|
| Transacciones atómicas desde cliente autenticado | BFF, webhooks cortos | CSV/XLS SAE, ETL | Jobs largos, HTTP persistente |

---

## Consecuencias

**Positivas:** menos superficie que microservicios; un solo Postgres como verdad; Android nativo alineado a tiendas y políticas de fondo.  

**Negativas:** límites de tier Supabase al crecer; dos clientes posibles (Android + Next) a gestionar; carpeta legado `apps/mobile/` hasta limpieza.

---

## Checklist post-ADR

1. [x] [`.env.example`](../.env.example) en raíz.  
2. [x] [CURSOR_CONTEXT.md](../CURSOR_CONTEXT.md) alineado (revisar tras cada cierre de fase).  
3. [x] [README.md](../README.md) y [STACK_POR_FASE.md](../docs/reference/STACK_POR_FASE.md) coherentes con este ADR.  
4. [ ] Proyecto Supabase operativo y `.env` local sin secretos en git.  
5. [ ] Módulo `apps/android/` con Gradle cuando arranque desarrollo de producto.  
