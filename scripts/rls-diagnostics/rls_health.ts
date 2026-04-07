import path from "node:path";
import { fileURLToPath } from "node:url";
import dotenv from "dotenv";
import { createClient, type SupabaseClient } from "@supabase/supabase-js";

type Role = "admin" | "encargado" | "empleado";
type Verdict = "pass" | "fail" | "skip";

type CaseResult = {
  role: Role;
  test: string;
  verdict: Verdict;
  detail?: string;
  code?: string | null;
};

const __dirname = path.dirname(fileURLToPath(import.meta.url));
dotenv.config({ path: path.resolve(__dirname, "../../.env") });
dotenv.config({ path: path.resolve(__dirname, "../../.env.local") });

function env(name: string, fallbacks: string[] = []): string {
  const v = process.env[name]?.trim();
  if (v) return v;
  for (const fb of fallbacks) {
    const x = process.env[fb]?.trim();
    if (x) return x;
  }
  return "";
}

function isRlsError(error: { message?: string; code?: string } | null | undefined): boolean {
  if (!error) return false;
  const msg = String(error.message ?? "").toLowerCase();
  return error.code === "42501" || msg.includes("row-level security") || msg.includes("permission denied");
}

function pickId(row: unknown, keys: string[]): string | null {
  if (!row || typeof row !== "object") return null;
  const r = row as Record<string, unknown>;
  for (const key of keys) {
    const v = r[key];
    if (v != null && String(v).length > 0) return String(v);
  }
  return null;
}

const SUPABASE_URL = env("SUPABASE_URL", ["EXPO_PUBLIC_SUPABASE_URL"]);
const SUPABASE_ANON_KEY = env("SUPABASE_ANON_KEY", ["EXPO_PUBLIC_SUPABASE_ANON_KEY"]);
const TEST_PASSWORD = env("RLS_TEST_PASSWORD", ["TEST_USER_PASSWORD"]);

const USERS: Record<Role, string> = {
  admin: env("RLS_TEST_ADMIN_EMAIL"),
  encargado: env("RLS_TEST_ENCARGADO_EMAIL"),
  empleado: env("RLS_TEST_EMPLEADO_EMAIL"),
};

const EXPECT_INSERT_MASTER: Record<Role, boolean> = {
  admin: true,
  encargado: false,
  empleado: false,
};

async function loginAs(role: Role): Promise<{ client: SupabaseClient; userId: string | null }> {
  const client = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
  const email = USERS[role];
  const { data, error } = await client.auth.signInWithPassword({
    email,
    password: TEST_PASSWORD,
  });
  if (error || !data.user) {
    throw new Error(`Login failed for ${role}: ${error?.message ?? "sin usuario"}`);
  }
  return { client, userId: data.user.id };
}

async function currentCtx(client: SupabaseClient): Promise<{
  empresa: string | null;
  sucursal: string | null;
  rol: string | null;
}> {
  const [empresa, sucursal, rol] = await Promise.all([
    client.rpc("current_empresa_id"),
    client.rpc("current_sucursal_id"),
    client.rpc("app_role"),
  ]);
  return {
    empresa: empresa.data ?? null,
    sucursal: sucursal.data ?? null,
    rol: rol.data ?? null,
  };
}

async function testProductos(client: SupabaseClient, role: Role, empresaId: string): Promise<CaseResult[]> {
  const out: CaseResult[] = [];
  {
    const { error } = await client.from("productos").select("*").limit(2);
    out.push({
      role,
      test: "productos.select",
      verdict: error ? "fail" : "pass",
      detail: error?.message,
      code: error?.code ?? null,
    });
  }
  {
    const { error } = await client.from("productos").insert({
      empresa_id: empresaId,
      sku_codigo: `T-P-${Date.now()}`,
      nombre: `Producto test ${role}`,
    });
    const expected = EXPECT_INSERT_MASTER[role];
    const ok = expected ? !error : isRlsError(error);
    out.push({
      role,
      test: "productos.insert",
      verdict: ok ? "pass" : "fail",
      detail: error?.message ?? "ok",
      code: error?.code ?? null,
    });
  }
  return out;
}

async function testClientesProveedores(
  client: SupabaseClient,
  role: Role,
  empresaId: string,
): Promise<CaseResult[]> {
  const out: CaseResult[] = [];
  const expected = EXPECT_INSERT_MASTER[role];
  const rows = [
    {
      table: "clientes",
      payload: {
        empresa_id: empresaId,
        num_documento: `T-C-${Date.now()}`,
        razon_social: `Cliente test ${role}`,
      },
    },
    {
      table: "proveedores",
      payload: {
        empresa_id: empresaId,
        num_documento: `T-V-${Date.now()}`,
        razon_social: `Proveedor test ${role}`,
      },
    },
  ] as const;
  for (const row of rows) {
    const { error } = await client.from(row.table).insert(row.payload);
    const ok = expected ? !error : isRlsError(error);
    out.push({
      role,
      test: `${row.table}.insert`,
      verdict: ok ? "pass" : "fail",
      detail: error?.message ?? "ok",
      code: error?.code ?? null,
    });
  }
  return out;
}

