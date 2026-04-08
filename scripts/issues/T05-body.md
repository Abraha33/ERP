Crear el módulo Android base en `apps/android/` (Kotlin, Jetpack Compose, Gradle). Verificar que compile e instale en emulador o dispositivo. Estructura mínima de paquetes (`ui`, `data`, `domain` o equivalente acordado en el ticket). Sin pantallas de negocio todavía: solo app shell o pantalla vacía que arranque.

## Definition of Done
- [ ] Proyecto Gradle en `apps/android/` (minSdk / compileSdk acordados)
- [ ] `./gradlew installDebug` (o tarea equivalente) en emulador Android
- [ ] Estructura de carpetas/paquetes documentada en el PR
- [ ] ktlint o convención de formato acordada (si aplica)
- [ ] `.env.example` en raíz del monorepo con `SUPABASE_URL` y `SUPABASE_ANON_KEY` (placeholders), alineado con ADR-001
