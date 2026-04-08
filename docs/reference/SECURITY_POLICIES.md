# Políticas de seguridad (borrador declarativo)

**Propósito:** describir la intención de autorización por **rol de aplicación** y tabla, **sin SQL**. Sirve de fuente para generar **RLS en Postgres/Supabase** (ver migración borrador en `supabase/migrations/`).

**Relacionado:** [SAE_DATA_MAPPING.md](./SAE_DATA_MAPPING.md) (campos de negocio), [ADR-001](../../ADR/ADR-001-stack-tecnologico.md) (Supabase + RLS).

---

## 0. Convenciones

- **`rol`:** rol de aplicación (no es un rol nativo de PostgreSQL). Valores: `admin`, `encargado`, `empleado`.
- **`tabla`:** nombre lógico (mapeo a nombre físico 1:1 en el borrador SQL).
- **`accion`:** `SELECT`, `INSERT`, `UPDATE`, `DELETE` (o `ALL` cuando todas las acciones comparten la misma condición).
- **`condicion_filas`:** predicado lógico usando claves de aislamiento (`empresa`, `sucursal`, `usuario`, `asignación`).
- **`columnas_restringidas`:** columnas que no deben poder cambiarse en `UPDATE` según rol (en RLS puro no existen; requieren **triggers** o **privilegios por columna** en Postgres 15+).

**Variables lógicas**

| Variable | Significado |
|----------|-------------|
| `current_user_id` | Usuario autenticado (`auth.uid()` en Supabase). |
| `current_empresa_id` | Empresa activa del usuario (perfil / JWT). |
| `current_sucursal_id` | Sucursal activa del usuario (perfil / JWT). |
| `empleados_del_encargado()` | Conjunto de IDs de empleados subordinados al encargado actual (jerarquía en `profiles.supervisor_id`). *Opcional para afinar SELECT de OC/traslados; el cuadro siguiente no lo exige en todas las filas.* |

**Notas de implementación**

- En el borrador SQL, `app_role`, `current_empresa_id` y `current_sucursal_id` se leen de `public.profiles` vía funciones `SECURITY DEFINER`.
- Las restricciones del tipo *“solo puede cambiar estado y nota”* no son expresables solo con RLS por fila: documentar aquí y cubrir con triggers o capa API.

---

## 1. Productos

### `productos`

| tabla | rol | accion | condicion_filas | columnas_restringidas |
|-------|-----|--------|-----------------|------------------------|
| productos | empleado | SELECT | `empresa_id = current_empresa_id` | - |
| productos | empleado | INSERT | nunca | todas |
| productos | empleado | UPDATE | nunca | todas |
| productos | empleado | DELETE | nunca | todas |
| productos | encargado | SELECT | `empresa_id = current_empresa_id` | - |
| productos | encargado | INSERT | nunca (solo admin crea/edita catálogo) | todas |
| productos | encargado | UPDATE | nunca | todas |
| productos | encargado | DELETE | nunca | todas |
| productos | admin | SELECT | `empresa_id = current_empresa_id` | - |
| productos | admin | INSERT | `empresa_id = current_empresa_id` | - |
| productos | admin | UPDATE | `empresa_id = current_empresa_id` | - |
| productos | admin | DELETE | `empresa_id = current_empresa_id` | - |

---

## 2. Compras

### `compras_encabezado` (compras reales / facturas)

| tabla | rol | accion | condicion_filas | columnas_restringidas |
|-------|-----|--------|-----------------|------------------------|
| compras_encabezado | empleado | SELECT | nunca (empleado opera a nivel OC, no compras reales) | todas |
| compras_encabezado | empleado | INSERT | nunca | todas |
| compras_encabezado | empleado | UPDATE | nunca | todas |
| compras_encabezado | empleado | DELETE | nunca | todas |
| compras_encabezado | encargado | SELECT | `empresa_id = current_empresa_id AND id_sucursal = current_sucursal_id` | - |
| compras_encabezado | encargado | INSERT | nunca (encargado aprueba OC; admin registra compra) | todas |
| compras_encabezado | encargado | UPDATE | nunca | todas |
| compras_encabezado | encargado | DELETE | nunca | todas |
| compras_encabezado | admin | SELECT | `empresa_id = current_empresa_id` | - |
| compras_encabezado | admin | INSERT | `empresa_id = current_empresa_id` (p. ej. desde OC aprobada) | - |
| compras_encabezado | admin | UPDATE | `empresa_id = current_empresa_id` | - |
| compras_encabezado | admin | DELETE | `empresa_id = current_empresa_id` | - |

