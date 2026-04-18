# apps/web — Cliente Web (Fase 1)

> **Estado:** scaffold reservado — aún no inicializado.

Este directorio contendrá el cliente web del ERP, construido con **React + TypeScript + Vite**.

## Stack planeado

| Capa | Tecnología |
|------|-----------|
| Framework | React 18 + TypeScript |
| Build | Vite |
| Estilos | TailwindCSS |
| Estado | Zustand (ligero) o React Query |
| Auth | Supabase Auth (`@supabase/supabase-js`) |
| API | Supabase PostgREST / FastAPI `/api/v1` |

## Inicialización (cuando entre en scope — Fase 1)

```bash
cd apps/web
npm create vite@latest . -- --template react-ts
npm install
```

## Referencias

- [ADR-001](../../docs/adr/ADR-001-stack-tecnologico.md) — decisiones de stack global
- [ROADMAP.md](../../ROADMAP.md) — Fase 1 tickets T1.x
