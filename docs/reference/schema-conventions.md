# Convenciones de esquema (PostgreSQL / Supabase)

Documento de referencia para **migraciones**, tablas **multi-tenant** y modelo **ERP + CRM**. El CRM es un módulo sobre el núcleo ERP: maestros (`clientes`, `productos`, documentos de venta) viven en el mismo Postgres con RLS; tablas puramente CRM (conversaciones, casos) se añaden después con FK al ERP (ver [Esqueleto.md](./Esqueleto.md) para alcance funcional).

**Reglas de repo:** `.cursor/rules/project.mdc` (migraciones solo en `supabase/migrations/`, sin hardcode de tenant en cliente). Cursor y humanos aplican este documento **sin reinterpretar**.

---

## 1. Alineación con `project.mdc` (decisiones ya cerradas)

Las siguientes decisiones vienen de **`.cursor/rules/project.mdc`**; aquí solo se consolidan para migraciones:

### 1.1 Tablas base (documentadas / borrador)

- **`profiles`:** vínculo usuario ↔ tenant y rol de app; columnas de convención según migraciones M0+: `deleted_at`, `updated_at`, `sync_status` cuando aplique.
- **Núcleo operativo (nombres típicos en migraciones):** `productos`, `clientes`, `proveedores`, tablas `compras_*`, `ordenes_compra_*`, `traslados_*`, y extensiones posteriores (p. ej. ventas, inventario, ubicaciones) bajo el mismo patrón tenant + RLS.

### 1.2 RLS, roles y funciones de sesión

- **RLS:** obligatoria en **todas** las tablas expuestas a PostgREST (`ALTER TABLE ... ENABLE ROW LEVEL SECURITY`).
- **Roles de aplicación (orden de privilegio):** `admin` > `encargado` > `empleado` — campo `app_role` en `public.profiles` (valores acordados en migraciones).
- **Funciones de sesión (predicados reutilizables en policies):**
  - `public.current_empresa_id()` → `uuid`
  - `public.current_sucursal_id()` → `uuid`
  - `public.app_role()` → `text`
- **Prohibido en app cliente:** hardcodear `empresa_id` ni `sucursal_id`; deben derivarse del contexto de sesión / perfil y RLS.
- **Nombres de policies:** `p_<tabla>_<acción>_<rol>` (detalle en [SECURITY_POLICIES.md](./SECURITY_POLICIES.md) y ADR-001).

---

## 2. Claves primarias: UUID frente a `bigint`

| Enfoque | Uso en ERP Satélite |
|---------|---------------------|
| **`uuid` + `gen_random_uuid()`** | **Predeterminado** para PK de entidades de negocio (productos, clientes, documentos, líneas, ubicaciones, etc.). Facilita sync offline (Fase 5), merges e idempotencia en cliente; requiere `pgcrypto` (`create extension if not exists pgcrypto;`). |
| **`bigint` / `serial`** | **No** para nuevas tablas de dominio salvo ADR específico (p. ej. integración con sistema legacy que imponga IDs enteros). Si se usa, documentar en la migración y en un ADR o apéndice. |
| **Excepción `profiles`** | `id uuid PRIMARY KEY REFERENCES auth.users (id) ON DELETE CASCADE` — el PK **es** el usuario de Auth; no se genera con `gen_random_uuid()` en el insert de perfil. |

**Claves foráneas:** mismo tipo que la columna referenciada (`uuid` → `uuid`). Nombres recomendados: `xxx_id` (singular del objeto referido: `empresa_id`, `cliente_id`, `producto_id`).

**Números de negocio** (folio, número de OC/OV visible al usuario): **no sustituyen la PK**; usar columnas dedicadas (`numero_documento`, `codigo`, etc.) y reglas de unicidad por `empresa_id` (o tenant + sucursal) según dominio — alineado a numeración en [Esqueleto.md](./Esqueleto.md).

---

## 3. Multi-tenant y alcance

- **`empresa_id uuid NOT NULL`** en casi todas las tablas de negocio (filas pertenecen a un tenant).
- **`sucursal_id uuid`** cuando el dominio lo requiera (nullable solo si el flujo de onboarding lo permite explícitamente).
- Índice mínimo por tenant: `CREATE INDEX idx_<tabla>_empresa ON public.<tabla>(empresa_id);` — añadir índices compuestos según consultas (`(empresa_id, estado)`, etc.).

---

## 4. Campos estándar de fila

### 4.1 `created_at`

```sql
created_at timestamptz NOT NULL DEFAULT now()
```

- Momento de creación de la fila; no actualizar manualmente en updates normales.

### 4.2 `updated_at`

```sql
updated_at timestamptz NOT NULL DEFAULT now()
```

- Debe mantenerse con trigger **`BEFORE UPDATE`** usando una función global reutilizable (`public.set_updated_at()`).
- Cumple doble función: auditoría ligera y, en Fase 5, apoyo a sync incremental / resolución de conflictos (criterio a definir por tabla en tickets de sync).

### 4.3 `deleted_at` (soft delete)

```sql
deleted_at timestamptz NULL
```

- **NULL** = fila activa; **no NULL** = borrado lógico.
- Consultas de aplicación: filtrar `WHERE deleted_at IS NULL` (o vistas que ya lo apliquen).
- **RLS:** las policies pueden exigir `deleted_at IS NULL` para roles que no administran papelera.
- Tablas donde el dominio no use soft delete: omitir columna por decisión explícita en la migración (documentar en comentario `COMMENT ON`).

