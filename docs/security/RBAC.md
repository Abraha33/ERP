# RBAC

## Objetivo
Definir roles, permisos y restricciones del ERP+CRM para backend, frontend y asistentes IA.

## Roles base
- Superadmin
- Admin empresa
- Gerencia
- Ventas
- Compras
- Inventario
- Cartera
- Contabilidad
- RRHH
- Operación campo
- Soporte
- Auditoría

## Reglas globales
- Todo acceso es deny-by-default.
- Los permisos se asignan por rol y pueden refinarse por empresa, sucursal y módulo.
- Toda acción sensible debe quedar auditada.
- Los usuarios solo pueden ver información de su empresa, salvo roles cross-company explícitos.

## Matriz inicial
| Módulo | Acción | Superadmin | Admin empresa | Gerencia | Operativo |
|---|---|---|---|---|---|
| Terceros | Leer | Sí | Sí | Sí | Según rol |
| Terceros | Crear/editar | Sí | Sí | Opcional | Según rol |
| Ventas | Leer | Sí | Sí | Sí | Sí |
| Ventas | Aprobar | Sí | Sí | Sí | No |
| Compras | Aprobar | Sí | Sí | Sí | No |
| Inventario | Ajustes | Sí | Sí | Opcional | No |
| Contabilidad | Cierre | Sí | No | Sí | No |
| RRHH | Ver salarios | Sí | Opcional | Opcional | No |

## Scope de permisos
- Por módulo
- Por acción: read, create, update, delete, approve, export
- Por empresa
- Por sucursal
- Por documento/estado si aplica

## Auditoría mínima
- usuario
- fecha/hora
- entidad
- acción
- before/after
- origen (web, móvil, API, job)

## Pendientes
- Definir permisos especiales de cartera
- Definir segregación de funciones en contabilidad
- Definir aprobación multinivel para compras