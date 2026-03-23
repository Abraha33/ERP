# Error al invitar usuario: `empresa_id` NULL en `user_profiles`

## Qué significa el error

Al usar **Invite user** (o crear usuario), Supabase crea la fila en `auth.users`. Si tienes un **trigger** `AFTER INSERT ON auth.users` que inserta en `public.user_profiles` (o similar) y **no rellena** `empresa_id`, Postgres rechaza el insert:

`null value in column "empresa_id" of relation "user_profiles" violates not-null constraint`

El POST a `/auth/v1/invite` falla porque la transacción de creación de usuario incluye ese insert.

## Opción A — Rellenar `empresa_id` desde metadatos (recomendado)

En el **Dashboard** el invite simple **no** suele permitir JSON de metadatos. Opciones:

1. **Supabase Dashboard → Authentication → Users → Add user** y, si la UI lo permite, añadir **User metadata** con `empresa_id` (UUID string) y opcionalmente `sucursal_id`, `app_role`.
2. **API Admin** (`service_role`): `inviteUserByEmail` / `createUser` con `user_metadata: { empresa_id: "<uuid>", sucursal_id: "<uuid>", app_role: "empleado" }`.
3. Ajustar el **trigger** para leer:

   - `NEW.raw_user_meta_data->>'empresa_id'`
   - `NEW.raw_user_meta_data->>'sucursal_id'`
   - `NEW.raw_user_meta_data->>'app_role'`

   y castear a `uuid` / `text` según tu tabla.

Si falta `empresa_id` en metadata, el trigger puede **hacer RAISE** con un mensaje claro (falla el invite hasta que pases datos) o usar un **UUID de empresa por defecto** (solo entornos de prueba).

## Opción B — Empresa por defecto en el trigger (solo dev / un solo tenant)

Si todos los invites son de la misma empresa en pruebas:

```sql
-- Ejemplo: sustituye el UUID por tu empresa de prueba
v_empresa uuid := 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'::uuid;
```

y en el `INSERT` usa `COALESCE(metadata_empresa, v_empresa)`.

## Opción C — Permitir NULL temporalmente

`ALTER TABLE public.user_profiles ALTER COLUMN empresa_id DROP NOT NULL;`  
y completar `empresa_id` en un flujo posterior (onboarding). Menos seguro si la app asume siempre tenant.

## Cómo ver tu trigger actual

En **SQL Editor**:

```sql
SELECT tgname, tgrelid::regclass, pg_get_triggerdef(oid)
FROM pg_trigger
WHERE NOT tgisinternal
  AND tgrelid = 'auth.users'::regclass;
```

Revisa la función que llama (`EXECUTE FUNCTION ...`) y actualiza el `INSERT` en `user_profiles`.

## Alineación con este repo

En las migraciones de ejemplo del repo la tabla se llama **`public.profiles`**. En tu proyecto aparece **`user_profiles`**: es el **mismo patrón** (perfil ligado a `auth.users.id`), solo cambia el nombre. Unifica nombres cuando puedas para evitar confusiones.

## Archivo SQL de ejemplo

Plantilla lista para adaptar nombres de columnas: [sql/supabase_user_profile_trigger_example.sql](./sql/supabase_user_profile_trigger_example.sql).
