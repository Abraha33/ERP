# Estado de la BD — Fase 1 · S1 (Modelo de datos e importación)

Documento de auditoría a partir de **`supabase/migrations/`** (repo **Abraha33/ERP**). Úsalo como referencia en issues del milestone **Fase 1 · S1 — Modelo de datos e importación** (#16), p. ej. **[E01-S01-03]**, **[E01-S01-04]**, **T1.1.***.

**Última revisión:** 2026-04-10 — alinear con ROADMAP Fase 1 · S1, `docs/reference/Esqueleto.md`, `.cursor/rules/project.mdc`. Incluye migración **S1** post-auth + `updated_at` (`20260420120000_...`).

---

## 1. Orden de migraciones aplicadas

| Orden | Archivo |
|-------|---------|
| 1 | `20260322190000_draft_rls_core.sql` |
| 2 | `20260323213000_01_schema.sql` |
| 3 | `20260323213100_03_triggers_user_profiles.sql` |
| 4 | `20260408130000_m0_001_profiles.sql` |
| 5 | `20260410120000_erp_core_ubicaciones_inventario_ordenes_venta.sql` |
| 6 | `20260415100000_001_profiles.sql` |
| 7 | `20260420120000_s1_auth_profiles_and_updated_at_triggers.sql` |

---

## 2. Tablas principales y propósito

- **`profiles`** — Usuario Auth ↔ `empresa_id`, `sucursal_id`, `app_role` (admin | encargado | empleado); convención W04 (`updated_at`, `deleted_at`, `sync_status`).
- **`empresas`** — Tenant explícito (nombre, auditoría); `profiles.empresa_id` **no** tiene FK a `empresas.id` en migraciones (coherencia por convención).
- **`ubicaciones`** — Almacenes / punto con tipo (`ALMACEN`, `TIENDA`, `TRANSITO`, `DEVOLUCIONES`) por `empresa_id`.
- **`productos`** — Catálogo; columnas extendidas en `erp_core` (descripción, UOM, activo, auditoría, `sync_status`).
- **`clientes`** — Maestro clientes extendido (contacto, auditoría, `sync_status`).
- **`proveedores`** — Maestro mínimo (desde draft); `created_at` / `updated_at` desde migración S1 (`20260420120000_...`).
- **`compras_encabezado` / `compras_detalle`** — Compras (draft).
- **`ordenes_compra_encabezado` / `ordenes_compra_detalle`** — OC con enum de estado (draft).
- **`traslados_encabezado` / `traslados_detalle`** — Traslados con enum (draft).
- **`inventario_existencias`** — Stock por `producto_id` y `ubicacion_id` (MVP).
- **`ordenes_venta_encabezado` / `ordenes_venta_detalle`** — OV con estados en texto y líneas.

**No creadas por migraciones actuales:** `import_log`; tablas dedicadas **`tiendas`**, **`zonas`**; staging de importación.

**Post-auth:** el archivo `03_triggers_user_profiles.sql` sigue en el historial con el nombre antiguo; a partir de **`20260420120000_s1_auth_profiles_and_updated_at_triggers.sql`**, la función **`handle_new_auth_user`** escribe en **`public.profiles`** (solo si `user_metadata` incluye `empresa_id` UUID válido; si no, no-op). No se usa **`user_profiles`**.

---

## 3. Funciones y triggers relevantes

- **`public.set_updated_at()`** — Trigger PL/pgSQL para `updated_at` (definida en `erp_core` y repetida en `001_profiles`).
- **`public.current_empresa_id()`**, **`public.current_sucursal_id()`**, **`public.app_role()`** — `SECURITY DEFINER`, leen `profiles`; versión vigente tras cadena completa: **`001_profiles`**.
- **Draft adicional:** `empleados_del_encargado`, `oc_visible_encargado`, `traslado_visible_encargado` (políticas OC/traslados).
- **`public.handle_new_auth_user()`** + trigger **`on_auth_user_created`** en `auth.users` — tras migración **7**, inserta/actualiza **`public.profiles`** condicionado a `empresa_id` en metadata (ver comentario en función).

### Cobertura `updated_at` (triggers explícitos)

| Con trigger | Notas |
|---------------|--------|
| `profiles`, `productos`, `clientes`, `ubicaciones`, `inventario_existencias`, `ordenes_venta_*`, `empresas`, `proveedores`, `compras_*`, `ordenes_compra_*`, `traslados_*` | Tras **`20260420120000_...`**, el draft de compras/OC/traslados y `proveedores` tienen columnas `created_at`/`updated_at` y triggers `tr_*_updated_at`. |

---

## 4. RLS — resumen por tabla

| Tabla | RLS | Resumen de policies |
|-------|-----|---------------------|
| `profiles` | Sí | `anon`: SELECT imposible; `authenticated`: solo fila propia (SELECT con `deleted_at is null`). |
| `productos` | Sí | SELECT por `empresa_id` (empleado, encargado, admin); mutación solo **admin**. |
| `compras_encabezado` / `compras_detalle` | Sí | Encargado + sucursal; admin global. |
| `ordenes_compra_*` | Sí | Empleado asignado, encargado por sucursal, admin. |
| `traslados_*` | Sí | Análogo a OC. |
| `clientes`, `proveedores` | Sí | Staff SELECT mismo tenant; admin ALL. |
| `empresas` | Sí | SELECT si `id = current_empresa_id()`; UPDATE admin mismo id. |
| `ubicaciones` | Sí | SELECT staff; ALL solo admin. |
| `inventario_existencias` | Sí | SELECT staff; escritura admin. |
| `ordenes_venta_encabezado` | Sí | SELECT staff; INSERT/UPDATE encargado+admin; DELETE admin. |
| `ordenes_venta_detalle` | Sí | SELECT staff vía OV; escritura encargado+admin vía EXISTS. |

Convención de nombres: ver `docs/reference/schema-conventions.md` y `docs/reference/SECURITY_POLICIES.md` (borrador).

---

## 5. Mapa ROADMAP S1 (`T1.1.1`–`T1.1.7`)

| Ticket | Estado vs migraciones |
|--------|------------------------|
| **T1.1.1** | **Parcial:** `productos`, `profiles`, “tienda” como `ubicaciones` tipo `TIENDA`; faltan `tiendas`/`zonas` dedicadas o ADR explícito. |
| **T1.1.2** | **Cubierto en núcleo draft + ERP:** triggers `updated_at` en tablas listadas en §3 (incl. `empresas`, compras, OC, traslados, `proveedores`). Revisar tablas futuras al añadirlas. |
| **T1.1.3** | **Parcial:** RLS amplio; revisión fina / huecos / import y convenciones pendientes. |
| **T1.1.4** | **Parcial (BD):** login email/password sigue siendo Supabase Auth; trigger post-signup ya apunta a **`profiles`** con `empresa_id` en metadata (sin metadata, el perfil se crea por flujo admin/service). |
| **T1.1.5** | **No cubierto:** módulo import Excel → backend. |
| **T1.1.6** | **No cubierto:** validación/limpieza en código. |
| **T1.1.7** | **No cubierto:** tabla `import_log`. |

---

## 6. Issues del milestone (agrupación práctica)

**Repositorio:** `Abraha33/ERP`, milestone **#16**. Referencia: inventario de issues abierto al documentar.

### (a) Cerrar o avanzar con documentación + verificación

- **[E01-S01-02]** — Confirmar `.env.example` en repo.
- **[E01-S01-03]** — Sustituido por migraciones versionadas; cerrar con enlace a esta página y a `supabase/migrations/`.
- **[E01-S01-04]** — Checklist: `supabase db reset` / `db push` y lista de tablas vs sección 2.
- **[T06] Excel SAE** — Cerrar si `docs/legacy/EXCEL_ANALYSIS.md` (u otro doc acordado) cumple alcance.

### (b) Ajustes pequeños en SQL / policies

- **T1.1.2** — Migración nueva: triggers `updated_at` faltantes.
- **T1.1.3** + **[T07] RLS** — Revisión y migración de policies puntuales.
- **T1.1.1** — DDL `tiendas`/`zonas` o ADR “tienda = `ubicaciones`” + `zonas` mínimas.
- **T1.1.4 (BD)** — ~~Corregir trigger post-auth~~ hecho en **`20260420120000_s1_auth_profiles_and_updated_at_triggers.sql`**; validar en app que el signup envía `empresa_id` en metadata si se espera fila automática en `profiles`.

### (c) Trabajo nuevo

- **T1.1.7** `import_log` → **T1.1.5** / **T1.1.6** import y validación.
- **[E01-S01-05]** seed, **[E01-S01-06..10]** worker FastAPI (opcional).
- Scraper, CRUD app (**[T08]–[T10]**): coordinar con Fase 1 · S2 donde aplique.
- Issues **Expo / React Native** en milestone: desalineados con stack Kotlin (`project.mdc`) — gestionar aparte.

**Orden sugerido:** (a) verificación y cierre doc → (b) T1.1.3 / [T07] (trigger Auth + T1.1.2 cubiertos por **`20260420120000_...`**) → T1.1.1 gap → (c) `import_log` + import.

---

## 7. Plan corto para cerrar S1 (backend datos)

1. Publicar y enlazar **este documento** en issues **[E01-S01-03]**, **[E01-S01-04]**.
2. ~~Resolver trigger `auth.users` + `profiles`~~ — migración **`20260420120000_...`**.
3. ~~Triggers `updated_at` restantes~~ — incluidos en la misma migración; cerrar **T1.1.2** tras verificar en entorno real.
4. Pasada **RLS** documentada → **T1.1.3** + **[T07]**.
5. **T1.1.1:** decisión tiendas/zonas + migración si aplica.
6. **T1.1.7** → **T1.1.5** / **T1.1.6**.

---

## 8. Textos listos para pegar en GitHub

### 8.1 [E01-S01-03] (#49) — Core tables desde draft

```markdown
## Cierre: tablas núcleo

Las tablas definidas en el borrador **`20260322190000_draft_rls_core.sql`** y su evolución (**`m0_001_profiles`**, **`erp_core_...`**, **`001_profiles`**) son la **fuente de verdad** en `supabase/migrations/`. No hace falta volcar el draft a mano: el historial de migraciones lo reemplaza.

**Referencia:** `docs/backend/estado-bd-fase1-s1.md` en el repo (ruta relativa desde la raíz del monorepo).

**Criterio de hecho:** enlazar este doc en el issue y archivar/duplicar contra **T1.1.*** si el equipo prefiere un solo hilo de seguimiento.
```

### 8.2 [E01-S01-04] — Run draft SQL; verify tables

*(Ajusta checkboxes al verificar en tu máquina.)*

```markdown
## Verificación BD — alineado a `docs/backend/estado-bd-fase1-s1.md`

- [ ] `supabase db reset` (o `db push`) sin error en local/remoto de prueba
- [ ] Tablas presentes según doc sección 2 (incl. draft + erp_core + profiles)
- [ ] Post-auth: `handle_new_auth_user` → `profiles` solo con `empresa_id` en metadata (doc §2)
- [ ] RLS activo en tablas expuestas (doc §4)

**Evidencia:** enlace al commit / rama donde se aplicaron migraciones; captura o log de `db reset` opcional.
```

---

## Referencias

- [ROADMAP.md](../../ROADMAP.md) — Fase 1 · S1
- [Esqueleto.md](../reference/Esqueleto.md) — catálogos e inventario
- [schema-conventions.md](../reference/schema-conventions.md)
- [.cursor/rules/project.mdc](../../.cursor/rules/project.mdc)
- [migration-strategy.md](./migration-strategy.md)
