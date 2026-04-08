# Ticket #263: Cierre de Caja Pro (Arqueo, Fondos y Auditoria)

Issue GitHub: https://github.com/Abraha33/ERP/issues/263
Proyecto GitHub: https://github.com/users/Abraha33/projects/11

## Contexto y User Story
Como Cajero/Administrador, quiero abrir, gestionar y cerrar mi sesion de caja, registrando retiros parciales (sangrias), validando efectivo y otros medios de pago (vouchers), y definiendo el fondo para el siguiente turno, para garantizar un control auditable del dinero y prevenir fraudes o descuadres.

## Metadatos
- Etiquetas: backend, database, caja, alta-prioridad, seguridad
- Estimacion: 8-10h
- Epic: Gestion de Tesoreria / Ventas

## Objetivos del Desarrollo
- Controlar apertura y cierre definiendo un monto base.
- Registrar ingresos, egresos, devoluciones y retiros parciales (sangrias).
- Calcular efectivo esperado vs. contado y auditar diferencias.
- Validar otros medios de pago (vouchers de tarjeta, comprobantes de transferencia).
- Separar el dinero a depositar del fondo de caja que se deja para el proximo turno.
- Requerir autorizacion de supervisor para diferencias (descuadres) que superen la tolerancia.

## Alcance (Database Schema)
### 1) `caja_sesiones` (Control del ciclo de vida)
| Campo | Tipo de Dato | Detalles |
| :--- | :--- | :--- |
| id | UUID / BIGINT | PK |
| caja_id | UUID / BIGINT | FK -> cajas.id |
| usuario_id | UUID / BIGINT | FK -> usuarios.id |
| monto_apertura | DECIMAL(12,2) | Default 0.00 |
| fecha_apertura | TIMESTAMP | Not Null |
| fecha_cierre | TIMESTAMP | Nullable |
| estado | ENUM / VARCHAR | abierta, cerrada |

### 2) `movimientos_caja` (Entradas y salidas manuales)
| Campo | Tipo de Dato | Detalles |
| :--- | :--- | :--- |
| id | UUID / BIGINT | PK |
| caja_sesion_id | UUID / BIGINT | FK -> caja_sesiones.id |
| tipo | ENUM / VARCHAR | ingreso, egreso, retiro_valores, devolucion |
| concepto | VARCHAR(100) | Ej: Pago proveedor, Entrega parcial a supervisor |
| monto | DECIMAL(12,2) | Valor absoluto (> 0) |
| referencia_id | VARCHAR(50) | Obligatorio si es devolucion (ID del Ticket/Venta) |
| created_at | TIMESTAMP | Default CURRENT_TIMESTAMP |

### 3) `arqueos_caja` (Cabecera del resultado final)
| Campo | Tipo de Dato | Detalles |
| :--- | :--- | :--- |
| id | UUID / BIGINT | PK |
| caja_sesion_id | UUID / BIGINT | FK -> caja_sesiones.id (Unique) |
| total_esperado | DECIMAL(12,2) | Calculado por el sistema al momento de cerrar |
| total_contado | DECIMAL(12,2) | Sumatoria del detalle fisico (arqueos_detalle) |
| diferencia | DECIMAL(12,2) | total_contado - total_esperado |
| monto_retirado | DECIMAL(12,2) | Dinero que sale fisicamente para deposito/banco |
| monto_dejado | DECIMAL(12,2) | Fondo de cambio que se queda en la gaveta |
| supervisor_id | UUID / BIGINT | FK -> usuarios.id (Nullable, quien autoriza descuadre) |
| estado_auditoria | ENUM / VARCHAR | aprobado, pendiente, rechazado |

### 4) `arqueos_detalle` (Desglose fisico del efectivo)
| Campo | Tipo de Dato | Detalles |
| :--- | :--- | :--- |
| id | UUID / BIGINT | PK |
| arqueo_caja_id | UUID / BIGINT | FK -> arqueos_caja.id |
| tipo | ENUM / VARCHAR | billete, moneda |
| denominacion | DECIMAL(10,2) | Ej: 50.00, 100.00 |
| cantidad | INT | Cantidad de piezas |
| subtotal | DECIMAL(12,2) | denominacion * cantidad |

### 5) `arqueos_otros_medios` (Control de Vouchers/Transferencias)
| Campo | Tipo de Dato | Detalles |
| :--- | :--- | :--- |
| id | UUID / BIGINT | PK |
| arqueo_caja_id | UUID / BIGINT | FK -> arqueos_caja.id |
| metodo_pago | VARCHAR(50) | tarjeta_credito, tarjeta_debito, transferencia |
| total_esperado | DECIMAL(12,2) | Suma de ventas en sistema para este metodo |
| total_declarado | DECIMAL(12,2) | Suma de comprobantes/vouchers fisicos entregados |
| diferencia | DECIMAL(12,2) | total_declarado - total_esperado |

## Logica de Negocio y Formulas
Calculo de efectivo esperado:
`monto_apertura + ventas_efectivo + movimientos(ingresos) - movimientos(egresos) - movimientos(retiro_valores) - movimientos(devoluciones)`

Regla del cuadre fisico (distribucion):
El `total_contado` debe ser exactamente igual a la suma de `monto_retirado + monto_dejado`.

## Reglas del Sistema (Restricciones y Seguridad)
- Devoluciones estrictas: bloquear cualquier movimiento `tipo = devolucion` sin `referencia_id` vinculada a una venta real.
- Margen de tolerancia y auditoria: si la diferencia en efectivo u otros medios es distinta de 0.00 (o supera tolerancia configurable), solicitar PIN de supervisor o dejar `estado_auditoria = pendiente`.
- Sugerencia de fondo inicial: al abrir una nueva sesion de caja, usar automaticamente el `monto_dejado` de la sesion anterior como `monto_apertura`.

## Criterios de Aceptacion (DoD)
- [ ] Las 5 tablas estan creadas con sus correctas llaves foraneas.
- [ ] El sistema permite registrar retiros de valores (sangrias) descontando del total_esperado sin requerir cerrar la caja.
- [ ] Las devoluciones de dinero exigen obligatoriamente una referencia al ticket/factura original.
- [ ] El usuario puede auditar y declarar la sumatoria de vouchers de tarjeta vs. lo que el sistema esperaba.
- [ ] Al cerrar caja, el sistema obliga a distribuir el total_contado entre monto_retirado y monto_dejado.
- [ ] Las sesiones con diferencias que superen la tolerancia cambian a estado pendiente y requieren validacion.
