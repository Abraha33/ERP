# App (ERP + CRM)

Sistema integrado: ERP como núcleo operativo y de datos; CRM como módulo de relación con clientes y contacto (mensajería, casos, pedidos). Referencia actual: Wappsi.

---

## 0. Arquitectura y stack técnico

- **Arquitectura (decisión cerrada)**: **monolito modular headless**.
- **Backend principal**: **FastAPI (Python)**.
- **API**: **REST versionada** bajo **`/api/v1`**.
- **Comunicación interna (entre módulos)**: **llamadas internas en Python** (no HTTP entre módulos).
- **Persistencia (MVP)**: **una sola BD transaccional**: PostgreSQL (Supabase).
- **Auth**: Supabase Auth (JWT) validado en backend; **RBAC** por roles de negocio.
- **Asíncrono (MVP)**: eventos in-process + tabla `jobs/outbox` en Postgres + worker (sin “plataforma de colas” externa).

Referencia: [ADR-001](../ADR-001-architecture-stack.md).

---

## 1. ERP — Módulos principales

### 1.1 Catálogos / Maestros
- **Productos**
    - SKU, nombre, descripción, categoría/familia, subcategoría.
    - Unidad de medida (venta y compra), conversiones.
    - Estado: activo, inactivo, descontinuado.
    - Atributos: peso, dimensiones, imagen, código de barras.
    - Zona de producto (conjunto de productos para inventario_restauracion).
- **Precios y listas**
    - Listas por canal: POS, mayorista, electrónica.
    - Precio de venta, costo, costo promedio; moneda.
    - Descuentos por volumen o por cliente/listas especiales.
    - Vigencia de precios y cambios de precio (historial).
- **Ubicaciones / bodegas**
    - Almacenes y ubicaciones internas (estantería, zona).
    - Tipo: venta, compra, tránsito, devoluciones.
    - Responsable por ubicación (opcional).
- **Terceros (maestro compartido)**
    - Clientes: datos fiscales, dirección de facturación y envío, contacto, condiciones de pago, lista de precios.
    - Proveedores: datos fiscales, contacto, condiciones de pago, cuentas bancarias.
    - Transportistas: nombre, contacto, tarifas o convenios.
- **Numeración y secuencias**: generación única de números para OC, OV, factura, pedido, caso, ajuste; reglas por tipo, año y/o sucursal; manejo de concurrencia (secuencias atómicas o bloqueo optimista).

### 1.2 Compras
- Órdenes de compra (OC): encabezado y líneas por producto, cantidad, precio, proveedor, fecha esperada.
- Estados de compra: borrador, enviada, parcialmente recibida, recibida, facturada, cerrada, cancelada.
- Ingreso de facturas de proveedor: vincular a OC, cargar factura (PDF/XML), registrar precios y cambios.
- Devoluciones a proveedor: por OC o por factura; estados y reembolso o crédito.
- Aprobaciones: flujo de autorización (encargado, límites por monto).
- Historial de compras por proveedor y por producto (para CRM y reportes).

### 1.3 Ventas
- **Cotizaciones**: crear cotización → vigencia → aprobación → convertir a pedido/OV; historial y seguimiento en CRM.
- Órdenes de venta (OV): orígenes — punto de venta (POS), mayorista, electrónica (e-commerce), CRM (pedido desde chat).
- Pedidos: conversión pedido → OV; estados (borrador, confirmado, facturado, preparando, enviado, entregado, cancelado).
- **Picking y packing**: entre "prepara pedido" y "envío": lista de picking por ubicación, empaque (peso/dimensiones para envío), opcional captura de lotes/series.
- Facturación: factura desde OV, facturación electrónica/fiscal (emisión, timbrado, cancelación según país).
- Envíos y logística: transportista, guía, seguimiento; estados (por despachar, en tránsito, entregado).
- Devoluciones de clientes: solicitud, aprobación, recepción, reembolso o crédito; vinculación con inventario y contabilidad.
- Condiciones de pago: contado, crédito, plazos; vencimientos y recordatorios.

### 1.4 Inventario
- Stock por producto y por ubicación; stock disponible vs reservado vs en tránsito.
- Traslados entre ubicaciones: solicitud, aprobación, ejecución; estados.
- Estados de inventario: disponible, bloqueado, en cuarentena, dañado, etc.
- Ajustes y auditorías: motivo, cantidad, aprobación, trazabilidad (quién, cuándo).
- Stocks de seguridad y alertas por producto o por tipo (stock mínimo, punto de reorden).
- Lotes y caducidad (opcional): por lote o fecha de vencimiento; FIFO/FEFO.
- Inventario_restauracion (disparado desde CRM): contar zona → confirmar cantidad → orden de compra → autorización encargado.

