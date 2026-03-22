# Mapeo SAE / export → modelo ERP (Satélite)

**Propósito:** documentar la **estructura y datos** que se pretenden extraer de informes y export del **SAE** hacia tablas objetivo del ERP. Complementa [EXCEL_ANALYSIS.md](./EXCEL_ANALYSIS.md) (checklist de obtención y calidad del archivo).

**Convenciones**

| Valor en *origen* | Significado |
|-------------------|-------------|
| UI | Pantalla / flujo en el SAE |
| Archivo | Columna en Excel o CSV exportado |
| Maestro | Resolución vía catálogo maestro (p. ej. productos por código) |
| Derivado | Regla o lookup (no viene literal en una sola celda) |
| Calculado | Derivado numérico en el ERP |
| ERP | Generado por el sistema (IDs, auditoría) |
| Manual / Manual/Config | Captura humana o parámetros |

Los nombres de **archivo_origen** son ejemplos con fecha; al importar conviene normalizar o parametrizar rutas.

---

## 1. `compras_encabezado`

| entidad | tabla | campo_erp | descripcion | origen | archivo_origen | columna_origen |
|---------|-------|-----------|-------------|--------|----------------|----------------|
| compras | compras_encabezado | id_compra | Id interno de la compra | ERP | - | - |
| compras | compras_encabezado | num_compra | Número interno (COM-...) | UI | - | Número |
| compras | compras_encabezado | fecha_compra | Fecha de la compra | UI | - | Fecha |
| compras | compras_encabezado | id_sucursal | Sucursal donde se registra la compra | UI | - | Sucursal |
| compras | compras_encabezado | id_bodega | Bodega de ingreso de mercancía | UI | - | Bodega |
| compras | compras_encabezado | id_proveedor | Proveedor | UI | suppliers_2026_03_22_13_20_16.xlsx | NIT/CC (lookup sobre proveedores) |
| compras | compras_encabezado | tipo_compra | Productos / Gastos / Gasto importación | UI | - | Tipo de compra |
| compras | compras_encabezado | moneda | Moneda de la compra | Manual/Config | - | - |
| compras | compras_encabezado | tasa_cambio | Tasa de cambio | Manual | - | - |
| compras | compras_encabezado | num_doc_proveedor | Número de factura del proveedor | Manual | - | - |
| compras | compras_encabezado | fecha_doc_proveedor | Fecha de factura del proveedor | Manual | - | - |
| compras | compras_encabezado | estado_compra | Estado (Aprobado / No aprobado) | UI | - | Estado |
| compras | compras_encabezado | flete_otro_gasto_monto | Total fletes y otros gastos | UI | - | Fletes y/o otros gastos |
| compras | compras_encabezado | flete_prorratear | Si se prorratea flete en ítems (Sí/No) | UI | - | Prorratear el costo de Fletes... |
| compras | compras_encabezado | num_pago | Número de pago | UI | - | Número de pago |
| compras | compras_encabezado | afecta_caja | Indica si afecta caja | UI | - | ¿El pago a esta compra afecta caja? |
| compras | compras_encabezado | forma_pago | Forma de pago | UI | - | Forma de pago |
| compras | compras_encabezado | plazo_dias | Plazo de crédito predeterminado | Derivado | customers_2026_03_22_13_19_13.xlsx | Plazo predeterminado (según proveedor) |
| compras | compras_encabezado | nota_compra | Nota u observación de la compra | UI | - | Nota |
| compras | compras_encabezado | fecha_creacion | Fecha de creación del registro | ERP | - | - |

> **Nota:** `plazo_dias` referencia archivo *customers* en el origen indicado; validar si en SAE el plazo por proveedor vive en maestro de proveedores y corregir `archivo_origen` cuando se confirme.

---

## 2. `compras_detalle`