### 4.4 `sync_status` (sync cliente ↔ servidor)

Columna para tablas que participen en **Room ↔ Supabase** (offline / cola de subida):

| Valor | Significado |
|-------|-------------|
| `SYNCED` | Fila alineada con el servidor. |
| `PENDING` | Cambio local pendiente de subir. |
| `CONFLICT` | Requiere resolución manual o regla explícita. |

```sql
sync_status text NOT NULL DEFAULT 'SYNCED'
  CHECK (sync_status IN ('SYNCED', 'PENDING', 'CONFLICT'))
```

- **Default:** `'SYNCED'` para filas creadas solo en servidor.
- Tablas **solo servidor** (p. ej. logs internos, catálogos que nunca editará el móvil offline): se puede omitir `sync_status` si se documenta el motivo.

---

## 5. Naming y estilo SQL

| Elemento | Convención |
|----------|------------|
| **Esquema** | `public` para tablas de aplicación salvo decisión contraria. |
| **Tablas** | `snake_case`, **plural** (`productos`, `ordenes_venta_encabezado`, `clientes`). |
| **Columnas** | `snake_case`; FKs `*_id`. |
| **Índices** | `idx_<tabla>_<columnas>` o prefijo claro (`idx_<tabla>_empresa`). |
| **Constraints** | `uq_<tabla>_<descripcion>` (unique), `chk_<tabla>_<descripcion>` (check) cuando ayude al diagnóstico. |
| **Triggers** | `tr_<tabla>_<evento>` (p. ej. `tr_productos_updated_at`). |
| **Funciones** | `snake_case`; helpers de sesión ya fijados: `current_empresa_id`, `current_sucursal_id`, `app_role`, `set_updated_at`. |
| **Policies RLS** | `p_<tabla>_<acción>_<rol>` (`p_productos_select_empleado`, etc.). |

**Kotlin (app):** tipos PascalCase, miembros camelCase — mapeo explícito a columnas SQL en capa de datos.

---

## 6. RLS (resumen operativo)

1. Tras `CREATE TABLE`, ejecutar `ALTER TABLE ... ENABLE ROW LEVEL SECURITY`.
2. No exponer tablas sin policies a roles que no deban ver datos globales.
3. Predicados típicos: `empresa_id = public.current_empresa_id()` combinado con `public.app_role()` y, si aplica, filtro por `sucursal_id` o reglas de documento.
4. Incluir `deleted_at IS NULL` en lecturas cuando el rol no deba ver filas eliminadas lógicamente.

---

## 7. Plantilla: función y trigger `updated_at`

```sql
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END;
$$;

CREATE TRIGGER tr_<tabla>_updated_at
  BEFORE UPDATE ON public.<tabla>
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();
```

En versiones antiguas de Postgres usar `EXECUTE PROCEDURE` en lugar de `EXECUTE FUNCTION` si aplica.

---

## 8. Ejemplo compliant — tabla de catálogo `productos`

```sql
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE public.productos (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  empresa_id uuid NOT NULL,
  sku_codigo text,
  nombre text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  sync_status text NOT NULL DEFAULT 'SYNCED'
    CHECK (sync_status IN ('SYNCED', 'PENDING', 'CONFLICT'))
);

CREATE INDEX idx_productos_empresa ON public.productos (empresa_id);

CREATE TRIGGER tr_productos_updated_at
  BEFORE UPDATE ON public.productos
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();

ALTER TABLE public.productos ENABLE ROW LEVEL SECURITY;
-- Policies: migración dedicada, nombres p_productos_*_admin|encargado|empleado
```

---

## 9. Ejemplo — `profiles` (PK = Auth user)

No usar `DEFAULT gen_random_uuid()` en `id`; debe coincidir con `auth.users.id`:

```sql
CREATE TABLE public.profiles (
  id uuid PRIMARY KEY REFERENCES auth.users (id) ON DELETE CASCADE,
  empresa_id uuid NOT NULL,
  sucursal_id uuid,
  app_role text NOT NULL CHECK (app_role IN ('admin', 'encargado', 'empleado')),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  sync_status text NOT NULL DEFAULT 'SYNCED'
    CHECK (sync_status IN ('SYNCED', 'PENDING', 'CONFLICT'))
);
-- RLS + triggers según migraciones del repo
```

---

## 10. Checklist al crear una migración nueva

- [ ] PK `uuid` con `gen_random_uuid()` salvo excepción documentada (`profiles`, legacy).
- [ ] `empresa_id` (y `sucursal_id` si aplica) sin valores fijos en cliente.
- [ ] `created_at`, `updated_at`; trigger `set_updated_at` si hay `updated_at`.
- [ ] `deleted_at` si el dominio usa soft delete.
- [ ] `sync_status` si la tabla participará en sync móvil offline.
- [ ] Índice por `empresa_id` (y otros según consultas).
- [ ] `ENABLE ROW LEVEL SECURITY` + policies con nombres `p_<tabla>_...`.
- [ ] Sin editar el esquema en Dashboard sin migración equivalente en `supabase/migrations/`.

---

## Referencias

- [Esqueleto.md](./Esqueleto.md) — módulos ERP + CRM y flujos de negocio.
- [SECURITY_POLICIES.md](./SECURITY_POLICIES.md) — políticas RLS (borrador / evolución).
- [ADR-001](../adr/ADR-001-stack-tecnologico.md) — stack y reglas globales.
- `.cursor/rules/project.mdc` — reglas críticas de BD y monorepo.
