/**
 * Diagnóstico con SERVICE ROLE (solo proyecto dev): lee tablas sin RLS y lista usuarios Auth.
 *
 * Requisitos en la raíz del repo: archivo .env (NO commiteado; ya está en .gitignore):
 *   SUPABASE_URL (o EXPO_PUBLIC_SUPABASE_URL)
 *   SUPABASE_SERVICE_ROLE_KEY (o SUPABASE_SERVICE_KEY / SERVICE_ROLE_KEY)
 *
 * Opcional (comparar anon vs service):
 *   SUPABASE_ANON_KEY o EXPO_PUBLIC_SUPABASE_ANON_KEY
 *   RLS_TEST_ADMIN_EMAIL + RLS_TEST_PASSWORD
 *
 * Ejecutar desde esta carpeta:
 *   npm install
 *   npm run live
 *
 * Nunca subas la service role key al repo ni la pegues en el chat.
 */

import path from "node:path";
import { fileURLToPath } from "node:url";
import { createClient, type SupabaseClient } from "@supabase/supabase-js";
import dotenv from "dotenv";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
/** Raíz del monorepo (carpeta que contiene `scripts/`). */
const repoRoot = path.resolve(__dirname, "../..");
dotenv.config({ path: path.join(repoRoot, ".env") });
dotenv.config({ path: path.join(repoRoot, ".env.local") });

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
const serviceKey = env("SUPABASE_SERVICE_ROLE_KEY", [
  "SUPABASE_SERVICE_KEY",
  "SERVICE_ROLE_KEY",
]);
const anonKey = env("SUPABASE_ANON_KEY", ["EXPO_PUBLIC_SUPABASE_ANON_KEY"]);
const adminEmail = env("RLS_TEST_ADMIN_EMAIL");
const testPassword = env("RLS_TEST_PASSWORD");

type Check = { name: string; ok: boolean; detail?: string; data?: unknown };

/** Quita comillas, saltos de línea y prefijo Bearer que suelen romper el JWT en .env */
function normalizeServiceKey(raw: string): string {
  let s = raw.trim();
  s = s.replace(/\r\n/g, "").replace(/\n/g, "").replace(/\r/g, "");
  if (
    (s.startsWith('"') && s.endsWith('"')) ||
    (s.startsWith("'") && s.endsWith("'"))
  ) {
    s = s.slice(1, -1).trim();
  }
  if (s.toLowerCase().startsWith("bearer ")) {
    s = s.slice(7).trim();
  }
  return s;
}

/** El payload JWT de Supabase incluye `role`: `service_role` | `anon` | … */
function jwtPayloadRole(jwt: string): string | null {
  try {
    const parts = jwt.split(".");
    if (parts.length < 2) return null;
    let b64 = parts[1].replace(/-/g, "+").replace(/_/g, "/");
    while (b64.length % 4 !== 0) {
      b64 += "=";
    }
    const json = Buffer.from(b64, "base64").toString("utf8");
    const p = JSON.parse(json) as { role?: string };
    return typeof p.role === "string" ? p.role : null;
  } catch {
    return null;
  }
}

