# ERP Satelite Operativa

Sistema empresarial completo (ERP + CRM) construido por un solo founder en 14 meses.
Stack: por definir. Ver [ADR-001](./ADR/ADR-001-stack-tecnologico.md).

---

## INDICE

1. [Que es este proyecto](#1-que-es-este-proyecto)
2. [Como leer el tablero Projects](#2-como-leer-el-tablero-projects)
3. [Como operar el tablero dia a dia](#3-como-operar-el-tablero-dia-a-dia)
   - [3.2 Fork vs ramas Git y flujo main / develop](#32-fork-vs-ramas-git-y-flujo-main--develop)
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

### 3.2 Fork vs ramas Git y flujo main / develop

En GitHub, **fork** es una **copia del repo** bajo otra cuenta u organizacion (para contribuir con PRs desde afuera). **No** es una rama. Este proyecto se desarrolla en el repo canonico **`Abraha33/erp-satelite`**; como solo dev **no necesitas un fork** salvo que quieras experimentar aislado.

**Ramas oficiales y para que sirven:**

| Rama / tipo | Quien la usa | Proposito |
|-------------|--------------|-----------|
| **`main`** | Release | Codigo **estable** alineado a lo que puedes considerar produccion o demo seria. Solo entra con merge desde `develop` (o hotfix excepcional). |
| **`develop`** | Dia a dia | **Integracion**: aqui van los PRs del sprint. Es la base que actualizas al empezar una tarea nueva. Debe compilar y pasar CI razonablemente. |
| **`dev`** (legacy) | Opcional | Si aun existe en remotos viejos, tratala como alias obsoleto de `develop`; nuevos flujos usan **`develop`**. |
| **Ramas de trabajo** | Por ticket | Creadas **desde `develop`**, nombre recomendado `feature/<rol>-<tema>` o `feature/issue-NNN-desc` (ej. `feature/database-issue-202-rls`). **Vida corta**; un PR → **`develop`**. |

**Flujo resumido:** `feature/...` → PR → **`develop`** → (cuando cierre hito) PR **`develop`** → **`main`**.

**Rutina diaria (git):**

1. `git checkout develop && git pull origin develop`
2. `git checkout -b feature/<rol>-<tema>`
3. Commits; abre PR hacia **`develop`**.
4. Tras merge, borra la rama de trabajo; al cerrar sprint/hito, integra **`develop`** → **`main`**.

### 3.3 Roles de desarrollo

Eres **un solo dev**; los **roles** (`role/frontend`, `role/database`, …) son *sombreros* para enfocar el dia. No confundir con **roles de producto** en [CURSOR_CONTEXT.md](./CURSOR_CONTEXT.md) (administrador / encargado / empleado): esos son RBAC en la app.

**Rutina diaria (tablero):**

1. En el Project, filtra por **un** label `role/*` (o una vista guardada; ver [docs/GITHUB_PROJECTS.md](./docs/GITHUB_PROJECTS.md#vistas-por-rol-en-el-project)).
2. Entre tickets **Ready** con ese rol, elige uno (puede ser al azar **si** no hay P0 bloqueante ni dependencias sin resolver).
3. Mueve **una** tarjeta a **In progress** (WIP = 1).
4. Abre la rama de trabajo desde **`develop`** (ver §3.2).

**Etiquetar issues:** cada ticket deberia tener **un** `role/*` principal. Mantener `area/*` y `tipo/*` como hasta ahora; ver tabla en [§4](#4-sistema-de-labels). Crear labels en el repo: `python scripts/ensure_role_labels.py`.

---

## 4. Sistema de Labels

**Colores en GitHub Projects** (Status / Priority): [paleta en GITHUB_PROJECTS.md](./docs/GITHUB_PROJECTS.md#paleta-de-color-project-11).

**Vista Equipo (tabla):** labels `area/*` y `tipo/*` para chips en **Labels** — [tabla recomendada](./docs/GITHUB_PROJECTS.md#etiquetas-en-issues-chips-en-team-view). Filtros por asignado / sin asignar / persona: [guía](./docs/GITHUB_PROJECTS.md#filtros-por-assignees-sin-asignar-y-por-persona) (`no:assignee`, `assignee:@me`, **Slice by Assignees**).

| Label | Uso |
|-------|-----|
| **Roles de trabajo (`role/*`)** | **Uno por issue** — sombrero del dia / filtro del tablero (ver [§3.3](#33-roles-de-desarrollo)). |
| `role/frontend` | Expo / RN / UI de producto. |
| `role/backend` | API, reglas de negocio, servicios. |
| `role/database` | Schema, migrations, RLS, SQL, Supabase. |
| `role/platform` | Repo, CI/CD, scripts, `.env`, hygiene GitHub Project. |
| `role/integration` | Excel SAE, scraper, import/export, datos legacy. |
| `role/qa-release` | Pruebas en dispositivo, checklist release, verificacion antes de Done. |
| `role/crm` | WhatsApp, conversaciones, pipeline (fases CRM). |
| `role/offline-sync` | Base local, sync, conflictos (fase offline-first). |
| `role/security` | Auth, secretos, hardening, revision authz. |
| `role/docs-adr` | README, ADR, CURSOR_CONTEXT, guias. |
| `alta`, `media`, `baja` | Prioridad (no duplicar con campo Priority). |
| `backend`, `frontend`, `database`, `docs` | Etiquetas genericas legacy; preferir `role/*` + `area/*`. |
| `MVP` | Bloqueante para MVP. |
| `Sprint-N` | Asociado al sprint N. |
| `fase-0` … `fase-5` | Fase del roadmap. |
| `area/app`, `area/api`, `area/db`, `area/docs` | Ambito tecnico (chips en vista Equipo). |
| `area/web`, `area/mobile` | Opcional: refinan `role/frontend` (web vs nativo). |
| `tipo/bug`, `tipo/feature`, `tipo/chore` | Tipo de trabajo. |

**Equivalencia rapida:** `role/frontend` ≈ `area/app`; `role/backend` ≈ `area/api`; `role/database` ≈ `area/db`; `role/docs-adr` ≈ `area/docs`. Si un issue toca dos capas, elige el rol donde cae **la mayor parte del esfuerzo** y menciona la otra en el cuerpo.

---

## 5. Sistema de Milestones

Los milestones siguen el [ROADMAP.md](./ROADMAP.md):

- **Fase 0** — Fundacion (repo, stack, Excel)
- **Fase 1** — App Satelite MVP (Mes 1–3)
- **Fase 2** — ERP Basico (Mes 4–7)
- **Fase 3** — ERP Completo (Mes 8–10)
- **Fase 4** — CRM (Mes 11–12)
- **Fase 5** — Offline-First (Mes 13–14)

---

## 6. Como leer un Issue

- **ID de ticket (obligatorio en roadmap/SCRUM):** formato estandar en [docs/TICKET_ID_CONVENTION.md](./docs/TICKET_ID_CONVENTION.md): **`[T##]`** alineado con [ROADMAP.md](./ROADMAP.md) (ej. `[T01] Definicion del stack`) o **`[E##-S##-##]`** para tickets del CSV SCRUM (ej. `[E05-S10-07] Document deployment`). No mezclar `T01:` sin corchetes con `[E5-S10-07]` sin ceros.
- **Prefijo tematico (otros issues):** `[Setup]`, `[DB]`, `[Scraper]`, etc. Evita titulos solo tipo `T3.1.1: Provider factory` como titulo principal; el ID puede ir en el cuerpo.
- **Orden en el Project:** **View** → **Sort** → **Title** → **Ascending** para recorrer T01→T99 y E01-S01-01→… en orden.
- **Cuerpo:** descripcion, criterios de aceptacion, enlace a milestone o fase.
- **Labels:** un `role/*` obligatorio para triage; `area/*`, `tipo/*`, `fase-*` segun convenga.
- **Milestone:** sprint o fase.

---

## 7. Flujo de trabajo semanal

1. **Inicio de sprint:** Elegir 5-7 items del Backlog y pasarlos a **Ready** (cada uno con `role/*` asignado).
2. **Cada dia:** Elige **rol** del dia → filtra el Project por `label:role/...` → **1** item en **In progress**; rama desde **`develop`** (ver [§3.2](#32-fork-vs-ramas-git-y-flujo-main--develop)); hasta **In review** antes de coger otro.
3. **Fin de semana:** Revisar **Done**, actualizar [CURSOR_CONTEXT.md](./CURSOR_CONTEXT.md) con sprint activo y ultimo issue cerrado.

---

## 8. Reglas del proyecto

- **WIP = 1** en **In progress** (solo dev).
- **Ramas:** trabajo en **`feature/*`** desde **`develop`**; merge a **`develop`**; **`main`** solo por release o hotfix; no commitear directo a `main` salvo hotfix acordado.
- PRs pequenos; un issue = un PR cuando sea posible.
- Documentar decisiones en ADR/ cuando afecten arquitectura.
- No commitear secrets; usar .env y variables de entorno.

---

## 9. Arquitectura del sistema

Monolito modular o servicios separados (API ERP, CRM, workers). Ver [docs/Esqueleto.md](./docs/Esqueleto.md) para alcance funcional completo.

---

## 10. Tech Stack confirmado

Por definir. Ver [ADR-001](./ADR/ADR-001-stack-tecnologico.md).

---

## 11. Decisiones tecnicas pendientes

Ver [ADR/](./ADR/) y [DECISIONS.md](./DECISIONS.md) (si existe).

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
└── erp-satelite/          # Repo Git: ramas main + develop; trabajo en feature/* desde develop
    ├── ADR/               # Architecture Decision Records
    ├── docs/               # GITHUB_PROJECTS.md, GITHUB_PROJECT_WORKFLOWS.md, Esqueleto, EXCEL_ANALYSIS
    ├── scripts/            # Python, PowerShell, JSON, GraphQL (tablero, vistas, migraciones)
    ├── .github/workflows/  # daily-progress.yml (push/PR/schedule)
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
| `migrate_status_to_priority_board.py` | Aplica schema Status (Icebox…Done) tras cambiar GraphQL. |
| `migrate_priority_palette.py` | Restaura P0–P3 tras cambiar colores Priority. |
| `ensure_role_labels.py` | Crea labels `role/*` y `area/web|mobile` en el repo (idempotente). |
| `merge_empty_priority_to_no_priority.py` | Unifica filas *No priority*: asigna opcion **No Priority** a items con Priority vacio (Project 11). |
| `apply-team-view-fields.ps1` | PATCH columnas vista Equipo (views/3). |
| `create-project-views.ps1` | Recrea vistas si las borras (view-*.json). |

**Archivos JSON/GraphQL:** `view-priority-foco-semana.json`, `patch-view-priority-board.json`, `patch-view-team-visible-fields.json`, `field-status-update.json`, `field-size.json`, `field-roadmap-inicio.json`, `field-roadmap-fin.json`, `field-priority.json`; `graphql/replace-status-priority-board.graphql`, `graphql/replace-priority-palette.graphql`, `graphql/project-workflows.graphql`, etc.

---

## Documentacion

- [ROADMAP.md](./ROADMAP.md) — Plan completo de fases y tickets
- [docs/Esqueleto.md](./docs/Esqueleto.md) — Alcance funcional ERP + CRM
- [docs/GITHUB_PROJECTS.md](./docs/GITHUB_PROJECTS.md) — Tablero ultra-lean (solo dev), vistas, pack experto, scripts
- [docs/GITHUB_PROJECT_WORKFLOWS.md](./docs/GITHUB_PROJECT_WORKFLOWS.md) — Workflows del Project (activar 2–7)
- [docs/EXCEL_ANALYSIS.md](./docs/EXCEL_ANALYSIS.md) — Estructura del Excel del SAE
- [CURSOR_CONTEXT.md](./CURSOR_CONTEXT.md) — Contexto para el asistente IA
- [.github/workflows/daily-progress.yml](./.github/workflows/daily-progress.yml) — Automatizacion push/PR/schedule
- [docs/TICKET_ID_CONVENTION.md](./docs/TICKET_ID_CONVENTION.md) — Formato `[T##]` y `[E##-S##-##]` en titulos; orden en el Project