| entidad | tabla | campo_erp | descripcion | origen | archivo_origen | columna_origen |
|---------|-------|-----------|-------------|--------|----------------|----------------|
| compras | compras_detalle | id_compra_linea | Id interno de línea de compra | ERP | - | - |
| compras | compras_detalle | id_compra | FK a encabezado de compra | ERP | - | - |
| compras | compras_detalle | cod_producto | Código/PLU del producto | Archivo | sample_purchase_products-1.xlsx | Codigo Producto |
| compras | compras_detalle | id_producto | Id interno de producto (lookup por código) | Derivado | ProductsPerUnits2026_03_22.xlsx | Código |
| compras | compras_detalle | variante | Variante de producto | Archivo | sample_purchase_products-1.xlsx | Variante |
| compras | compras_detalle | cantidad | Cantidad comprada | Archivo | sample_purchase_products-1.xlsx | Cantidad |
| compras | compras_detalle | um_compra | Unidad de medida de compra | Maestro | ProductsPerUnits2026_03_22.xlsx | Comprar Código de unidad |
| compras | compras_detalle | costo_unitario_bruto | Costo unitario sin descuento | Archivo | sample_purchase_products-1.xlsx | Costo Unitario |
| compras | compras_detalle | descuento_raw | Valor o % de descuento recibido | Archivo | sample_purchase_products-1.xlsx | Descuento |
| compras | compras_detalle | tipo_descuento | Tipo de descuento (PORCENTAJE/VALOR) | Derivado | sample_purchase_products-1.xlsx | Descuento (parseado) |
| compras | compras_detalle | descuento_valor | Importe de descuento en valor | Calculado | - | - |
| compras | compras_detalle | costo_unitario_neto | Costo después de descuento | Calculado | - | - |
| compras | compras_detalle | nombre_impuesto | Nombre de impuesto (IVA19, Exento, etc.) | Archivo | sample_purchase_products-1.xlsx | Nombre Impuesto |
| compras | compras_detalle | id_impuesto | FK a catálogo de impuestos | Derivado | - | - |
| compras | compras_detalle | imp_monto_unitario | Valor de impuesto por unidad | Calculado | - | - |
| compras | compras_detalle | costo_unitario_final | Costo total unitario (incluye impuesto + flete) | Calculado | - | - |
| compras | compras_detalle | caducidad_fecha | Fecha de caducidad del producto | Archivo | sample_transfer_products.csv | Expiry (si aplica a compras) |
| compras | compras_detalle | lote_codigo | Código de lote | Manual | - | - |
| compras | compras_detalle | flete_prorrateado_unit | Flete u otros gastos prorrateados por unidad | Calculado | - | - |
| compras | compras_detalle | subtotal_linea | Cantidad × costo_unitario_final | Calculado | - | - |
| compras | compras_detalle | nota_linea | Observación de línea | Manual | - | - |

---

## 3. `productos`

