# CURSOR_CONTEXT

## Proyecto

ERP+CRM modular para operación real de PyME, con foco en ventas, compras, inventario, cartera y CRM.

## Fuente de verdad

- README.md
- ROADMAP.md
- Decisiones de arquitectura: `docs/ADR-001-architecture-stack.md`, `docs/ADR-002-offline-strategy.md`, [ADR/](../../ADR/)
- docs/domain/*
- docs/security/* (incluye contratos de API documentados allí)
- Integraciones: [docs/backend/INTEGRATIONS.md](../backend/INTEGRATIONS.md)

## Reglas para asistentes

- No inventar stack; usar ADRs
- No proponer offline antes de la fase definida
- Respetar multiempresa, RBAC y auditoría
- Priorizar MVP operativo sobre complejidad prematura
- Si hay conflicto entre archivos, ADR > README > docs secundarios

## Convenciones

- Modular monolith
- API versionada
- Seguridad deny-by-default
- Trazabilidad y auditoría en entidades sensibles

## Consultar antes de cambiar

- Arquitectura base
- Estrategia offline
- Integraciones regulatorias
- Módulos fuera del MVP
