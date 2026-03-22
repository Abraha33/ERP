# ROADMAP — Producto ERP + CRM Satélite (14 meses)

Plan maestro del **producto completo**: no es solo la app de campo. Cubre **fundación (Fase 0)**, **App Satélite** (MVP de operaciones en tienda/campo), **ERP básico** (MVP administrativo), **ERP completo**, **CRM** y **offline-first**. Este archivo es el **`ROADMAP.md` de la raíz del repositorio** (lo que ves al abrir el proyecto en GitHub). Si usas una carpeta monorepo local (`ERP/`) con scripts fuera del repo, el plan maestro canónico sigue siendo este mismo archivo dentro de `erp-satelite/`.

| Fase | Ámbito del producto | Período | Hito |
|------|---------------------|---------|------|
| **0** | Fundación (Git, stack ADR, Excel/SAE, entornos) | Semana 1–2 | Base lista para Fase 1 |
| **1** | **App Satélite** — MVP campo (móvil + web, importación, scraper) | Mes 1–3 | Operaciones de campo activas |
| **2** | **ERP básico** — MVP back-office (catálogos, compras, ventas, inventario) | Mes 4–7 | SAE parcialmente reemplazado |
| **3** | **ERP completo** (contabilidad, RRHH, reportes, auditoría) | Mes 8–10 | SAE reemplazado totalmente |
| **4** | **CRM** (canales, pipeline, historial cliente) | Mes 11–12 | Gestión comercial activa |
| **5** | **Offline-first** (BD local, sync, conflictos) | Mes 13–14 | App funciona sin internet |

**Stack por fase:** [docs/STACK_POR_FASE.md](./docs/STACK_POR_FASE.md).

