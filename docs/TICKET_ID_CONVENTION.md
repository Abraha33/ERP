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

El script [scripts/import-backlog-to-github.py](../scripts/import-backlog-to-github.py) formatea títulos como `[ID] título`. Los IDs del CSV se normalizan a `[E##-S##-##]` al crear issues.

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
