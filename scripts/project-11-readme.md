# ERP Satelite Operativa — Project 11

Tablero del producto: [github.com/users/Abraha33/projects/11](https://github.com/users/Abraha33/projects/11). Código: [github.com/Abraha33/erp-satelite](https://github.com/Abraha33/erp-satelite).

Sistema empresarial completo (ERP + CRM) construido por un solo founder en 14 meses.  
Stack: por definir. Ver [ADR-001](https://github.com/Abraha33/erp-satelite/blob/main/ADR/ADR-001-stack-tecnologico.md).

---

## INDICE

1. Que es este proyecto  
2. Como leer el tablero Projects  
3. Como operar el tablero dia a dia  
4. Sistema de Labels  
5. Sistema de Milestones  
6. Como leer un Issue  
7. Flujo de trabajo semanal  
8. Reglas del proyecto  
9. Arquitectura del sistema  
10. Tech Stack confirmado  
11. Decisiones tecnicas pendientes  
12. Estrategia de construccion  
13. Estructura de carpetas  
14. Timeline del proyecto  
15. Glosario  
16. Setup inicial y scripts  
17. Documentacion  

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

**Asignaciones:** en la practica todo va con **Assignees = tu usuario [@Abraha33](https://github.com/Abraha33)**. La vista *Mis ítems* filtra `assignee:@me` (eres tu); si un ticket no aparece, asignatelo.

**Status update:** campo de texto **Status update** por tarjeta (bloqueo, avance). Activalo en tablas **Equipo** / **Mis ítems**: menu **View** → campos visibles.

**Modo solo dev (ultra-lean):** [docs/GITHUB_PROJECTS.md](https://github.com/Abraha33/erp-satelite/blob/main/docs/GITHUB_PROJECTS.md). **Workflows (7):** [docs/GITHUB_PROJECT_WORKFLOWS.md](https://github.com/Abraha33/erp-satelite/blob/main/docs/GITHUB_PROJECT_WORKFLOWS.md). Estado: `python scripts/project_workflows_status.py --from-num 2 --to-num 7`.

### Workflows del Project (7 automatizaciones)

No hay API para activarlos; se configuran en [Project → Workflows](https://github.com/users/Abraha33/projects/11/workflows).

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

Orden: **Icebox** → **Backlog** → **Ready** → **In progress** → **In review** → **Done**. Detalle en [GITHUB_PROJECTS.md](https://github.com/Abraha33/erp-satelite/blob/main/docs/GITHUB_PROJECTS.md).

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

**Priority board:** campo **Priority (P0–P3)**; filtros `no:Priority` / `has:Priority` — [guía](https://github.com/Abraha33/erp-satelite/blob/main/docs/GITHUB_PROJECTS.md#filtros-priority-con-y-sin-valor). Paridad visual Factura SaaS: [GITHUB_PROJECTS.md](https://github.com/Abraha33/erp-satelite/blob/main/docs/GITHUB_PROJECTS.md#paridad-visual-con-tu-captura-factura-saas-priority-board). `python scripts/list_items_missing_priority.py` lista ítems sin prioridad. Opcional: **Foco de hoy** con **+ New view**.

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

El workflow [daily-progress.yml](https://github.com/Abraha33/erp-satelite/blob/main/.github/workflows/daily-progress.yml) actualiza el tablero automaticamente:

| Evento | Accion |
|--------|--------|
| **Push** con commit que referencia `#123` | Backlog → In progress (si el issue esta en Backlog) |
| **PR opened** | In review (issues vinculados con closingIssuesReferences) |
| **PR closed (merged)** | Done |
| **PR closed (no merged)** | Backlog |
| **Schedule** (14:00 UTC diario, ~9am UTC-5) | Comenta en issues abiertos con actividad en las ultimas 24h un resumen |

**Secret recomendado:** `PROJECTS_TOKEN` (PAT con scope `project`) para escribir en GitHub Projects. Si no existe, usa `github.token` (puede limitar permisos en forks).

---

## 4. Sistema de Labels

**Colores** (Status / Priority): [paleta](https://github.com/Abraha33/erp-satelite/blob/main/docs/GITHUB_PROJECTS.md#paleta-de-color-project-11).

**Vista Equipo:** labels `area/*` y `tipo/*` — [tabla recomendada](https://github.com/Abraha33/erp-satelite/blob/main/docs/GITHUB_PROJECTS.md#etiquetas-en-issues-chips-en-team-view). Filtros: [guía](https://github.com/Abraha33/erp-satelite/blob/main/docs/GITHUB_PROJECTS.md#filtros-por-assignees-sin-asignar-y-por-persona).

| Label | Uso |
|-------|-----|
| `alta`, `media`, `baja` | Prioridad (no duplicar con campo Priority). |
| `backend`, `frontend`, `database`, `docs` | Area tecnica. |
| `MVP` | Bloqueante para MVP. |
| `Sprint-N` | Asociado al sprint N. |
| `fase-0` … `fase-5` | Fase del roadmap. |
| `area/app`, `area/api`, `area/db`, `area/docs` | Ambito (chips en vista Equipo). |
| `tipo/bug`, `tipo/feature`, `tipo/chore` | Tipo de trabajo. |

---

## 5. Sistema de Milestones

Siguen el [ROADMAP.md](https://github.com/Abraha33/erp-satelite/blob/main/ROADMAP.md):

- **Fase 0** — Fundacion (repo, stack, Excel)
- **Fase 1** — App Satelite MVP (Mes 1–3)
- **Fase 2** — ERP Basico (Mes 4–7)
- **Fase 3** — ERP Completo (Mes 8–10)
- **Fase 4** — CRM (Mes 11–12)
- **Fase 5** — Offline-First (Mes 13–14)

---

## 6. Como leer un Issue

- **Titulo:** prefijo semantico + frase clara. Ejemplos: `[Setup] Inicializar Expo en blanco`, `[DB] Tabla productos y RLS`, `[Scraper] Login en SAE con Playwright`. Evita titulos solo tipo `T3.1.1: Provider factory` como titulo principal; el ID numerico puede ir en el cuerpo.
- **Cuerpo:** descripcion, criterios de aceptacion, enlace a milestone o fase.
- **Labels:** prioridad, area (setup, database, scraper, frontend).
- **Milestone:** sprint o fase.

---

## 7. Flujo de trabajo semanal

1. **Inicio de sprint:** Elegir 5-7 items del Backlog y pasarlos a **Ready**.
2. **Cada dia:** Como mucho **1** item en **In progress**; avanzar hasta **In review** antes de coger otro.
3. **Fin de semana:** Revisar **Done**, actualizar [CURSOR_CONTEXT.md](https://github.com/Abraha33/erp-satelite/blob/main/CURSOR_CONTEXT.md) con sprint activo y ultimo issue cerrado.

---

## 8. Reglas del proyecto

- **WIP = 1** en **In progress** (solo dev).
- PRs pequenos; un issue = un PR cuando sea posible.
- Documentar decisiones en ADR/ cuando afecten arquitectura.
- No commitear secrets; usar .env y variables de entorno.

---

## 9. Arquitectura del sistema

Monolito modular o servicios separados (API ERP, CRM, workers). Ver [docs/Esqueleto.md](https://github.com/Abraha33/erp-satelite/blob/main/docs/Esqueleto.md) para alcance funcional completo.

---

## 10. Tech Stack confirmado

Por definir. Ver [ADR-001](https://github.com/Abraha33/erp-satelite/blob/main/ADR/ADR-001-stack-tecnologico.md).

---

## 11. Decisiones tecnicas pendientes

Ver [ADR/](https://github.com/Abraha33/erp-satelite/tree/main/ADR) y [DECISIONS.md](https://github.com/Abraha33/erp-satelite/blob/main/DECISIONS.md) (si existe).

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
ERP1/                     # Raiz del monorepo
├── setup-erp-project.sh   # Setup Project 11 (repo, Status, Status update, vincula issues)
└── erp-satelite/
    ├── ADR/
    ├── docs/               # GITHUB_PROJECTS.md, GITHUB_PROJECT_WORKFLOWS.md, Esqueleto, EXCEL_ANALYSIS
    ├── scripts/            # Python, PowerShell, JSON, GraphQL
    ├── .github/workflows/  # daily-progress.yml
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

Configura: repo (descripcion, topics), vincula issues al Project 11, opciones Status (Icebox…Done), campo **Status update**, Status=Backlog en todos los items. Requiere `gh` autenticado. Luego activar workflows 2–7 en [Workflows](https://github.com/users/Abraha33/projects/11/workflows).

### Pack experto (Priority board)

```bash
cd erp-satelite
python scripts/priority_board_hygiene.py --dry-run --fill-size --bump-active-priority
python scripts/priority_board_hygiene.py --fill-size --bump-active-priority
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
| `apply-team-view-fields.ps1` | PATCH columnas vista Equipo (views/3). |
| `create-project-views.ps1` | Recrea vistas si las borras (view-*.json). |

**JSON/GraphQL:** `view-priority-foco-semana.json`, `patch-view-priority-board.json`, `patch-view-team-visible-fields.json`, `field-status-update.json`, `field-size.json`, `field-roadmap-inicio.json`, `field-roadmap-fin.json`, `field-priority.json`; `graphql/replace-status-priority-board.graphql`, `graphql/replace-priority-palette.graphql`, `graphql/project-workflows.graphql`, etc. (en `erp-satelite/scripts/`).

---

## 17. Documentacion

- [README.md](https://github.com/Abraha33/erp-satelite/blob/main/README.md) — Copia canónica en el repo (mismo contenido que este readme)
- [ROADMAP.md](https://github.com/Abraha33/erp-satelite/blob/main/ROADMAP.md) — Plan completo de fases y tickets
- [docs/Esqueleto.md](https://github.com/Abraha33/erp-satelite/blob/main/docs/Esqueleto.md) — Alcance funcional ERP + CRM
- [docs/GITHUB_PROJECTS.md](https://github.com/Abraha33/erp-satelite/blob/main/docs/GITHUB_PROJECTS.md) — Tablero ultra-lean, vistas, pack experto, scripts
- [docs/GITHUB_PROJECT_WORKFLOWS.md](https://github.com/Abraha33/erp-satelite/blob/main/docs/GITHUB_PROJECT_WORKFLOWS.md) — Workflows del Project (activar 2–7)
- [docs/EXCEL_ANALYSIS.md](https://github.com/Abraha33/erp-satelite/blob/main/docs/EXCEL_ANALYSIS.md) — Estructura del Excel del SAE
- [CURSOR_CONTEXT.md](https://github.com/Abraha33/erp-satelite/blob/main/CURSOR_CONTEXT.md) — Contexto para el asistente IA
- [daily-progress.yml](https://github.com/Abraha33/erp-satelite/blob/main/.github/workflows/daily-progress.yml) — Automatizacion push/PR/schedule