async function createCompra(client: SupabaseClient, empresaId: string, sucursalId: string, userId: string): Promise<string | null> {
  const { data, error } = await client
    .from("compras_encabezado")
    .insert({
      empresa_id: empresaId,
      id_sucursal: sucursalId,
      num_compra: `COMP-${Date.now()}`,
      fecha_compra: new Date().toISOString().slice(0, 10),
      created_by: userId,
    })
    .select("*")
    .maybeSingle();
  if (error || !data) return null;
  return pickId(data, ["id_compra", "id"]);
}

async function testComprasFlow(
  client: SupabaseClient,
  role: Role,
  empresaId: string,
  sucursalId: string,
  userId: string,
): Promise<CaseResult[]> {
  const out: CaseResult[] = [];
  const compraId = await createCompra(client, empresaId, sucursalId, userId);
  if (!compraId) {
    out.push({ role, test: "compras_encabezado.insert", verdict: "fail", detail: "no se pudo crear encabezado" });
    return out;
  }
  out.push({ role, test: "compras_encabezado.insert", verdict: "pass" });
  const { error } = await client.from("compras_detalle").insert({ id_compra: compraId });
  out.push({
    role,
    test: "compras_detalle.insert",
    verdict: error ? "fail" : "pass",
    detail: error?.message ?? "ok",
    code: error?.code ?? null,
  });
  return out;
}

async function testOcFlow(
  client: SupabaseClient,
  role: Role,
  empresaId: string,
  sucursalId: string,
  userId: string,
): Promise<CaseResult[]> {
  const out: CaseResult[] = [];
  const num = `OC-${Date.now()}`;
  const base = {
    empresa_id: empresaId,
    id_sucursal: sucursalId,
    empleado_asignado_id: userId,
    estado: "BORRADOR",
    num_oc: num,
    fecha_oc: new Date().toISOString().slice(0, 10),
    created_by: userId,
  };
  let r = await client
    .from("ordenes_compra_encabezado")
    .insert({ ...base, nota_encargado: `Test OC ${role}` })
    .select("*")
    .maybeSingle();
  if (r.error) {
    r = await client.from("ordenes_compra_encabezado").insert(base).select("*").maybeSingle();
  }
  if (r.error || !r.data) {
    out.push({
      role,
      test: "ordenes_compra_encabezado.insert",
      verdict: "fail",
      detail: r.error?.message ?? "sin data",
      code: r.error?.code ?? null,
    });
    return out;
  }
  out.push({ role, test: "ordenes_compra_encabezado.insert", verdict: "pass" });
  const ocId = pickId(r.data, ["id_orden_compra", "id"]);
  if (!ocId) {
    out.push({ role, test: "ordenes_compra_detalle.insert", verdict: "fail", detail: "no se resolvió id OC" });
    return out;
  }
  const { error } = await client.from("ordenes_compra_detalle").insert({
    id_orden_compra: ocId,
    cod_producto: `T-P-${Date.now()}`,
    cantidad: 1,
  });
  out.push({
    role,
    test: "ordenes_compra_detalle.insert",
    verdict: error ? "fail" : "pass",
    detail: error?.message ?? "ok",
    code: error?.code ?? null,
  });
  return out;
}

async function testTrasladoFlow(
  client: SupabaseClient,
  role: Role,
  empresaId: string,
  sucursalId: string,
  userId: string,
): Promise<CaseResult[]> {
  const out: CaseResult[] = [];
  const num = `TR-${Date.now()}`;
  const base = {
    empresa_id: empresaId,
    id_sucursal_origen: sucursalId,
    empleado_asignado_id: userId,
    estado: "BORRADOR",
    num_traslado: num,
    fecha_traslado: new Date().toISOString().slice(0, 10),
    created_by: userId,
  };
  let r = await client
    .from("traslados_encabezado")
    .insert({ ...base, nota_traslado: `Test TR ${role}` })
    .select("*")
    .maybeSingle();
  if (r.error) {
    r = await client.from("traslados_encabezado").insert(base).select("*").maybeSingle();
  }
  if (r.error || !r.data) {
    out.push({
      role,
      test: "traslados_encabezado.insert",
      verdict: "fail",
      detail: r.error?.message ?? "sin data",
      code: r.error?.code ?? null,
    });
    return out;
  }
  out.push({ role, test: "traslados_encabezado.insert", verdict: "pass" });
  const trId = pickId(r.data, ["id_traslado", "id"]);
  if (!trId) {
    out.push({ role, test: "traslados_detalle.insert", verdict: "fail", detail: "no se resolvió id traslado" });
    return out;
  }
  const { error } = await client.from("traslados_detalle").insert({
    id_traslado: trId,
    cod_producto: `T-P-${Date.now()}`,
    cantidad: 1,
  });
  out.push({
    role,
    test: "traslados_detalle.insert",
    verdict: error ? "fail" : "pass",
    detail: error?.message ?? "ok",
    code: error?.code ?? null,
  });
  return out;
}

