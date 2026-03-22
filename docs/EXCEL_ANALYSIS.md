# Análisis del Excel exportado del SAE

**Tickets:** T0.1.5 (análisis) · T0.1.6 (columnas).  
**Estado global:** **En progreso** — plantilla en repo; completar celdas cuando haya export real o datos parciales.

**Stack de importación:** ver [ADR-001](../ADR/ADR-001-stack-tecnologico.md) (FastAPI worker / validación) y [STACK_POR_FASE.md](./STACK_POR_FASE.md) Fase 1.

---

## 1. Obtención del archivo

| Pregunta | Estado |
|----------|--------|
| Ruta o menú en el SAE | En progreso |
| Formato (.xlsx / .xls / .csv / otro) | En progreso |
| Frecuencia de actualización | En progreso |
| Archivo de muestra (solo local, no en git) | En progreso |

---

## 2. Estructura del archivo

| Pregunta | Estado |
|----------|--------|
| Nombre de la hoja principal (productos) | En progreso |
| Fila donde empiezan los datos (1-based) | En progreso |
| Encabezados múltiples / filas basura | En progreso |

### Mapeo columnas → dominio

| Campo ERP | Columna Excel (letra / nombre cabecera) | Notas |
|-----------|----------------------------------------|--------|
| código SKU | En progreso | |
| nombre | En progreso | |
| precio | En progreso | |
| stock | En progreso | |
| categoría | En progreso | |
| unidad | En progreso | |
| código de barras | En progreso | |

---

## 3. Calidad de datos

| Tema | Observación |
|------|-------------|
| Filas vacías / duplicados | En progreso |
| Decimal punto vs coma | En progreso |
| Encoding | En progreso |
| Inconsistencias | En progreso |

---

## 4. Riesgos

En progreso (pendiente de primer export o revisión con datos reales).

---

## 5. Siguiente paso

Cuando §1–§3 pasen a **Hecho** con datos reales, el ticket de implementación **T1.1.5** puede fijar reglas de validación y tipos.
