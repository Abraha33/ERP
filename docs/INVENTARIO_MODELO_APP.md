# Inventario — Modelo de dominio (App Satélite, Fase 1)

Modelo lógico para la capa de app (**Kotlin + Compose**). No está acoplado 1:1 a tablas SQL; los mapeos hacia Supabase se harán en una capa de datos posterior.

**Referencias:** [INVENTARIO_MODELO.md](./INVENTARIO_MODELO.md) (funcional), [INVENTARIO_MAPEO_BD.md](./INVENTARIO_MAPEO_BD.md) (tablas reales).

---

## Decisiones Fase 1 (cantidades, fechas, IDs)

| Tema | Decisión |
|------|----------|
| **Cantidades** | `java.math.BigDecimal` — evita errores de redondeo de `Double` y alinea con `numeric` en Postgres. Usar escala explícita al serializar (p. ej. 4 decimales) cuando el backend lo exija. |
| **Fechas/horas** | `java.time.Instant` en dominio y ViewModel. En bordes (JSON Supabase, logs) serializar a ISO-8601 (`Instant.toString()`). Activar **core library desugaring** si `minSdk` &lt; 26. |
| **Identificadores** | `String` (UUID como texto) en Fase 1 para velocidad de desarrollo. Más adelante se pueden introducir `@JvmInline value class` (p. ej. `ProductoId`, `TrasladoId`) sin cambiar el wire format. |

---

## Código Kotlin (dominio)

```kotlin
import java.math.BigDecimal
import java.time.Instant

// Dominio Inventario — Fase 1 · App Satélite
// (Modelo lógico para la app; no acoplado 1:1 a la BD)

data class ProductoResumen(
    val idProducto: String,            // public.productos.id_producto
    val sku: String?,
    val nombre: String,
    val activo: Boolean,
    val unidad: String?,               // unidad principal (venta) — ej. productos.um_venta
    val categoria: String?             // categoría/familia
)

data class Bodega(
    val id: String,
    val nombre: String,
    val codigo: String?
)

data class ZonaBodega(
    val id: String,
    val bodegaId: String,
    val nombre: String,
    val codigo: String?
)

/**
 * Vista compuesta para UI: puede armarse desde jerarquía real
 * (bodegas → zonasbodega → estanterias → filasestanteria → cubiculosfila)
 * o mostrar solo los niveles que existan en un contexto dado.
 */
data class UbicacionFisica(
    val bodega: Bodega,
    val zona: ZonaBodega?,
    val estanteria: String?,          // código o etiqueta UI; opcionalmente IDs en capa datos
    val fila: String?,
    val cubiculo: String?
)

enum class EstadoStockOperativo {
    DISPONIBLE,
    RESERVADO,
    EN_TRANSITO,
    BLOQUEADO,
    DANADO,
    EN_CUARENTENA
}

data class StockPorUbicacion(
    val producto: ProductoResumen,
    val ubicacion: UbicacionFisica,
    val cantidad: BigDecimal,
    val estado: EstadoStockOperativo
)

enum class EstadoTraslado {
    BORRADOR,
    ENVIADO,
    PENDIENTE_APROBACION,
    APROBADO,
    EJECUTADO,
    RECHAZADO,
    CANCELADO
}

data class LineaTrasladoUI(
    val producto: ProductoResumen,
    val cantidad: BigDecimal
)

data class TrasladoUI(
    val id: String,
    val origen: UbicacionFisica,
    val destino: UbicacionFisica,
    val estado: EstadoTraslado,
    val lineas: List<LineaTrasladoUI>,
    val creadoPor: String,
    val aprobadoPor: String?,
    val ejecutadoPor: String?,
    val creadoEn: Instant,
    val actualizadoEn: Instant?
)

enum class EstadoMisionConteo {
    CREADA,
    ASIGNADA,
    EN_EJECUCION,
    FINALIZADA,
    REVISADA
}

data class ItemConteo(
    val producto: ProductoResumen,
    val ubicacion: UbicacionFisica,
    val cantidadSistema: BigDecimal?,
    val cantidadContada: BigDecimal?,
    val diferencia: BigDecimal?
)

data class MisionConteoUI(
    val id: String,
    val estado: EstadoMisionConteo,
    val ubicacionObjetivo: UbicacionFisica?,
    val productosObjetivo: List<ProductoResumen>,
    val asignadosA: List<String>,      // user ids (auth / user_profiles.userid)
    val items: List<ItemConteo>,
    val creadaPor: String,
    val creadaEn: Instant,
    val revisadaPor: String?,
    val revisadaEn: Instant?
)
```

### Notas de mapeo (cuando exista capa datos)

- **`EstadoTraslado` / `EstadoMisionConteo`:** los valores reales en BD pueden ser `text` o enums Postgres; mantener una tabla de conversión bidireccional en el repositorio.
- **`EstadoStockOperativo`:** si `stockubicacion` aún no tiene columna de estado, usar `DISPONIBLE` por defecto en el mapper hasta que exista DDL.
- **`productos.activo`:** mapear desde `producto_inactivo` (invertido) o columna equivalente según contrato acordado con backend.

---

## Respuestas explícitas (para el siguiente paso: endpoints / RPC)

1. **Tipo numérico para cantidades:** **`BigDecimal`** en la app Fase 1.
2. **Fechas:** tipos nativos **`java.time.Instant`** en dominio/UI; ISO-8601 solo en el borde de red.
3. **IDs:** **`String`** en Fase 1; value objects opcionales en una iteración posterior.

El siguiente paso natural es listar **lecturas/escrituras** (PostgREST o RPC) que alimenten estos tipos y validarlos contra [INVENTARIO_MAPEO_BD.md](./INVENTARIO_MAPEO_BD.md).
