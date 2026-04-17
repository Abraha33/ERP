# DATA_MODEL

## Objetivo
Describir las entidades principales del ERP+CRM y sus relaciones de negocio.

## Núcleo organizacional
- Empresa
- Sucursal
- Bodega
- Usuario
- Rol
- Permiso

## Maestros
- Tercero
- Cliente
- Proveedor
- Empleado
- Producto
- Servicio
- Categoría
- Lista de precios
- Impuesto

## Comercial
- Cotización
- Pedido de venta
- Remisión
- Factura de venta
- Nota crédito
- Recibo de caja

## Compras
- Solicitud de compra
- Orden de compra
- Recepción
- Factura proveedor
- Nota débito/crédito proveedor
- Egreso

## Inventario
- Movimiento inventario
- Kardex
- Lote/serie
- Ajuste
- Traslado
- Conteo físico

## Financiero
- Cuenta contable
- Comprobante
- Movimiento contable
- Centro de costo
- Cuenta por cobrar
- Cuenta por pagar
- Conciliación

## CRM
- Lead
- Oportunidad
- Actividad
- Contacto
- Canal
- Estado oportunidad

## Relaciones clave
- Empresa 1:N Sucursales
- Sucursal 1:N Bodegas
- Tercero puede ser cliente y/o proveedor
- Pedido de venta -> factura de venta
- Orden de compra -> recepción -> factura proveedor
- Factura genera movimientos contables e impacto en cartera
- Movimiento inventario afecta kardex y existencias
- Lead puede convertirse en cliente/oportunidad

## Reglas transversales
- Toda entidad operativa debe incluir company_id
- Toda entidad transaccional debe incluir created_by y timestamps
- Soft delete solo donde aplique
- Numeración documental configurable por empresa/sucursal/tipo

## Pendientes
- Definir estrategia exacta multiempresa
- Definir lotes/series para MVP o fase posterior
- Definir si contabilidad nace en MVP o fase incremental