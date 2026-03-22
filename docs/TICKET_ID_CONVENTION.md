# Convención de IDs en títulos de issues

## Formato canónico

Todo issue debe llevar el **ID entre corchetes al inicio**, un espacio y luego el título legible:

```text
[ID] Descripción corta en español o inglés
```

### 1) Tickets del ROADMAP (sprints 14 meses)

- Patrón: **`[T##]`** con **dos dígitos** (`T01` … `T99`).
- Alineado con [ROADMAP.md](../ROADMAP.md) (columna *Ticket*).
- Ejemplo: `[T01] Definición y documentación del Stack en el README`.

**No usar:** `T01:` sin corchetes (legacy).

### 2) Tickets granulares (SCRUM / CSV / épicas)

- Patrón: **`[E##-S##-##]`** — Epic (2 dígitos), Sprint (2 dígitos), ítem (2 dígitos).
- Ejemplo: `[E05-S10-07] Document deployment and prod env` (antes `[E5-S10-07]`).

**Por qué el padding:** así el orden **Título ascendente** en GitHub Projects coincide con el orden lógico (`E05-S09-07` antes que `E05-S10-01`). Sin ceros, `E5-S10-01` quedaría antes que `E5-S9-07` al ordenar por texto.

### 3) Cruce ROADMAP ↔ SCRUM

Son planificaciones distintas: un **T03** no tiene por qué ser el mismo trabajo que **E1-S1-03**. Si hace falta trazabilidad, en el **cuerpo** del issue añade:

```markdown
**Ref SCRUM:** E05-S10-07
```

o

```markdown
**Ref ROADMAP:** T06
```

---

## Orden “de primero a último” en el Project

1. Abre la vista (tabla o board).
2. **View** (engranaje junto al filtro) → **Sort** → **Title** → **Ascending**.

Con los formatos anteriores, los **T##** quedan agrupados y ordenados; los **E##-S##-##** quedan en orden épica → sprint → ítem.

**Mezcla `[E…]` y `[T…]`:** al ordenar solo por **Title**, en ASCII las **`E`** van **antes** que las **`T`** (letra `E` < `T`). Si quieres primero el bloque ROADMAP (T01…) y luego los épicos, usa **Sort** por **Milestone** / **Sprint** o un campo numérico *Order* en el proyecto; o unifica todo a un solo prefijo y deja la referencia cruzada en el cuerpo del issue.

**Opcional:** si el orden por título no te basta, usa **Sort** por **Milestone** y luego **Title**, o un campo numérico propio (*Order*) en el proyecto.

---

## Import CSV

El script [scripts/import-backlog-to-github.py](../scripts/import-backlog-to-github.py) formatea títulos como `[ID] título`. Los IDs del CSV se normalizan a `[E##-S##-##]` al crear issues. Asigna **milestone por sprint** dentro de cada fase 1–5 cuando aplica (ver `scripts/roadmap_milestones.py`). Antes: `python scripts/ensure_roadmap_milestones.py`.

Para alinear milestones en issues ya existentes: `python scripts/sync_issue_milestones.py --dry-run` → `--apply`. Tickets **`T{phase}.{sprint}.*`** usan `Fase {phase} · S{sprint} — …` (Fase **1** = ERP Satélite, S1–S5; F2–F4 y F5 según ROADMAP). También existen rollups `Fase N — …` por fase. CSV: sprints **1–6** → F1; **7–10** → F2; meses 4–7 / 8–10 también mapean a sprints F2/F3.

**Épicas `[E*-S##-*]` con sprint mayor a 10:** el script asigna **Fase 3 · S#** (S15–S20 → S1–S4), **Fase 4 · S#** (S21–S24 → S1–S4), **Fase 5 · S#** (S25–S28 → S1–S2). **Fase 4 · S5** (historial cliente) sigue yendo con títulos **`T4.5.*`** o milestone rollup de fase 4.

---

## Colision de numeros T##

Si dos issues distintos usan el mismo `[T06]` (p. ej. uno del ROADMAP “Auth” y otro “Excel”), **solo uno** puede ser el T06 oficial del [ROADMAP.md](../ROADMAP.md). Al otro asignale otro prefijo en el titulo, p. ej. `[DOC-Excel] …` o renumeracion, y deja la referencia en el cuerpo: `**Ref ROADMAP:** fuera de tabla T06`.

---

## Normalizar issues ya creados

```bash
cd erp-satelite
python scripts/normalize_issue_title_prefixes.py              # vista previa (sin cambios)
python scripts/normalize_issue_title_prefixes.py --apply       # escribe títulos en GitHub
python scripts/normalize_issue_title_prefixes.py --state all --apply   # incluye cerrados
```

Requiere `gh` autenticado y permiso para editar issues en el repo.
