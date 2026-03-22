# GitHub Project 11 — Workflows (automatizaciones)

Los **workflows** del proyecto **no** se pueden activar por CLI/API de forma soportada: hay que hacerlo en el navegador. Esta guía lista **7** automatizaciones alineadas con el campo **Status** (**Icebox**, **Backlog**, **Ready**, **In progress**, **In review**, **Done**) y el repo **`Abraha33/erp-satelite`**.

**Enlace directo:** [Project 11 → Workflows](https://github.com/users/Abraha33/projects/11/workflows)

Ruta manual: proyecto → menú **···** (arriba a la derecha) → **Workflows**.

### Activar workflows **nº 2 a 7** (numeración de GitHub)

En la UI, cada automatización lleva un **número interno** (no siempre coincide con el orden de la tabla de abajo). Para ver qué falta **sin adivinar**:

```bash
cd erp-satelite
python scripts/project_workflows_status.py --from-num 2 --to-num 7
```

- Salida **OFF** → abre el enlace que imprime el script, entra en ese workflow → **Edit** → ajusta disparadores/estado (según filas de abajo) → **Save and turn on workflow**.
- **No existe API pública** para encenderlos desde `gh`/GraphQL; solo lectura del campo `enabled` y borrado (`deleteProjectV2Workflow`).

**Orden práctico en Project 11 (rango 2–7):** suele incluir *Pull request merged*, *Auto-close issue*, *Auto-add sub-issues*, *Pull request linked*, *Item added to project*, *Auto-add to project*. Los dos de auto-add pueden llevar reglas distintas; revisa que el repo sea **`Abraha33/erp-satelite`** y el **Status** coincida con **Done** / **Backlog** según el caso.

Opcional (Windows): `powershell -File scripts/open-project-workflows.ps1` abre la página de Workflows en el navegador.

---

## Checklist: 7 workflows

Para cada fila: abre el workflow → **Edit** → ajusta valores → **Save and turn on workflow** (o confirma que ya está **ON**).

| # | Workflow (nombre en inglés en la UI) | Configuración recomendada |
|---|----------------------------------------|---------------------------|
| 1 | **Item added to project** | **Set status** → **Backlog** (trabajo que entra al tablero va al plan ejecutable). Las ideas “de nevera” las mueves tú a **Icebox** a mano cuando no quieras mezclarlas con Backlog. |
| 2 | **Issue or pull request closed** *(o similar)* | **Set status** → **Done** (cuando cierras el issue/PR en GitHub, el ítem pasa a Done). Suele venir activo por defecto. |
| 3 | **Pull request merged** | **Set status** → **Done** (al mergear el PR, tarjeta en Done). Suele venir activo por defecto. |
| 4 | **Issue reopened** *(si aparece en tu lista)* | **Set status** → **Backlog** (al reabrir un issue, vuelve al cajón de planificación; luego tú lo mueves a **Ready** si entra al sprint). |
| 5 | **Auto-close issue** *(auto-close cuando el status del proyecto cambia)* | Disparador: cuando el **Status** del ítem pasa a **Done** → **cerrar el issue** en el repo (evita cerrar dos veces). Comprueba que el estado elegido sea exactamente **Done** (como en el campo del proyecto). |
| 6 | **Auto-add to project** | Repositorio: **`Abraha33/erp-satelite`**. Filtro sugerido: **`is:issue`** (entran issues nuevos/actualizados que cumplan el filtro). Opcional: **`is:issue assignee:Abraha33`** si solo quieres auto-añadir lo asignado a ti. *En GitHub Free solo hay **1** workflow de auto-add; en Pro/Team puedes duplicar y añadir más filtros/repos.* |
| 7 | **Auto-archive items** | Opcional. Si lo activas, usa un filtro **conservador** para no archivar trabajo vivo, p. ej. **`is:closed reason:completed updated:<@today-90d`** (issues cerrados como completados y sin actividad reciente en el proyecto). Revisa la [documentación de auto-archive](https://docs.github.com/en/issues/planning-and-tracking-with-projects/automating-your-project/archiving-items-automatically). Si no estás seguro, déjalo **OFF**. |

---

## Coherencia con el tablero

- Los nombres **Backlog**, **Done**, **Icebox**, etc. deben coincidir **exactamente** con las opciones del campo **Status** del Project.
- **Auto-close** (tabla #5) y **item cerrado → Done** (nombre en UI tipo *Item closed*) trabajan en conjunto: mueves a **Done** en el proyecto → se cierra el issue; cierras el issue en GitHub → la tarjeta pasa a **Done** en el proyecto.

---

## Scripts en el repo

| Script | Uso |
|--------|-----|
| `scripts/project_workflows_status.py` | Lista workflows y cuáles están **OFF** en un rango de números GitHub (p. ej. `--from-num 2 --to-num 7`). |
| `scripts/graphql/project-workflows.graphql` | Query usada por el script anterior. |
| `scripts/open-project-workflows.ps1` | Abre [Workflows del Project 11](https://github.com/users/Abraha33/projects/11/workflows) en el navegador. |

---

## Plan y límites

- **Auto-add:** en cuenta **Free** el límite es **1** workflow de este tipo; en **Pro/Team** hasta **5** (puedes duplicar el workflow para más filtros). Ver [Adding items automatically](https://docs.github.com/en/issues/planning-and-tracking-with-projects/automating-your-project/adding-items-automatically).

---

## Referencias oficiales

- [Using the built-in automations](https://docs.github.com/en/issues/planning-and-tracking-with-projects/automating-your-project/using-the-built-in-automations)
- [Adding items automatically](https://docs.github.com/en/issues/planning-and-tracking-with-projects/automating-your-project/adding-items-automatically)
- [Archiving items automatically](https://docs.github.com/en/issues/planning-and-tracking-with-projects/automating-your-project/archiving-items-automatically)