| entidad | tabla | campo_erp | descripcion | origen | archivo_origen | columna_origen |
|---------|-------|-----------|-------------|--------|----------------|----------------|
| producto | productos | id_producto | Id interno de producto | ERP | - | - |
| producto | productos | sku_codigo | Código interno / SKU | Archivo | ProductsPerUnits2026_03_22.xlsx | Código |
| producto | productos | nombre | Nombre comercial | Archivo | ProductsPerUnits2026_03_22.xlsx | Nombre |
| producto | productos | referencia_interna | Referencia / modelo | Archivo | ProductsPerUnits2026_03_22.xlsx | Referencia |
| producto | productos | marca | Marca | Archivo | ProductsPerUnits2026_03_22.xlsx | Marca |
| producto | productos | categoria | Categoría/familia | Archivo | ProductsPerUnits2026_03_22.xlsx | Categoría |
| producto | productos | subcategoria | Subcategoría | Archivo | ProductsPerUnits2026_03_22.xlsx | Subcategoría |
| producto | productos | codigo_subcategoria | Código de subcategoría | Archivo | ProductsPerUnits2026_03_22.xlsx | Código de Subcategoría |
| producto | productos | codigo_barras | Código de barras (EAN/UPC) | Manual/Archivo | ProductsPerUnits2026_03_22.xlsx | (EAN, si existe) |
| producto | productos | clase_codigo_barras | Tipo de código de barras (code128, etc.) | Archivo | ProductsPerUnits2026_03_22.xlsx | Clase de código de barras |
| producto | productos | um_base | Unidad de medida base | Archivo | ProductsPerUnits2026_03_22.xlsx | UM Base |
| producto | productos | um_venta | Unidad de medida de venta | Archivo | ProductsPerUnits2026_03_22.xlsx | Venta Código de unidad |
| producto | productos | um_compra | Unidad de medida de compra | Archivo | ProductsPerUnits2026_03_22.xlsx | Comprar Código de unidad |
| producto | productos | factor_um_base | Factor vs UM base | Archivo | ProductsPerUnits2026_03_22.xlsx | Factor |
| producto | productos | um_alt_2 | Unidad alternativa 2 | Archivo | ProductsPerUnits2026_03_22.xlsx | UM2 |
| producto | productos | factor_alt_2 | Factor unidad alternativa 2 | Archivo | ProductsPerUnits2026_03_22.xlsx | Factor2 |
| producto | productos | um_alt_3 | Unidad alternativa 3 | Archivo | ProductsPerUnits2026_03_22.xlsx | UM3 |
| producto | productos | factor_alt_3 | Factor unidad alternativa 3 | Archivo | ProductsPerUnits2026_03_22.xlsx | Factor3 |
| producto | productos | um_alt_4 | Unidad alternativa 4 | Archivo | ProductsPerUnits2026_03_22.xlsx | UM4 |
| producto | productos | factor_alt_4 | Factor unidad alternativa 4 | Archivo | ProductsPerUnits2026_03_22.xlsx | Factor4 |
| producto | productos | um_alt_5 | Unidad alternativa 5 | Archivo | ProductsPerUnits2026_03_22.xlsx | UM5 |
| producto | productos | factor_alt_5 | Factor unidad alternativa 5 | Archivo | ProductsPerUnits2026_03_22.xlsx | Factor5 |
| producto | productos | um_alt_6 | Unidad alternativa 6 | Archivo | ProductsPerUnits2026_03_22.xlsx | UM6 |
| producto | productos | factor_alt_6 | Factor unidad alternativa 6 | Archivo | ProductsPerUnits2026_03_22.xlsx | Factor6 |
| producto | productos | costo_ultimo | Último costo | Archivo | ProductsPerUnits2026_03_22.xlsx | Último costo |
| producto | productos | costo_promedio | Costo promedio | Archivo | ProductsPerUnits2026_03_22.xlsx | Costo promedio |
| producto | productos | precio_lista_base | Precio lista HOLA AMIGO JC | Archivo | ProductsPerUnits2026_03_22.xlsx | Precio HOLA AMIGO JC |
| producto | productos | precio_lista_bolsas | Precio lista bolsas | Archivo | ProductsPerUnits2026_03_22.xlsx | Precio bolsas |
| producto | productos | stock_alerta | Cantidad de alerta | Archivo | ProductsPerUnits2026_03_22.xlsx | Cantidad de alerta |
| producto | productos | tasa_impuesto | Tasa de impuestos (IVA 19%, etc.) | Archivo | ProductsPerUnits2026_03_22.xlsx | Tasa de impuestos |
| producto | productos | metodo_calculo_impuesto | Método de cálculo (incluido/excl.) | Archivo | ProductsPerUnits2026_03_22.xlsx | Método de cálculo de impuestos |
| producto | productos | url_imagen | Ruta/archivo de imagen | Archivo | ProductsPerUnits2026_03_22.xlsx | Imagen |
| producto | productos | stock_sucursal_1 | Stock sucursal principal | Archivo | ProductsPerUnits2026_03_22.xlsx | COMERCIALIZADORA HOLA AMIGO JC |
| producto | productos | stock_sucursal_2 | Stock sucursal TIENDA PUNTO DE VENTA | Archivo | ProductsPerUnits2026_03_22.xlsx | TIENDA PUNTO DE VENTA |
| producto | productos | stock_total | Stock total | Archivo | ProductsPerUnits2026_03_22.xlsx | Cantidad |
| producto | productos | producto_inactivo | Marca si producto está inactivo | Archivo | ProductsPerUnits2026_03_22.xlsx | Producto inactivo |
| producto | productos | descripcion_detallada | Descripción larga | Archivo | ProductsPerUnits2026_03_22.xlsx | Detalles de producto |
| producto | productos | garantia_dias | Tiempo de garantía en días | Archivo | ProductsPerUnits2026_03_22.xlsx | Tiempo garantía (Días) |
| producto | productos | variantes_texto | Texto de variantes | Archivo | ProductsPerUnits2026_03_22.xlsx | Variantes de producto |
| producto | productos | campo_personalizado_1 | Campo personalizado 1 | Archivo | ProductsPerUnits2026_03_22.xlsx | Producto Campo Personalizado 1 |
| producto | productos | campo_personalizado_2 | Campo personalizado 2 | Archivo | ProductsPerUnits2026_03_22.xlsx | Producto Campo Personalizado 2 |
| producto | productos | campo_personalizado_3 | Campo personalizado 3 | Archivo | ProductsPerUnits2026_03_22.xlsx | Producto Campo Personalizado 3 |
| producto | productos | campo_personalizado_4 | Campo personalizado 4 | Archivo | ProductsPerUnits2026_03_22.xlsx | Producto Campo Personalizado 4 |
| producto | productos | campo_personalizado_5 | Campo personalizado 5 | Archivo | ProductsPerUnits2026_03_22.xlsx | Producto Campo Personalizado 5 |
| producto | productos | campo_personalizado_6 | Campo personalizado 6 | Archivo | ProductsPerUnits2026_03_22.xlsx | Producto Campo Personalizado 6 |
| producto | productos | zona_producto | Zona para inventario_restauracion | Manual | - | - |
| producto | productos | peso | Peso del producto | Manual | - | - |
| producto | productos | dimensiones | Dimensiones | Manual | - | - |
| producto | productos | estado_producto | Activo / Inactivo / Descontinuado | Derivado | ProductsPerUnits2026_03_22.xlsx | Producto inactivo |

