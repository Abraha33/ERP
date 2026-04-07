# Estrategia de ramas Git

## Ramas permanentes

| Rama | Propósito |
|------|-----------|
| **`main`** | Línea estable; solo integración desde `develop` (o hotfix puntuales acordados). |
| **`develop`** | Integración continua del trabajo del equipo; base para features. |

## Ramas de trabajo

| Prefijo | Uso | Ejemplo |
|---------|-----|---------|
| **`feature/`** | Nueva funcionalidad, UI, scripts no destructivos. | `feature/T12-cierre-caja-ui` |
| **`db/`** | Migraciones SQL, cambios de RLS, índices, seeds estructurados. | `db/empresas-sucursales-rls` |

## Convenciones

- Nombre en **kebab-case**; incluir referencia al ticket (`T##`, `E##-S##-##`) cuando exista.
- **Un PR** preferiblemente alineado a **un issue** (o épica explícita en la descripción).
- Merge a `develop` vía **PR** con revisión; no force-push en ramas compartidas.

## Hotfixes

- Desde `main` → rama `hotfix/…` → PR a `main` y **backport** a `develop` si el equipo lo practica.

## Repositorio de aplicación

El producto vive en **`Abraha33/erp-satelite`**. Clona y ramifica ahí si el monorepo local solo contiene docs/supabase; ajusta rutas según tu layout (`erp-satelite/` como subcarpeta).
