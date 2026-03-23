/**
 * Health check de RLS contra Supabase (anon key + signInWithPassword por rol).
 *
 * Requisitos en Supabase:
 * - Usuarios en Auth con los emails de prueba.
 * - Filas en public.profiles (id = auth.uid()) con empresa_id, sucursal_id, app_role.
 *
 * Uso (desde esta carpeta):
 *   npm install
 *   npm run diag
 *
 * Variables: ver .env en la raíz del repo (RLS_TEST_* y URL/anon key).
 */

import path from "node:path";
import { fileURLToPath } from "node:url";
import { createClient, type SupabaseClient } from "@supabase/supabase-js";
import dotenv from "dotenv";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
dotenv.config({ path: path.resolve(__dirname, "../../.env") });

type Role = "admin" | "encargado" | "empleado";

type DiagResult = {
  role: Role;
  test: string;
  ok: boolean;
  data?: unknown;
  error?: string;
  code?: string;
  hint?: string;
};

function env(name: string, fallbacks: string[] = []): string {
  const v = process.env[name]?.trim();
  if (v) return v;
  for (const f of fallbacks) {
    const x = process.env[f]?.trim();
    if (x) return x;
  }
  return "";
}

const supabaseUrl = env("SUPABASE_URL", ["EXPO_PUBLIC_SUPABASE_URL"]);
const supabaseAnonKey = env("SUPABASE_ANON_KEY", ["EXPO_PUBLIC_SUPABASE_ANON_KEY"]);

const ADMIN_EMAIL = env("RLS_TEST_ADMIN_EMAIL");
const ENCARGADO_EMAIL = env("RLS_TEST_ENCARGADO_EMAIL");
const EMPLEADO_EMAIL = env("RLS_TEST_EMPLEADO_EMAIL");
const TEST_PASSWORD = env("RLS_TEST_PASSWORD");

const TEST_EMPRESA_ID = env("RLS_TEST_EMPRESA_ID");
const TEST_SUCURSAL_ID = env("RLS_TEST_SUCURSAL_ID");

function emailForRole(role: Role): string {
  if (role === "admin") return ADMIN_EMAIL;
  if (role === "encargado") return ENCARGADO_EMAIL;
  return EMPLEADO_EMAIL;
}

async function loginAs(role: Role): Promise<{
  supabase: SupabaseClient;
  authError: Error | null;
  userId: string | null;
}> {
  const supabase = createClient(supabaseUrl, supabaseAnonKey);
  const email = emailForRole(role);
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password: TEST_PASSWORD,
  });
  const authError = error ?? null;
  const userId = data.user?.id ?? null;
  return { supabase, authError, userId };
}

async function signOut(supabase: SupabaseClient): Promise<void> {
  await supabase.auth.signOut();
}

function row(
  role: Role,
  test: string,
  ok: boolean,
  extra: Partial<DiagResult> = {},
): DiagResult {
  return { role, test, ok, ...extra };
}

/** Tablas del borrador: PK es `id`, no id_producto / id_orden_compra en columnas de tabla. */
async function testProductosSelect(
  supabase: SupabaseClient,
  role: Role,
): Promise<DiagResult> {
  const { data, error } = await supabase
    .from("productos")
    .select("id, empresa_id")
    .limit(3);

  if (error) {
    return row(role, "productos_select", false, {
      error: error.message,
      code: error.code,
      hint:
        "Revisa RLS en productos y que profiles tenga empresa_id alineada a las filas.",
    });
  }
  return row(role, "productos_select", true, { data });
}

/** Empleado no debe ver compras reales (política: sin acceso). */
async function testComprasEncabezadoSelect(
  supabase: SupabaseClient,
  role: Role,
): Promise<DiagResult> {
  const { data, error } = await supabase
    .from("compras_encabezado")
    .select("id, empresa_id, id_sucursal")
    .limit(3);

  if (error) {
    const rls =
      error.message.toLowerCase().includes("permission") ||
      error.message.toLowerCase().includes("rls") ||
      error.code === "42501";
    if (role === "empleado" && rls) {
      return row(role, "compras_encabezado_select_denied_empleado", true, {
        data: { note: "Error esperado por RLS para empleado", message: error.message },
      });
    }
    return row(role, "compras_encabezado_select", false, {
      error: error.message,
      code: error.code,
    });
  }

  if (role === "empleado" && (data?.length ?? 0) === 0) {
    return row(role, "compras_encabezado_select_empty_empleado", true, {
      data: { rows: 0, note: "Sin filas (esperado si RLS bloquea todo)" },
    });
  }

  return row(role, "compras_encabezado_select", true, { data });
}

async function testOrdenCompraInsertEmpleado(
  supabase: SupabaseClient,
  role: Role,
  userId: string,
): Promise<DiagResult> {
  if (role !== "empleado") {
    return row(role, "ordenes_compra_insert_empleado_skip", true, {
      hint: "Solo aplica con sesión empleado",
    });
  }

  if (!TEST_EMPRESA_ID || !TEST_SUCURSAL_ID) {
    return row(role, "ordenes_compra_insert_empleado", false, {
      error: "Faltan RLS_TEST_EMPRESA_ID o RLS_TEST_SUCURSAL_ID en .env",
    });
  }

  const { data, error } = await supabase
    .from("ordenes_compra_encabezado")
    .insert({
      empresa_id: TEST_EMPRESA_ID,
      id_sucursal: TEST_SUCURSAL_ID,
      empleado_asignado_id: userId,
      estado: "BORRADOR",
    })
    .select("id, estado")
    .maybeSingle();

  if (error) {
    return row(role, "ordenes_compra_insert_empleado", false, {
      error: error.message,
      code: error.code,
      hint:
        "Comprueba profiles (empresa_id, sucursal_id, app_role=empleado) y políticas OC.",
    });
  }
  return row(role, "ordenes_compra_insert_empleado", true, { data });
}