### `compras_detalle`

| tabla | rol | accion | condicion_filas | columnas_restringidas |
|-------|-----|--------|-----------------|------------------------|
| compras_detalle | empleado | *todas* | igual que encabezado (sin acceso) | todas |
| compras_detalle | encargado | SELECT | misma visibilidad que encabezado vía `id_compra` | - |
| compras_detalle | encargado | otras | nunca | todas |
| compras_detalle | admin | ALL | misma empresa que encabezado vía `id_compra` | - |

*(En SQL: subconsulta `EXISTS` al encabezado por `id_compra`.)*

### `ordenes_compra_encabezado` (OC)

| tabla | rol | accion | condicion_filas | columnas_restringidas |
|-------|-----|--------|-----------------|------------------------|
| ordenes_compra_encabezado | empleado | SELECT | `empresa_id = current_empresa_id AND empleado_asignado_id = current_user_id` | - |
| ordenes_compra_encabezado | empleado | INSERT | `empresa_id = current_empresa_id AND id_sucursal = current_sucursal_id AND empleado_asignado_id = current_user_id` y `estado IN ('BORRADOR','ENVIADO')` | no cambiar encargado ni saltar estados no permitidos (trigger/API) |
| ordenes_compra_encabezado | empleado | UPDATE | `empresa_id = current_empresa_id AND empleado_asignado_id = current_user_id AND estado = 'BORRADOR'` | no cambiar `empleado_asignado_id` ni `estado` salvo reglas de negocio (trigger/API) |
| ordenes_compra_encabezado | empleado | DELETE | `empresa_id = current_empresa_id AND empleado_asignado_id = current_user_id AND estado = 'BORRADOR'` | - |
| ordenes_compra_encabezado | encargado | SELECT | `empresa_id = current_empresa_id AND id_sucursal = current_sucursal_id` | - |
| ordenes_compra_encabezado | encargado | UPDATE | `empresa_id = current_empresa_id AND id_sucursal = current_sucursal_id AND estado IN ('ENVIADO','PENDIENTE')` | idealmente solo campos de estado y nota (trigger/API) |
| ordenes_compra_encabezado | encargado | INSERT | `empresa_id = current_empresa_id AND id_sucursal = current_sucursal_id` (si se permite que el encargado cree OC) | - |
| ordenes_compra_encabezado | encargado | DELETE | nunca | todas |
| ordenes_compra_encabezado | admin | SELECT | `empresa_id = current_empresa_id` | - |
| ordenes_compra_encabezado | admin | INSERT | `empresa_id = current_empresa_id` | - |
| ordenes_compra_encabezado | admin | UPDATE | `empresa_id = current_empresa_id` | - |
| ordenes_compra_encabezado | admin | DELETE | `empresa_id = current_empresa_id` | - |

### `ordenes_compra_detalle`

| tabla | rol | accion | condicion_filas | columnas_restringidas |
|-------|-----|--------|-----------------|------------------------|
| ordenes_compra_detalle | empleado | ALL | heredada de `ordenes_compra_encabezado` por `id_orden_compra` | según encabezado |
| ordenes_compra_detalle | encargado | ALL | misma lógica que encabezado (sucursal; opcional subordinados) | según encabezado |
| ordenes_compra_detalle | admin | ALL | `empresa_id = current_empresa_id` vía encabezado | - |

---

## 3. Traslados

### `traslados_encabezado`

