# Checklist inicio / fin de sesión

## Inicio

- [ ] Revisar [session-context.md](./session-context.md) (tablas, decisiones, pendientes).
- [ ] Abrir tablero GitHub Project 11 y filtrar **Ready** / **In progress** asignados a ti.
- [ ] `git fetch` y estar en la rama correcta ([git-branches.md](./git-branches.md)).
- [ ] Supabase: confirmar proyecto (local vs remoto) y que `.env` apunta al entorno deseado.
- [ ] Si vas a tocar RLS: copiar prompt base de [agents/supabase-debug-prompt.md](./agents/supabase-debug-prompt.md) en un scratchpad.

## Durante la sesión

- [ ] Un issue → una rama / un foco principal.
- [ ] Migraciones: probar orden `up` en limpio cuando sea posible.
- [ ] No commitear secretos; revisar `git diff` antes de push.

## Fin

- [ ] Tests manuales mínimos según ticket (web/Android).
- [ ] Actualizar **session-context.md** si cambió el esquema, RLS o una decisión.
- [ ] PR en borrador o listo: enlace en el issue; **Status** → **In review** si aplica.
- [ ] Dejar nota en el issue si quedó bloqueo (enlace a [open-questions.md](./open-questions.md) si es decisión de producto).

## Opcional (Cursor / agentes)

- Inicio: [agents/cursor-prompt.md](./agents/cursor-prompt.md).
- Investigación externa: [agents/perplexity-prompt.md](./agents/perplexity-prompt.md).
