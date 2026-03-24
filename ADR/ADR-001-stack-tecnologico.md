# ADR-001 — Stack tecnológico de fundación (ERP Satélite)

**Estado:** ACEPTADA  
**Fecha:** 2026-03-22  
**Decisor:** Abraha33 (acaceres163@unab.edu.co)

El desglose **por fase** del producto sigue en [docs/STACK_POR_FASE.md](../docs/STACK_POR_FASE.md). Este ADR fija la **decisión global** de fundación; ese documento detalla qué se añade en cada etapa.

---

## Contexto

ERP Satélite es un ERP + CRM construido por un solo desarrollador (~25 h/semana) con horizonte de **14 meses** y **5 fases**. La Fase 1 es una app de operaciones de campo (**móvil-first**) que consume **Excel** exportado del sistema legacy **SAE**. Las fases posteriores escalan hacia ERP completo, CRM con WhatsApp y modo offline.

La decisión de stack debe **minimizar superficie de mantenimiento** y **maximizar velocidad de iteración** con asistentes IA.

**Restricciones fijas:** solo ramas `main` / `develop`; secretos en `.env` (nunca commiteados); decisiones de arquitectura en `ADR/`; tablero GitHub **Project 11**; offline “de verdad” solo exigido en **Fase 5**.

---

## Opciones evaluadas

### Frontend
- **A1. React Native + Expo SDK** → **elegida**
- A2. Flutter  
- A3. PWA + React  

### Backend
- **B1. Supabase (BaaS) como contrato principal de la app + Python para integración; FastAPI solo opcional para jobs** → **elegida** (detalle operativo 2026-03-24 en “Decisión final” y revisión)
- B2. Firebase + Cloud Functions  
- B3. API propia (NestJS) + Supabase solo como DB  

### Base de datos cloud
- **C1. PostgreSQL en Supabase + Supabase CLI** (`db push` / migraciones versionadas) → **elegida**
- C2. Railway + Prisma  
- C3. PlanetScale (MySQL)  

### Base de datos local (Fase 5)
- **WatermelonDB** reservado para offline; no es obligatorio en el cliente antes de Fase 5.

---

## Decisión final

| Capa | Tecnología | Notas / versión mínima |
|------|------------|-------------------------|
| Móvil + web | React Native + **Expo SDK** | SDK **51+** (revisar en `package.json` al crear app) |
| Lenguaje app | **TypeScript** (`strict: true`) | 5.x |
| BaaS | **Supabase** | Auth, Postgres, Storage, RLS, **Realtime**, **RPC**, Edge Functions |
| Acceso desde app | **Supabase client SDK** (JS/TS en Expo) | **RLS** obligatorio en tablas expuestas; sin API propia intermedia para el CRUD típico |
| Lógica transaccional | **Supabase RPC** (SQL) | p. ej. abrir/cerrar turno de caja, operaciones multi-fila atómicas |
| Auth MVP | **Supabase Auth** (email/contraseña) | — |
| Base de datos | **PostgreSQL** (instancia del proyecto Supabase) | La versión la fija Supabase en el panel |
| Migraciones | **Supabase CLI** + SQL en repo (`database/migrations/` o `supabase/migrations/`) | Coherente con README |
| Integración SAE / archivos | **Scripts Python** (CLI) | CSV/XLS ↔ Supabase vía **API** (anon/service según script) o **conexión directa** Postgres; export inverso para alimentar SAE — **no** requiere FastAPI |
| Worker HTTP / jobs largos (opcional) | **FastAPI** (Python **3.12**) | VPS/runner, webhooks pesados, orquestación que no convenga en un script |
| Scraper UI SAE (opcional) | **Playwright** (Python) | **1.40+**; solo cuando el legacy no entregue export útil |
| CI/CD | **GitHub Actions** + **Expo EAS** (builds) | Tokens en GitHub Secrets / EAS, no en `.env` del repo |
| Offline (Fase 5) | **WatermelonDB** | Reservado; sync documentado en fases posteriores |

### Revisión 2026-03-24 — Backend operativo y SAE

