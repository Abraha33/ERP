# Mapeo SAE / export → modelo ERP (Satélite)

**Propósito:** documentar la **estructura y datos** que se pretenden extraer de informes y export del **SAE** hacia tablas objetivo del ERP. Complementa [EXCEL_ANALYSIS.md](../legacy/EXCEL_ANALYSIS.md) (checklist de obtención y calidad del archivo).

**Milestone (GitHub):** [Fase 1 · S1 — Modelar datos e importación](https://github.com/Abraha33/ERP/milestone/16) — esquema por campo: qué viene del **SAE**, qué es solo **ERP** y qué es **DERIVED** (lookup / reglas).

**Convenciones — columna `grupo`**

| grupo | Significado |
|-------|-------------|
| **SAE** | Dato desde export (Excel/CSV) o desde la UI del SAE (**Wappsi**); en `archivo_origen` aparece `(UI Wappsi)` cuando no hay archivo. |
| **ERP** | Campo definido o mantenido solo en el ERP (IDs internos, auditoría, borrado lógico, moneda/tasas si se fijan en sistema, extensiones de maestro). |
| **DERIVED** | Lookup, parseo, normalización o cálculo en importación / ETL (no viene literal en una sola celda o depende de reglas). |

Los nombres de **archivo_origen** son ejemplos con fecha; al importar conviene normalizar o parametrizar rutas.

---

## 1. `compras_encabezado`

| entidad | tabla | campo_erp | descripcion | grupo | archivo_origen | columna_origen |
|---------|-------|-----------|-------------|-------|----------------|----------------|
| compras | compras_encabezado | id_compra | Id interno de la compra | ERP | - | - |
| compras | compras_encabezado | num_compra | Número interno (COM-...) | SAE | (UI Wappsi) | Número |
| compras | compras_encabezado | fecha_compra | Fecha de la compra | SAE | (UI Wappsi) | Fecha |
| compras | compras_encabezado | id_sucursal | Sucursal donde se registra la compra | SAE | (UI Wappsi) | Sucursal |
| compras | compras_encabezado | id_bodega | Bodega de ingreso de mercancía | SAE | (UI Wappsi) | Bodega |
| compras | compras_encabezado | id_proveedor | Proveedor | SAE | suppliers_2026_03_22_13_20_16.xlsx | NIT/CC (lookup sobre proveedores) |
| compras | compras_encabezado | tipo_compra | Productos / Gastos / Gasto importación | SAE | (UI Wappsi) | Tipo de compra |
| compras | compras_encabezado | estado_compra | Estado (Aprobado / No aprobado) | SAE | (UI Wappsi) | Estado |
| compras | compras_encabezado | flete_otro_gasto_monto | Total fletes y otros gastos | SAE | (UI Wappsi) | Fletes y/o otros gastos |
| compras | compras_encabezado | flete_prorratear | Si se prorratea flete en ítems (Sí/No) | SAE | (UI Wappsi) | Prorratear el costo de Fletes... |
| compras | compras_encabezado | num_pago | Número de pago | SAE | (UI Wappsi) | Número de pago |
| compras | compras_encabezado | afecta_caja | Indica si afecta caja | SAE | (UI Wappsi) | ¿El pago a esta compra afecta caja? |
| compras | compras_encabezado | forma_pago | Forma de pago | SAE | (UI Wappsi) | Forma de pago |
| compras | compras_encabezado | plazo_dias | Plazo de crédito en días | DERIVED | customers_2026_03_22_13_19_13.xlsx | Plazo predeterminado (según proveedor) |
| compras | compras_encabezado | moneda | Moneda de la compra | ERP | - | - |
| compras | compras_encabezado | tasa_cambio | Tasa de cambio | ERP | - | - |
| compras | compras_encabezado | num_doc_proveedor | Número de factura del proveedor | ERP | - | - |
| compras | compras_encabezado | fecha_doc_proveedor | Fecha de factura del proveedor | ERP | - | - |
| compras | compras_encabezado | centro_costo_id | Centro de costo | ERP | - | - |
| compras | compras_encabezado | nota_compra | Nota u observación de la compra | SAE | (UI Wappsi) | Nota |
| compras | compras_encabezado | fecha_creacion | Fecha de creación del registro | ERP | - | - |
| compras | compras_encabezado | created_by | Usuario que crea la compra | ERP | - | - |
| compras | compras_encabezado | fecha_actualizacion | Fecha de última actualización | ERP | - | - |
| compras | compras_encabezado | updated_by | Usuario que actualiza la compra | ERP | - | - |
| compras | compras_encabezado | version | Versión del registro para concurrencia | ERP | - | - |
| compras | compras_encabezado | deleted_at | Fecha de borrado lógico | ERP | - | - |
| compras | compras_encabezado | is_deleted | Flag de borrado lógico | ERP | - | - |

> **Nota:** validar en SAE si `plazo_dias` en compras debe resolverse desde maestro de **proveedores** (no customers); ajustar `archivo_origen` cuando se confirme.

---

## 2. `compras_detalle`

| entidad | tabla | campo_erp | descripcion | grupo | archivo_origen | columna_origen |
|---------|-------|-----------|-------------|-------|----------------|----------------|
| compras | compras_detalle | id_compra_linea | Id interno de línea de compra | ERP | - | - |
| compras | compras_detalle | id_compra | FK a encabezado de compra | ERP | - | - |
| compras | compras_detalle | cod_producto | Código/PLU del producto | SAE | sample_purchase_products-1.xlsx | Codigo Producto |
| compras | compras_detalle | id_producto | Id interno de producto (lookup por código) | DERIVED | ProductsPerUnits2026_03_22.xlsx | Código |
| compras | compras_detalle | variante | Variante de producto | SAE | sample_purchase_products-1.xlsx | Variante |
| compras | compras_detalle | cantidad | Cantidad comprada | SAE | sample_purchase_products-1.xlsx | Cantidad |
| compras | compras_detalle | um_compra | Unidad de medida de compra | DERIVED | ProductsPerUnits2026_03_22.xlsx | Comprar Código de unidad |
| compras | compras_detalle | costo_unitario_bruto | Costo unitario sin descuento | SAE | sample_purchase_products-1.xlsx | Costo Unitario |
| compras | compras_detalle | descuento_raw | Valor o % de descuento recibido (texto original) | SAE | sample_purchase_products-1.xlsx | Descuento |
| compras | compras_detalle | tipo_descuento | Tipo de descuento (PORCENTAJE/VALOR) | DERIVED | sample_purchase_products-1.xlsx | Descuento (parseado) |
| compras | compras_detalle | descuento_valor | Importe de descuento en valor | DERIVED | - | - |
| compras | compras_detalle | costo_unitario_neto | Costo después de descuento | DERIVED | - | - |
| compras | compras_detalle | nombre_impuesto | Nombre de impuesto (IVA19, Exento, etc.) | SAE | sample_purchase_products-1.xlsx | Nombre Impuesto |
| compras | compras_detalle | id_impuesto | FK a catálogo de impuestos | DERIVED | - | - |
| compras | compras_detalle | imp_monto_unitario | Valor de impuesto por unidad | DERIVED | - | - |
| compras | compras_detalle | flete_prorrateado_unit | Flete u otros gastos prorrateados por unidad | DERIVED | - | - |
| compras | compras_detalle | costo_unitario_final | Costo unitario final (incluye impuesto + flete) | DERIVED | - | - |
| compras | compras_detalle | caducidad_fecha | Fecha de caducidad del producto | SAE | (XLS compras si trae Caducidad) | Caducidad |
| compras | compras_detalle | lote_codigo | Código de lote | ERP | - | - |
| compras | compras_detalle | subtotal_linea | Cantidad × costo_unitario_final | DERIVED | - | - |
| compras | compras_detalle | nota_linea | Observación de línea | ERP | - | - |
| compras | compras_detalle | created_at | Fecha creación línea | ERP | - | - |
| compras | compras_detalle | created_by | Usuario creación línea | ERP | - | - |
| compras | compras_detalle | updated_at | Fecha actualización línea | ERP | - | - |
| compras | compras_detalle | updated_by | Usuario actualización línea | ERP | - | - |

---

## 3. `productos`

| entidad | tabla | campo_erp | descripcion | grupo | archivo_origen | columna_origen |
|---------|-------|-----------|-------------|-------|----------------|----------------|
| producto | productos | id_producto | Id interno de producto | ERP | - | - |
| producto | productos | sku_codigo | Código interno / SKU | SAE | ProductsPerUnits2026_03_22.xlsx | Código |
| producto | productos | nombre | Nombre comercial | SAE | ProductsPerUnits2026_03_22.xlsx | Nombre |
| producto | productos | referencia_interna | Referencia / modelo | SAE | ProductsPerUnits2026_03_22.xlsx | Referencia |
| producto | productos | marca | Marca | SAE | ProductsPerUnits2026_03_22.xlsx | Marca |
| producto | productos | categoria | Categoría/familia | SAE | ProductsPerUnits2026_03_22.xlsx | Categoría |
| producto | productos | subcategoria | Subcategoría | SAE | ProductsPerUnits2026_03_22.xlsx | Subcategoría |
| producto | productos | codigo_subcategoria | Código de subcategoría | SAE | ProductsPerUnits2026_03_22.xlsx | Código de Subcategoría |
| producto | productos | clase_codigo_barras | Tipo de código de barras (code128, etc.) | SAE | ProductsPerUnits2026_03_22.xlsx | Clase de código de barras |
| producto | productos | codigo_barras | Código de barras (EAN/UPC) | ERP | - | - (añadir columna en import) |
| producto | productos | um_base | Unidad de medida base | SAE | ProductsPerUnits2026_03_22.xlsx | UM Base |
| producto | productos | um_venta | Unidad de medida de venta | SAE | ProductsPerUnits2026_03_22.xlsx | Venta Código de unidad |
| producto | productos | um_compra | Unidad de medida de compra | SAE | ProductsPerUnits2026_03_22.xlsx | Comprar Código de unidad |
| producto | productos | factor_um_base | Factor vs UM base | SAE | ProductsPerUnits2026_03_22.xlsx | Factor |
| producto | productos | um_alt_2 | Unidad alternativa 2 | SAE | ProductsPerUnits2026_03_22.xlsx | UM2 |
| producto | productos | factor_alt_2 | Factor unidad alternativa 2 | SAE | ProductsPerUnits2026_03_22.xlsx | Factor2 |
| producto | productos | um_alt_3 | Unidad alternativa 3 | SAE | ProductsPerUnits2026_03_22.xlsx | UM3 |
| producto | productos | factor_alt_3 | Factor unidad alternativa 3 | SAE | ProductsPerUnits2026_03_22.xlsx | Factor3 |
| producto | productos | um_alt_4 | Unidad alternativa 4 | SAE | ProductsPerUnits2026_03_22.xlsx | UM4 |
| producto | productos | factor_alt_4 | Factor unidad alternativa 4 | SAE | ProductsPerUnits2026_03_22.xlsx | Factor4 |
| producto | productos | um_alt_5 | Unidad alternativa 5 | SAE | ProductsPerUnits2026_03_22.xlsx | UM5 |
| producto | productos | factor_alt_5 | Factor unidad alternativa 5 | SAE | ProductsPerUnits2026_03_22.xlsx | Factor5 |
| producto | productos | um_alt_6 | Unidad alternativa 6 | SAE | ProductsPerUnits2026_03_22.xlsx | UM6 |
| producto | productos | factor_alt_6 | Factor unidad alternativa 6 | SAE | ProductsPerUnits2026_03_22.xlsx | Factor6 |
| producto | productos | costo_ultimo | Último costo | SAE | ProductsPerUnits2026_03_22.xlsx | Último costo |
| producto | productos | costo_promedio | Costo promedio | SAE | ProductsPerUnits2026_03_22.xlsx | Costo promedio |
| producto | productos | precio_lista_base | Precio lista HOLA AMIGO JC | SAE | ProductsPerUnits2026_03_22.xlsx | Precio HOLA AMIGO JC |
| producto | productos | precio_lista_bolsas | Precio lista bolsas | SAE | ProductsPerUnits2026_03_22.xlsx | Precio bolsas |
| producto | productos | stock_alerta | Cantidad de alerta | SAE | ProductsPerUnits2026_03_22.xlsx | Cantidad de alerta |
| producto | productos | tasa_impuesto | Tasa de impuestos (IVA 19%, etc.) | SAE | ProductsPerUnits2026_03_22.xlsx | Tasa de impuestos |
| producto | productos | metodo_calculo_impuesto | Método de cálculo de impuestos (incluido/excl.) | SAE | ProductsPerUnits2026_03_22.xlsx | Método de cálculo de impuestos |
| producto | productos | url_imagen | Ruta/archivo de imagen | SAE | ProductsPerUnits2026_03_22.xlsx | Imagen |
| producto | productos | stock_sucursal_1 | Stock sucursal principal | SAE | ProductsPerUnits2026_03_22.xlsx | COMERCIALIZADORA HOLA AMIGO JC |
| producto | productos | stock_sucursal_2 | Stock sucursal TIENDA PUNTO DE VENTA | SAE | ProductsPerUnits2026_03_22.xlsx | TIENDA PUNTO DE VENTA |
| producto | productos | stock_total | Stock total | SAE | ProductsPerUnits2026_03_22.xlsx | Cantidad |
| producto | productos | producto_inactivo | Flag producto inactivo | SAE | ProductsPerUnits2026_03_22.xlsx | Producto inactivo |
| producto | productos | descripcion_detallada | Detalles de producto / descripción larga | SAE | ProductsPerUnits2026_03_22.xlsx | Detalles de producto |
| producto | productos | garantia_dias | Tiempo de garantía en días | SAE | ProductsPerUnits2026_03_22.xlsx | Tiempo garantía (Días) |
| producto | productos | variantes_texto | Texto de variantes | SAE | ProductsPerUnits2026_03_22.xlsx | Variantes de producto |
| producto | productos | campo_personalizado_1 | Campo personalizado 1 | SAE | ProductsPerUnits2026_03_22.xlsx | Producto Campo Personalizado 1 |
| producto | productos | campo_personalizado_2 | Campo personalizado 2 | SAE | ProductsPerUnits2026_03_22.xlsx | Producto Campo Personalizado 2 |
| producto | productos | campo_personalizado_3 | Campo personalizado 3 | SAE | ProductsPerUnits2026_03_22.xlsx | Producto Campo Personalizado 3 |
| producto | productos | campo_personalizado_4 | Campo personalizado 4 | SAE | ProductsPerUnits2026_03_22.xlsx | Producto Campo Personalizado 4 |
| producto | productos | campo_personalizado_5 | Campo personalizado 5 | SAE | ProductsPerUnits2026_03_22.xlsx | Producto Campo Personalizado 5 |
| producto | productos | campo_personalizado_6 | Campo personalizado 6 | SAE | ProductsPerUnits2026_03_22.xlsx | Producto Campo Personalizado 6 |
| producto | productos | estado_producto | Activo / Inactivo / Descontinuado | DERIVED | ProductsPerUnits2026_03_22.xlsx | Producto inactivo |
| producto | productos | zona_producto | Zona de producto para inventario_restauracion | ERP | - | - |
| producto | productos | peso | Peso del producto | ERP | - | - |
| producto | productos | dimensiones | Dimensiones (alto/ancho/largo) | ERP | - | - |
| producto | productos | created_at | Fecha creación | ERP | - | - |
| producto | productos | created_by | Usuario creación | ERP | - | - |
| producto | productos | updated_at | Fecha actualización | ERP | - | - |
| producto | productos | updated_by | Usuario actualización | ERP | - | - |

> **Nota:** columnas de stock por sucursal con nombre fijo de negocio conviene normalizar a `id_sucursal` + tabla de ubicaciones en el ERP.

---

## 4. `traslados_encabezado`

| entidad | tabla | campo_erp | descripcion | grupo | archivo_origen | columna_origen |
|---------|-------|-----------|-------------|-------|----------------|----------------|
| inventario | traslados_encabezado | id_traslado | Id interno del traslado | ERP | - | - |
| inventario | traslados_encabezado | num_traslado | Número interno (TRA-...) | SAE | (UI Wappsi) | Número |
| inventario | traslados_encabezado | fecha_traslado | Fecha del traslado | DERIVED | (UI Wappsi) | Fecha (si existe en UI) |
| inventario | traslados_encabezado | id_sucursal_origen | Sucursal origen | SAE | (UI Wappsi) | Sucursal origen |
| inventario | traslados_encabezado | id_bodega_origen | Bodega origen | SAE | (UI Wappsi) | Desde la bodega |
| inventario | traslados_encabezado | id_bodega_destino | Bodega destino | SAE | (UI Wappsi) | Para la bodega |
| inventario | traslados_encabezado | estado_traslado | Pendiente / Enviado / Completado | SAE | (UI Wappsi) | Estado |
| inventario | traslados_encabezado | flete_otro_gasto | Flete y otros gastos | SAE | (UI Wappsi) | Flete y/o otros gastos |
| inventario | traslados_encabezado | motivo_traslado | Motivo del traslado | ERP | - | - |
| inventario | traslados_encabezado | responsable_solicita | Usuario que solicita | ERP | - | - |
| inventario | traslados_encabezado | responsable_aprueba | Usuario que aprueba | ERP | - | - |
| inventario | traslados_encabezado | fecha_aprobacion | Fecha de aprobación | ERP | - | - |
| inventario | traslados_encabezado | nota_traslado | Nota u observación | SAE | (UI Wappsi) | Nota |
| inventario | traslados_encabezado | created_at | Fecha creación | ERP | - | - |
| inventario | traslados_encabezado | created_by | Usuario creación | ERP | - | - |
| inventario | traslados_encabezado | updated_at | Fecha actualización | ERP | - | - |
| inventario | traslados_encabezado | updated_by | Usuario actualización | ERP | - | - |

---

## 5. `traslados_detalle`

| entidad | tabla | campo_erp | descripcion | grupo | archivo_origen | columna_origen |
|---------|-------|-----------|-------------|-------|----------------|----------------|
| inventario | traslados_detalle | id_traslado_linea | Id interno de línea de traslado | ERP | - | - |
| inventario | traslados_detalle | id_traslado | FK a encabezado de traslado | ERP | - | - |
| inventario | traslados_detalle | cod_producto | Código de producto | SAE | sample_transfer_products.csv | Product Code |
| inventario | traslados_detalle | id_producto | Id interno de producto | DERIVED | ProductsPerUnits2026_03_22.xlsx | Código |
| inventario | traslados_detalle | variante | Variante de producto | SAE | sample_transfer_products.csv | Product Variant |
| inventario | traslados_detalle | cantidad | Cantidad a trasladar | SAE | sample_transfer_products.csv | Quantity |
| inventario | traslados_detalle | um_traslado | Unidad de medida utilizada | DERIVED | ProductsPerUnits2026_03_22.xlsx | UM Base |
| inventario | traslados_detalle | costo_unitario_ref | Costo unitario de referencia | SAE | sample_transfer_products.csv | Unit Cost |
| inventario | traslados_detalle | expiry | Fecha de caducidad | SAE | sample_transfer_products.csv | Expiry |
| inventario | traslados_detalle | subtotal_costo | Cantidad × costo_unitario_ref | DERIVED | - | - |
| inventario | traslados_detalle | lote_codigo | Código de lote | ERP | - | - |
| inventario | traslados_detalle | estado_inventario | Estado (disponible, dañado, cuarentena, etc.) | ERP | - | - |
| inventario | traslados_detalle | nota_linea | Observación de línea | ERP | - | - |
| inventario | traslados_detalle | created_at | Fecha creación línea | ERP | - | - |
| inventario | traslados_detalle | created_by | Usuario creación línea | ERP | - | - |
| inventario | traslados_detalle | updated_at | Fecha actualización línea | ERP | - | - |
| inventario | traslados_detalle | updated_by | Usuario actualización línea | ERP | - | - |

---

## 6. `clientes` (terceros tipo cliente)

| entidad | tabla | campo_erp | descripcion | grupo | archivo_origen | columna_origen |
|---------|-------|-----------|-------------|-------|----------------|----------------|
| tercero | clientes | id_tercero | Id interno del tercero | ERP | - | - |
| tercero | clientes | tipo_tercero | Tipo de tercero (Cliente) | DERIVED | customers_2026_03_22_13_19_13.xlsx | - |
| tercero | clientes | estado | Estado (Activo/Inactivo) | SAE | customers_2026_03_22_13_19_13.xlsx | Estado |
| tercero | clientes | tipo_documento | Tipo de documento (NIT/CC) | SAE | customers_2026_03_22_13_19_13.xlsx | Tipo documento |
| tercero | clientes | num_documento | Número de documento | SAE | customers_2026_03_22_13_19_13.xlsx | NIT/CC |
| tercero | clientes | dv | Dígito de verificación | SAE | customers_2026_03_22_13_19_13.xlsx | Dígito de verificación |
| tercero | clientes | tipo_persona | Natural / Jurídica | SAE | customers_2026_03_22_13_19_13.xlsx | Tipo de persona |
| tercero | clientes | tipo_regimen | Régimen tributario | SAE | customers_2026_03_22_13_19_13.xlsx | Tipo de régimen |
| tercero | clientes | razon_social | Razón social | SAE | customers_2026_03_22_13_19_13.xlsx | Razón social |
| tercero | clientes | nombres | Nombres | SAE | customers_2026_03_22_13_19_13.xlsx | Nombres |
| tercero | clientes | segundo_nombre | Segundo nombre | SAE | customers_2026_03_22_13_19_13.xlsx | Segundo nombre |
| tercero | clientes | primer_apellido | Primer apellido | SAE | customers_2026_03_22_13_19_13.xlsx | Primer apellido |
| tercero | clientes | segundo_apellido | Segundo apellido | SAE | customers_2026_03_22_13_19_13.xlsx | Segundo apellido |
| tercero | clientes | nombre_comercial | Nombre Comercial | SAE | customers_2026_03_22_13_19_13.xlsx | Nombre Comercial |
| tercero | clientes | direccion | Dirección | SAE | customers_2026_03_22_13_19_13.xlsx | Dirección |
| tercero | clientes | zona | Zona | SAE | customers_2026_03_22_13_19_13.xlsx | Zona |
| tercero | clientes | barrio | Barrio | SAE | customers_2026_03_22_13_19_13.xlsx | Barrio |
| tercero | clientes | ciudad | Ciudad | SAE | customers_2026_03_22_13_19_13.xlsx | Ciudad |
| tercero | clientes | departamento | Departamento | SAE | customers_2026_03_22_13_19_13.xlsx | Departamento |
| tercero | clientes | pais | País | SAE | customers_2026_03_22_13_19_13.xlsx | País |
| tercero | clientes | telefono | Teléfono | SAE | customers_2026_03_22_13_19_13.xlsx | Teléfono |
| tercero | clientes | email | Email | SAE | customers_2026_03_22_13_19_13.xlsx | Email |
| tercero | clientes | mes_cumple | Mes de cumpleaños | SAE | customers_2026_03_22_13_19_13.xlsx | Mes de cumpleaños |
| tercero | clientes | dia_cumple | Día de cumpleaños | SAE | customers_2026_03_22_13_19_13.xlsx | Día de cumpleaños |
| tercero | clientes | genero | Género | SAE | customers_2026_03_22_13_19_13.xlsx | Género |
| tercero | clientes | lista_precios | Lista de precios asignada | SAE | customers_2026_03_22_13_19_13.xlsx | Lista Precios |
| tercero | clientes | grupo_cliente | Grupo de clientes | SAE | customers_2026_03_22_13_19_13.xlsx | Grupo |
| tercero | clientes | vendedor_principal_id | Vendedor principal asignado | SAE | customers_2026_03_22_13_19_13.xlsx | Vendedor principal asignado |
| tercero | clientes | afiliado_id | Afiliado asignado | SAE | customers_2026_03_22_13_19_13.xlsx | Afiliado Asignado |
| tercero | clientes | tipo_pago | Tipo de pago del cliente | SAE | customers_2026_03_22_13_19_13.xlsx | Tipo de pago del cliente |
| tercero | clientes | limite_credito | Límite de crédito | SAE | customers_2026_03_22_13_19_13.xlsx | Límite de crédito |
| tercero | clientes | plazo_predeterminado | Plazo predeterminado | SAE | customers_2026_03_22_13_19_13.xlsx | Plazo predeterminado |
| tercero | clientes | no_acumular_puntos | No acumular puntos (flag original) | SAE | customers_2026_03_22_13_19_13.xlsx | No acumular puntos |
| tercero | clientes | acumula_puntos | Indica si acumula puntos | DERIVED | customers_2026_03_22_13_19_13.xlsx | No acumular puntos |
| tercero | clientes | puntos_premio | Puntos acumulados | SAE | customers_2026_03_22_13_19_13.xlsx | Puntos Premio |
| tercero | clientes | valor_anticipo | Valor de anticipo | SAE | customers_2026_03_22_13_19_13.xlsx | Valor de anticipo |
| tercero | clientes | solo_pos | Cliente solo para POS | SAE | customers_2026_03_22_13_19_13.xlsx | Cliente sólo para POS |
| tercero | clientes | exento_impuestos | Cliente exento de impuestos | SAE | customers_2026_03_22_13_19_13.xlsx | Cliente Exento de Impuestos |
| tercero | clientes | aplicar_ret_sin_base | Aplicar retenciones sin validar base mínima | SAE | customers_2026_03_22_13_19_13.xlsx | Aplicar retenciones sin validar base mínima |
| tercero | clientes | es_retenedor_fuente | Cliente es retenedor de fuente | SAE | customers_2026_03_22_13_19_13.xlsx | Retenedor de Fuente |
| tercero | clientes | es_retenedor_iva | Cliente es retenedor de IVA | SAE | customers_2026_03_22_13_19_13.xlsx | Retenedor de IVA |
| tercero | clientes | es_retenedor_ica | Cliente es retenedor de ICA | SAE | customers_2026_03_22_13_19_13.xlsx | Retenedor de ICA |
| tercero | clientes | canal_principal | Canal principal (mayorista, detalle, etc.) | ERP | - | - |
| tercero | clientes | segmento | Segmento (A/B/C, etc.) | ERP | - | - |
| tercero | clientes | lat | Latitud (para rutas) | ERP | - | - |
| tercero | clientes | lng | Longitud | ERP | - | - |
| tercero | clientes | fecha_creacion | Fecha de creación del cliente | ERP | - | - |
| tercero | clientes | fecha_ultima_compra | Fecha de última compra | DERIVED | - | - |

---

## 7. `proveedores` (terceros tipo proveedor)

| entidad | tabla | campo_erp | descripcion | grupo | archivo_origen | columna_origen |
|---------|-------|-----------|-------------|-------|----------------|----------------|
| tercero | proveedores | id_tercero | Id interno del tercero | ERP | - | - |
| tercero | proveedores | tipo_tercero | Tipo de tercero (Proveedor) | DERIVED | suppliers_2026_03_22_13_20_16.xlsx | - |
| tercero | proveedores | estado | Estado (Activo/Inactivo) | ERP | - | - |
| tercero | proveedores | tipo_documento | Tipo documento (NIT/CC) | ERP | - | - |
| tercero | proveedores | num_documento | Número de documento | SAE | suppliers_2026_03_22_13_20_16.xlsx | NIT/CC |
| tercero | proveedores | dv | Dígito de verificación | ERP | - | - |
| tercero | proveedores | tipo_persona | Natural/Jurídica | ERP | - | - |
| tercero | proveedores | razon_social | Razón social | SAE | suppliers_2026_03_22_13_20_16.xlsx | Empresa |
| tercero | proveedores | nombre_contacto | Nombre de contacto | SAE | suppliers_2026_03_22_13_20_16.xlsx | Nombre |
| tercero | proveedores | direccion | Dirección | SAE | suppliers_2026_03_22_13_20_16.xlsx | Dirección |
| tercero | proveedores | ciudad | Ciudad | SAE | suppliers_2026_03_22_13_20_16.xlsx | Ciudad |
| tercero | proveedores | departamento | Departamento | SAE | suppliers_2026_03_22_13_20_16.xlsx | Departamento |
| tercero | proveedores | codigo_postal | Código postal | SAE | suppliers_2026_03_22_13_20_16.xlsx | Código Postal |
| tercero | proveedores | pais | País | SAE | suppliers_2026_03_22_13_20_16.xlsx | País |
| tercero | proveedores | telefono | Teléfono | SAE | suppliers_2026_03_22_13_20_16.xlsx | Teléfono |
| tercero | proveedores | email | Email | SAE | suppliers_2026_03_22_13_20_16.xlsx | Email |
| tercero | proveedores | condicion_pago | Condición de pago | ERP | - | - |
| tercero | proveedores | cuenta_bancaria | Cuenta bancaria principal | SAE | suppliers_2026_03_22_13_20_16.xlsx | Proveedor Campo personalizado 1 |
| tercero | proveedores | campo_personalizado_2 | Campo personalizado 2 | SAE | suppliers_2026_03_22_13_20_16.xlsx | Proveedor Campo personalizado 2 |
| tercero | proveedores | campo_personalizado_3 | Campo personalizado 3 | SAE | suppliers_2026_03_22_13_20_16.xlsx | Proveedor Campo personalizado 3 |
| tercero | proveedores | campo_personalizado_4 | Campo personalizado 4 | SAE | suppliers_2026_03_22_13_20_16.xlsx | Proveedor Campo Personalizado 4 |
| tercero | proveedores | campo_personalizado_5 | Campo personalizado 5 | SAE | suppliers_2026_03_22_13_20_16.xlsx | Proveedor Campo Personalizado 5 |
| tercero | proveedores | campo_personalizado_6 | Campo personalizado 6 | SAE | suppliers_2026_03_22_13_20_16.xlsx | Proveedor Campo personalizado 6 |
| tercero | proveedores | es_transportista | Marca proveedor como transportista | ERP | - | - |
| tercero | proveedores | fecha_creacion | Fecha de creación del proveedor | ERP | - | - |
| tercero | proveedores | fecha_ultima_compra | Fecha de última compra | DERIVED | - | - |
| tercero | proveedores | dias_entrega_promedio | Días promedio de entrega de OC | DERIVED | - | - |
| tercero | proveedores | score_cumplimiento | KPI de cumplimiento de entregas | DERIVED | - | - |

---

## Archivos de export referenciados (índice)

| Archivo (ejemplo) | Uso principal |
|-------------------|---------------|
| ProductsPerUnits2026_03_22.xlsx | Maestro productos / UMs / costos / listas |
| customers_2026_03_22_13_19_13.xlsx | Clientes |
| suppliers_2026_03_22_13_20_16.xlsx | Proveedores |
| sample_purchase_products-1.xlsx | Líneas de compra (muestra) |
| sample_transfer_products.csv | Líneas de traslado (muestra) |

---

## Siguientes pasos sugeridos

1. Confirmar origen de `plazo_dias` en compras (proveedor vs customers) y actualizar fila en §1.
2. Sustituir columnas de stock con nombre de sucursal por modelo **sucursal_id + stock** en Postgres.
3. Al cerrar nombres de archivo reales, actualizar § índice y reglas de importación (T1.1.5–T1.1.6).