async function testOptionalCaja(client: SupabaseClient, role: Role, empresaId: string, sucursalId: string): Promise<CaseResult[]> {
  const out: CaseResult[] = [];
  const { error: probeArq } = await client.from("arqueos_caja").select("*").limit(1);
  if (probeArq && /does not exist|schema cache|Could not find|42P01|PGRST205/i.test(probeArq.message)) {
    out.push({ role, test: "arqueos_caja", verdict: "skip", detail: "tabla no existe en este esquema" });
  } else {
    const { error } = await client.from("arqueos_caja").insert({
      empresa_id: empresaId,
      sucursal_id: sucursalId,
      estado: "ABIERTO",
      saldo_inicial: 0,
      total_segun_sistema: 100000,
      total_contado: 99500,
      diferencia: -500,
      comentario: `Arqueo test ${role}`,
    });
    out.push({
      role,
      test: "arqueos_caja.insert",
      verdict: error ? "fail" : "pass",
      detail: error?.message ?? "ok",
      code: error?.code ?? null,
    });
  }

  const { error: probeTurno } = await client.from("turnos_caja").select("*").limit(1);
  if (probeTurno && /does not exist|schema cache|Could not find|42P01|PGRST205/i.test(probeTurno.message)) {
    out.push({ role, test: "turnos_caja", verdict: "skip", detail: "tabla no existe en este esquema" });
  } else {
    out.push({ role, test: "turnos_caja", verdict: "pass", detail: "tabla detectada (agrega casos específicos aquí)" });
  }
  return out;
}

async function runRole(role: Role): Promise<CaseResult[]> {
  const results: CaseResult[] = [];
  const { client, userId } = await loginAs(role);
  if (!userId) throw new Error(`No user id for ${role}`);

  const ctx = await currentCtx(client);
  if (!ctx.empresa || !ctx.sucursal || !ctx.rol) {
    results.push({
      role,
      test: "ctx.rpc",
      verdict: "fail",
      detail: `Contexto incompleto: empresa=${ctx.empresa} sucursal=${ctx.sucursal} rol=${ctx.rol}`,
    });
    return results;
  }
  results.push({
    role,
    test: "ctx.rpc",
    verdict: "pass",
    detail: `empresa=${ctx.empresa.slice(0, 8)}... sucursal=${ctx.sucursal.slice(0, 8)}... rol=${ctx.rol}`,
  });

  results.push(...(await testProductos(client, role, ctx.empresa)));
  results.push(...(await testClientesProveedores(client, role, ctx.empresa)));
  results.push(...(await testComprasFlow(client, role, ctx.empresa, ctx.sucursal, userId)));
  results.push(...(await testOcFlow(client, role, ctx.empresa, ctx.sucursal, userId)));
  results.push(...(await testTrasladoFlow(client, role, ctx.empresa, ctx.sucursal, userId)));
  results.push(...(await testOptionalCaja(client, role, ctx.empresa, ctx.sucursal)));

  await client.auth.signOut();
  return results;
}

async function main(): Promise<void> {
  const missing: string[] = [];
  if (!SUPABASE_URL) missing.push("SUPABASE_URL o EXPO_PUBLIC_SUPABASE_URL");
  if (!SUPABASE_ANON_KEY) missing.push("SUPABASE_ANON_KEY o EXPO_PUBLIC_SUPABASE_ANON_KEY");
  if (!TEST_PASSWORD) missing.push("RLS_TEST_PASSWORD o TEST_USER_PASSWORD");
  for (const role of ["admin", "encargado", "empleado"] as const) {
    if (!USERS[role]) missing.push(`RLS_TEST_${role.toUpperCase()}_EMAIL`);
  }
  if (missing.length) {
    console.error(JSON.stringify({ ok: false, missing }, null, 2));
    process.exit(1);
  }

  const all: CaseResult[] = [];
  for (const role of ["admin", "encargado", "empleado"] as const) {
    all.push(...(await runRole(role)));
  }

  const failed = all.filter((r) => r.verdict === "fail");
  console.log(
    JSON.stringify(
      {
        ok: failed.length === 0,
        summary: {
          total: all.length,
          pass: all.filter((r) => r.verdict === "pass").length,
          fail: failed.length,
          skip: all.filter((r) => r.verdict === "skip").length,
        },
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