**Última revisión:** 2026-03-22 — alineado con [README.md §16](./README.md#16-setup-inicial-y-scripts) y scaffold en la raíz del repo (`apps/mobile`, `worker/`, `scraper/`, CI).

**Vista por sprints (T01–T35, ~14 semanas):** [docs/ROADMAP_SPRINTS.md](./docs/ROADMAP_SPRINTS.md).

---

## FASE 0: FUNDACIÓN (Semana 1–2)
| Ticket | Tarea                                           | Horas | Prioridad | Estado (marzo 2026) |
|--------|-------------------------------------------------|-------|-----------|---------------------|
| T0.1.1 | Crear repo GitHub + ramas main y develop        | 1h    | Alta      | **Hecho** |
| T0.1.2 | Crear proyecto en backend cloud (Supabase)      | 1h    | Alta      | **En progreso** (proyecto + keys en `.env`) |
| T0.1.3 | Definir stack tecnológico (ADR-001)             | 3h    | Alta      | **Hecho** |
| T0.1.4 | Configurar variables de entorno base            | 1h    | Alta      | **En progreso** (plantillas + `.env` locales; falta rellenar secretos) |
| T0.1.5 | Analizar estructura del Excel exportado del SAE | 2h    | Alta      | **En progreso** |
| T0.1.6 | Documentar columnas en EXCEL_ANALYSIS.md        | 1h    | Alta      | **En progreso** (ver [docs/EXCEL_ANALYSIS.md](./docs/EXCEL_ANALYSIS.md)) |
| T0.1.7 | Completar CURSOR_CONTEXT.md con stack definido  | 1h    | Alta      | **Hecho** |

**Scaffold de código (Fase 0, fuera de la tabla T0.1.* original):** en la raíz del repo ya existen `apps/mobile` (Expo + Expo Router + NativeWind + TypeScript strict), `worker/` (FastAPI + `/health`), `scraper/` (stub Playwright + `.env`), `.github/workflows/ci.yml` y `eas.json` en mobile. No implica tablas Supabase ni producto en producción.

---

## FASE 1: APP SATÉLITE — MVP CAMPO (Mes 1–3)

### Sprint 1 — Modelar datos e importación (Semana 3–4)
| Ticket | Tarea                                           | Horas | Prioridad |
|--------|-------------------------------------------------|-------|-----------|
| T1.1.1 | Tablas: productos, perfiles, tiendas, zonas     | 3h    | Alta      |
| T1.1.2 | Trigger updated_at en todas las tablas          | 1h    | Alta      |
| T1.1.3 | Políticas de seguridad por rol                  | 3h    | Alta      |
| T1.1.4 | Auth: login por email y contraseña              | 1h    | Alta      |
| T1.1.5 | Módulo importación Excel → backend              | 5h    | Alta      |
| T1.1.6 | Validación y limpieza de datos al importar      | 3h    | Alta      |
| T1.1.7 | Tabla import_log                                | 1h    | Alta      |

### Sprint 2 — Login y catálogo (Semana 5–6)
| Ticket | Tarea                            | Horas | Prioridad |
|--------|----------------------------------|-------|-----------|
| T1.2.1 | Pantalla de login + lectura rol  | 3h    | Alta      |
| T1.2.2 | Navegación condicional por rol   | 2h    | Alta      |
| T1.2.3 | Catálogo de productos + búsqueda | 4h    | Alta      |
| T1.2.4 | Pantalla de detalle de producto  | 2h    | Media     |

### Sprint 3 — Recepción y traslados (Semana 7–8)
| Ticket | Tarea                                       | Horas | Prioridad |
|--------|---------------------------------------------|-------|-----------|
| T1.3.1 | Tablas: recepciones, traslados, stock_zona  | 3h    | Alta      |
| T1.3.2 | Pantalla recepción de mercancía             | 4h    | Alta      |
| T1.3.3 | Pantalla traslados entre zonas              | 4h    | Alta      |
| T1.3.4 | Vista encargado: aprobar / rechazar         | 3h    | Alta      |

### Sprint 4 — Misiones de conteo (Semana 9–10)
| Ticket | Tarea                                    | Horas | Prioridad |
|--------|------------------------------------------|-------|-----------|
| T1.4.1 | Tablas: misiones_conteo, conteo_detalle  | 2h    | Alta      |
| T1.4.2 | Vista admin: crear misión                | 3h    | Alta      |
| T1.4.3 | Vista empleado: ejecutar misión asignada | 5h    | Alta      |
| T1.4.4 | Vista admin: descuadres por misión       | 3h    | Alta      |

### Sprint 5 — Arqueo de caja (Semana 11–12)
| Ticket | Tarea                                        | Horas | Prioridad |
|--------|----------------------------------------------|-------|-----------|
| T1.5.1 | Tabla arqueos_caja                           | 2h    | Alta      |
| T1.5.2 | Pantalla arqueo: billetes, monedas, vouchers | 4h    | Alta      |
| T1.5.3 | Cálculo automático y diferencia vs sistema   | 2h    | Alta      |
| T1.5.4 | Histórico de arqueos                         | 2h    | Media     |

---

## FASE 2: ERP BÁSICO — MVP BACK-OFFICE (Mes 4–7)
| Ticket | Tarea                                          | Horas | Prioridad |
|--------|------------------------------------------------|-------|-----------|
| T2.1.x | Catálogos: productos, proveedores, clientes    | 30h   | Alta      |
| T2.2.x | Compras: OC, recepción, pagos                  | 25h   | Alta      |
| T2.3.x | Ventas: cotizaciones, pedidos, facturación     | 25h   | Alta      |
| T2.4.x | Inventario: stock en tiempo real, trazabilidad | 20h   | Alta      |

---

## FASE 3: ERP COMPLETO (Mes 8–10)

En GitHub, milestones de sprint: **`Fase 3 · S1` … `Fase 3 · S4`** (alineados a `T3.{stream}.*` y a `[E*-S15-*]` … `[E*-S20-*]` en import).

### Sprint 1 — Contabilidad (Mes 8)
| Ticket | Tarea                                 | Horas | Prioridad |
|--------|---------------------------------------|-------|-----------|
| T3.1.x | Contabilidad: asientos, P&L, cierres  | 30h   | Alta      |

### Sprint 2 — RRHH (Mes 9)
| Ticket | Tarea                                 | Horas | Prioridad |
|--------|---------------------------------------|-------|-----------|
| T3.2.x | RRHH: empleados, turnos, nómina       | 20h   | Alta      |

### Sprint 3 — Reportes gerenciales (Mes 10, bloque 1)
| Ticket | Tarea                                 | Horas | Prioridad |
|--------|---------------------------------------|-------|-----------|
| T3.3.x | Reportes gerenciales avanzados        | 15h   | Media     |

### Sprint 4 — Auditoría y trazabilidad (Mes 10, bloque 2 / cierre)
| Ticket | Tarea                                 | Horas | Prioridad |
|--------|---------------------------------------|-------|-----------|
| T3.4.x | Auditoría y trazabilidad completa     | 10h   | Media     |

---

## FASE 4: CRM (Mes 11–12)

En GitHub, milestones de sprint: **`Fase 4 · S1` … `Fase 4 · S5`** (`T4.{stream}.*`; épicas E con sprint **21–24** → S1–S4; **S5** prioriza tickets `T4.5.*` o rollup de fase).

### Sprint 1 — Comunicación interna
| Ticket | Tarea                                       | Horas | Prioridad |
|--------|---------------------------------------------|-------|-----------|
| T4.1.x | Comunicación interna entre usuarios         | 15h   | Media     |

### Sprint 2 — Transcripción y audio
| Ticket | Tarea                                       | Horas | Prioridad |
|--------|---------------------------------------------|-------|-----------|
| T4.2.x | Transcripción de audio a texto              | 12h   | Media     |

### Sprint 3 — Casos y tickets
| Ticket | Tarea                                       | Horas | Prioridad |
|--------|---------------------------------------------|-------|-----------|
| T4.3.x | Gestión de casos y tickets                  | 15h   | Media     |

### Sprint 4 — Pipeline de ventas
| Ticket | Tarea                                       | Horas | Prioridad |
|--------|---------------------------------------------|-------|-----------|
| T4.4.x | Pipeline de ventas: leads → cierre          | 20h   | Media     |

### Sprint 5 — Historial por cliente
| Ticket | Tarea                                       | Horas | Prioridad |
|--------|---------------------------------------------|-------|-----------|
| T4.5.x | Historial completo por cliente              | 10h   | Media     |

---

## FASE 5: OFFLINE-FIRST (Mes 13–14)
| Ticket | Tarea                                          | Horas | Prioridad |
|--------|------------------------------------------------|-------|-----------|
| T5.1.1 | Base de datos local en el dispositivo          | 4h    | Alta      |
| T5.1.2 | Modelos locales espejo de tablas críticas      | 6h    | Alta      |
| T5.1.3 | UI siempre lee local, nunca directo al backend | 8h    | Alta      |
| T5.2.1 | Sync descarga: backend → local                 | 6h    | Alta      |
| T5.2.2 | Sync subida: local → backend con pending_sync  | 8h    | Alta      |
| T5.2.3 | Indicador de conexión y estado de sync         | 3h    | Media     |
| T5.2.4 | Resolución de conflictos vía updated_at        | 5h    | Media     |
