# Mapa módulo → carpeta `app/` → fase

> La app de producto vive en **`apps/android/`** (Compose, navegación Kotlin). `apps/mobile/` es **legado** hasta retirada. Esta tabla es la **convención objetivo** de paquetes / pantallas.

| Módulo ERP | Rutas sugeridas (`app/`) | Fase roadmap |
|------------|---------------------------|--------------|
| Auth / sesión | `app/(auth)/…`, `app/index` | F1+ |
| Perfil / empresa / sucursal | `app/(app)/settings/…` o `app/onboarding/…` | F1–F2 |
| Inventario / almacén | `app/(app)/inventario/…` | F1–F2 |
| Traslados | `app/(app)/traslados/…` | F1–F2 |
| Órdenes de compra | `app/(app)/compras/oc/…` | F2 |
| Compras (facturas) | `app/(app)/compras/…` | F2 |
| Ventas / POS | `app/(app)/ventas/…` | F2 |
| Catálogos (productos, clientes, proveedores) | `app/(app)/catalogo/…` | F2 |
| Contabilidad | `app/(app)/contabilidad/…` | F3 |
| RRHH | `app/(app)/rrhh/…` | F3 |
| CRM / inbox | `app/(app)/crm/…` | F4 |
| Sync / offline | Room + WorkManager + pantallas de estado | F5 |

## Layout técnico

- Agrupar por **grupos de rutas** `(app)`, `(auth)` para tabs y guards.
- Componentes compartidos: `components/`; lógica Supabase: `lib/` o `services/`.

## Referencias

- Fases y stack: [STACK_POR_FASE.md](./STACK_POR_FASE.md).
- Datos y tablas lógicas: [SAE_DATA_MAPPING.md](./SAE_DATA_MAPPING.md), [SECURITY_POLICIES.md](./SECURITY_POLICIES.md).