async function testOrdenCompraSelect(
  supabase: SupabaseClient,
  role: Role,
): Promise<DiagResult> {
  const { data, error } = await supabase
    .from("ordenes_compra_encabezado")
    .select("id, estado, empresa_id, id_sucursal")
    .limit(5);

  if (error) {
    return row(role, `ordenes_compra_select_${role}`, false, {
      error: error.message,
      code: error.code,
    });
  }
  return row(role, `ordenes_compra_select_${role}`, true, { data });
}

async function testTrasladoInsertEmpleado(
  supabase: SupabaseClient,
  role: Role,
  userId: string,
): Promise<DiagResult> {
  if (role !== "empleado") {
    return row(role, "traslados_insert_empleado_skip", true, {
      hint: "Solo aplica con sesión empleado",
    });
  }

  if (!TEST_EMPRESA_ID || !TEST_SUCURSAL_ID) {
    return row(role, "traslados_insert_empleado", false, {
      error: "Faltan RLS_TEST_EMPRESA_ID o RLS_TEST_SUCURSAL_ID en .env",
    });
  }

  const { data, error } = await supabase
    .from("traslados_encabezado")
    .insert({
      empresa_id: TEST_EMPRESA_ID,
      id_sucursal_origen: TEST_SUCURSAL_ID,
      empleado_asignado_id: userId,
      estado: "BORRADOR",
    })
    .select("id, estado")
    .maybeSingle();

  if (error) {
    return row(role, "traslados_insert_empleado", false, {
      error: error.message,
      code: error.code,
      hint:
        "Comprueba id_sucursal_origen = sucursal del profile y empleado_asignado_id = auth.uid().",
    });
  }
  return row(role, "traslados_insert_empleado", true, { data });
}

async function testTrasladoSelectEncargado(
  supabase: SupabaseClient,
  role: Role,
): Promise<DiagResult> {
  if (role !== "encargado") {
    return row(role, "traslados_select_encargado_skip", true);
  }

  const { data, error } = await supabase
    .from("traslados_encabezado")
    .select("id, estado, id_sucursal_origen")
    .limit(5);

  if (error) {
    return row(role, "traslados_select_encargado", false, {
      error: error.message,
      code: error.code,
    });
  }
  return row(role, "traslados_select_encargado", true, { data });
}

/** Placeholder: la migración actual no define turnos_caja. */
function testTurnosCajaPlaceholder(role: Role): DiagResult {
  return row(role, "turnos_caja_skip", true, {
    hint:
      "Tabla turnos_caja no existe en supabase/migrations aún; añade migración y este test.",
  });
}

async function runForRole(role: Role): Promise<DiagResult[]> {
  const results: DiagResult[] = [];
  const { supabase, authError, userId } = await loginAs(role);

  if (authError || !userId) {
    results.push(
      row(role, "auth_sign_in", false, {
        error: authError?.message ?? "No user id",
        hint: `Email configurado: ${emailForRole(role) || "(vacío)"}`,
      }),
    );
    return results;
  }

  results.push(row(role, "auth_sign_in", true, { data: { userId } }));

  try {
    results.push(await testProductosSelect(supabase, role));
    results.push(await testComprasEncabezadoSelect(supabase, role));
    results.push(await testOrdenCompraInsertEmpleado(supabase, role, userId));
    results.push(await testOrdenCompraSelect(supabase, role));
    results.push(await testTrasladoInsertEmpleado(supabase, role, userId));
    results.push(await testTrasladoSelectEncargado(supabase, role));
    results.push(testTurnosCajaPlaceholder(role));
  } finally {
    await signOut(supabase);
  }

  return results;
}

async function main(): Promise<void> {
  const missing: string[] = [];
  if (!supabaseUrl) missing.push("SUPABASE_URL o EXPO_PUBLIC_SUPABASE_URL");
  if (!supabaseAnonKey) missing.push("SUPABASE_ANON_KEY o EXPO_PUBLIC_SUPABASE_ANON_KEY");
  if (!ADMIN_EMAIL) missing.push("RLS_TEST_ADMIN_EMAIL");
  if (!ENCARGADO_EMAIL) missing.push("RLS_TEST_ENCARGADO_EMAIL");
  if (!EMPLEADO_EMAIL) missing.push("RLS_TEST_EMPLEADO_EMAIL");
  if (!TEST_PASSWORD) missing.push("RLS_TEST_PASSWORD");

  if (missing.length) {
    console.error(JSON.stringify({ ok: false, missing }, null, 2));
    process.exit(1);
  }

  const roles: Role[] = ["admin", "encargado", "empleado"];
  const all: DiagResult[] = [];

  for (const role of roles) {
    all.push(...(await runForRole(role)));
  }

  const failed = all.filter((r) => !r.ok);
  console.log(
    JSON.stringify(
      {
        ok: failed.length === 0,
        summary: { total: all.length, failed: failed.length },
        results: all,
      },
      null,
      2,
    ),
  );

  if (failed.length) process.exit(1);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