/** Políticas admin del borrador: hace falta al menos un perfil con empresa+sucursal+admin; el resto es informativo. */
function userProfilesReadinessCheck(sample: unknown[] | undefined): Check | null {
  if (!Array.isArray(sample) || sample.length === 0) return null;

  function rowHasEmpresa(r: Record<string, unknown>): boolean {
    return r.empresa_id != null && String(r.empresa_id).trim() !== "";
  }
  function rowHasSucursal(r: Record<string, unknown>): boolean {
    return r.sucursal_id != null && String(r.sucursal_id).trim() !== "";
  }
  function rowIsAdmin(r: Record<string, unknown>): boolean {
    const rp = String(r.rol_principal ?? r.app_role ?? "").toLowerCase();
    return rp === "admin";
  }

  let anyNullEmpresa = false;
  let anyNullSucursal = false;
  let adminReadyCount = 0;
  const nonAdminUserIds: string[] = [];

  for (const row of sample) {
    const r = row as Record<string, unknown>;
    if (!rowHasEmpresa(r)) anyNullEmpresa = true;
    if (!rowHasSucursal(r)) anyNullSucursal = true;
    if (rowHasEmpresa(r) && rowHasSucursal(r) && rowIsAdmin(r)) {
      adminReadyCount += 1;
    }
    const rp = String(r.rol_principal ?? r.app_role ?? "").toLowerCase();
    if (rp.length > 0 && rp !== "admin" && r.user_id != null) {
      nonAdminUserIds.push(String(r.user_id));
    }
  }

  const warnings: string[] = [];
  if (anyNullEmpresa) {
    warnings.push(
      "Alguna fila tiene empresa_id NULL: ese usuario seguirá sin poder insertar maestros hasta rellenar tenant.",
    );
  }
  if (anyNullSucursal) {
    warnings.push(
      "Alguna fila tiene sucursal_id NULL: revisa compras/OC/traslados para esa cuenta.",
    );
  }

  const noteParts: string[] = [];
  if (adminReadyCount > 0) {
    noteParts.push(
      `${adminReadyCount} perfil(es) listo(s) para inserts tipo admin (empresa + sucursal + rol admin).`,
    );
  }
  if (nonAdminUserIds.length > 0) {
    noteParts.push(
      "Hay cuenta(s) empleado/encargado: con esa sesión los inserts de productos/clientes fallan por RLS. Entra con un usuario cuyo user_profiles.rol_principal sea admin o actualiza el rol en SQL.",
    );
  }

  if (adminReadyCount === 0) {
    return {
      name: "user_profiles_rls_readiness",
      ok: false,
      detail:
        "Ningún perfil cumple admin + empresa_id + sucursal_id: nadie pasa las políticas de insert en maestros.",
      data: {
        adminReadyCount,
        fixSqlTemplate:
          "UPDATE public.user_profiles SET empresa_id = '…uuid…'::uuid, sucursal_id = '…uuid…'::uuid, rol_principal = 'admin' WHERE user_id = '…auth.users.id…'::uuid;",
      },
    };
  }

  return {
    name: "user_profiles_rls_readiness",
    ok: true,
    data: {
      note: noteParts.join(" ") || "Perfiles coherentes con el borrador de políticas.",
      adminReadyCount,
      ...(warnings.length ? { warnings } : {}),
    },
  };
}

async function safeSelect(
  admin: SupabaseClient,
  table: string,
  columns: string,
  limit = 5,
): Promise<Check> {
  const { data, error } = await admin.from(table).select(columns).limit(limit);
  if (error) {
    return {
      name: `${table}_select`,
      ok: false,
      detail: error.message,
      data: { code: error.code },
    };
  }
  return {
    name: `${table}_select`,
    ok: true,
    data: { rows: data?.length ?? 0, sample: data },
  };
}

async function anonProductosProbe(): Promise<Check | null> {
  if (!anonKey || !adminEmail || !testPassword) {
    return {
      name: "anon_productos_probe",
      ok: true,
      detail:
        "Omitido: define SUPABASE_ANON_KEY (o EXPO_PUBLIC_*), RLS_TEST_ADMIN_EMAIL y RLS_TEST_PASSWORD para comparar RLS con anon.",
    };
  }
  const anon = createClient(supabaseUrl, anonKey);
  const { data: signData, error: signErr } = await anon.auth.signInWithPassword({
    email: adminEmail,
    password: testPassword,
  });
  if (signErr || !signData.user) {
    return {
      name: "anon_productos_probe",
      ok: false,
      detail: signErr?.message ?? "Sin usuario",
    };
  }
  const { data, error } = await anon.from("productos").select("id, empresa_id").limit(3);
  await anon.auth.signOut();
  if (error) {
    return {
      name: "anon_productos_probe",
      ok: false,
      detail: error.message,
      data: { code: error.code, hint: "Con anon + sesión admin; si falla, RLS o perfil no alineado." },
    };
  }
  return {
    name: "anon_productos_probe",
    ok: true,
    data: { rows: data?.length ?? 0, sample: data },
  };
}