### 1.5 Contabilidad
- Plan de cuentas y cuentas contables.
- Asientos contables: manuales y automáticos (desde facturación, compras, nómina).
- Integración con facturación: ventas y compras generan asientos (o interfaz con sistema contable externo).
- Reportes financieros: balance, P&L, flujo de caja, antigüedad de saldos.
- Caja / tesorería: movimientos de efectivo y bancos, conciliación.
- Impuestos: IVA y retenciones por país; reportes fiscales.

### 1.6 RRHH
- Gestión de empleados: datos personales, puesto, departamento, jefe, fecha de ingreso.
- Nóminas: cálculo de sueldos, deducciones, bonos; generación de pagos y archivos para bancos.
- Ausencias: vacaciones, permisos, incapacidades; aprobaciones y saldos.
- Control de horas o por proyectos (opcional): registro de tiempo, asignación a órdenes o proyectos.

### 1.7 CRM (módulo del ERP)
- **Comunicación y mensajería**
    - Recibir mensajes: audio, video, texto, imagen.
    - Traducir audio a texto (transcripción).
    - Enviar mensajes.
    - Historial de conversación por cliente/contacto.
- **Casos y estados**
    - Casos por cliente: estado (abierto, en proceso, resuelto, cerrado).
    - Tipos: venta, soporte, devolución, reclamo, consulta.
    - Asignación y seguimiento.
- **Flujo de venta (pedido → entrega)**
    - Pedido: cliente tiene pedido; sin cancelar o confirmar método de pago.
    - Factura: se completa pago.
    - Prepara pedido.
    - Entrega a domicilio (domicilio definido: cliente u otro).
    - Entrega completada.
    - Durante el pedido: ver estado de inventario (quedó bajo) → disparar proceso inventario_restauracion.
- **Ventas — Clientes**
    - Historial de ventas por cliente (desde ERP).
    - Solicitudes y seguimiento (cotizaciones, pedidos, facturas pendientes).
- **Devoluciones — Clientes**
    - Historial de devoluciones por cliente (desde ERP).
    - Solicitudes y seguimiento de devoluciones.
- **Contactos — Proveedores**
    - Historial de compras por proveedor (desde ERP).
    - Solicitudes y seguimiento (OC, facturas pendientes).
- **Filtros y vistas**
    - Por estado de cliente (activo, inactivo, moroso, etc.).
    - Por tipo de solicitud o caso.
    - Por asignado, por fecha, por canal.

### 1.8 Dashboards y reportes
- Resumen de métricas: ventas (por día/semana/mes, por canal), compras, stock (valorizado, alertas), finanzas (caja, cuentas por cobrar/pagar).
- Reportes por período: ventas, compras, inventario, finanzas; filtros por fecha, cliente, producto, ubicación, vendedor.
- Exportar: Excel, PDF.
- Gráficos: tendencias, comparativas, top productos/clientes.

---

## 2. Requisitos no funcionales / transversales

- **Rendimiento**: respuestas rápidas; tiempo real o cuasi tiempo real para stock, estados de pedido y alertas.
- **Alimentación del ERP**: datos entran desde POS, electrónica, mayorista, compras, inventario y desde el CRM (pedidos, casos).
- **Validación**
    - Compras: facturas, cantidades, precios, estados; duplicados y conciliación con OC.
    - Órdenes de venta: stock disponible, datos de cliente, método de pago, límites de crédito.
    - Traslados: origen/destino válidos, cantidades, disponibilidad.
    - Inventarios: ajustes y auditorías con trazabilidad y aprobación según rol.
- **Seguridad y roles**
    - Perfiles: compras, ventas, inventario, contabilidad, RRHH, CRM, admin.
    - Permisos: aprobar OC, autorizar ajustes, ver reportes financieros, gestionar nóminas, ver todos los clientes, etc.
    - Auditoría: quién aprobó o modificó qué y cuándo (movimientos críticos).
- **Multiempresa / multisucursal** (opcional): empresas o sucursales con inventario y/o contabilidad separados.
- **Consistencia e idempotencia**
    - Idempotencia: mismo pedido o pago recibido dos veces (doble clic, reconexión) no duplica OV ni movimientos; uso de idempotency keys o identificadores únicos de negocio.
    - Reserva de stock: al confirmar pedido, reservar (disponible → reservado); liberar si cancelación o vencimiento; tiempo de vida de la reserva.
    - Transacciones: operaciones atómicas donde aplique (crear OV + reservar stock + asiento); consistencia eventual aceptada donde sea explícito (ej. historial CRM alimentado por ERP).
