# ADR-001 — Stack tecnológico de fundación (ERP Satélite)

**Estado:** ACEPTADA (revisión **2026-04-08** — cliente **Kotlin + Compose + Room**)  
**Fecha original:** 2026-03-22  
**Decisor:** Abraha33 (acaceres163@unab.edu.co)

El desglose **por fase** del producto sigue en [docs/reference/STACK_POR_FASE.md](../docs/reference/STACK_POR_FASE.md). Este ADR fija la **decisión global** de fundación.

---

## Contexto

ERP Satélite es un ERP + CRM construido por un solo desarrollador (~25 h/semana) con horizonte de **14 meses** y **5 fases**. La Fase 1 es una app de operaciones de campo (**móvil-first Android**) que consume **Excel** exportado del sistema legacy **SAE**. Las fases posteriores escalan hacia ERP completo, CRM con WhatsApp y modo offline.

La decisión de stack debe **minimizar superficie de mantenimiento** y **maximizar velocidad de iteración** con asistentes IA.

**Restricciones fijas:** solo ramas `main` / `develop`; secretos en `.env` (nunca commiteados); decisiones de arquitectura en `ADR/`; tablero GitHub **Project 11**; offline “de verdad” solo exigido en **Fase 5**.

---

## Opciones evaluadas (frontend)

### Frontend móvil
- **A1. Kotlin + Jetpack Compose + Material 3** → **elegida**
- A2. Cliente móvil en ecosistema **JavaScript multiplataforma** (histórico; **deprecado** 2026-04-08; **no** es el stack activo)
- A3. Flutter  
- A4. PWA + React  

### Backend
- **B1. Supabase (BaaS) como contrato principal de la app + Python para integración; FastAPI solo opcional para jobs** → **elegida**
- B2. Firebase + Cloud Functions  
- B3. API propia (NestJS) + Supabase solo como DB  

### Base de datos cloud
- **C1. PostgreSQL en Supabase + Supabase CLI** (`db push` / migraciones versionadas) → **elegida**
- C2. Railway + Prisma  
- C3. PlanetScale (MySQL)  

### Base de datos local (Fase 5)
- **Room** (SQLite) en Android + **WorkManager** para sync en segundo plano; estrategia de conflictos documentada en fases posteriores. No es obligatorio antes de Fase 5.

---

## Decisión final

| Capa | Tecnología | Notas / versión mínima |
|------|------------|-------------------------|
| App Android | **Kotlin** + **Jetpack Compose** | UI declarativa; Material 3 recomendado |
| Persistencia local | **Room** | Entidades alineadas a contrato Supabase donde aplique |
| Jobs en background | **WorkManager** | Sync, reintentos, restricciones de red/batería |
| Acceso red / Auth | **Supabase Kotlin** (`supabase-kt`) u oficial equivalente | **RLS** obligatorio; sin exponer `service_role` en la app |
| Lógica transaccional cloud | **Supabase RPC** (SQL) | Operaciones multi-fila atómicas |
| Auth MVP | **Supabase Auth** | Email/contraseña u OAuth según producto |
| Base de datos | **PostgreSQL** (instancia Supabase) | Versionada por Supabase |
| Migraciones | **Supabase CLI** + SQL en `supabase/migrations/` | Ver [docs/reference/schema-conventions.md](../docs/reference/schema-conventions.md) |
| Integración SAE | **Scripts Python** (CLI) | CSV/XLS ↔ Supabase vía API o Postgres directo |
| Worker HTTP (opcional) | **FastAPI** en `tools/worker/` | Python **3.12** |
| Scraper UI SAE (opcional) | **Playwright** (Python) | Solo cuando el legacy no entregue export útil |
| CI/CD | **GitHub Actions** | Builds Android (Gradle) en CI cuando el módulo exista |
| Offline (Fase 5) | **Room** + sync documentada | Conflictos por `updated_at` / reglas explícitas |

### Revisión 2026-04-08 — Cliente nativo Android

- Se **depreca** como objetivo de producto la opción **A2** y la base de datos local **JS** usada antes en Fase 5; el repo puede conservar `apps/mobile` solo como legado hasta eliminación explícita.
- La app de campo vive en **`apps/android/`** (proyecto Gradle cuando se inicialice).

---

## Variables de entorno

La lista canónica está en **[`.env.example`](../.env.example)** (14 variables operativas + comentarios de CI). Incluye: Supabase, Postgres directo, SAE, Playwright, worker FastAPI, placeholders CRM, Android `APPLICATION_ID`, `ERP_ENVIRONMENT`, token CI.

**No duplicar** el inventario completo en este ADR.

---

## Regla práctica: Edge Functions vs RPC vs scripts Python vs FastAPI

| Usar **RPC (Postgres)** cuando… | Usar **Edge Functions** cuando… | Usar **scripts Python** cuando… | Usar **FastAPI** cuando… |
|----------------------------------|----------------------------------|-----------------------------------|---------------------------|
| Varias tablas, regla atómica, llamada desde cliente autenticado | Webhook HTTP corto, transformación ligera | Import/export SAE por CSV/XLS, ETL CLI | Job largo con servidor HTTP persistente |
| Ej.: cerrar turno de caja | Baja latencia | Service role solo en entornos de confianza | Playwright u orquestación pesada |

---

## Consecuencias

**Positivas**

- **Kotlin** y **Compose** alineados con tooling Android oficial y políticas de tienda.
- **Room** integra bien con **WorkManager** para Fase 5 sin stack JS intermedio.
- Supabase cubre Auth, RLS y Realtime sin backend propio desde cero.

**Negativas / trade-offs**

- Límites del free tier de Supabase al crecer.
- Dos superficies de cliente si persiste carpeta legado (`apps/mobile/`): mantener una sola fuente de verdad en ADR y README hasta limpieza.

---

## Tras cerrar este ADR (checklist)

1. [x] [`.env.example`](../.env.example) en raíz con variables canónicas.
2. [x] [CURSOR_CONTEXT.md](../CURSOR_CONTEXT.md) alineado a Kotlin + Supabase.
3. [x] [README.md](../README.md) línea de stack.
4. [x] [STACK_POR_FASE.md](../docs/reference/STACK_POR_FASE.md) alineado a Kotlin + Room como línea base.
5. [ ] Proyecto **Supabase** operativo y `.env` local sin subir secretos.
6. [ ] Módulo **`apps/android/`** inicializado (Gradle) cuando arranque desarrollo de producto.