> **Nota:** columnas de stock por sucursal con nombre fijo de negocio conviene normalizar a `id_sucursal` + tabla de ubicaciones en el ERP.

---

## 4. `traslados_encabezado`

| entidad | tabla | campo_erp | descripcion | origen | archivo_origen | columna_origen |
|---------|-------|-----------|-------------|--------|----------------|----------------|
| inventario | traslados_encabezado | id_traslado | Id interno del traslado | ERP | - | - |
| inventario | traslados_encabezado | num_traslado | Número interno (TRA-...) | UI | - | Número |
| inventario | traslados_encabezado | fecha_traslado | Fecha del traslado | UI | - | Fecha (si existe en UI) |
| inventario | traslados_encabezado | id_sucursal_origen | Sucursal origen | UI | - | Sucursal origen |
| inventario | traslados_encabezado | id_bodega_origen | Bodega origen | UI | - | Desde la bodega |
| inventario | traslados_encabezado | id_bodega_destino | Bodega destino | UI | - | Para la bodega |
| inventario | traslados_encabezado | estado_traslado | Pendiente / Enviado / Completado | UI | - | Estado |
| inventario | traslados_encabezado | flete_otro_gasto | Flete y otros gastos | UI | - | Flete y/o otros gastos |
| inventario | traslados_encabezado | motivo_traslado | Motivo del traslado | Manual | - | - |
| inventario | traslados_encabezado | responsable_solicita | Usuario que solicita | ERP | - | - |
| inventario | traslados_encabezado | responsable_aprueba | Usuario que aprueba | Manual | - | - |
| inventario | traslados_encabezado | nota_traslado | Nota u observación | UI | - | Nota |

---

## 5. `traslados_detalle`

