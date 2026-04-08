# Taxonomía de tickets: labels, milestones, tallas

## Labels (sugeridos)

Alineados con scripts del repo (`ensure_role_labels.py`, import CSV). Ajustar en GitHub si el set real difiere.

| Prefijo | Ejemplos | Uso |
|---------|----------|-----|
| **`role/`** | `role/backend`, `role/frontend`, `role/database`, `role/devops`, `role/qa`, `role/design`, `role/product`, `role/platform` | Área principal del trabajo |
| **`priority/`** | `priority/P0` … `priority/P3` | Urgencia (P0 máxima) |
| **`type/`** | `type/bug`, `type/feature`, `type/chore`, `type/docs` | Naturaleza del cambio |
| **`module/`** | `module/inventario`, `module/compras`, `module/auth` | Módulo ERP (opcional hasta que el set esté fijado) |

**Nota:** **Backlog / In progress / Done** son valores del campo **Status** del Project, no labels (ver [WORKFLOW.md](./WORKFLOW.md)).

## Milestones por fase (F0–F5)

| Fase | Nombre (roadmap) | Enfoque |
|------|------------------|---------|
| **F0** | Fundación | Repo, docs, análisis, sin producto en prod. |
| **F1** | App Satélite MVP | Campo + Supabase + Excel/scraper. |
| **F2** | ERP básico | Catálogos, compras, ventas, inventario. |
| **F3** | ERP completo | Contabilidad, RRHH, reportes, auditoría. |
| **F4** | CRM | WhatsApp/Meta, pipeline comercial. |
| **F5** | Offline-first | Room, WorkManager, sync, conflictos. |

Los nombres exactos de milestones en GitHub pueden generarse con scripts (`ensure_roadmap_milestones.py`, etc.); ver [TICKET_ID_CONVENTION.md](./TICKET_ID_CONVENTION.md) para mapeo CSV ↔ milestone.

## Tallas (estimación relativa)

| Talla | Significado orientativo |
|-------|-------------------------|
| **XS** | < 2 h; cambio localizado, bajo riesgo. |
| **S** | Medio día; unos pocos archivos o una migración pequeña. |
| **M** | 1–2 días; varias capas (UI + API/RLS) o diseño moderado. |
| **L** | 3–5 días; épica técnica o varios módulos; conviene dividir. |
| **XL** | > 1 semana o alto riesgo; **debe** descomponerse antes de entrar a sprint. |

Calibración con horas reales: [estimation-and-definition-of-done.md](./estimation-and-definition-of-done.md).

## Título del issue

Formato canónico: [TICKET_ID_CONVENTION.md](./TICKET_ID_CONVENTION.md).
