# Análisis del Excel exportado del SAE

**Tickets:** T0.1.5 (análisis) · T0.1.6 (columnas).  
**Estado:** plantilla y checklist **listos** en repo; filas marcadas **_(pendiente — te paso el resto)_** las completará el founder cuando tenga export real.

**Stack de importación:** ver [ADR-001](../ADR/ADR-001-stack-tecnologico.md) (FastAPI worker / validación) y [STACK_POR_FASE.md](./STACK_POR_FASE.md) Fase 1.

---

## 1. Obtención del archivo

| Pregunta | Estado |
|----------|--------|
| Ruta o menú en el SAE | _(pendiente — te paso el resto)_ |
| Formato (.xlsx / .xls / .csv / otro) | _(pendiente)_ |
| Frecuencia de actualización | _(pendiente)_ |
| Archivo de muestra (solo local, no en git) | _(pendiente)_ |

---

## 2. Estructura del archivo

| Pregunta | Estado |
|----------|--------|
| Nombre de la hoja principal (productos) | _(pendiente)_ |
| Fila donde empiezan los datos (1-based) | _(pendiente)_ |
| Encabezados múltiples / filas basura | _(pendiente)_ |

### Mapeo columnas → dominio

| Campo ERP | Columna Excel (letra / nombre cabecera) | Notas |
|-----------|----------------------------------------|--------|
| código SKU | _(pendiente)_ | |
| nombre | _(pendiente)_ | |
| precio | _(pendiente)_ | |
| stock | _(pendiente)_ | |
| categoría | _(pendiente)_ | |
| unidad | _(pendiente)_ | |
| código de barras | _(pendiente)_ | |

---

## 3. Calidad de datos

| Tema | Observación |
|------|-------------|
| Filas vacías / duplicados | _(pendiente)_ |
| Decimal punto vs coma | _(pendiente)_ | |
| Encoding | _(pendiente)_ | |
| Inconsistencias | _(pendiente)_ | |

---

## 4. Riesgos

_(pendiente al revisar el primer export real)_

---

## 5. Siguiente paso

Cuando rellenes §1–§3 con datos reales, el ticket de implementación **T1.1.5** puede fijar reglas de validación y tipos.
