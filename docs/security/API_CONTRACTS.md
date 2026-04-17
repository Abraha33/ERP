# API_CONTRACTS

## Objetivo
Definir convenciones base de la API del ERP+CRM.

## Estilo
- REST JSON
- Versionado por prefijo: /api/v1
- Auth con JWT/Bearer
- Fechas en ISO-8601
- IDs UUID salvo excepción documentada

## Convenciones
- GET /resource
- GET /resource/{id}
- POST /resource
- PATCH /resource/{id}
- DELETE /resource/{id}
- POST /resource/{id}/approve
- POST /resource/{id}/cancel

## Respuesta estándar
```json
{
  "data": {},
  "meta": {
    "request_id": "uuid",
    "pagination": null
  },
  "error": null
}
```

## Error estándar
```json
{
  "data": null,
  "meta": {
    "request_id": "uuid"
  },
  "error": {
    "code": "validation_error",
    "message": "Human readable message",
    "details": []
  }
}
```

## Recursos iniciales MVP
- /auth
- /users
- /roles
- /third-parties
- /products
- /price-lists
- /quotes
- /sales-orders
- /sales-invoices
- /purchase-orders
- /goods-receipts
- /inventory-movements
- /crm/leads
- /crm/opportunities
- /reports

## Reglas de seguridad
- Cada endpoint valida company scope
- Los endpoints de aprobación requieren permiso explícito
- Export endpoints deben quedar auditados

## Pendientes
- Definir filtros estándar
- Definir paginación exacta
- Definir endpoints batch
- Definir webhooks salientes