| entidad | tabla | campo_erp | descripcion | origen | archivo_origen | columna_origen |
|---------|-------|-----------|-------------|--------|----------------|----------------|
| inventario | traslados_detalle | id_traslado_linea | Id interno de línea de traslado | ERP | - | - |
| inventario | traslados_detalle | id_traslado | FK a encabezado de traslado | ERP | - | - |
| inventario | traslados_detalle | cod_producto | Código de producto | Archivo | sample_transfer_products.csv | Product Code |
| inventario | traslados_detalle | id_producto | Id interno de producto | Derivado | ProductsPerUnits2026_03_22.xlsx | Código |
| inventario | traslados_detalle | variante | Variante de producto | Archivo | sample_transfer_products.csv | Product Variant |
| inventario | traslados_detalle | cantidad | Cantidad a trasladar | Archivo | sample_transfer_products.csv | Quantity |
| inventario | traslados_detalle | um_traslado | Unidad de medida utilizada | Maestro | ProductsPerUnits2026_03_22.xlsx | UM Base |
| inventario | traslados_detalle | costo_unitario_ref | Costo unitario de referencia | Archivo | sample_transfer_products.csv | Unit Cost |
| inventario | traslados_detalle | expiry | Fecha de caducidad | Archivo | sample_transfer_products.csv | Expiry |
| inventario | traslados_detalle | lote_codigo | Código de lote | Manual | - | - |
| inventario | traslados_detalle | subtotal_costo | Cantidad × costo_unitario_ref | Calculado | - | - |
| inventario | traslados_detalle | nota_linea | Observación de línea | Manual | - | - |

---

## 6. `clientes` (terceros tipo cliente)

