# Análisis del Excel exportado del SAE

**Tickets:** T0.1.5 (análisis) · T0.1.6 (columnas).  
**Estado global:** **En progreso** — plantilla en repo; completar celdas cuando haya export real o datos parciales.

**Stack de importación:** ver [ADR-001](../ADR/ADR-001-stack-tecnologico.md) (FastAPI worker / validación) y [STACK_POR_FASE.md](./STACK_POR_FASE.md) Fase 1.

**Mapeo detallado SAE → tablas ERP (compras, traslados, productos, clientes, proveedores):** [SAE_DATA_MAPPING.md](./SAE_DATA_MAPPING.md).

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

El inventario campo a campo por entidad está en **[SAE_DATA_MAPPING.md](./SAE_DATA_MAPPING.md)** (**Fase 1 · S1 — Modelar datos e importación**, [milestone en GitHub](https://github.com/Abraha33/ERP/milestone/16); columnas `grupo` **SAE** / **ERP** / **DERIVED**).

Resumen genérico (productos) — completar con export real:

| Campo ERP | Columna Excel (letra / nombre cabecera) | Notas |
|-----------|----------------------------------------|--------|
| código SKU | Ver SAE_DATA_MAPPING § productos | ProductsPerUnits… |
| nombre | Ver SAE_DATA_MAPPING | |
| precio / listas | Ver SAE_DATA_MAPPING | Varias listas |
| stock | Ver SAE_DATA_MAPPING | Por sucursal en columnas |
| categoría | Ver SAE_DATA_MAPPING | |
| unidad | Ver SAE_DATA_MAPPING | UM base / compra / venta |
| código de barras | Ver SAE_DATA_MAPPING (`grupo` ERP; añadir columna en import) | - |

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