- **App (web/móvil):** consumo **directo** de Supabase con **SDK** y políticas **RLS**; **Realtime** para escenarios como inventario y traslados; **RPC** para reglas de negocio complejas (cerrar caja, etc.).
- **SAE:** capa de integración = **scripts Python** separados del runtime de la app; sin servicio FastAPI obligatorio para import/export.
- **FastAPI / `worker/`:** se mantiene como **opción** para cargas que sigan requiriendo HTTP persistente o dependencias que no encajen en un script puntual.

---

## Variables de entorno

La **lista canónica de nombres** (sin valores secretos) vive en **[`.env.example`](../.env.example)**. Incluye:

- **Supabase:** `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY` (solo entornos de confianza, nunca en el bundle Expo).
- **FastAPI worker:** `DATABASE_URL`, `FASTAPI_SECRET_KEY`, `ALLOWED_ORIGINS`.
- **Expo:** `EXPO_PUBLIC_SUPABASE_URL`, `EXPO_PUBLIC_SUPABASE_ANON_KEY`, `EXPO_PUBLIC_API_BASE_URL` (solo claves **públicas**; en la práctica URL/anon suelen coincidir con las de Supabase).
- **Playwright / SAE:** `SAE_*`, `PLAYWRIGHT_HEADLESS`.
- **Fase 4 (placeholders):** WhatsApp, `OPENAI_API_KEY` — vacíos hasta CRM/transcripción.
- **CI/EAS:** comentarios en `.env.example` para `EXPO_TOKEN`, `SUPABASE_ACCESS_TOKEN` en **GitHub Secrets**.

**No duplicar** aquí el inventario completo: una sola fuente de verdad → `.env.example`.

---

## Regla práctica: Edge Functions vs RPC vs scripts Python vs FastAPI

| Usar **RPC (Postgres)** cuando… | Usar **Edge Functions** cuando… | Usar **scripts Python** cuando… | Usar **FastAPI** cuando… |
|-----------------------------------|--------------------------------|----------------------------------|---------------------------|
| Varias tablas deben actualizarse con una regla atómica y la llamada viene de la app autenticada | Webhook HTTP corto, transformación ligera, cercano a Postgres/Auth | Import/export SAE por CSV/XLS, validaciones batch, ETL puntual (CLI) | Job largo con servidor HTTP persistente, o dependencias que no encajan en script ni Edge |
| Ej.: abrir/cerrar turno de caja con validaciones | Baja latencia y poco estado | Conexión Postgres directa o Supabase API con service role (solo entornos de confianza) | **Playwright** u orquestación muy pesada fuera del bucle de import por archivo |

---

## Consecuencias

**Positivas**

- Un solo repo; **TypeScript** en app y **Python** acotado a **scripts SAE**, scraper opcional y **worker** FastAPI si hace falta.
- Supabase cubre Auth, RLS y Realtime sin montar backend propio desde cero.
- **Expo EAS** permite builds nativos sin depender solo de una Mac física para distribución.
- Stack muy documentado en comunidad y en asistentes IA.

**Negativas / trade-offs**

- Límites del **free tier** de Supabase (DB, storage, egress); valorar **Pro** al crecer (p. ej. Fase 2).
- **WatermelonDB** en Fase 5 favorece **`updated_at` y convenciones de borrado** desde Fase 1 (alineado a tickets tipo T1.1.2).
- **Playwright** en producción implica runtime tipo Chromium (~orden de 100MB+); ejecutar en **VPS**, **runner** o job aislado, no en el mismo proceso que la app móvil.

---

## Tras cerrar este ADR (checklist)

1. [x] [`.env.example`](../.env.example) actualizado.
2. [x] [CURSOR_CONTEXT.md](../CURSOR_CONTEXT.md) alineado.
3. [x] [README.md](../README.md) §10–11 y línea de stack inicial.
4. [x] [STACK_POR_FASE.md](../docs/STACK_POR_FASE.md) — línea base y Fase 1 sin ambigüedad FastAPI.
5. [ ] **En progreso:** proyecto **Supabase** (T0.1.2 / p. ej. #195), **`.env` local** y entornos (T0.1.4), **Excel SAE** en [EXCEL_ANALYSIS.md](../docs/EXCEL_ANALYSIS.md) (T0.1.5–6). Issues de documentación #1, #2, #3, #199–#201 cerrados; cerrar issue Supabase cuando el proyecto exista y `.env` esté rellenado (sin subir secretos).
6. [ ] **Commit y push** en `develop` con estos archivos (operación tuya si no está hecho).
