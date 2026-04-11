# Módulo Inventario — Fase 1 · App Satélite

## 1. Objetivo

El módulo de **inventario** en Fase 1 permite a la app satélite operar el inventario de campo con foco en:

- Consulta de **stock por producto y ubicación**.
- **Recepción** de mercancía.
- **Traslados internos** entre bodegas / zonas / ubicaciones físicas.
- **Misiones de conteo** y registro de diferencias.

Usa roles simples de producto: **administrador**, **encargado** y **empleado**.

---

## 2. Alcance MVP Fase 1

Incluye:

- Consulta de **productos** y detalle básico.
- Consulta de **stock por ubicación**.
- **Recepción** de mercancía en una ubicación destino.
- **Traslado** entre zonas o bodegas internas (y ubicaciones físicas).
- **Aprobación de traslados** por encargado.
- **Misiones de conteo** y registro de diferencias.
- **Trazabilidad básica** de movimientos (quién, cuándo, qué).

Queda fuera (por ahora):

- Lotes y caducidad (FEFO/FIFO).
- Reservas avanzadas de stock.
- Valorización compleja (costos, promedios avanzados).
- Automatización de reabastecimiento (reposiciones automáticas complejas).

---

## 3. Roles (RBAC inventario)

Usa los roles de producto ya definidos para la app satélite:

- **administrador**
  - Ver todo el inventario.
  - Configurar ubicaciones y reglas.
  - Corregir movimientos y diferencias.
  - Crear misiones de conteo.
  - Aprobar / cerrar flujos sensibles.

- **encargado**
  - Ver inventario de su operación.
  - Aprobar / rechazar traslados.
  - Validar recepciones sensibles.
  - Revisar diferencias de conteo.

- **empleado**
  - Ejecutar recepción de mercancía.
  - Registrar traslados operativos.
  - Ejecutar misiones de conteo asignadas.
  - Consultar stock necesario para su tarea.

---

## 4. Entidades canónicas (nivel negocio)

- **Producto**
  - SKU, nombre, estado (activo/inactivo), unidad, categoría.
- **Ubicación**
  - Bodega (almacén / tienda) y ubicación interna completa.
- **Stock**
  - Cantidad por producto y ubicación (foco en "disponible" y estados operativos).
- **Movimiento**
  - Entrada, salida, traslado, ajuste, conteo.
- **Traslado**
  - Solicitud, aprobación, ejecución.
- **Misión de conteo**
  - Asignación a empleados, ejecución, diferencias.

---

## 5. Flujos principales

### 5.1 Consulta de stock

1. Usuario busca un **producto**.
2. Ve **detalle** básico del producto.
3. Ve lista de **stock por ubicación** (bodega / zona / ubicación física).
4. Desde aquí puede decidir si:
   - Recibe mercancía.
   - Solicita traslado.
   - Incluye el producto en una misión de conteo.

### 5.2 Recepción de mercancía

1. Empleado selecciona **ubicación destino**.
2. Registra **producto + cantidad** recibida.
3. El sistema registra:
   - Usuario, fecha/hora.
   - Origen lógico (ej: OC, devolución, ajuste manual).
4. El **stock disponible** en esa ubicación aumenta.

### 5.3 Traslado interno

1. Empleado crea traslado: **origen**, **destino**, **productos + cantidades**.
2. Traslado queda en estado inicial (por ejemplo `BORRADOR` / `ENVIADO`).
3. Encargado revisa y **aprueba / rechaza**.
4. Una vez ejecutado:
   - Stock baja en origen.
   - Stock sube en destino.
   - Queda trazabilidad de quién creó, quién aprobó, quién ejecutó.

### 5.4 Misiones de conteo

1. Administrador o encargado define una **misión de conteo**:
   - Rango de productos y/o ubicaciones.
   - Asignatarios (empleados).
2. Empleado ve sus misiones y registra conteos físicos.
3. El sistema calcula **diferencias** entre sistema y conteo.
4. Encargado / admin revisa diferencias y decide:
   - Aprobar ajustes.
   - Investigar antes de ajustar.

---

## 6. Estados mínimos

### 6.1 Estados operativos de stock

- `DISPONIBLE`
- `RESERVADO`
- `EN_TRANSITO`
- `BLOQUEADO`
- `DANADO`
- `EN_CUARENTENA`

Se aplican a nivel de **stock por producto y ubicación**.

### 6.2 Estados de recepción

- `BORRADOR`
- `CONFIRMADA`
- `CANCELADA`

### 6.3 Estados de traslado

- `BORRADOR`
- `ENVIADO`
- `PENDIENTE_APROBACION`
- `APROBADO`
- `EJECUTADO`
- `RECHAZADO`
- `CANCELADO`

### 6.4 Estados de misión de conteo

- `CREADA`
- `ASIGNADA`
- `EN_EJECUCION`
- `FINALIZADA`
- `REVISADA`

---

## 7. Reglas de negocio mínimas