| entidad | tabla | campo_erp | descripcion | origen | archivo_origen | columna_origen |
|---------|-------|-----------|-------------|--------|----------------|----------------|
| tercero | clientes | id_tercero | Id interno del tercero | ERP | - | - |
| tercero | clientes | tipo_tercero | Tipo de tercero (Cliente) | Derivado | customers_2026_03_22_13_19_13.xlsx | - |
| tercero | clientes | estado | Estado (Activo/Inactivo) | Archivo | customers_2026_03_22_13_19_13.xlsx | Estado |
| tercero | clientes | tipo_documento | Tipo de documento (NIT/CC) | Archivo | customers_2026_03_22_13_19_13.xlsx | Tipo documento |
| tercero | clientes | num_documento | Número de documento | Archivo | customers_2026_03_22_13_19_13.xlsx | NIT/CC |
| tercero | clientes | dv | Dígito de verificación | Archivo | customers_2026_03_22_13_19_13.xlsx | Dígito de verificación |
| tercero | clientes | tipo_persona | Natural / Jurídica | Archivo | customers_2026_03_22_13_19_13.xlsx | Tipo de persona |
| tercero | clientes | tipo_regimen | Régimen tributario | Archivo | customers_2026_03_22_13_19_13.xlsx | Tipo de régimen |
| tercero | clientes | razon_social | Razón social | Archivo | customers_2026_03_22_13_19_13.xlsx | Razón social |
| tercero | clientes | nombres | Nombres | Archivo | customers_2026_03_22_13_19_13.xlsx | Nombres |
| tercero | clientes | segundo_nombre | Segundo nombre | Archivo | customers_2026_03_22_13_19_13.xlsx | Segundo nombre |
| tercero | clientes | primer_apellido | Primer apellido | Archivo | customers_2026_03_22_13_19_13.xlsx | Primer apellido |
| tercero | clientes | segundo_apellido | Segundo apellido | Archivo | customers_2026_03_22_13_19_13.xlsx | Segundo apellido |
| tercero | clientes | nombre_comercial | Nombre Comercial | Archivo | customers_2026_03_22_13_19_13.xlsx | Nombre Comercial |
| tercero | clientes | direccion | Dirección | Archivo | customers_2026_03_22_13_19_13.xlsx | Dirección |
| tercero | clientes | zona | Zona | Archivo | customers_2026_03_22_13_19_13.xlsx | Zona |
| tercero | clientes | barrio | Barrio | Archivo | customers_2026_03_22_13_19_13.xlsx | Barrio |
| tercero | clientes | ciudad | Ciudad | Archivo | customers_2026_03_22_13_19_13.xlsx | Ciudad |
| tercero | clientes | departamento | Departamento | Archivo | customers_2026_03_22_13_19_13.xlsx | Departamento |
| tercero | clientes | pais | País | Archivo | customers_2026_03_22_13_19_13.xlsx | País |
| tercero | clientes | telefono | Teléfono | Archivo | customers_2026_03_22_13_19_13.xlsx | Teléfono |
| tercero | clientes | email | Email | Archivo | customers_2026_03_22_13_19_13.xlsx | Email |
| tercero | clientes | mes_cumple | Mes de cumpleaños | Archivo | customers_2026_03_22_13_19_13.xlsx | Mes de cumpleaños |
| tercero | clientes | dia_cumple | Día de cumpleaños | Archivo | customers_2026_03_22_13_19_13.xlsx | Día de cumpleaños |
| tercero | clientes | genero | Género | Archivo | customers_2026_03_22_13_19_13.xlsx | Género |
| tercero | clientes | lista_precios | Lista de precios asignada | Archivo | customers_2026_03_22_13_19_13.xlsx | Lista Precios |
| tercero | clientes | grupo_cliente | Grupo de clientes | Archivo | customers_2026_03_22_13_19_13.xlsx | Grupo |
| tercero | clientes | vendedor_principal_id | Vendedor principal asignado | Archivo | customers_2026_03_22_13_19_13.xlsx | Vendedor principal asignado |
| tercero | clientes | afiliado_id | Afiliado asignado | Archivo | customers_2026_03_22_13_19_13.xlsx | Afiliado Asignado |
| tercero | clientes | tipo_pago | Tipo de pago del cliente | Archivo | customers_2026_03_22_13_19_13.xlsx | Tipo de pago del cliente |
| tercero | clientes | limite_credito | Límite de crédito | Archivo | customers_2026_03_22_13_19_13.xlsx | Límite de crédito |
| tercero | clientes | plazo_predeterminado | Plazo predeterminado | Archivo | customers_2026_03_22_13_19_13.xlsx | Plazo predeterminado |
| tercero | clientes | no_acumular_puntos | No acumular puntos (flag origen) | Archivo | customers_2026_03_22_13_19_13.xlsx | No acumular puntos |
| tercero | clientes | acumula_puntos | Indica si acumula puntos | Derivado | customers_2026_03_22_13_19_13.xlsx | No acumular puntos |
| tercero | clientes | puntos_premio | Puntos acumulados | Archivo | customers_2026_03_22_13_19_13.xlsx | Puntos Premio |
| tercero | clientes | valor_anticipo | Valor de anticipo | Archivo | customers_2026_03_22_13_19_13.xlsx | Valor de anticipo |
| tercero | clientes | solo_pos | Cliente solo para POS | Archivo | customers_2026_03_22_13_19_13.xlsx | Cliente sólo para POS |
| tercero | clientes | exento_impuestos | Cliente exento de impuestos | Archivo | customers_2026_03_22_13_19_13.xlsx | Cliente Exento de Impuestos |
| tercero | clientes | aplicar_ret_sin_base | Aplicar retenciones sin validar base mínima | Archivo | customers_2026_03_22_13_19_13.xlsx | Aplicar retenciones sin validar base mínima |
| tercero | clientes | es_retenedor_fuente | Cliente es retenedor de fuente | Archivo | customers_2026_03_22_13_19_13.xlsx | Retenedor de Fuente |
| tercero | clientes | es_retenedor_iva | Cliente es retenedor de IVA | Archivo | customers_2026_03_22_13_19_13.xlsx | Retenedor de IVA |
| tercero | clientes | es_retenedor_ica | Cliente es retenedor de ICA | Archivo | customers_2026_03_22_13_19_13.xlsx | Retenedor de ICA |
| tercero | clientes | fecha_creacion | Fecha de creación del cliente | ERP | - | - |
| tercero | clientes | fecha_ultima_compra | Fecha de última compra | Calculado | - | - |

---

## 7. `proveedores` (terceros tipo proveedor)