- **Resiliencia**
    - Reconexión: reintentos y mensaje claro al usuario si falla crear pedido o consultar stock.
    - Offline: **no es requisito del MVP**. Si entra, entra **acotado a 1–2 flujos** con estrategia de conflictos explícita (ADR específico).
    - Timeouts y circuit breaker en llamadas a facturación electrónica y pasarelas de pago.

---

## 3. Integración CRM ↔ ERP

- **Principio**: ERP y CRM comparten proceso y BD transaccional, pero mantienen **límites por dominio** (módulos) para evitar caos.
- **Integración interna (ERP↔CRM dentro del monolito)**: no hay “API entre módulos”. Hay **servicios internos** y **eventos de dominio in-process**.
- **Integración externa**: clientes (Web ERP, POS, e-commerce, móvil) consumen **`/api/v1`**.
- **Eventos/webhooks**: solo cuando haya un consumidor externo real. Dentro del monolito, eventos son in-process; para async se usa `jobs/outbox`.
- **Versionado de API**: `/api/v1` no se rompe; cambios incompatibles van a `/api/v2` con deprecación.
- Flujos concretos:
    - CRM consulta **stock** en el ERP; si "quedó bajo" dispara **inventario_restauracion**.
    - Pedido confirmado en CRM → crea o actualiza **orden de venta** en ERP.
    - ERP notifica al CRM: factura generada, pedido listo para preparar, enviado, entregado.
    - Devolución en CRM → genera o vincula **devolución** en ERP (ventas/inventario).
    - Historial en CRM (ventas, devoluciones, compras) alimentado por datos del ERP.
    - Cliente y dirección en CRM sincronizados con maestro de terceros del ERP.

### 3.1 Eventos de dominio y flujos asíncronos

- **Eventos clave**: `PedidoConfirmado`, `PagoRecibido`, `StockPorDebajoDelMinimo`, `FacturaEmitida`, `OVCreada`, `DevolucionSolicitada`, etc.
- **Consumidores**: handlers in-process (actualizar estados, disparar validaciones); y procesos async vía `jobs/outbox` (notificaciones, reportes, integraciones).
- **Worker**: consume `jobs/outbox` desde Postgres con reintentos; dead-letter simple (estado + razón) para fallos persistentes.

---

## 4. Notificaciones y alertas

- Stock bajo / ruptura → inventario_restauracion y/o alerta a compras.
- Órdenes de compra pendientes de recibir o facturar.
- Pedidos listos para preparar o para enviar (para almacén y CRM).
- Facturas de cliente vencidas o por vencer; recordatorios de pago.
- Casos o solicitudes sin asignar o vencidos (CRM).
- Alertas de caducidad de lotes (si aplica).

---

## 5. Operación: logs, monitoreo y salud

- **Logs**: estructurados (ej. JSON) con correlation id por pedido o flujo para rastrear un caso de punta a punta.
- **Métricas**: latencia de APIs críticas (stock, crear OV), tasa de error, volumen de mensajes/eventos.
- **Health checks**: endpoint `/health` o `/ready` que revise BD, colas y servicios externos (facturación, pago).
- **Alertas técnicas**: caída de workers, cola que crece sin consumir, errores 5xx por encima de umbral.

---

## 6. Backup, retención y cumplimiento

- **Backup**: base de datos con frecuencia definida; RPO/RTO (cuánto dato se puede perder y en cuánto tiempo recuperar).
- **Retención**: cuánto tiempo se guardan mensajes de chat, historial de precios, auditoría, logs de acceso.
- **Datos personales**: si aplica GDPR o ley local — anonimización, exportación, borrado; dónde se almacenan datos de clientes y empleados.

---

## 7. Calidad, ambientes y despliegue

- **Testing**: unitarios en reglas de negocio (precios, stock, límites); integración en flujos ERP ↔ CRM (pedido → OV, stock bajo → inventario_restauracion); e2e en flujo completo de venta y facturación.
- **Ambientes**: dev, staging, producción; variables de entorno y secretos (nunca hardcodear BD, APIs ni keys).
- **Despliegue**: CI/CD (build, tests, deploy); estrategia de release (blue/green o canary si aplica).
- **Feature flags** (opcional): activar/desactivar flujos sin redeploy (ej. facturación electrónica, nuevo canal).

---

## 8. Referencia: Wappsi (para comparar)

- Ventas: POS y electrónica.
- Compras: POS, electrónica, devoluciones.
- Productos: agregar/editar.
- Inventario: traslados, ajustes.
- Terceros: clientes, proveedores.

---

## 9. Nota

Este esqueleto organiza el ERP con el CRM como un módulo más. Se puede desarrollar cada módulo en su propia carpeta o archivo. Prioridad sugerida: Catálogos e Inventario → Compras → Ventas → integración CRM ↔ ERP → Contabilidad → RRHH → Dashboards y reportes avanzados.