- No se puede trasladar **más stock que el disponible** en origen.
- Todo movimiento deja **trazabilidad**: usuario, fecha/hora, tipo de movimiento.
- Ajustes y diferencias sensibles deben ser visibles para revisión de un rol superior.
- Empleado **ejecuta**, encargado **valida** donde aplique.
- Las consultas de stock deben ser rápidas y seguras: solo muestran lo autorizado según rol y tenant.

---

## 8. Dependencias de Fase 1 · Sprint 1

Para que este módulo sea implementable:

- **T1.1.1**: Definir modelo canónico de productos, perfiles, tiendas y zonas.
- **T1.1.3**: Definir políticas de seguridad por rol alineadas a estos flujos.
- **T1.1.4**: Auth por email/contraseña funcionando.
- **T1.1.5–T1.1.7**: Importación inicial desde Excel para alimentar catálogo y, si aplica, stock base.

---

## 9. Profundidad de ubicaciones (Fase 1)

En Fase 1 se usa **toda la jerarquía de ubicación física**:

- **Bodega / tienda**
- **Zona**
- **Estantería**
- **Fila**
- **Cubículo** (o posición de picking)

La App Satélite usará esta jerarquía para:

- Mostrar stock por producto en ubicaciones específicas (ej: Bodega A → Zona 1 → Estantería 2 → Fila 3 → Cubículo 04).
- Asignar misiones de conteo a zonas o estanterías concretas.
- Reducir caminatas y tiempos de búsqueda (conteos por sector).

---

## 10. Orden de implementación de flujos (App Satélite)

Orden de construcción para inventario en la app:

1. **Consulta**
   - Búsqueda de producto.
   - Detalle de producto.
   - Stock por bodega / zona / ubicación interna (hasta cubículo).

2. **Recepción**
   - Registrar entrada de mercancía en una ubicación.
   - Ver y ajustar recepciones recientes.

3. **Traslados**
   - Crear traslados entre ubicaciones.
   - Vista de encargado para aprobar / rechazar.
   - Ejecución y reflejo en stock.

4. **Misiones de conteo**
   - Crear misiones por zona/estantería/fila.
   - Ejecutar conteos.
   - Revisar diferencias.

---

## 11. Política de stock por tipo de negocio

Además de los estados operativos, el sistema manejará **plantillas de política de stock** por tipo de negocio, por ejemplo:

- **Distribuidor de plásticos** (caso actual).
- Restaurante / food service.
- Farmacia.
- Retail de moda.
- etc.

### 11.1 Estructura funcional de la política de stock

Nivel diseño funcional (no SQL aún):

- `stock_policy_template`
  - `id`
  - `nombre` (ej: "Distribuidor de plásticos")
  - `descripcion`
  - `usa_stock_seguridad` (bool)
  - `usa_stock_estacional` (bool)
  - `usa_caducidad` (bool)
  - `horizonte_planeacion_dias` (int)
  - `metodo_reposicion` (enum: PUNTO_PEDIDO / DIAS_COBERTURA / OTRO)
  - `nivel_rotacion_objetivo` (enum: ALTA / MEDIA / BAJA)
  - `politica_stock_muerto_dias_sin_venta` (int)

- `business_type`
  - `id`
  - `nombre` (ej: "Distribuidor de plásticos")
  - `stock_policy_template_id` (FK)

- `empresa`
  - `id`
  - `business_type_id` (FK) → hereda plantilla por defecto.

### 11.2 Plantilla ejemplo: Distribuidor de plásticos

Plantilla inicial pensada para este caso:

- `nombre`: **Distribuidor de plásticos**
- `usa_caducidad`: `false`
- `usa_stock_seguridad`: `true`
  - Regla sugerida: productos A (alto volumen) con seguridad ≈ ventas de 7–14 días.
- `usa_stock_estacional`: `false` (en general no prioritario).
- `politica_stock_muerto_dias_sin_venta`: `120–180` días.
- `horizonte_planeacion_dias`: `30–60`.
- `metodo_reposicion`: `PUNTO_PEDIDO` (+ posibilidad de cantidad económica en fases posteriores).

En la UI se expone como preguntas sencillas, no como teoría de stock:

- "¿En cuántos días máximo quieres quedarte sin producto A si un proveedor se atrasa?"
- "¿Después de cuántos días sin venta marcamos una referencia como 'stock muerto'?"

---

## 12. Decisiones Fase 1 (inventario)

- **Profundidad UI Fase 1**: se usan **todas las capas** de ubicación en la app (Bodega, Zona, Estantería, Fila, Cubículo).
- **Política de stock activada en Fase 1**: se activan los **parámetros recomendados** de la plantilla "Distribuidor de plásticos" (stock de seguridad, stock muerto por días sin venta, horizonte de 30–60 días, reposición por punto de pedido).
- **Alertas prioritarias Fase 1**:
  - Stock por debajo del mínimo / seguridad.
  - Referencias candidatas a stock muerto (X días sin venta).
  - Sin stock en ubicación crítica.
