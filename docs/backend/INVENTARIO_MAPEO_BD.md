# Módulo Inventario — Mapeo a BD (Supabase actual)

> Este documento traduce el modelo funcional de `INVENTARIO_MODELO.md`
> a tablas y campos existentes en la BD real (Supabase), sin definir aún
> migraciones nuevas.

## 1. Tablas reales a usar en Fase 1

### 1.1 Productos

- **Tabla real**: `public.productos`
- **Uso Fase 1**:
  - Catálogo operativo principal.
  - Fuente para búsqueda y detalle de producto en app satélite.
- **Notas**:
  - PK real: `id_producto` (no `id`).
  - Contiene múltiples columnas heredadas de SAE/import.

### 1.2 Usuarios y roles

- **Tablas reales**:
  - `public.user_profiles`
  - `public.roles`
  - `public.user_roles`
- **Uso Fase 1**:
  - `user_profiles`: vínculo `auth.users` ↔ empresa/sucursal.
  - `roles` / `user_roles`: determinan `app_role()` (`admin`, `encargado`, `empleado`, etc.).

### 1.3 Ubicaciones físicas (inventario)

- **Tablas reales** (jerarquía):
  - `public.bodegas`
  - `public.zonasbodega`
  - `public.estanterias`
  - `public.filasestanteria`
  - `public.cubiculosfila`
- **Uso Fase 1**:
  - App satélite debe navegar Bodega → Zona → Estantería → Fila → Cubículo.
  - Misiones de conteo y traslados se atan a ubicaciones dentro de esta jerarquía.

### 1.4 Stock por ubicación

- **Tabla real**:
  - `public.stockubicacion`
- **Uso Fase 1**:
  - Representa stock físico por producto y cubículo.
  - Debe soportar estados operativos (`DISPONIBLE`, `EN_TRANSITO`, etc.) a nivel de fila.

### 1.5 Movimientos e inventario

- **Tabla real**:
  - `public.movimientosinventario`
- **Uso Fase 1**:
  - Registro de entradas, salidas, traslados y ajustes.
  - Trazabilidad: quién, cuándo, qué, desde dónde hacia dónde.

### 1.6 Traslados

- **Tablas reales**:
  - `public.traslados_encabezado`
  - `public.traslados_detalle`
- **Uso Fase 1**:
  - `*_encabezado`: datos generales (empresa, sucursal, estado, origen/destino).
  - `*_detalle`: productos y cantidades por traslado.

### 1.7 Misiones de conteo

- **Tablas reales**:
  - `public.misiones_conteo`
  - `public.misiones_conteo_detalle`
- **Uso Fase 1**:
  - `misiones_conteo`: misión (zona/ubicación, rango productos, asignatarios).
  - `misiones_conteo_detalle`: conteos por producto/ubicación.

---

## 2. Gaps conocidos vs modelo funcional

1. **Estados operativos de stock**
   - Revisar si `stockubicacion` ya tiene columna para estado (`estado_stock` o similar).
   - Si no, anotar gap: "Falta columna para estado operativo de stock".

2. **Estados de traslado**
   - Verificar columnas de estado en `traslados_encabezado` (tipo y valores).
   - Mapear a estados deseados (`BORRADOR`, `ENVIADO`, `PENDIENTE_APROBACION`, etc.).

3. **Política de stock por tipo de negocio**
   - Tablas `stock_policy_template` y `business_type` todavía **no existen**.
   - Para Fase 1, se usará la plantilla "Distribuidor de plásticos" como decisión de negocio, no necesariamente como tablas implementadas aún.

---

## 3. Prioridades técnicas Fase 1 (sin SQL aún)

1. **Confirmar columnas clave** en tablas reales:
   - `productos`: PK, empresa_id, campos de identificación.
   - `stockubicacion`: producto, ubicación, cantidad, estado.
   - `traslados_*`: campos de origen/destino, estados, vínculos a usuario.
   - `misiones_*`: vínculos a producto, ubicación y usuario.

2. **Analizar RLS actual** para:
   - `bodegas`, `zonasbodega`, `stockubicacion`,
   - `movimientosinventario`, `traslados_encabezado`, `traslados_detalle`,
   - `misiones_conteo`, `misiones_conteo_detalle`.

3. **Definir qué tablas necesitan policies nuevas o corregidas**
   para soportar los flujos de Fase 1 con roles `admin`, `encargado`, `empleado`.

> Este documento solo mapea y enumera gaps. Las migraciones SQL se
> harán en una rama nueva, después de revisar este mapeo contra la BD real.
