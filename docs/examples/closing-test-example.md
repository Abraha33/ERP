# Qué es una prueba de cierre y cómo escribirla

## Propósito

Una **prueba de cierre** demuestra que el ticket cumple el **Definition of Done** en un entorno realista: misma base de datos, mismos roles RLS y mismos clientes (web/móvil) que usará el equipo.

No sustituye tests automatizados cuando existan, pero evita el “funciona en mi máquina” con `service_role`.

## Qué debe incluir

1. **Identidad del ticket** — issue, rama, alcance en una frase.
2. **Entorno** — proyecto Supabase (o local), versión aproximada de la app.
3. **Matriz rol × acción** — al menos un flujo por rol de aplicación afectado (`admin`, `encargado`, `empleado`).
4. **RLS** — evidencia de que un usuario sin permiso recibe el fallo esperado (vacío, 401/RPC error, mensaje de app).
5. **Regresión breve** — qué pantallas o APIs vecinas se re-probaron.

## Ejemplo breve (narrativo)

> **Ticket:** #45 — Lista de sucursales en ajustes.  
> **Entorno:** Supabase staging + Expo web.  
> **admin@…:** abre Ajustes → Sucursales; ve 3 filas; crea “Bodega Norte”; aparece en lista.  
> **encargado@…:** misma pantalla; ve solo sucursales con `empresa_id` igual al perfil; intento de insert vía API REST devuelve sin filas afectadas / error de política.  
> **empleado@…:** no ve el ítem de menú (o lista vacía según spec).  
> **Regresión:** login y cambio de perfil siguen funcionando.

## Plantilla tabular

Usa [../agents/testing-prompt.md](../agents/testing-prompt.md) para la tabla y checkboxes.

## Errores a evitar

- Probar solo con **service role** o como `postgres` en SQL Editor sin `SET request.jwt.claim.sub`.
- Olvidar **web** o **Android** cuando el ticket toca UI compartida.
- Cerrar sin actualizar [../session-context.md](../session-context.md) si el esquema cambió.
