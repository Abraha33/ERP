# ERP Satelite Operativa

Sistema empresarial completo (ERP + CRM) construido por un solo founder en 14 meses.
Stack: **Expo + Supabase + FastAPI (worker) + Playwright**; offline **WatermelonDB** en Fase 5. Detalle: [ADR-001](./ADR/ADR-001-stack-tecnologico.md) y [STACK_POR_FASE.md](./docs/STACK_POR_FASE.md).

**Plan maestro del producto** (fases 0–5: fundación, App Satélite, ERP básico, ERP completo, CRM, offline): **[ROADMAP.md](./ROADMAP.md)**. **Vista por sprints** (T01–T35, arranque): [docs/ROADMAP_SPRINTS.md](./docs/ROADMAP_SPRINTS.md).

**Fundación (operativo):** proyecto **Supabase**, **`.env` / entornos locales** y **[docs/EXCEL_ANALYSIS.md](./docs/EXCEL_ANALYSIS.md)** — **en progreso** (tabla en [§16](#16-setup-inicial-y-scripts)).

---

## INDICE

1. [Que es este proyecto](#1-que-es-este-proyecto)
2. [Como leer el tablero Projects](#2-como-leer-el-tablero-projects)
3. [Como operar el tablero dia a dia](#3-como-operar-el-tablero-dia-a-dia)
   - [3.2 Ramas Git: solo `main` y `develop`](#32-ramas-git-solo-main-y-develop)
   - [3.3 Roles de desarrollo](#33-roles-de-desarrollo)
4. [Sistema de Labels](#4-sistema-de-labels)
5. [Sistema de Milestones](#5-sistema-de-milestones)
6. [Como leer un Issue](#6-como-leer-un-issue)
7. [Flujo de trabajo semanal](#7-flujo-de-trabajo-semanal)
8. [Reglas del proyecto](#8-reglas-del-proyecto)
9. [Arquitectura del sistema](#9-arquitectura-del-sistema)
10. [Tech Stack confirmado](#10-tech-stack-confirmado)
11. [Decisiones tecnicas pendientes](#11-decisiones-tecnicas-pendientes)
12. [Estrategia de construccion](#12-estrategia-de-construccion)
13. [Estructura de carpetas](#13-estructura-de-carpetas)
14. [Timeline del proyecto](#14-timeline-del-proyecto)
15. [Glosario](#15-glosario)
16. [Setup inicial y scripts](#16-setup-inicial-y-scripts)

---

## 1. Que es este proyecto

Es un ERP + CRM integrado que reemplaza gradualmente el SAE actual, empezando por una app satelite para operaciones de campo.

### Para que sirve

- **Fase 1 (App Satelite):** App movil para recepcion, traslados, misiones de conteo y arqueo. Se alimenta de Excel exportados del SAE.
- **Fases 2–3 (ERP):** Catalogos, compras, ventas, inventario, contabilidad, RRHH.
- **Fase 4 (CRM):** Comunicacion con clientes (WhatsApp), transcripcion de audio, casos, pipeline de ventas.
- **Fase 5 (Offline):** Base local, sync automatico, resiliencia sin internet.

### Quien lo construye

- 1 founder / desarrollador
- Uso intensivo de IA (Cursor, ChatGPT)

---

## 2. Como leer el tablero Projects

El tablero esta en: [github.com/users/Abraha33/projects/11](https://github.com/users/Abraha33/projects/11)

**Asignaciones:** en la practica todo va con **Assignees = tu usuario [@Abraha33](https://github.com/Abraha33)**. La vista *Mis ítems* filtra `assignee:@me` (eres tu); si un ticket no aparece, asignatelo.

**Status update:** en el proyecto hay un campo de texto **Status update** por tarjeta (bloqueo, avance). Activalo como columna en tablas **Equipo** / **Mis ítems** si no lo ves: menu **View** → campos visibles.

**Modo solo dev (ultra-lean):** detalle completo en [docs/GITHUB_PROJECTS.md](./docs/GITHUB_PROJECTS.md). **Workflows del Project (7):** [docs/GITHUB_PROJECT_WORKFLOWS.md](./docs/GITHUB_PROJECT_WORKFLOWS.md). Estado: `python scripts/project_workflows_status.py --from-num 2 --to-num 7`.

### Workflows del Project (7 automatizaciones)

No hay API para activarlos; se configuran en [Project → Workflows](https://github.com/users/Abraha33/projects/11/workflows). Guía: [docs/GITHUB_PROJECT_WORKFLOWS.md](./docs/GITHUB_PROJECT_WORKFLOWS.md).

| # | Workflow | Configuracion |
|---|----------|---------------|
| 1 | Item added to project | Status → **Backlog** |
| 2 | Issue/PR closed | Status → **Done** |
| 3 | Pull request merged | Status → **Done** |
| 4 | Issue reopened | Status → **Backlog** |
| 5 | Auto-close issue | Status → Done → cerrar issue en repo |
| 6 | Auto-add to project | Repo `Abraha33/erp-satelite`, filtro `is:issue` |
| 7 | Auto-archive (opcional) | Filtro conservador o OFF |

### Columnas del Kanban (Status)

Orden: **Icebox** (nevera / algún día) → **Backlog** → **Ready** → **In progress** → **In review** → **Done**. Detalle en [docs/GITHUB_PROJECTS.md](./docs/GITHUB_PROJECTS.md).

| Columna | Significado |
|---------|-------------|
| **Icebox** | Ideas fuera del plan activo; no mezclar con Backlog. |
| **Backlog** | En roadmap ~14 meses, aun no sprint. |
| **Ready** | Cola del sprint (2 semanas). Maximo 5-7 tickets. |
| **In progress** | **Solo 1 tarea** a la vez en la practica. |
| **In review** | Pruebas en celular o navegador (tu QA / self-review). |
| **Done** | Completado. |

### Vistas en el Project 11

| Vista | Tipo | Enlace | Uso |
|-------|------|--------|-----|
| **Priority board** | Board | [views/2](https://github.com/users/Abraha33/projects/11/views/2) | Columnas = **Status** (Icebox…Done), filas = **Priority** (P0–P3). Group by Priority, Column field Status. |
| **Equipo · inventario** | Tabla | [views/3](https://github.com/users/Abraha33/projects/11/views/3) | Slice by **Assignees**, Group by **Status**. Columnas: Title, Status, Linked PRs, Sub-issues, Size. Paridad [Factura SaaS](https://github.com/users/Abraha33/projects/5/views/3). |
| **Mis ítems · foco** | Tabla | [views/5](https://github.com/users/Abraha33/projects/11/views/5) | Filtro `assignee:@me` (= @Abraha33). Solo tu cola. |
| **Foco semana** | Board | [views/10](https://github.com/users/Abraha33/projects/11/views/10) | Solo **Ready + In progress + In review**. Pack experto. |
| **Roadmap · 14 meses** | Roadmap | [views/8](https://github.com/users/Abraha33/projects/11/views/8) | Timeline con **Roadmap · inicio/fin**, hitos, filtro `-status:Done`. |

**Priority board:** prioridad en campo **Priority (P0–P3)**; filtros `no:Priority` / `has:Priority` — [guía](./docs/GITHUB_PROJECTS.md#filtros-priority-con-y-sin-valor). Paridad visual Factura SaaS: [docs/GITHUB_PROJECTS.md](./docs/GITHUB_PROJECTS.md#paridad-visual-con-tu-captura-factura-saas-priority-board). `python scripts/list_items_missing_priority.py` lista ítems sin prioridad. Opcional: **Foco de hoy** con **+ New view**.

### Campos personalizados (Project 11)

| Campo | Uso |
|-------|-----|
| **Status** | Icebox, Backlog, Ready, In progress, In review, Done. |
| **Priority** | P0 (urgente), P1 (sprint), P2 (media), P3 (baja). |
| **Size** | Numero (equivale a *Estimate*). Field sum en cabeceras. |
| **Status update** | Texto: bloqueo, avance, nota corta por tarjeta. |
| **Roadmap · inicio** / **Roadmap · fin** | Fechas para timeline (views/8). |

---

## 3. Como operar el tablero dia a dia

1. **Sprint:** De **Backlog** (no de Icebox salvo que promuevas la idea) pasa a **Ready** solo 5-7 tickets para estas 2 semanas.
2. **Trabajar:** Mueve **una** tarjeta a **In progress**. No abras otra hasta terminar o bloquear.
3. **Probar:** Cuando compile en Cursor, mueve a **In review** y prueba en dispositivo real.
4. **Cerrar:** Si pasa las pruebas, **Done**. Si falla, vuelve a **In progress**.
5. **Ideas:** Las que no son plan aun → **Icebox**; el trabajo en roadmap sin sprint → **Backlog**.

### 3.1 Workflow Daily Progress (automatizacion)

El workflow [.github/workflows/daily-progress.yml](./.github/workflows/daily-progress.yml) actualiza el tablero automaticamente:

| Evento | Accion |
|--------|--------|
| **Push** con commit que referencia `#123` | Backlog → In progress (si el issue esta en Backlog) |
| **PR opened** | In review (issues vinculados con closingIssuesReferences) |
| **PR closed (merged)** | Done |
| **PR closed (no merged)** | Backlog |
| **Schedule** (14:00 UTC diario, ~9am UTC-5) | Comenta en issues abiertos con actividad en las ultimas 24h un resumen |

**Secret recomendado:** `PROJECTS_TOKEN` (PAT con scope `project`) para escribir en GitHub Projects. Si no existe, usa `github.token` (puede limitar permisos en forks).

### 3.2 Ramas Git: solo `main` y `develop`

En el remoto de **`Abraha33/erp-satelite`** solo deben quedar **dos ramas permanentes**: **`main`** y **`develop`**. No hay rama `dev`, ni otra rama de integración paralela.

En GitHub, **fork** es una **copia del repo** bajo otra cuenta (contribuciones externas); **no** es una rama. Como solo dev suele bastar el repo canonico; un fork es opcional.

| Rama | Proposito |
|------|-----------|
| **`main`** | Codigo **estable** (release / demo seria). Solo entra con merge desde `develop` (u hotfix excepcional acordado). |
| **`develop`** | **Integracion diaria** del sprint; debe compilar y pasar CI razonablemente. |

**Flujo:** todo el trabajo se integra en **`develop`**; al cerrar hito, merge **`develop`** → **`main`**.

**Tareas:** con `develop` actualizado, puedes **pushear directo a `develop`** o, si quieres revisión, crear una **rama temporal** (nombre libre), abrir **PR → `develop`** y **borrar la rama** en GitHub tras el merge. Esa rama no forma parte del modelo de ramas del repo (solo existen `main` y `develop` a largo plazo).

**Rutina tipica (PR opcional):**

1. `git checkout develop && git pull origin develop`
2. (Opcional) `git checkout -b trabajo-issue-NNN` — commits; PR hacia **`develop`**; borrar rama remota al fusionar.
3. O bien: commits y `git push origin develop` si trabajas solo sin PR.
4. Al cierre de hito: PR **`develop`** → **`main`**.

### 3.3 Roles de desarrollo

Eres **un solo dev**; los **roles** (`role/frontend`, `role/database`, …) son *sombreros* para enfocar el dia. No confundir con **roles de producto** en [CURSOR_CONTEXT.md](./CURSOR_CONTEXT.md) (administrador / encargado / empleado): esos son RBAC en la app.

**Rutina diaria (tablero):**

1. En el Project, en **las vistas que ya tienes** (Priority, Equipo, Mis ítems, Foco semana, Roadmap), escribe en el **filtro** `label:role/...` cuando quieras ver solo una capa; **no** crees vistas nuevas solo para rol, y **no guardes** ese filtro en la vista si quieres seguir viendo el tablero completo después (ver [docs/GITHUB_PROJECTS.md](./docs/GITHUB_PROJECTS.md#filtrar-por-rol-sin-vistas-nuevas)).
2. Entre tickets **Ready** con ese rol, elige uno (puede ser al azar **si** no hay P0 bloqueante ni dependencias sin resolver).
3. Mueve **una** tarjeta a **In progress** (WIP = 1).
4. Trabaja sobre **`develop`** (o rama temporal → PR a `develop`; ver §3.2).

**Etiquetar issues:** en el repo solo hace falta **`role/*`** y **`priority/P0`…`priority/P3`** (ver [§4](#4-sistema-de-labels)). Las **etapas** (Backlog, In progress, Done, …) son el **campo Status** del [Project 11](https://github.com/users/Abraha33/projects/11), **no** etiquetas. Crear labels: `python scripts/ensure_role_labels.py`.

---

## 4. Sistema de Labels (mínimo)

**Política:** pocas etiquetas en el issue — **rol**, **prioridad** y nada más. Ámbito (app/api/db), tipo (bug/feature), fase del roadmap y MVP van en el **cuerpo del issue**, en **Milestone** o en campos del Project; no hace falta duplicarlos como `area/*`, `tipo/*`, `fase-*`, etc.

**Colores del tablero** (Status / Priority en el Project): [GITHUB_PROJECTS.md](./docs/GITHUB_PROJECTS.md#paleta-de-color-project-11).

### Etapas de trabajo (no son labels)

En **GitHub Projects** usa el campo **Status**: **Icebox** → **Backlog** → **Ready** → **In progress** → **In review** → **Done**. Ahí ves si algo está en backlog o en curso; los workflows del Project mueven tarjetas según PR/commits (ver [§3.1](#31-workflow-daily-progress-automatizacion)). En el filtro del proyecto puedes usar el propio **Status**, no `label:…`.

### Etiquetas permitidas en el repo

| Label | Uso |
|-------|-----|
| **`role/*`** | **Exactamente uno por issue** — capa principal (filtro `label:role/...` en el Project). |
| **`priority/P0`** … **`priority/P3`** | **Como máximo uno** — misma escala que el campo **Priority** del tablero (P0 urgente → P3 baja); mantén label y campo alineados. |
| `role/frontend` | Expo / RN / UI de producto. |
| `role/backend` | API, reglas de negocio, servicios. |
| `role/database` | Schema, migrations, RLS, SQL, Supabase. |
| `role/platform` | Repo, CI/CD, scripts, `.env`, hygiene del Project. |
| `role/integration` | Excel SAE, scraper, import/export, datos legacy. |
| `role/qa-release` | Pruebas en dispositivo, checklist release, verificación antes de Done. |
| `role/crm` | WhatsApp, conversaciones, pipeline (CRM). |
| `role/offline-sync` | Base local, sync, conflictos (offline-first). |
| `role/security` | Auth, secretos, hardening, revisión authz. |
| `role/docs-adr` | README, ADR, CURSOR_CONTEXT, guías. |
| `priority/P0` | Urgente / bloqueante. |
| `priority/P1` | Alta — sprint actual. |
| `priority/P2` | Media. |
| `priority/P3` | Baja. |

**Legacy:** si aún ves `area/*`, `tipo/*`, `frontend` plano, `alta`/`media`/`baja`, `MVP`, `Sprint-N`, `fase-*`, puedes quitarlos del issue cuando toques el ticket; no se vuelven a crear con `ensure_role_labels.py`.

**Dos capas en un ticket:** un solo `role/*`; detalla la otra en el cuerpo del issue.

---

## 5. Sistema de Milestones

Hitos alineados al plan maestro [ROADMAP.md](./ROADMAP.md) y a la vista sprint [docs/ROADMAP_SPRINTS.md](./docs/ROADMAP_SPRINTS.md): **un milestone por fase** (rollup) y **un milestone por sprint** dentro de cada fase **1–5** (issues `T{phase}.{sprint}.*`). La **Fase 1** es **App Satélite** (MVP de operaciones de campo).

| Fase | Milestone rollup (opcional en filtros) | Sprints (`Tb.c.*` → **Sb**) |
|------|----------------------------------------|-----------------------------|
| **0** | `Fase 0 — Fundación` | (sin sub-sprints; todo `T0.1.*` usa el rollup) |
| **1 · ERP Satélite** | *(sin milestone rollup; solo sprints)* | **S1–S5:** modelo datos/importación, login/catálogo, recepción/traslados, misiones conteo, arqueo caja |
| **2 · ERP Básico** | `Fase 2 — ERP Básico` | **S1–S4:** catálogos, compras, ventas, inventario |
| **3 · ERP Completo** | `Fase 3 — ERP Completo` | **S1–S4:** contabilidad, RRHH, reportes, auditoría |
| **4 · CRM** | `Fase 4 — CRM` | **S1–S5:** comunicación interna, transcripción, casos, pipeline, historial cliente |
| **5 · Offline** | `Fase 5 — Offline-First` | **S1–S2:** DB local/UI offline; sync y conflictos |

Los nombres exactos en GitHub los define `scripts/roadmap_milestones.py` (`ensure_roadmap_milestones.py` los crea todos).

**Scripts:** `python scripts/ensure_roadmap_milestones.py` → `import-backlog-to-github.py` / `sync_roadmap_granular_issues.py` asignan sprint; `sync_issue_milestones.py` alinea issues ya creados. Otro repositorio: `-R Owner/repo` en esos scripts o `python scripts/sync_milestones_for_project_repos.py` (lista en `scripts/project_milestone_repos.txt`). Tickets `[E##-S##-##]` del CSV 5 meses: sprints **1–6** → Fase **1** S1–S5; **7–10** → Fase **2** S1–S4.

**Regla de oro (producto):** ningún milestone sprint `Fase N · S#` debe quedar sin al menos un issue **[Stack]** que fije stack y librerías para ese bloque (ver `docs/STACK_POR_FASE.md` y ADR-001). Cada rollup `Fase N — …` (fases 0 y 2–5) debe tener un **[Stack] Fase N — …** de la fase; la **Fase 1** no usa rollup en GitHub (solo sprints `Fase 1 · S#`). Script: `python scripts/ensure_milestone_stack_and_coverage.py --all-repos --dry-run` / `--apply`. Orquestador: `python scripts/full_project_health.py --dry-run` / `--apply`.

---

## 6. Como leer un Issue

- **ID de ticket (obligatorio en roadmap/SCRUM):** formato estandar en [docs/TICKET_ID_CONVENTION.md](./docs/TICKET_ID_CONVENTION.md): **`[T##]`** alineado con [docs/ROADMAP_SPRINTS.md](./docs/ROADMAP_SPRINTS.md) (ej. `[T01] Definicion del stack`); tickets **`T0.1.*` / `T1.*.*`** con el plan maestro en [ROADMAP.md](./ROADMAP.md). También **`[E##-S##-##]`** para CSV SCRUM (ej. `[E05-S10-07] Document deployment`). No mezclar `T01:` sin corchetes con `[E5-S10-07]` sin ceros.
- **Prefijo tematico (otros issues):** `[Setup]`, `[DB]`, `[Scraper]`, etc. Evita titulos solo tipo `T3.1.1: Provider factory` como titulo principal; el ID puede ir en el cuerpo.
- **Orden en el Project:** **View** → **Sort** → **Title** → **Ascending** para recorrer T01→T99 y E01-S01-01→… en orden.
- **Cuerpo:** descripcion, criterios de aceptacion, enlace a milestone o fase.
- **Labels:** un `role/*` y un `priority/P0`…`P3` cuando apliquen; etapas = **Status** del Project, no etiquetas.
- **Milestone:** sprint o fase (rollup).

---

## 7. Flujo de trabajo semanal

1. **Inicio de sprint:** Elegir 5-7 items del Backlog y pasarlos a **Ready** (cada uno con `role/*` asignado).
2. **Cada dia:** Elige **rol** del dia → filtra el Project por `label:role/...` → **1** item en **In progress**; base Git **`develop`** (ver [§3.2](#32-ramas-git-solo-main-y-develop)); hasta **In review** antes de coger otro.
3. **Fin de semana:** Revisar **Done**, actualizar [CURSOR_CONTEXT.md](./CURSOR_CONTEXT.md) con sprint activo y ultimo issue cerrado.

---

## 8. Reglas del proyecto

- **WIP = 1** en **In progress** (solo dev).
- **Ramas:** solo **`main`** y **`develop`** en el remoto; integra en **`develop`**, **`main`** solo por release/hotfix; no commits directos a `main` salvo hotfix acordado.
- PRs pequenos; un issue = un PR cuando sea posible.
- Documentar decisiones en ADR/ cuando afecten arquitectura.
- No commitear secrets; usar .env y variables de entorno.

---

## 9. Arquitectura del sistema

Monolito modular o servicios separados (API ERP, CRM, workers). Ver [docs/Esqueleto.md](./docs/Esqueleto.md) para alcance funcional completo.

---

## 10. Tech Stack confirmado

Decisión **ACEPTADA** en [ADR-001](./ADR/ADR-001-stack-tecnologico.md) (2026-03-22): **React Native + Expo (SDK 51+)**, **TypeScript strict**, **Supabase** (Auth, Postgres, RLS, Storage, Realtime, Edge Functions), **FastAPI** (Python 3.12) para worker/jobs pesados, **Playwright** para integración SAE, **GitHub Actions** + **Expo EAS**, **WatermelonDB** reservado para **Fase 5**. Variables: [`.env.example`](./.env.example). Desglose por fase: **[docs/STACK_POR_FASE.md](./docs/STACK_POR_FASE.md)**. **Conexión real** (proyecto Supabase + `.env` relleno) y **Excel SAE** documentado: **en progreso** — §16.

---

## 11. Decisiones tecnicas pendientes

La **base** del stack está cerrada (ADR-001). Pendientes típicos por etapa: BI, fiscal electrónico, librería de gráficos, proveedor de transcripción, etc. → ver columnas *A definir* en [STACK_POR_FASE.md](./docs/STACK_POR_FASE.md) o nuevos ADR cuando entren en alcance. Ver también [ADR/](./ADR/) y `DECISIONS.md` si existe.

---

## 12. Estrategia de construccion

| Fase | Nombre        | Meses  | Hito                            |
|------|---------------|--------|----------------------------------|
| 1    | App Satelite  | 1–3    | Operaciones de campo activas     |
| 2    | ERP Basico    | 4–7    | SAE parcialmente reemplazado     |
| 3    | ERP Completo  | 8–10   | SAE reemplazado totalmente       |
| 4    | CRM           | 11–12  | Gestion comercial activa         |
| 5    | Offline-First | 13–14  | App funciona sin internet        |

---

## 13. Estructura de carpetas

```
ERP1/                     # Raiz del monorepo (ver README.md aqui)
├── setup-erp-project.sh   # Setup Project 11 (repo, Status, Status update, vincula issues)
└── erp-satelite/          # Repo Git: solo ramas permanentes main + develop (ver README §3.2)
    ├── ADR/               # Architecture Decision Records
    ├── docs/               # STACK_POR_FASE, ROADMAP_SPRINTS (T01–T35), GITHUB_PROJECTS, EXCEL_ANALYSIS…
    ├── apps/mobile/        # Expo (React Native + Router + NativeWind); ver apps/mobile/.env.example
    ├── worker/             # FastAPI (jobs pesados); uvicorn app.main:app desde worker/
    ├── scraper/            # Playwright + Python; pip install -r scraper/requirements.txt && playwright install
    ├── scripts/            # Python, PowerShell, JSON, GraphQL (tablero, vistas, migraciones)
    ├── .github/workflows/  # ci.yml, daily-progress.yml
    ├── README.md
    ├── ROADMAP.md
    ├── CURSOR_CONTEXT.md
    └── .env.example
```

---

## 14. Timeline del proyecto

- **Mes 3** — App Satelite MVP operativa.
- **Mes 7** — ERP Basico (catalogos, compras, ventas, inventario).
- **Mes 10** — ERP Completo (contabilidad, RRHH).
- **Mes 12** — CRM activo.
- **Mes 14** — Offline-First.

---

## 15. Glosario

| Termino   | Significado                                      |
|-----------|--------------------------------------------------|
| SAE       | Sistema actual a reemplazar.                     |
| OV        | Orden de venta.                                  |
| OC        | Orden de compra.                                 |
| inventario_restauracion | Conteo que dispara orden de compra.      |
| App Satelite | App movil para campo, paralela al SAE.        |

---

## 16. Setup inicial y scripts

### Fase 0 — Fundación (checklist)

| Paso | Ticket | Acción | Estado |
|------|--------|--------|--------|
| 1 | T0.1.1 | Repo + ramas `main` / `develop` ([§3.2](#32-ramas-git-solo-main-y-develop)). | Hecho |
| 2 | T0.1.2 | Crear proyecto en [Supabase](https://supabase.com); copiar URL y keys. | **En progreso** |
| 3 | T0.1.3 | Revisar [ADR-001](./ADR/ADR-001-stack-tecnologico.md) (stack aceptado). | Hecho |
| 4 | T0.1.4 | `cp .env.example .env` (o equivalente en Windows) y rellenar **sin** subir `.env`. | **En progreso** |
| 5 | T0.1.5–T0.1.6 | [docs/EXCEL_ANALYSIS.md](./docs/EXCEL_ANALYSIS.md) + [docs/SAE_DATA_MAPPING.md](./docs/SAE_DATA_MAPPING.md) al tener export del SAE. | **En progreso** |
| 6 | T0.1.7 | [CURSOR_CONTEXT.md](./CURSOR_CONTEXT.md) alineado con ADR (ya referenciado). | Hecho |

### Setup del proyecto (desde raiz ERP1)

```bash
bash setup-erp-project.sh
```

El script (en la raiz del monorepo, fuera de `erp-satelite`) configura: repo (descripcion, topics), vincula issues al Project 11, crea opciones Status (Icebox…Done), crea campo **Status update**, setea Status=Backlog en todos los items. Requiere `gh` autenticado. Tras ejecutar: activar workflows 2–7 en el navegador ([Workflows](https://github.com/users/Abraha33/projects/11/workflows)).

### Pack experto (Priority board)

Para tablero legible: totales Size con sentido, prioridad coherente, corte "solo esta semana".

```bash
cd erp-satelite
python scripts/priority_board_hygiene.py --dry-run --fill-size --bump-active-priority   # ver que hara
python scripts/priority_board_hygiene.py --fill-size --bump-active-priority               # aplicar
```

PowerShell: `.\scripts\apply-priority-board-expert.ps1 -Run`

### Scripts (tabla completa)

| Script | Uso |
|--------|-----|
| `project_workflows_status.py --from-num 2 --to-num 7` | Que workflows estan ON/OFF. No puede activarlos por API. |
| `open-project-workflows.ps1` | Abre Workflows del Project 11 en el navegador. |
| `priority_board_hygiene.py` | Size en columnas activas vacias + No Priority → P2 en Ready/In progress/In review. |
| `bulk_triage_project_items.py --dry-run` / `--priority P3 --assignee Abraha33` | Rellena Priority y Assignees en items vacios. |
| `list_items_missing_priority.py` | Lista items sin campo Priority. |
| `verify_priority_board_layout.py` | Comprueba Group by=Priority, columnas=Status (paridad Factura). |
| `verify_team_items_layout.py` | Comprueba Table + Group by Status (paridad Factura Team items). |
| `set_all_project_items_backlog.py` | Todos los items → Backlog (limpiar "No Status"). |
| `set_issue_project_status.py` | Project 11: `--issue N` o `N,M` y `--status` (Icebox…Done). Ej. fundación: #195 In progress, #194,196–198 Ready. |
| `migrate_status_to_priority_board.py` | Aplica schema Status (Icebox…Done) tras cambiar GraphQL. |
| `migrate_priority_palette.py` | Restaura P0–P3 tras cambiar colores Priority. |
| `ensure_role_labels.py` | Crea solo `role/*` y `priority/P0`…`P3` en el repo (idempotente). |
| `harmonize_legacy_role_labels.py` | Quita `frontend`/`backend`/`database`/`docs` si ya hay `role/*`; migra legacy → `role/*` si faltaba. |
| `apply_role_labels_to_issues.py` | Asigna `role/*` a issues sin rol (heuristicas por titulo). |
| `merge_empty_priority_to_no_priority.py` | Unifica filas *No priority*: asigna opcion **No Priority** a items con Priority vacio (Project 11). |
| `apply-team-view-fields.ps1` | PATCH columnas vista Equipo (views/3). |
| `create-project-views.ps1` | Recrea vistas si las borras (view-*.json). |

**Archivos JSON/GraphQL:** `view-priority-foco-semana.json`, `patch-view-priority-board.json`, `patch-view-team-visible-fields.json`, `field-status-update.json`, `field-size.json`, `field-roadmap-inicio.json`, `field-roadmap-fin.json`, `field-priority.json`; `graphql/replace-status-priority-board.graphql`, `graphql/replace-priority-palette.graphql`, `graphql/project-workflows.graphql`, etc.

---

## 17. Stack por fase (tecnologías por etapa)

Cada fase del roadmap usa un **subconjunto** del stack total; así evitas adelantar offline, CRM o BI antes de tiempo.

| Fase | Qué define |
|------|-----------|
| **0** Fundación | Git, `gh`, ADR, análisis Excel — sin app en producción. |
| **1** App Satélite | Expo + Supabase + import Excel + **Python/Playwright (scraper)**. |
| **2** ERP básico | Lo anterior + módulos web/MVP (catálogos, compras, ventas, stock); reportes ligeros; fiscal TBD. |
| **3** ERP completo | Contabilidad, RRHH, reportes avanzados (BI opcional), auditoría fuerte. |
| **4** CRM | WhatsApp Cloud API, workers, transcripción; inbox en la misma app. |
| **5** Offline-first | **WatermelonDB**, sync, conflictos; cloud sigue siendo Supabase. |

Detalle tabla por tabla: **[docs/STACK_POR_FASE.md](./docs/STACK_POR_FASE.md)**. Cierra opciones globales en [ADR-001](./ADR/ADR-001-stack-tecnologico.md).

---

## Documentacion

- [ROADMAP.md](./ROADMAP.md) — Plan maestro por fases (0–5) y tickets T0.x–T5.x
- [docs/ROADMAP_SPRINTS.md](./docs/ROADMAP_SPRINTS.md) — Vista por sprints T01–T35 (arranque)
- [docs/Esqueleto.md](./docs/Esqueleto.md) — Alcance funcional ERP + CRM
- [docs/STACK_POR_FASE.md](./docs/STACK_POR_FASE.md) — Stack tecnológico por fase (Satélite, ERP, CRM, offline)
- [docs/GITHUB_PROJECTS.md](./docs/GITHUB_PROJECTS.md) — Tablero ultra-lean (solo dev), vistas, pack experto, scripts
- [docs/GITHUB_PROJECT_WORKFLOWS.md](./docs/GITHUB_PROJECT_WORKFLOWS.md) — Workflows del Project (activar 2–7)
- [docs/EXCEL_ANALYSIS.md](./docs/EXCEL_ANALYSIS.md) — Estructura del Excel del SAE
- [docs/SAE_DATA_MAPPING.md](./docs/SAE_DATA_MAPPING.md) — Mapeo SAE/export → tablas ERP (compras, traslados, productos, terceros)
- [CURSOR_CONTEXT.md](./CURSOR_CONTEXT.md) — Contexto para el asistente IA
- [.github/workflows/daily-progress.yml](./.github/workflows/daily-progress.yml) — Automatizacion push/PR/schedule
- [docs/TICKET_ID_CONVENTION.md](./docs/TICKET_ID_CONVENTION.md) — Formato `[T##]` y `[E##-S##-##]` en titulos; orden en el Project
