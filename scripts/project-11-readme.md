# ERP Satélite — Project 11

Tablero del producto. Repo: [github.com/Abraha33/erp-satelite](https://github.com/Abraha33/erp-satelite)

## Stack

Por definir. Ver [ADR-001](https://github.com/Abraha33/erp-satelite/blob/main/ADR/ADR-001-stack-tecnologico.md).

## Columnas del tablero (Status)

Orden: **Icebox** → **Backlog** → **Ready** → **In progress** → **In review** → **Done**

| Columna | Significado |
|---------|-------------|
| **Icebox** | Ideas fuera del plan activo (nevera). |
| **Backlog** | En roadmap ~14 meses, aún no en sprint. |
| **Ready** | Cola del sprint (5–7 tickets). |
| **In progress** | En desarrollo (WIP = 1). |
| **In review** | Pruebas / self-review. |
| **Done** | Completado. |

## Campos personalizados

- **Priority** — P0 (urgente), P1 (sprint), P2 (media), P3 (baja)
- **Size** — número (Estimate)
- **Status update** — texto (bloqueo, avance por tarjeta)
- **Roadmap · inicio** / **Roadmap · fin** — fechas para timeline

## Vistas

| Vista | Enlace | Uso |
|-------|--------|-----|
| **Priority board** | [views/2](https://github.com/users/Abraha33/projects/11/views/2) | Board: columnas = Status, filas = Priority (P0–P3). Group by Priority, Column field Status. |
| **Equipo · inventario** | [views/3](https://github.com/users/Abraha33/projects/11/views/3) | Tabla: Slice by Assignees, Group by Status. Paridad Factura SaaS. |
| **Mis ítems** | [views/5](https://github.com/users/Abraha33/projects/11/views/5) | assignee:@me |
| **Foco semana** | [views/10](https://github.com/users/Abraha33/projects/11/views/10) | Solo Ready + In progress + In review. |
| **Roadmap · 14 meses** | [views/8](https://github.com/users/Abraha33/projects/11/views/8) | Timeline con Roadmap inicio/fin, filtro -status:Done. |

## Workflows (7)

No hay API para activarlos; configurar en [Workflows](https://github.com/users/Abraha33/projects/11/workflows). Guía: [GITHUB_PROJECT_WORKFLOWS.md](https://github.com/Abraha33/erp-satelite/blob/main/docs/GITHUB_PROJECT_WORKFLOWS.md)

1. Item added → Backlog
2. Issue/PR closed → Done
3. PR merged → Done
4. Issue reopened → Backlog
5. Auto-close (Status Done → cerrar issue)
6. Auto-add (repo erp-satelite, is:issue)
7. Auto-archive (opcional)

**Daily Progress** (workflow del repo): push/PR/schedule actualiza Status automáticamente. Secret `PROJECTS_TOKEN` recomendado.

## Setup y scripts

- **Setup:** `bash setup-erp-project.sh` (desde raíz ERP1)
- **Pack experto:** `python scripts/priority_board_hygiene.py --fill-size --bump-active-priority`
- **Workflows ON/OFF:** `python scripts/project_workflows_status.py --from-num 2 --to-num 7`
- **Triage:** `python scripts/bulk_triage_project_items.py --priority P3 --assignee Abraha33`
- **Verificar layouts:** `verify_priority_board_layout.py`, `verify_team_items_layout.py`
