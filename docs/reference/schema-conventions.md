# Convenciones de esquema (PostgreSQL / Supabase)

Documento de referencia para migraciones y tablas multi-tenant. Cursor y humanos deben aplicar esto sin reinterpretar.

## Identificadores

- **PK:** `id uuid PRIMARY KEY DEFAULT gen_random_uuid()` (requiere extensión `pgcrypto`).
- **Tenant:** `empresa_id uuid NOT NULL` en casi todas las tablas de negocio.
- **Sucursal (cuando aplique):** `sucursal_id uuid` (nullable hasta onboarding si el flujo lo permite).

## Timestamps y borrado lógico

- **`created_at timestamptz NOT NULL DEFAULT now()`** en tablas nuevas.
- **`updated_at timestamptz NOT NULL DEFAULT now()`** — mantener con trigger `BEFORE UPDATE` (función `set_updated_at()` reutilizable).
- **`deleted_at timestamptz`** — soft delete; en `SELECT` de app, filtrar `WHERE deleted_at IS NULL` (o vistas). Las policies RLS pueden incluir `deleted_at IS NULL` para empleados.

## Sincronización local (cliente)

Columna opcional en tablas que participen en sync offline (Room ↔ Supabase):

| Valor        | Significado                          |
|-------------|---------------------------------------|
| `SYNCED`    | Fila alineada con el servidor       |
| `PENDING`   | Cambio local pendiente de subir     |
| `CONFLICT`  | Requiere resolución manual o regla  |

En SQL:

```sql
sync_status text NOT NULL DEFAULT 'SYNCED'
  CHECK (sync_status IN ('SYNCED', 'PENDING', 'CONFLICT'))
```

## Índices

- Por tenant: `CREATE INDEX idx_<tabla>_empresa ON public.<tabla>(empresa_id);`
- FKs y columnas de filtro frecuente: índice explícito según consultas.

## RLS

- `ALTER TABLE ... ENABLE ROW LEVEL SECURITY;` en **todas** las tablas expuestas a PostgREST.
- Nombres de policies: `p_<tabla>_<acción>_<rol>` (ver ADR-001 y `docs/SECURITY_POLICIES.md`).

## Ejemplo compliant — `productos`

```sql
CREATE TABLE public.productos (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  empresa_id uuid NOT NULL,
  sku_codigo text,
  nombre text,
  deleted_at timestamptz,
  updated_at timestamptz NOT NULL DEFAULT now(),
  sync_status text NOT NULL DEFAULT 'SYNCED'
    CHECK (sync_status IN ('SYNCED', 'PENDING', 'CONFLICT')),
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_productos_empresa ON public.productos (empresa_id);

ALTER TABLE public.productos ENABLE ROW LEVEL SECURITY;
-- Policies según roles (admin / encargado / empleado) en migración dedicada.
```

## Trigger `updated_at` (plantilla)

```sql
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at := now();
  RETURN NEW;
END;
$$;

-- Por tabla:
CREATE TRIGGER tr_productos_updated_at
  BEFORE UPDATE ON public.productos
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
```

Ajustar nombre de trigger para evitar colisiones.