async function main(): Promise<void> {
  const missing: string[] = [];
  if (!supabaseUrl) missing.push("SUPABASE_URL o EXPO_PUBLIC_SUPABASE_URL");
  if (!serviceKey) missing.push("SUPABASE_SERVICE_ROLE_KEY");

  if (missing.length) {
    console.error(
      JSON.stringify(
        {
          ok: false,
          missing,
          envFileExpected: path.join(repoRoot, ".env"),
          hint: "Añade SUPABASE_SERVICE_ROLE_KEY en ese archivo (no en apps/mobile/.env). Supabase Dashboard → Project Settings → API → service_role (secreto, empieza por eyJ…).",
        },
        null,
        2,
      ),
    );
    process.exit(1);
  }

  const normalizedKey = normalizeServiceKey(serviceKey);
  if (normalizedKey.length < 20) {
    console.error(JSON.stringify({ ok: false, error: "SUPABASE_SERVICE_ROLE_KEY parece inválida (demasiado corta)." }, null, 2));
    process.exit(1);
  }

  const segments = normalizedKey.split(".");
  if (segments.length !== 3) {
    console.error(
      JSON.stringify(
        {
          ok: false,
          error: "SUPABASE_SERVICE_ROLE_KEY no es un JWT válido (debe tener exactamente 3 partes separadas por un punto).",
          segmentsFound: segments.length,
          hint:
            "Pega la clave en una sola línea en .env, sin cortes ni espacios en medio. Ej: SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIj... (Project Settings → API → service_role).",
          envFileExpected: path.join(repoRoot, ".env"),
        },
        null,
        2,
      ),
    );
    process.exit(1);
  }

  const keyRole = jwtPayloadRole(normalizedKey);
  if (keyRole === "anon") {
    console.error(
      JSON.stringify(
        {
          ok: false,
          jwtRoleInKey: "anon",
          hint:
            "Has puesto la clave «anon» (public) en SUPABASE_SERVICE_ROLE_KEY. Debe ser la clave «service_role» (secret) del mismo pantallazo API.",
          envFileExpected: path.join(repoRoot, ".env"),
        },
        null,
        2,
      ),
    );
    process.exit(1);
  }

  const admin = createClient(supabaseUrl, normalizedKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  });

  const checks: Check[] = [];

  checks.push({
    name: "jwt_key_inspect",
    ok: true,
    data: {
      jwtRole: keyRole ?? "(no detectado en payload; la clave puede ser válida igualmente)",
      segmentCount: segments.length,
      keyLength: normalizedKey.length,
      hint:
        keyRole == null
          ? "Si listUsers da «User not allowed», la clave suele ser anon o un token corrupto."
          : keyRole === "service_role"
            ? "JWT reconocido como service_role."
            : undefined,
    },
  });

  const { data: usersData, error: usersErr } = await admin.auth.admin.listUsers({
    page: 1,
    perPage: 8,
  });
  checks.push({
    name: "auth_admin_listUsers",
    ok: !usersErr,
    detail: usersErr?.message,
    data: usersErr
      ? undefined
      : {
          count: usersData.users.length,
          emails: usersData.users.map((u) => u.email).filter(Boolean),
        },
  });

  const upCheck = await safeSelect(admin, "user_profiles", "*", 8);
  checks.push(upCheck);
  if (upCheck.ok && upCheck.data && typeof upCheck.data === "object" && "sample" in upCheck.data) {
    const readiness = userProfilesReadinessCheck(
      (upCheck.data as { sample: unknown[] }).sample,
    );
    if (readiness) checks.push(readiness);
  }
  {
    const p = await safeSelect(admin, "profiles", "*", 3);
    if (
      !p.ok &&
      /does not exist|Could not find|schema cache|42P01|PGRST205/i.test(p.detail ?? "")
    ) {
      checks.push({
        name: "profiles_select",
        ok: true,
        detail: "Tabla public.profiles no existe en este proyecto (normal si solo usas user_profiles).",
      });
    } else {
      checks.push(p);
    }
  }
  checks.push(
    await (async (): Promise<Check> => {
      const { count, error } = await admin
        .from("productos")
        .select("*", { count: "exact", head: true });
      if (error) {
        return { name: "productos_count", ok: false, detail: error.message };
      }
      return { name: "productos_count", ok: true, data: { count } };
    })(),
  );

  const anonCheck = await anonProductosProbe();
  if (anonCheck) checks.push(anonCheck);

  /** listUsers puede fallar por causas raras; el resto del informe sigue siendo útil. */
  const failed = checks.filter((c) => !c.ok && c.name !== "auth_admin_listUsers");
  const softFailed = checks.filter((c) => !c.ok && c.name === "auth_admin_listUsers");
  const out = {
    ok: failed.length === 0,
    jwtRole: keyRole,
    note:
      "Lecturas con service_role ignoran RLS. Si user_profiles tiene filas aquí pero la app (anon) no ve nada, revisa RLS en user_profiles. Si anon_productos_probe falla con sesión admin, revisa current_empresa_id / app_role o políticas.",
    checks,
    ...(softFailed.length
      ? {
          warnings: softFailed.map((c) => ({
            name: c.name,
            detail: c.detail,
            hint: "Si la clave es service_role y esto persiste, revisa URL del proyecto o estado del proyecto en Supabase.",
          })),
        }
      : {}),
  };

  console.log(JSON.stringify(out, null, 2));
  if (failed.length) process.exit(1);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
