# Cursor rules — verificación M0 (W05)

## Rules esperadas en `.cursor/rules/` (9 archivos `.mdc`)

1. `project.mdc` — `alwaysApply: true`
2. `create-ticket.mdc`
3. `update-ticket.mdc`
4. `close-ticket.mdc`
5. `debug-sql.mdc`
6. `new-migration.mdc`
7. `new-feature.mdc`
8. `sync-context.mdc`
9. `review-pr.mdc`

Comandos slash en `.cursor/commands/*.md` deben delegar en la `.mdc` homónima.

## Conflicto conocido

- Si una regla global del workspace de Cursor sigue apuntando a un `.mdc` eliminado (p. ej. workflows), actualizar la regla en la UI de Cursor o enlazar `docs/WORKFLOW.md`.

## Prueba rápida

Pedir al agente un snippet de **Kotlin** para llamar a Supabase; no debe proponer cliente JS móvil si las reglas están cargadas.
