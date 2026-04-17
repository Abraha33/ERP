# INTEGRATIONS

## Objetivo
Registrar integraciones externas del ERP+CRM y su estado.

## Integraciones objetivo
- Supabase
- WhatsApp
- Correo transaccional
- Almacenamiento de archivos
- Facturación electrónica / DIAN
- Jobs/colas
- Observabilidad

## Supabase
### Uso previsto
- Auth
- Postgres
- Storage
- Realtime opcional

### Pendientes
- Confirmar límites
- Confirmar estrategia de migraciones
- Confirmar política RLS vs backend-only

## WhatsApp
### Casos
- Notificaciones
- Seguimiento comercial
- Recordatorios de cartera

### Pendientes
- Elegir proveedor/API
- Definir plantillas
- Definir trazabilidad CRM

## Facturación electrónica
### Casos
- Emisión
- Eventos
- Estados

### Pendientes
- Elegir proveedor
- Definir flujo de contingencia
- Definir sincronización ERP-contabilidad

## Correo
- OTP, invitaciones, alertas, reportes
- Definir proveedor y reputación de dominio

## Archivos
- Adjuntos de terceros, documentos, evidencias
- Definir buckets, naming y retención

## Observabilidad
- Logs
- Métricas
- Alertas
- Auditoría

## Pendientes globales
- Matriz build vs buy por integración
- SLA esperado por proveedor
- Costos estimados mensuales