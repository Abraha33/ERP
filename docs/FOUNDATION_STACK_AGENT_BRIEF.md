# Brief: fundación ERP Satélite — contexto para definir el tech stack

**Propósito:** documento **único y explícito** para pegar en otro agente y **revisar o reabrir** el debate del stack de fundación si hace falta. La decisión vigente está en **[ADR-001](../ADR/ADR-001-stack-tecnologico.md)** (**ACEPTADA**, 2026-03-22).

**Alcance:** Fase 0 + línea base que soporta Fase 1 (App Satélite MVP). No sustituye al ADR ni a [STACK_POR_FASE.md](./STACK_POR_FASE.md); sirve como **guion de trabajo** y checklist de capas.

---

## 1. Qué es ERP Satélite (producto)

- **ERP + CRM** a largo plazo; arranque por **app de operaciones de campo** (recepción, traslados, misiones de conteo, arqueo) alimentada con **Excel exportado del SAE** y, donde aplique, **scraper/automatización** frente al sistema legacy.
- **Un solo desarrollador** (founder), ~25 h/semana, uso intensivo de IA en el editor.
- **Horizonte:** roadmap ~**14 meses** (ver `ROADMAP.md` en la raíz del monorepo `ERP1` y `erp-satelite/ROADMAP.md` si existe copia local).

---

## 2. Restricciones que cualquier stack debe respetar

| Restricción | Detalle |
|-------------|---------|
| Ramas Git | Solo **`main`** y **`develop`** permanentes en remoto; integración en `develop`. Ver [README §3.2](../README.md#32-ramas-git-solo-main-y-develop). |
| Secretos | Nunca commitear `.env`; usar `.env.example` como plantilla. |
| Documentación de decisiones | Decisiones de arquitectura relevantes → `ADR/` (hoy el contenedor es **ADR-001**). |
| Tablero | Project 11, convención de issues y milestones en [README](../README.md) y [GITHUB_PROJECTS.md](./GITHUB_PROJECTS.md). |
| Offline “de verdad” | Requisito fuerte en **Fase 5**; antes de eso el stack puede preparar API/Postgres pero **no obliga** a meter BD local en el cliente desde el día 1. |

---

## 3. Capas a decidir (checklist para el otro agente)

Para cada fila, el agente debe **proponer opción principal + alternativa + riesgos** y **criterios de aceptación** (qué probar para dar por cerrado).

| # | Capa | Preguntas mínimas |
|---|------|-------------------|
| A | **Cliente móvil + web** | ¿Un solo codebase? ¿Expo / RN CLI / Flutter / PWA? ¿TypeScript obligatorio? |
| B | **Backend / BaaS** | ¿Supabase vs Firebase vs API propia (FastAPI/Nest) vs híbrido? ¿Quién define Auth y RLS? |
| C | **Base de datos cloud** | Postgres “de verdad” vs otros; migraciones; entorno local de desarrollo. |
| D | **Auth y roles** | Modelo (email, magic link, SSO futuro); claims vs tablas de roles; encaje con RLS. |
| E | **Importación Excel + SAE** | ¿Dónde corre la lógica (Edge, worker Python, solo cliente)? Límites de tamaño y repetición. |
| F | **Scraper / automatización** | ¿Playwright obligatorio u opcional? ¿Dónde se ejecuta (local, CI, VPS)? |
| G | **CI/CD** | GitHub Actions: qué gates (lint, typecheck, tests, deploy preview). |
| H | **Offline (solo diseño global)** | Compromiso con **WatermelonDB** u otra; estrategia de sync **a alto nivel** (detalle en Fase 5). |

---

## 4. Decisión de fundación (referencia)

El stack de fundación está **aceptado** en [ADR-001](../ADR/ADR-001-stack-tecnologico.md) (2026-03-22). Resumen: **Expo + Supabase + FastAPI (worker) + Playwright + GitHub Actions + EAS**; **WatermelonDB** en Fase 5.

Si en el futuro se reabre el debate, usar el **entregable** de la sección 5 y actualizar en bloque: `ADR-001`, `README` §10–11, `STACK_POR_FASE`, `CURSOR_CONTEXT`, `.env.example`.

---

## 5. Entregable esperado del agente colaborador

Pedir explícitamente una salida con esta estructura:

1. **Resumen ejecutivo** (5–10 líneas).
2. **Tabla decisión** (capas A–H con opción elegida y una alternativa).
3. **Riesgos y mitigaciones** (top 5).
4. **Plan de verificación** (comandos o pasos para comprobar que el stack “arranca”: repo, build app, conexión a backend de prueba).
5. **Borrador de texto** listo para pegar en `ADR/ADR-001-stack-tecnologico.md` (secciones: contexto, opciones, decisión final, consecuencias).
6. **Lista de variables de entorno** mínimas para `.env.example` (nombres solamente, sin secretos).

---

## 6. Tickets de roadmap (Fase 0) que este trabajo desbloquea

Alineación con `ERP1/ROADMAP.md` (granular):

| Ticket | Nombre | Relación con el stack |
|--------|--------|------------------------|
| T0.1.1 | Repo + `main` / `develop` | Independiente del stack. |
| T0.1.2 | Proyecto backend cloud | Depende de decisión capa B/C. |
| T0.1.3 | ADR stack | **Salida principal** del otro agente. |
| T0.1.4 | Variables de entorno | Lista del entregable (6). |
| T0.1.5–T0.1.6 | Excel SAE | Parcialmente independiente; importación depende de B/E. |
| T0.1.7 | CURSOR_CONTEXT | Actualizar tras cerrar ADR. |

---

## 7. Cómo usar este brief (copiar y pegar)

**Instrucción sugerida para el otro agente:**

> Estás ayudando a definir el **tech stack de fundación** del proyecto **ERP Satélite** (`Abraha33/erp-satelite`). Lee el archivo `docs/FOUNDATION_STACK_AGENT_BRIEF.md` del repo como fuente de verdad de contexto y restricciones. No modifiques el repositorio salvo que el usuario lo pida. Produce el **entregable** de la sección 5. Si recomiendas cambiar la hipótesis de la sección 4, sé explícito sobre trade-offs para un solo desarrollador y el roadmap de 14 meses.

---

## 8. Referencias rápidas en el repo

| Documento | Uso |
|-----------|-----|
| [README.md](../README.md) | Reglas de trabajo, milestones, tablero, ramas. |
| [STACK_POR_FASE.md](./STACK_POR_FASE.md) | Stack por fase del producto. |
| [CURSOR_CONTEXT.md](../CURSOR_CONTEXT.md) | Defaults para asistentes en Cursor. |
| [ADR-001](../ADR/ADR-001-stack-tecnologico.md) | Donde debe quedar la decisión formal. |
| [EXCEL_ANALYSIS.md](./EXCEL_ANALYSIS.md) | Análisis export SAE (puede ir en paralelo). |
| [Esqueleto.md](./Esqueleto.md) (si existe en `docs/`) | Alcance funcional alto nivel. |

---

*Última actualización del brief: 2026-03-22. Ajusta fechas o tickets si el roadmap cambia.*
