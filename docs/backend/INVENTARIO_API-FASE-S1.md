# API Inventario — Fase 1 · App Satélite (Diseño)

> Lista de endpoints / RPC que la App Satélite necesita para soportar
> el módulo de inventario Fase 1, usando los modelos de dominio
> definidos en la app.

---

## 1. Consulta de productos + stock

### 1.1 Buscar productos

- **Nombre**: `get_productos`
- **Tipo**: REST (PostgREST) o RPC sencilla.
- **Input**:
  - `q` (texto de búsqueda: SKU, nombre, código de barras).
  - `limit`, `offset` (paginación).
- **Output**:
  - Lista de `ProductoResumen` (idProducto, sku, nombre, activo, unidad, categoría).

### 1.2 Stock por producto y ubicación

- **Nombre**: `get_stock_por_producto`
- **Tipo**: RPC recomendada (join múltiples tablas).
- **Input**:
  - `producto_id` (UUID / id_producto).
- **Output**:
  - Lista de `StockPorUbicacion`:
    - ProductoResumen.
    - UbicacionFisica (bodega, zona, estantería, fila, cubículo).
    - cantidad (Double).
    - estado (EstadoStockOperativo).

---

## 2. Recepción de mercancía

### 2.1 Crear recepción (simple)

- **Nombre**: `registrar_recepcion`
- **Tipo**: RPC (para encapsular lógica de movimiento + stock).
- **Input**:
  - `producto_id`
  - `ubicacion_destino_id` (referencia a cubículo/ubicación).
  - `cantidad` (Double).
  - `origen_logico` (texto: OC, ajuste, etc.).
- **Output**:
  - Ok / error + movimiento generado (opcional).

### 2.2 Listar recepciones recientes (por usuario o sucursal)

- **Nombre**: `get_recepciones_recientes`
- **Tipo**: RPC o vista.
- **Input**:
  - `desde` (fecha/hora).
  - opcional: `sucursal_id`.
- **Output**:
  - Lista resumida de movimientos tipo recepción.

---

## 3. Traslados internos

### 3.1 Crear traslado

- **Nombre**: `crear_traslado`
- **Tipo**: RPC.
- **Input**:
  - `origen_ubicacion_id`
  - `destino_ubicacion_id`
  - `lineas`: lista (producto_id, cantidad).
- **Output**:
  - `TrasladoUI` (con estado inicial: BORRADOR o ENVIADO).

### 3.2 Actualizar estado de traslado (aprobación / ejecución)

- **Nombre**: `actualizar_estado_traslado`
- **Tipo**: RPC.
- **Input**:
  - `traslado_id`
  - `nuevo_estado` (APROBADO, EJECUTADO, RECHAZADO, CANCELADO).
- **Output**:
  - `TrasladoUI` actualizado.

### 3.3 Listar traslados (por rol / sucursal)

- **Nombre**: `get_traslados`
- **Tipo**: RPC o vista filtrada.
- **Input**:
  - Filtros: estado, rango de fechas, sucursal.
- **Output**:
  - Lista de `TrasladoUI` (resumen).

---

## 4. Misiones de conteo

### 4.1 Crear misión de conteo

- **Nombre**: `crear_mision_conteo`
- **Tipo**: RPC.
- **Input**:
  - Rango de ubicaciones (bodega / zona / estantería / fila).
  - Opcional: lista de productos.
  - Asignados (lista de user_id).
- **Output**:
  - `MisionConteoUI` (estado: CREADA o ASIGNADA).

### 4.2 Registrar conteo para un ítem

- **Nombre**: `registrar_conteo_item`
- **Tipo**: RPC.
- **Input**:
  - `mision_id`
  - `producto_id`
  - `ubicacion_id`
  - `cantidad_contada` (Double).
- **Output**:
  - `ItemConteo` actualizado (con diferencia calculada).

### 4.3 Listar misiones de conteo

- **Nombre**: `get_misiones_conteo`
- **Tipo**: RPC o vista.
- **Input**:
  - Filtros: estado, asignado_a, rango de fechas.
- **Output**:
  - Lista de `MisionConteoUI` (resumen).

### 4.4 Cerrar / revisar misión

- **Nombre**: `cerrar_mision_conteo`
- **Tipo**: RPC.
- **Input**:
  - `mision_id`
  - Acción (FINALIZAR, MARCAR_REVISADA).
- **Output**:
  - `MisionConteoUI` actualizado.

---

## 5. Alertas de stock (plantilla Distribuidor de plásticos)

### 5.1 Alertas de stock bajo

- **Nombre**: `get_alertas_stock_bajo`
- **Tipo**: RPC / vista.
- **Input**:
  - Opcional: filtros por categoría / bodega / zona.
- **Output**:
  - Lista de productos y ubicaciones donde `cantidad < stock_minimo` (según política).

### 5.2 Alertas de stock muerto (sin venta)

- **Nombre**: `get_alertas_stock_muerto`
- **Tipo**: RPC / vista.
- **Input**:
  - `dias_sin_venta_umbral` (por defecto 120–180 según plantilla).
- **Output**:
  - Lista de productos candidatos a stock muerto.

---

## 6. Notas Fase 1

- No todos estos RPC tienen que estar implementados en el primer commit.
- Prioridad según flujos:
  1. `get_productos`, `get_stock_por_producto`.
  2. `registrar_recepcion`.
  3. `crear_traslado`, `actualizar_estado_traslado`.
  4. `crear_mision_conteo`, `registrar_conteo_item`.
  5. Alertas.