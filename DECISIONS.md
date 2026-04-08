# Decisiones tecnicas pendientes

Documento para registrar decisiones de arquitectura y stack. Las decisiones formales van en [ADR/](./ADR/).

## Pendientes

- [ ] Stack backend adicional (solo si se abandona el modelo Supabase-first para un servicio propio)
- [ ] Base de datos (Supabase PostgreSQL confirmado en SCRUM; detalles de schema)
- [ ] Estrategia de migraciones (Flyway, Alembic, SQL versionado)
- [ ] Proveedor de facturacion electronica (por pais)

## Cerradas

- Cliente móvil producto: **Kotlin + Jetpack Compose + Room** — [ADR-001-stack-tecnologico.md](./ADR/ADR-001-stack-tecnologico.md)
- Backend datos/auth: **Supabase (Postgres + Auth + RLS)** — mismo ADR
