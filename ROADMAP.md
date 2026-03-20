# ROADMAP - ERP Satelite (14 Meses)

Fase 1  App Satelite   Mes 1-3    Operaciones de campo activas
Fase 2  ERP Basico     Mes 4-7    SAE parcialmente reemplazado
Fase 3  ERP Completo   Mes 8-10   SAE reemplazado totalmente
Fase 4  CRM            Mes 11-12  Gestion comercial activa
Fase 5  Offline-First  Mes 13-14  App funciona sin internet

## FASE 0: FUNDACION (Semana 1-2)
T0.1.1  Crear repo GitHub + ramas main/dev               1h  Alta
T0.1.2  Crear proyecto en backend cloud                  1h  Alta
T0.1.3  Definir stack tecnologico (ADR-001)              3h  Alta
T0.1.4  Configurar variables de entorno base             1h  Alta
T0.1.5  Analizar estructura del Excel exportado del SAE  2h  Alta
T0.1.6  Documentar columnas en EXCEL_ANALYSIS.md         1h  Alta
T0.1.7  Completar CURSOR_CONTEXT.md con stack definido   1h  Alta

## FASE 1: APP SATELITE MVP (Mes 1-3)

Sprint 1 - Modelo de datos e importacion (Semana 3-4)
T1.1.1  Tablas: productos, perfiles, tiendas, zonas      3h  Alta
T1.1.2  Trigger updated_at en todas las tablas           1h  Alta
T1.1.3  Politicas de seguridad por rol                   3h  Alta
T1.1.4  Auth: login por email y contrasena               1h  Alta
T1.1.5  Modulo importacion Excel al backend              5h  Alta
T1.1.6  Validacion y limpieza de datos al importar       3h  Alta
T1.1.7  Tabla import_log                                 1h  Alta

Sprint 2 - Login y catalogo (Semana 5-6)
T1.2.1  Pantalla de login + lectura rol                  3h  Alta
T1.2.2  Navegacion condicional por rol                   2h  Alta
T1.2.3  Catalogo de productos + busqueda                 4h  Alta
T1.2.4  Pantalla de detalle de producto                  2h  Media

Sprint 3 - Recepcion y traslados (Semana 7-8)
T1.3.1  Tablas: recepciones, traslados, stock_zona       3h  Alta
T1.3.2  Pantalla recepcion de mercancia                  4h  Alta
T1.3.3  Pantalla traslados entre zonas                   4h  Alta
T1.3.4  Vista encargado: aprobar / rechazar              3h  Alta

Sprint 4 - Misiones de conteo (Semana 9-10)
T1.4.1  Tablas: misiones_conteo, conteo_detalle          2h  Alta
T1.4.2  Vista admin: crear mision                        3h  Alta
T1.4.3  Vista empleado: ejecutar mision asignada         5h  Alta
T1.4.4  Vista admin: descuadres por mision               3h  Alta

Sprint 5 - Arqueo de caja (Semana 11-12)
T1.5.1  Tabla arqueos_caja                               2h  Alta
T1.5.2  Pantalla arqueo: billetes, monedas, vouchers     4h  Alta
T1.5.3  Calculo automatico y diferencia vs sistema       2h  Alta
T1.5.4  Historico de arqueos                             2h  Media

## FASE 2: ERP BASICO (Mes 4-7)
T2.1.x  Catalogos: productos, proveedores, clientes      30h  Alta
T2.2.x  Compras: OC, recepcion, pagos                    25h  Alta
T2.3.x  Ventas: cotizaciones, pedidos, facturacion       25h  Alta
T2.4.x  Inventario: stock tiempo real, trazabilidad      20h  Alta

## FASE 3: ERP COMPLETO (Mes 8-10)
T3.1.x  Contabilidad: asientos, P&L, cierres             30h  Alta
T3.2.x  RRHH: empleados, turnos, nomina                  20h  Alta
T3.3.x  Reportes gerenciales avanzados                   15h  Media
T3.4.x  Auditoria y trazabilidad completa                10h  Media

## FASE 4: CRM (Mes 11-12)
T4.1.x  Comunicacion interna entre usuarios              15h  Media
T4.2.x  Transcripcion de audio a texto                   12h  Media
T4.3.x  Gestion de casos y tickets                       15h  Media
T4.4.x  Pipeline de ventas: leads al cierre              20h  Media
T4.5.x  Historial completo por cliente                   10h  Media

## FASE 5: OFFLINE-FIRST (Mes 13-14)
T5.1.1  Base de datos local en el dispositivo            4h  Alta
T5.1.2  Modelos locales espejo de tablas criticas        6h  Alta
T5.1.3  UI siempre lee local, nunca directo al backend   8h  Alta
T5.2.1  Sync descarga: backend al local                  6h  Alta
T5.2.2  Sync subida: local al backend con pending_sync   8h  Alta
T5.2.3  Indicador de conexion y estado de sync           3h  Media
T5.2.4  Resolucion de conflictos via updated_at          5h  Media