| tabla | rol | accion | condicion_filas | columnas_restringidas |
|-------|-----|--------|-----------------|------------------------|
| traslados_encabezado | empleado | SELECT | `empresa_id = current_empresa_id AND empleado_asignado_id = current_user_id` | - |
| traslados_encabezado | empleado | INSERT | `empresa_id = current_empresa_id AND id_sucursal_origen = current_sucursal_id AND empleado_asignado_id = current_user_id` y `estado IN ('BORRADOR','ENVIADO')` | - |
| traslados_encabezado | empleado | UPDATE | `empresa_id = current_empresa_id AND empleado_asignado_id = current_user_id AND estado = 'BORRADOR'` | no cambiar estado ni sucursal de forma arbitraria (trigger/API) |
| traslados_encabezado | empleado | DELETE | `empresa_id = current_empresa_id AND empleado_asignado_id = current_user_id AND estado = 'BORRADOR'` | - |
| traslados_encabezado | encargado | SELECT | `empresa_id = current_empresa_id AND id_sucursal_origen = current_sucursal_id` | - |
| traslados_encabezado | encargado | UPDATE | `empresa_id = current_empresa_id AND id_sucursal_origen = current_sucursal_id AND estado IN ('ENVIADO','PENDIENTE')` | idealmente solo estado y nota (trigger/API) |
| traslados_encabezado | encargado | INSERT | `empresa_id = current_empresa_id AND id_sucursal_origen = current_sucursal_id` (opcional) | - |
| traslados_encabezado | encargado | DELETE | nunca | todas |
| traslados_encabezado | admin | ALL | `empresa_id = current_empresa_id` | - |

### `traslados_detalle`

| tabla | rol | accion | condicion_filas | columnas_restringidas |
|-------|-----|--------|-----------------|------------------------|
| traslados_detalle | empleado | ALL | heredada de `traslados_encabezado` por `id_traslado` | según encabezado |
| traslados_detalle | encargado | ALL | heredada de encabezado (misma sucursal origen) | según encabezado |
| traslados_detalle | admin | ALL | empresa vía encabezado | - |

---

## 4. Clientes

### `clientes`

| tabla | rol | accion | condicion_filas | columnas_restringidas |
|-------|-----|--------|-----------------|------------------------|
| clientes | empleado | SELECT | `empresa_id = current_empresa_id` | opcional: ocultar NIT completo, límites de crédito, etc. (vista o API) |
| clientes | empleado | INSERT | nunca | todas |
| clientes | empleado | UPDATE | nunca | todas |
| clientes | empleado | DELETE | nunca | todas |
| clientes | encargado | SELECT | `empresa_id = current_empresa_id` | igual que empleado si aplica |
| clientes | encargado | INSERT | nunca | todas |
| clientes | encargado | UPDATE | nunca | todas |
| clientes | encargado | DELETE | nunca | todas |
| clientes | admin | SELECT | `empresa_id = current_empresa_id` | - |
| clientes | admin | INSERT | `empresa_id = current_empresa_id` | - |
| clientes | admin | UPDATE | `empresa_id = current_empresa_id` | - |
| clientes | admin | DELETE | `empresa_id = current_empresa_id` | - |

---

## 5. Proveedores

### `proveedores`

| tabla | rol | accion | condicion_filas | columnas_restringidas |
|-------|-----|--------|-----------------|------------------------|
| proveedores | empleado | SELECT | `empresa_id = current_empresa_id` | opcional: campos sensibles vía vista/API |
| proveedores | empleado | INSERT | nunca | todas |
| proveedores | empleado | UPDATE | nunca | todas |
| proveedores | empleado | DELETE | nunca | todas |
| proveedores | encargado | SELECT | `empresa_id = current_empresa_id` | opcional |
| proveedores | encargado | INSERT | nunca | todas |
| proveedores | encargado | UPDATE | nunca | todas |
| proveedores | encargado | DELETE | nunca | todas |
| proveedores | admin | SELECT | `empresa_id = current_empresa_id` | - |
| proveedores | admin | INSERT | `empresa_id = current_empresa_id` | - |
| proveedores | admin | UPDATE | `empresa_id = current_empresa_id` | - |
| proveedores | admin | DELETE | `empresa_id = current_empresa_id` | - |

---

## 6. Siguiente paso (implementación)

1. Aplicar migración borrador `supabase/migrations/*_draft_rls_core.sql` solo en entorno de prueba; revisar nombres de enum y FKs respecto al modelo final.
2. Añadir **triggers** `BEFORE UPDATE` para `ordenes_compra_encabezado` y `traslados_encabezado` cuando el rol sea encargado o empleado y deba limitarse a columnas concretas.
3. Definir **vistas** `clientes_publico` / `proveedores_publico` si se filtran columnas sensibles para empleado/encargado.
4. Sincronizar creación de fila en `profiles` con **Auth** (trigger `on_auth_user_created` o flujo de registro) y decidir si replica claims en JWT.
