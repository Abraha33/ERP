# Diario — base de datos (logística)

Guía para ir cerrando cosas **de punta a punta**: primero qué quieres lograr, luego el checklist. Orden recomendado: **recepción → salud de stock → conteo ciego**. **Arqueo de caja** va aparte: primero hay que **decidir el modelo** (A/B/C) antes de escribir SQL definitivo.

---

## 1. Recepción de mercancía (triggers)

**Meta:** Que al registrar una recepción, el sistema **solo** (base de datos) mantenga stock, kardex y orden de compra al día — como tener **login y autenticación funcionando**: el usuario registra, el resto no se rompe.

| # | Qué queda funcionando |
|---|------------------------|
| 1 | **Trigger listo:** cada insert en `reception_items` dispara una función; todo ocurre en **una transacción**. |
| 2 | **Stock correcto:** suma o crea la fila por producto + bodega usando `base_quantity_calculated`. |
| 3 | **Kardex con trazabilidad:** movimiento `ENTRADA_COMPRA` en unidad base y enlace a `reception_id`. |
| 4 | **Líneas de OC al día:** `received_quantity` refleja lo recibido (en unidad de compra). |
| 5 | **Estado de OC claro:** la OC pasa a PARCIAL o COMPLETADA según lo pedido vs lo recibido; sin pisarse si dos personas reciben a la vez (bloqueos donde toque). |

**Tablas:** `reception_items` → `stock`, `kardex`, `purchase_order_items`, `purchase_orders`.

---

## 2. Salud del inventario (vista `vw_inventory_health`)

**Meta:** Un **semáforo** por producto: saber si hay quiebre, reorden, nivel bueno o exceso — **solo unidades físicas**, sin plata (eso va al SAE).

| # | Qué queda funcionando |
|---|------------------------|
| 1 | **Una consulta clara:** stock total por producto (bodegas activas) + umbrales del catálogo (`products`). |
| 2 | **Estado legible:** columna `stock_status` (CRITICO / REORDEN / OPTIMO / EXCESO) con reglas fijas. |
| 3 | **Sin sorpresas con datos feos:** reglas escritas en SQL para umbrales NULL o incoherentes. |
| 4 | **Unidad visible:** abreviatura de unidad base (`units_of_measure`) para que el front muestre bien. |
| 5 | **Dashboard usable:** vista rápida (índices / joins razonables); avisos por email/Slack = otro trabajo. |

---

## 3. Conteo ciego (misiones de inventario)

**Meta:** El bodeguero **no ve** la cantidad esperada cuando toca modo ciego; cuenta “en limpio”. Si no cuadra, **no se mueve stock** hasta que un supervisor **apruebe** — como separar “ingresar datos” de “autorizar cambio real”.

| # | Qué queda funcionando |
|---|------------------------|
| 1 | **Interruptor real:** puedes activar conteo ciego **global** o **por misión** (`blind_count` o similar). |
| 2 | **Secreto para el rol correcto:** con modo ciego activo, el bodeguero **no** obtiene `cantidad_esperada` en lecturas (RLS / vista / RPC); el supervisor **sí** puede verla para decidir. |
| 3 | **Conteo guardado:** `cantidad_contada` registrada; al cerrar, el servidor compara contra el teórico (no el front a ojo). |
| 4 | **Descuadre con freno:** si hay diferencia → estado “pendiente de aprobación”; **sin ajuste de inventario** hasta entonces. |
| 5 | **Cierre auditado:** al aprobar el supervisor, se aplica el ajuste (trigger/RPC) y queda registro de **quién** y **cuándo**. |

**Prioridad:** media/baja (Fase 2).

---

## 4. Arqueo de caja — decisión de modelado (antes del SQL)

**Contexto:** En el esquema actual típico, `arqueoscajadetalle` trae **billetes/monedas**: `tipo`, `denominacion`, `cantidad` (ej. 5 billetes de $50.000). Eso sirve para **cuadre físico** de efectivo.

Un modelo alternativo usa **por canal de pago**: `medio_pago`, `monto_sistema`, `monto_contado`, `diferencia` (efectivo total, tarjeta, transferencia, etc.) — sirve para **conciliación por medio**, no para contar piezas.

**Meta:** Tener **claro qué vas a construir** (y documentado) antes de migraciones: si no, el SQL de arqueos queda a medias. Issue de referencia en GitHub: **#264**.

### Opciones (elegir una)

| Opción | Qué obtienes | Coste |
|--------|----------------|-------|
| **A** Solo por **medio de pago** | Simple: totales por canal; menos tablas. | No cuadras efectivo por denominación. |
| **B** **Dos niveles** (recomendado si quieres todo) | Nivel 1: resumen por medio en detalle de arqueo; nivel 2: tabla de **denominaciones** (billetes/monedas). | Más tablas y UI; máxima auditoría. |
| **C** Solo **denominaciones** | Igual al enfoque “caja física” actual. | Débil para tarjeta/transfer vs sistema. |

### Criterios para decidir (sin apurarse)

- ¿Te obligan a **auditar efectivo físico** (billetes/monedas)?
- ¿Los cajeros toleran **más pasos** en pantalla?
- ¿Necesitas **conciliar** tarjeta/transfer vs vouchers por canal?
- ¿Cómo impacta en **reportes** y **cierre diario**?

### Qué queda funcionando cuando cierras la decisión

| # | Resultado |
|---|-----------|
| 1 | **Opción escogida:** A, B o C, con una frase de por qué. |
| 2 | **Esquema objetivo:** nombres de tablas/vistas y qué guarda cada una (dibujo o lista). |
| 3 | **Reglas de negocio:** qué pasa con NULL en montos, redondeos, medios sin denominaciones. |
| 4 | **Ticket o ADR corto** en el repo para no reabrir el debate en cada PR. |
| 5 | Recién ahí: **migraciones SQL** de arqueos alineadas a esa decisión. |

---

## Antes de mezclar todo

- Puedes hacer **recepción** sin tener conteo ciego.
- La **vista de salud** pide `products`, `stock` y `units_of_measure` bien cargados.
- **Conteo ciego** pide tablas de misión + líneas de conteo + flujo de aprobación definido.
- **Arqueo de caja** no depende de recepción ni de stock de producto; sí conviene tener **decisión A/B/C** cerrada antes de crear tablas definitivas de cierre de caja.