| entidad | tabla | campo_erp | descripcion | origen | archivo_origen | columna_origen |
|---------|-------|-----------|-------------|--------|----------------|----------------|
| tercero | proveedores | id_tercero | Id interno del tercero | ERP | - | - |
| tercero | proveedores | tipo_tercero | Tipo de tercero (Proveedor) | Derivado | suppliers_2026_03_22_13_20_16.xlsx | - |
| tercero | proveedores | estado | Estado (Activo/Inactivo) | Manual | - | - |
| tercero | proveedores | tipo_documento | Tipo documento (NIT/CC) | Manual | - | - |
| tercero | proveedores | num_documento | Número de documento | Archivo | suppliers_2026_03_22_13_20_16.xlsx | NIT/CC |
| tercero | proveedores | dv | Dígito de verificación | Manual | - | - |
| tercero | proveedores | tipo_persona | Natural/Jurídica | Manual | - | - |
| tercero | proveedores | razon_social | Razón social | Archivo | suppliers_2026_03_22_13_20_16.xlsx | Empresa |
| tercero | proveedores | nombre_contacto | Nombre de contacto | Archivo | suppliers_2026_03_22_13_20_16.xlsx | Nombre |
| tercero | proveedores | direccion | Dirección | Archivo | suppliers_2026_03_22_13_20_16.xlsx | Dirección |
| tercero | proveedores | ciudad | Ciudad | Archivo | suppliers_2026_03_22_13_20_16.xlsx | Ciudad |
| tercero | proveedores | departamento | Departamento | Archivo | suppliers_2026_03_22_13_20_16.xlsx | Departamento |
| tercero | proveedores | codigo_postal | Código postal | Archivo | suppliers_2026_03_22_13_20_16.xlsx | Código Postal |
| tercero | proveedores | pais | País | Archivo | suppliers_2026_03_22_13_20_16.xlsx | País |
| tercero | proveedores | telefono | Teléfono | Archivo | suppliers_2026_03_22_13_20_16.xlsx | Teléfono |
| tercero | proveedores | email | Email | Archivo | suppliers_2026_03_22_13_20_16.xlsx | Email |
| tercero | proveedores | condicion_pago | Condición de pago | Manual | - | - |
| tercero | proveedores | cuenta_bancaria | Cuenta bancaria principal | Archivo | suppliers_2026_03_22_13_20_16.xlsx | Proveedor Campo personalizado 1 |
| tercero | proveedores | campo_personalizado_2 | Campo personalizado 2 | Archivo | suppliers_2026_03_22_13_20_16.xlsx | Proveedor Campo personalizado 2 |
| tercero | proveedores | campo_personalizado_3 | Campo personalizado 3 | Archivo | suppliers_2026_03_22_13_20_16.xlsx | Proveedor Campo personalizado 3 |
| tercero | proveedores | campo_personalizado_4 | Campo personalizado 4 | Archivo | suppliers_2026_03_22_13_20_16.xlsx | Proveedor Campo Personalizado 4 |
| tercero | proveedores | campo_personalizado_5 | Campo personalizado 5 | Archivo | suppliers_2026_03_22_13_20_16.xlsx | Proveedor Campo Personalizado 5 |
| tercero | proveedores | campo_personalizado_6 | Campo personalizado 6 | Archivo | suppliers_2026_03_22_13_20_16.xlsx | Proveedor Campo personalizado 6 |
| tercero | proveedores | es_transportista | Marca proveedor como transportista | Manual | - | - |
| tercero | proveedores | fecha_creacion | Fecha de creación del proveedor | ERP | - | - |
| tercero | proveedores | fecha_ultima_compra | Fecha de última compra | Calculado | - | - |

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

1. Validar en SAE si `plazo_dias` en compras debe enlazarse a **proveedor** (no customers).
2. Sustituir columnas de stock con nombre de sucursal por modelo **sucursal_id + stock** en Postgres.
3. Al cerrar nombres de archivo reales, actualizar § índice y reglas de importación (T1.1.5–T1.1.6).
