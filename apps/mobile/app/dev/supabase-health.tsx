/**
 * Pantalla solo para desarrollo: prueba conexión a Supabase y SELECT mínimos
 * (útil para ver errores RLS / PostgREST en dispositivo o web local).
 *
 * En builds de producción __DEV__ es false: no se muestra el contenido útil.
 */
import { useCallback, useEffect, useRef, useState } from 'react';
import {
  ActivityIndicator,
  Platform,
  Pressable,
  ScrollView,
  StyleSheet,
  TextInput,
} from 'react-native';
import { useRouter } from 'expo-router';

import { Text, View } from '@/components/Themed';
import { randomUuid } from '@/lib/randomUuid';
import { getSupabaseClient, getSupabaseEnvSummary } from '@/lib/supabase';

type Probe = { table: string; ok: boolean; detail: string };

type RlsContext = {
  empresa_id: string;
  sucursal_id: string | null;
  /** Valor mostrado como «rol»: viene de `rol_principal` o, si no existe, de `app_role` en BD. */
  app_role: string | null;
  source: 'user_profiles' | 'manual';
};

function mapUserProfileRole(row: Record<string, unknown> | null | undefined): string | null {
  if (!row) return null;
  const rp = row.rol_principal;
  if (rp != null && String(rp).length > 0) return String(rp);
  const ar = row.app_role;
  if (ar != null && String(ar).length > 0) return String(ar);
  return null;
}

const UUID_LIKE = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

function isLikelyUuid(s: string): boolean {
  return UUID_LIKE.test(s.trim());
}

function makeAutoStamp(prefix: string): string {
  const rand = Math.random().toString(36).slice(2, 6).toUpperCase();
  return `${prefix}-${Date.now()}-${rand}`;
}

function makeAutoDocNumber(prefix: string): string {
  const ts = Date.now().toString().slice(-8);
  const rand = Math.random().toString(36).slice(2, 6).toUpperCase();
  return `${prefix}-${ts}-${rand}`;
}

function todayIsoDate(): string {
  return new Date().toISOString().slice(0, 10);
}

function formatUserProfilesRlsHint(
  op: 'insert' | 'update',
  err: { message: string; code?: string },
): string {
  const { message, code } = err;
  const verb = op === 'insert' ? 'crear' : 'actualizar';
  const head = op === 'insert' ? 'Crear perfil' : 'Actualizar perfil';
  const rls =
    code === '42501' || /row-level security|permission denied for table/i.test(message);
  if (!rls) {
    return `${head}: ${message}`;
  }
  return (
    `${head}: ${message}\n\n` +
    `RLS en public.user_profiles está bloqueando que el cliente ${verb} tu fila. ` +
    `Copia y pega en SQL Editor el archivo docs/sql/user_profiles_rls_dev_policies.sql ` +
    `(si usas user_id en vez de id: user_profiles_rls_dev_policies_user_id.sql; si tabla profiles: profiles_rls_dev_policies.sql). ` +
    `O inserta/edita la fila con service role y luego «Cargar contexto». ` +
    `Sin fila en BD, las funciones tipo current_empresa_id() suelen devolver null y los inserts de negocio fallan aunque uses contexto manual en la app.`
  );
}

function isRlsViolation(err: { message?: string; code?: string } | null | undefined): boolean {
  if (!err) return false;
  const msg = String(err.message ?? '').toLowerCase();
  return err.code === '42501' || msg.includes('row-level security');
}

function pickRowKey(row: unknown, keys: string[]): string | null {
  if (!row || typeof row !== 'object') return null;
  const r = row as Record<string, unknown>;
  for (const key of keys) {
    const v = r[key];
    if (v != null && String(v).length > 0) return String(v);
  }
  return null;
}

async function insertWithVariants(
  client: NonNullable<ReturnType<typeof getSupabaseClient>>,
  table: string,
  variants: Record<string, unknown>[],
): Promise<{ error: { message: string; code?: string } | null }> {
  let lastError: { message: string; code?: string } | null = null;
  for (const payload of variants) {
    const r = await client.from(table).insert(payload);
    if (!r.error) return { error: null };
    lastError = r.error;
    if (!postgrestColumnMissing(r.error, 'created_by') &&
        !postgrestColumnMissing(r.error, 'empresa_id') &&
        !postgrestColumnMissing(r.error, 'id_sucursal') &&
        !postgrestColumnMissing(r.error, 'id_sucursal_origen')) {
      return { error: r.error };
    }
  }
  return { error: lastError };
}

/** PostgREST: columna ausente en caché (PGRST204 / «Could not find … in the schema cache»). */
function postgrestColumnMissing(err: { message: string; code?: string } | null | undefined, column: string): boolean {
  if (!err?.message) return false;
  const m = err.message.toLowerCase();
  const c = column.toLowerCase();
  return (
    m.includes(c) &&
    (m.includes('schema cache') || m.includes('could not find') || String(err.code) === 'PGRST204')
  );
}

function formatAuthError(message: string): string {
  if (/invalid login credentials|invalid email or password/i.test(message)) {
    return `${message} · Si el usuario existe en Auth: confirma el email (enlace de Supabase), o define contraseña (invitación / reset). «Usuario no reconocido» suele ser contraseña incorrecta o email sin confirmar.`;
  }
  if (/email not confirmed/i.test(message)) {
    return `${message} · Abre el correo de confirmación o, solo en dev, desactiva «Confirm email» en Authentication → Providers → Email.`;
  }
  return message;
}

/** `*` evita errores si el esquema remoto no usa columna `id`. */
const TABLES: { table: string; select: string }[] = [
  { table: 'user_profiles', select: '*' },
  { table: 'productos', select: '*' },
  { table: 'compras_encabezado', select: '*' },
  { table: 'compras_detalle', select: '*' },
  { table: 'ordenes_compra_encabezado', select: '*' },
  { table: 'ordenes_compra_detalle', select: '*' },
  { table: 'traslados_encabezado', select: '*' },
  { table: 'traslados_detalle', select: '*' },
  { table: 'clientes', select: '*' },
  { table: 'proveedores', select: '*' },
];

export default function SupabaseHealthScreen() {
  const router = useRouter();
  const env = getSupabaseEnvSummary();

  const [probes, setProbes] = useState<Probe[] | null>(null);
  const [loading, setLoading] = useState(false);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [authMsg, setAuthMsg] = useState<string | null>(null);
  const [userLabel, setUserLabel] = useState<string | null>(null);
  const [sessionBusy, setSessionBusy] = useState(false);

  const [rlsCtx, setRlsCtx] = useState<RlsContext | null>(null);
  const [ctxMsg, setCtxMsg] = useState<string | null>(null);
  const [ctxBusy, setCtxBusy] = useState(false);
  const [manualEmpresaId, setManualEmpresaId] = useState('');
  const [manualSucursalId, setManualSucursalId] = useState('');

  const [prodSku, setProdSku] = useState('');
  const [prodNombre, setProdNombre] = useState('');
  const [cliDoc, setCliDoc] = useState('');
  const [cliRazon, setCliRazon] = useState('');
  const [provDoc, setProvDoc] = useState('');
  const [provRazon, setProvRazon] = useState('');
  const [ocNota, setOcNota] = useState('OC manual dev');
  const [ocLineCod, setOcLineCod] = useState('');
  const [ocLineQty, setOcLineQty] = useState('1');
  const [trNota, setTrNota] = useState('Traslado manual dev');
  const [trLineCod, setTrLineCod] = useState('');
  const [trLineQty, setTrLineQty] = useState('1');
  const [lastCompraId, setLastCompraId] = useState<string | null>(null);
  const [lastOcId, setLastOcId] = useState<string | null>(null);
  const [lastTrId, setLastTrId] = useState<string | null>(null);
  const [overrideCompraId, setOverrideCompraId] = useState('');
  const [overrideOcId, setOverrideOcId] = useState('');
  const [overrideTrId, setOverrideTrId] = useState('');
  const [insertMsg, setInsertMsg] = useState<string | null>(null);
  const [insertBusy, setInsertBusy] = useState(false);
  const [autoRealtime, setAutoRealtime] = useState(false);
  const [autoStatus, setAutoStatus] = useState<string>('inactivo');
  const autoTickRef = useRef(false);
  const autoRealtimeUserEnabledRef = useRef(false);

  const loadRlsContext = useCallback(async () => {
    const client = getSupabaseClient();
    if (!client) {
      setCtxMsg('Sin cliente Supabase');
      return;
    }
    const { data: sess } = await client.auth.getSession();
    if (!sess.session) {
      setCtxMsg('Inicia sesión para leer user_profiles');
      setRlsCtx(null);
      return;
    }
    setCtxBusy(true);
    setCtxMsg(null);
    try {
      let r = await client.from('user_profiles').select('empresa_id, sucursal_id, rol_principal').maybeSingle();
      if (r.error) {
        r = await client.from('user_profiles').select('empresa_id, sucursal_id, app_role').maybeSingle();
      }
      if (r.error) {
        r = await client.from('user_profiles').select('empresa_id, sucursal_id').maybeSingle();
      }
      if (!r.error && r.data && r.data.empresa_id != null) {
        const d = r.data as Record<string, unknown>;
        const empresa = String(d.empresa_id);
        const sucursal =
          d.sucursal_id != null && String(d.sucursal_id).length > 0 ? String(d.sucursal_id) : null;
        setRlsCtx({
          empresa_id: empresa,
          sucursal_id: sucursal,
          app_role: mapUserProfileRole(d),
          source: 'user_profiles',
        });
        setManualEmpresaId(empresa);
        setManualSucursalId(sucursal ?? '');
        setCtxMsg('Contexto desde public.user_profiles');
        return;
      }
      setRlsCtx(null);
      setCtxMsg(
        r.error?.message ||
          'No se pudo leer user_profiles; usa UUID manuales y «Aplicar manual».',
      );
    } finally {
      setCtxBusy(false);
    }
  }, []);

  const applyManualContext = useCallback(() => {
    const e = manualEmpresaId.trim();
    if (!e) {
      setCtxMsg('Pega al menos empresa_id (UUID)');
      return;
    }
    setRlsCtx({
      empresa_id: e,
      sucursal_id: manualSucursalId.trim() || null,
      app_role: null,
      source: 'manual',
    });
    setCtxMsg('Contexto manual aplicado (rol desconocido: prueba inserts según tu usuario)');
  }, [manualEmpresaId, manualSucursalId]);

  const runProbes = useCallback(async () => {
    const client = getSupabaseClient();
    if (!client) {
      setProbes([
        {
          table: '—',
          ok: false,
          detail:
            'Falta URL o anon key: crea apps/mobile/.env con EXPO_PUBLIC_SUPABASE_URL y EXPO_PUBLIC_SUPABASE_ANON_KEY (JWT eyJ…), ejecuta desde apps/mobile y reinicia con npx expo start --clear',
        },
      ]);
      return;
    }

    setLoading(true);
    setProbes(null);

    const out: Probe[] = [];

    for (const { table, select } of TABLES) {
      const { error, data } = await client.from(table).select(select).limit(1);
      if (error) {
        out.push({
          table,
          ok: false,
          detail: `${error.message}${error.code ? ` (${error.code})` : ''}`,
        });
      } else {
        const n = Array.isArray(data) ? data.length : 0;
        out.push({
          table,
          ok: true,
          detail: n === 0 ? 'OK · 0 filas (RLS o tabla vacía)' : `OK · muestra ${n} fila(s)`,
        });
      }
    }

    setProbes(out);
    setLoading(false);
  }, []);

  const withInsert = useCallback(
    async (fn: () => Promise<{ error: { message: string } | null }>) => {
      setInsertBusy(true);
      setInsertMsg(null);
      try {
        const { error } = await fn();
        if (error) setInsertMsg(error.message);
        else setInsertMsg('OK');
        await runProbes();
      } catch (e) {
        setInsertMsg(e instanceof Error ? e.message : 'Error');
      } finally {
        setInsertBusy(false);
      }
    },
    [runProbes],
  );

  const refreshSession = useCallback(async () => {
    const client = getSupabaseClient();
    if (!client) {
      setAuthMsg('Sin cliente Supabase: revisa apps/mobile/.env y reinicia con npx expo start --clear');
      setUserLabel('Sin sesión');
      return;
    }
    setSessionBusy(true);
    try {
      const { data: first, error: e1 } = await client.auth.getSession();
      if (e1) {
        setAuthMsg(`Sesión: ${e1.message}`);
        setUserLabel('Sin sesión');
        return;
      }
      if (first.session) {
        const { error: e2 } = await client.auth.refreshSession();
        if (e2) setAuthMsg(`Refresco token: ${e2.message}`);
        else setAuthMsg(null);
      }
      const { data, error } = await client.auth.getSession();
      if (error) {
        setAuthMsg(`Sesión: ${error.message}`);
        setUserLabel('Sin sesión');
        return;
      }
      const u = data.session?.user;
      setUserLabel(u ? `${u.email ?? u.id}` : 'Sin sesión');
    } catch (e) {
      setAuthMsg(e instanceof Error ? e.message : 'Error al refrescar sesión');
      setUserLabel('Sin sesión');
    } finally {
      setSessionBusy(false);
    }
  }, []);

  const signIn = useCallback(async () => {
    const client = getSupabaseClient();
    if (!client || !email.trim() || !password) {
      setAuthMsg('Completa email y contraseña');
      return;
    }
    setAuthMsg(null);
    const { error } = await client.auth.signInWithPassword({
      email: email.trim(),
      password,
    });
    if (error) setAuthMsg(formatAuthError(error.message));
    else {
      setAuthMsg('Sesión OK');
      await refreshSession();
      await loadRlsContext();
      await runProbes();
    }
  }, [email, password, refreshSession, runProbes, loadRlsContext]);

  const signOut = useCallback(async () => {
    const client = getSupabaseClient();
    if (!client) {
      setAuthMsg('Sin cliente Supabase: revisa apps/mobile/.env y reinicia con npx expo start --clear');
      return;
    }
    setSessionBusy(true);
    try {
      const { error } = await client.auth.signOut({ scope: 'local' });
      if (error) {
        setAuthMsg(`Salir: ${error.message}`);
        return;
      }
      setAuthMsg('Sesión cerrada');
      setUserLabel('Sin sesión');
      await runProbes();
    } catch (e) {
      setAuthMsg(e instanceof Error ? `Salir: ${e.message}` : 'Salir: error desconocido');
    } finally {
      setSessionBusy(false);
    }
  }, [runProbes]);

  const preloadExistingRefs = useCallback(async () => {
    const client = getSupabaseClient();
    if (!client) return;
    const { data: sess } = await client.auth.getSession();
    const uid = sess.session?.user.id;
    if (!uid) return;

    let compraQ = client.from('compras_encabezado').select('id').limit(1);
    if (rlsCtx?.empresa_id) compraQ = compraQ.eq('empresa_id', rlsCtx.empresa_id);
    if (rlsCtx?.sucursal_id) compraQ = compraQ.eq('id_sucursal', rlsCtx.sucursal_id);
    const compra = await compraQ.maybeSingle();
    if (compra.data) {
      const id = pickRowKey(compra.data, ['id_compra', 'id']);
      if (!id) return;
      setLastCompraId((prev) => prev || id);
      setOverrideCompraId((prev) => prev || id);
    }

    let ocQ = client.from('ordenes_compra_encabezado').select('id,id_orden_compra').limit(1);
    if (rlsCtx?.empresa_id) ocQ = ocQ.eq('empresa_id', rlsCtx.empresa_id);
    if (rlsCtx?.sucursal_id) ocQ = ocQ.eq('id_sucursal', rlsCtx.sucursal_id);
    ocQ = ocQ.eq('empleado_asignado_id', uid);
    const oc = await ocQ.maybeSingle();
    if (oc.data) {
      const id = pickRowKey(oc.data, ['id_orden_compra', 'id']);
      if (!id) return;
      setLastOcId((prev) => prev || id);
      setOverrideOcId((prev) => prev || id);
    }

    let trQ = client.from('traslados_encabezado').select('id,id_traslado').limit(1);
    if (rlsCtx?.empresa_id) trQ = trQ.eq('empresa_id', rlsCtx.empresa_id);
    if (rlsCtx?.sucursal_id) trQ = trQ.eq('id_sucursal_origen', rlsCtx.sucursal_id);
    trQ = trQ.eq('empleado_asignado_id', uid);
    const tr = await trQ.maybeSingle();
    if (tr.data) {
      const id = pickRowKey(tr.data, ['id_traslado', 'id']);
      if (!id) return;
      setLastTrId((prev) => prev || id);
      setOverrideTrId((prev) => prev || id);
    }
  }, [rlsCtx?.empresa_id, rlsCtx?.sucursal_id]);

  useEffect(() => {
    void refreshSession();
  }, [refreshSession]);

  useEffect(() => {
    const client = getSupabaseClient();
    if (!client) return;
    const {
      data: { subscription },
    } = client.auth.onAuthStateChange((_event, session) => {
      const u = session?.user;
      setUserLabel(u ? `${u.email ?? u.id}` : 'Sin sesión');
    });
    return () => subscription.unsubscribe();
  }, []);

  useEffect(() => {
    void preloadExistingRefs();
  }, [preloadExistingRefs]);

  if (!__DEV__) {
    return (
      <View style={styles.center}>
        <Text style={styles.title}>No disponible</Text>
        <Text style={styles.muted}>Esta pantalla solo existe en modo desarrollo.</Text>
        <Pressable style={styles.btn} onPress={() => router.back()}>
          <Text style={styles.btnText}>Volver</Text>
        </Pressable>
      </View>
    );
  }

  const insertProducto = async () => {
    const client = getSupabaseClient();
    if (!client || !rlsCtx) {
      setInsertMsg('Inicia sesión y carga contexto RLS (o manual)');
      return;
    }
    await withInsert(async () => {
      const r = await client.from('productos').insert({
        empresa_id: rlsCtx.empresa_id,
        sku_codigo: prodSku.trim() || null,
        nombre: prodNombre.trim() || null,
      });
      return { error: r.error };
    });
  };

  const insertCliente = async () => {
    const client = getSupabaseClient();
    if (!client || !rlsCtx) {
      setInsertMsg('Falta contexto RLS');
      return;
    }
    const doc = cliDoc.trim() || makeAutoStamp('DEMO-C');
    const razon = cliRazon.trim() || `Cliente ${makeAutoStamp('AUTO')}`;
    await withInsert(async () => {
      const r = await client.from('clientes').insert({
        empresa_id: rlsCtx.empresa_id,
        num_documento: doc,
        razon_social: razon,
      });
      if (!r.error) {
        setCliDoc(doc);
        setCliRazon(razon);
      }
      return { error: r.error };
    });
  };

  const insertProveedor = async () => {
    const client = getSupabaseClient();
    if (!client || !rlsCtx) {
      setInsertMsg('Falta contexto RLS');
      return;
    }
    const doc = provDoc.trim() || makeAutoStamp('DEMO-V');
    const razon = provRazon.trim() || `Proveedor ${makeAutoStamp('AUTO')}`;
    await withInsert(async () => {
      const r = await client.from('proveedores').insert({
        empresa_id: rlsCtx.empresa_id,
        num_documento: doc,
        razon_social: razon,
      });
      if (!r.error) {
        setProvDoc(doc);
        setProvRazon(razon);
      }
      return { error: r.error };
    });
  };

  const insertCompraEnc = async () => {
    const client = getSupabaseClient();
    if (!client || !rlsCtx?.sucursal_id) {
      setInsertMsg('Contexto con sucursal_id obligatorio (perfil o manual)');
      return;
    }
    const { data: sess } = await client.auth.getSession();
    const uid = sess.session?.user.id;
    if (!uid) {
      setInsertMsg('Sin usuario en sesión');
      return;
    }
    await withInsert(async () => {
      const numCompra = makeAutoDocNumber('COMP');
      const r = await client
        .from('compras_encabezado')
        .insert({
          empresa_id: rlsCtx.empresa_id,
          id_sucursal: rlsCtx.sucursal_id,
          num_compra: numCompra,
          fecha_compra: todayIsoDate(),
          created_by: uid,
        })
        .select('*')
        .single();
      if (!r.error && r.data) {
        const id = pickRowKey(r.data, ['id_compra', 'id']);
        if (!id) return { error: r.error };
        setLastCompraId(id);
        setOverrideCompraId(id);
      }
      return { error: r.error };
    });
  };

  const insertCompraDet = async () => {
    const client = getSupabaseClient();
    let cid = overrideCompraId.trim() || lastCompraId;
    if (!client) {
      setInsertMsg('Sin cliente Supabase');
      return;
    }
    const { data: sess } = await client.auth.getSession();
    const uid = sess.session?.user.id;
    if (!cid) {
      let latest = client.from('compras_encabezado').select('id,id_compra').limit(1);
      if (rlsCtx?.empresa_id) latest = latest.eq('empresa_id', rlsCtx.empresa_id);
      if (rlsCtx?.sucursal_id) latest = latest.eq('id_sucursal', rlsCtx.sucursal_id);
      const lr = await latest.maybeSingle();
      if (lr.data) {
        const id = pickRowKey(lr.data, ['id_compra', 'id']);
        if (!id) return;
        cid = id;
        setLastCompraId(cid);
        setOverrideCompraId(cid);
      }
    }
    if (!cid && rlsCtx?.sucursal_id && uid) {
      const numCompra = makeAutoDocNumber('COMP');
      const cr = await client
        .from('compras_encabezado')
        .insert({
          empresa_id: rlsCtx.empresa_id,
          id_sucursal: rlsCtx.sucursal_id,
          num_compra: numCompra,
          fecha_compra: todayIsoDate(),
          created_by: uid,
        })
        .select('*')
        .single();
      if (!cr.error && cr.data) {
        const id = pickRowKey(cr.data, ['id_compra', 'id']);
        if (!id) return;
        cid = id;
        setLastCompraId(cid);
        setOverrideCompraId(cid);
      }
    }
    if (!cid) {
      setInsertMsg('No hay compra disponible. Carga contexto con sucursal o crea encabezado.');
      return;
    }
    await withInsert(async () => {
      let enc = await client
        .from('compras_encabezado')
        .select('empresa_id, id_sucursal')
        .eq('id_compra', cid)
        .maybeSingle();
      if (enc.error) {
        enc = await client
          .from('compras_encabezado')
          .select('empresa_id, id_sucursal')
          .eq('id', cid)
          .maybeSingle();
      }
      const compraEmpresa =
        enc.data && typeof enc.data === 'object' && 'empresa_id' in enc.data
          ? String((enc.data as { empresa_id?: string | null }).empresa_id ?? '')
          : '';
      const compraSucursal =
        enc.data && typeof enc.data === 'object' && 'id_sucursal' in enc.data
          ? String((enc.data as { id_sucursal?: string | null }).id_sucursal ?? '')
          : '';
      let r = await insertWithVariants(client, 'compras_detalle', [
        {
          id_compra: cid,
          created_by: uid ?? null,
          empresa_id: compraEmpresa || rlsCtx?.empresa_id || null,
          id_sucursal: compraSucursal || rlsCtx?.sucursal_id || null,
        },
        {
          id_compra: cid,
          created_by: uid ?? null,
          empresa_id: compraEmpresa || rlsCtx?.empresa_id || null,
        },
        { id_compra: cid, created_by: uid ?? null },
        { id_compra: cid },
      ]);
      if (isRlsViolation(r.error) && rlsCtx?.sucursal_id && uid) {
        const cr = await client
          .from('compras_encabezado')
          .insert({
            empresa_id: rlsCtx.empresa_id,
            id_sucursal: rlsCtx.sucursal_id,
            num_compra: makeAutoDocNumber('COMP'),
            fecha_compra: todayIsoDate(),
            created_by: uid,
          })
          .select('*')
          .single();
        if (!cr.error && cr.data) {
          const fresh = pickRowKey(cr.data, ['id_compra', 'id']);
          if (!fresh) return { error: r.error };
          setLastCompraId(fresh);
          setOverrideCompraId(fresh);
          const freshEnc = await client
            .from('compras_encabezado')
            .select('empresa_id, id_sucursal')
            .eq('id_compra', fresh)
            .maybeSingle();
          const freshEmpresa =
            freshEnc.data && typeof freshEnc.data === 'object' && 'empresa_id' in freshEnc.data
              ? String((freshEnc.data as { empresa_id?: string | null }).empresa_id ?? '')
              : '';
          const freshSucursal =
            freshEnc.data && typeof freshEnc.data === 'object' && 'id_sucursal' in freshEnc.data
              ? String((freshEnc.data as { id_sucursal?: string | null }).id_sucursal ?? '')
              : '';
          r = await insertWithVariants(client, 'compras_detalle', [
            {
              id_compra: fresh,
              created_by: uid,
              empresa_id: freshEmpresa || rlsCtx.empresa_id,
              id_sucursal: freshSucursal || rlsCtx.sucursal_id,
            },
            { id_compra: fresh, created_by: uid, empresa_id: freshEmpresa || rlsCtx.empresa_id },
            { id_compra: fresh, created_by: uid },
            { id_compra: fresh },
          ]);
        }
      }
      return { error: r.error };
    });
  };

  const insertOcEnc = async () => {
    const client = getSupabaseClient();
    if (!client || !rlsCtx?.sucursal_id) {
      setInsertMsg('Contexto con sucursal_id obligatorio');
      return;
    }
    const { data: sess } = await client.auth.getSession();
    const uid = sess.session?.user.id;
    if (!uid) {
      setInsertMsg('Sin usuario en sesión');
      return;
    }
    await withInsert(async () => {
      const numOc = makeAutoDocNumber('OC');
      const base = {
        empresa_id: rlsCtx.empresa_id,
        id_sucursal: rlsCtx.sucursal_id,
        empleado_asignado_id: uid,
        estado: 'BORRADOR' as const,
        num_oc: numOc,
        fecha_oc: todayIsoDate(),
        created_by: uid,
      };
      let r = await client
        .from('ordenes_compra_encabezado')
        .insert({
          ...base,
          nota_encargado: ocNota.trim() || null,
        })
        .select('*')
        .single();
      if (r.error && postgrestColumnMissing(r.error, 'nota_encargado')) {
        r = await client.from('ordenes_compra_encabezado').insert(base).select('*').single();
      }
      if (!r.error && r.data) {
        const id = pickRowKey(r.data, ['id_orden_compra', 'id']);
        if (!id) return { error: r.error };
        setLastOcId(id);
        setOverrideOcId(id);
      }
      return { error: r.error };
    });
  };

  const insertOcDet = async () => {
    const client = getSupabaseClient();
    let oid = overrideOcId.trim() || lastOcId;
    if (!client) {
      setInsertMsg('Sin cliente Supabase');
      return;
    }
    const { data: sess } = await client.auth.getSession();
    const uid = sess.session?.user.id;
    if (!oid) {
      let latest = client.from('ordenes_compra_encabezado').select('id,id_orden_compra').limit(1);
      if (rlsCtx?.empresa_id) latest = latest.eq('empresa_id', rlsCtx.empresa_id);
      if (rlsCtx?.sucursal_id) latest = latest.eq('id_sucursal', rlsCtx.sucursal_id);
      if (uid) latest = latest.eq('empleado_asignado_id', uid);
      const lr = await latest.maybeSingle();
      if (lr.data) {
        const id = pickRowKey(lr.data, ['id_orden_compra', 'id']);
        if (!id) return;
        oid = id;
        setLastOcId(oid);
        setOverrideOcId(oid);
      }
    }
    if (!oid && rlsCtx?.sucursal_id && uid) {
      const numOc = makeAutoDocNumber('OC');
      const base = {
        empresa_id: rlsCtx.empresa_id,
        id_sucursal: rlsCtx.sucursal_id,
        empleado_asignado_id: uid,
        estado: 'BORRADOR' as const,
        num_oc: numOc,
        fecha_oc: todayIsoDate(),
        created_by: uid,
      };
      let cr = await client
        .from('ordenes_compra_encabezado')
        .insert({
          ...base,
          nota_encargado: ocNota.trim() || null,
        })
        .select('*')
        .single();
      if (cr.error && postgrestColumnMissing(cr.error, 'nota_encargado')) {
        cr = await client.from('ordenes_compra_encabezado').insert(base).select('*').single();
      }
      if (!cr.error && cr.data) {
        const id = pickRowKey(cr.data, ['id_orden_compra', 'id']);
        if (!id) return;
        oid = id;
        setLastOcId(oid);
        setOverrideOcId(oid);
      }
    }
    if (!oid) {
      setInsertMsg('No hay OC disponible. Carga contexto con sucursal e inicia sesión.');
      return;
    }
    const codProducto = ocLineCod.trim() || prodSku.trim() || makeAutoStamp('DEMO-P');
    const qty = Number(ocLineQty.replace(',', '.'));
    await withInsert(async () => {
      const ocEnc = await client
        .from('ordenes_compra_encabezado')
        .select('empresa_id, id_sucursal')
        .eq('id_orden_compra', oid)
        .maybeSingle();
      const ocEmpresa =
        ocEnc.data && typeof ocEnc.data === 'object' && 'empresa_id' in ocEnc.data
          ? String((ocEnc.data as { empresa_id?: string | null }).empresa_id ?? '')
          : '';
      const ocSucursal =
        ocEnc.data && typeof ocEnc.data === 'object' && 'id_sucursal' in ocEnc.data
          ? String((ocEnc.data as { id_sucursal?: string | null }).id_sucursal ?? '')
          : '';
      let r = await insertWithVariants(client, 'ordenes_compra_detalle', [
        {
          id_orden_compra: oid,
          cod_producto: codProducto,
          cantidad: Number.isFinite(qty) ? qty : 1,
          created_by: uid ?? null,
          empresa_id: ocEmpresa || rlsCtx?.empresa_id || null,
          id_sucursal: ocSucursal || rlsCtx?.sucursal_id || null,
        },
        {
          id_orden_compra: oid,
          cod_producto: codProducto,
          cantidad: Number.isFinite(qty) ? qty : 1,
          created_by: uid ?? null,
        },
        {
          id_orden_compra: oid,
          cod_producto: codProducto,
          cantidad: Number.isFinite(qty) ? qty : 1,
        },
      ]);
      if (isRlsViolation(r.error) && rlsCtx?.sucursal_id && uid) {
        const base = {
          empresa_id: rlsCtx.empresa_id,
          id_sucursal: rlsCtx.sucursal_id,
          empleado_asignado_id: uid,
          estado: 'BORRADOR' as const,
          num_oc: makeAutoDocNumber('OC'),
          fecha_oc: todayIsoDate(),
          created_by: uid,
        };
        let cr = await client
          .from('ordenes_compra_encabezado')
          .insert({
            ...base,
            nota_encargado: ocNota.trim() || null,
          })
          .select('*')
          .single();
        if (cr.error && postgrestColumnMissing(cr.error, 'nota_encargado')) {
          cr = await client.from('ordenes_compra_encabezado').insert(base).select('*').single();
        }
        if (!cr.error && cr.data) {
          const fresh = pickRowKey(cr.data, ['id_orden_compra', 'id']);
          if (!fresh) return { error: r.error };
          setLastOcId(fresh);
          setOverrideOcId(fresh);
          const freshEnc = await client
            .from('ordenes_compra_encabezado')
            .select('empresa_id, id_sucursal')
            .eq('id_orden_compra', fresh)
            .maybeSingle();
          const freshEmpresa =
            freshEnc.data && typeof freshEnc.data === 'object' && 'empresa_id' in freshEnc.data
              ? String((freshEnc.data as { empresa_id?: string | null }).empresa_id ?? '')
              : '';
          const freshSucursal =
            freshEnc.data && typeof freshEnc.data === 'object' && 'id_sucursal' in freshEnc.data
              ? String((freshEnc.data as { id_sucursal?: string | null }).id_sucursal ?? '')
              : '';
          r = await insertWithVariants(client, 'ordenes_compra_detalle', [
            {
              id_orden_compra: fresh,
              cod_producto: codProducto,
              cantidad: Number.isFinite(qty) ? qty : 1,
              created_by: uid,
              empresa_id: freshEmpresa || rlsCtx.empresa_id,
              id_sucursal: freshSucursal || rlsCtx.sucursal_id,
            },
            {
              id_orden_compra: fresh,
              cod_producto: codProducto,
              cantidad: Number.isFinite(qty) ? qty : 1,
              created_by: uid,
            },
            {
              id_orden_compra: fresh,
              cod_producto: codProducto,
              cantidad: Number.isFinite(qty) ? qty : 1,
            },
          ]);
        }
      }
      if (!r.error) {
        setOcLineCod(codProducto);
      }
      return { error: r.error };
    });
  };

  const insertTrEnc = async () => {
    const client = getSupabaseClient();
    if (!client || !rlsCtx?.sucursal_id) {
      setInsertMsg('Contexto con sucursal_id obligatorio');
      return;
    }
    const { data: sess } = await client.auth.getSession();
    const uid = sess.session?.user.id;
    if (!uid) {
      setInsertMsg('Sin usuario en sesión');
      return;
    }
    await withInsert(async () => {
      const numTraslado = makeAutoDocNumber('TR');
      const base = {
        empresa_id: rlsCtx.empresa_id,
        id_sucursal_origen: rlsCtx.sucursal_id,
        empleado_asignado_id: uid,
        estado: 'BORRADOR' as const,
        num_traslado: numTraslado,
        fecha_traslado: todayIsoDate(),
        created_by: uid,
      };
      let r = await client
        .from('traslados_encabezado')
        .insert({
          ...base,
          nota_traslado: trNota.trim() || null,
        })
        .select('*')
        .single();
      if (r.error && postgrestColumnMissing(r.error, 'nota_traslado')) {
        r = await client.from('traslados_encabezado').insert(base).select('*').single();
      }
      if (!r.error && r.data) {
        const id = pickRowKey(r.data, ['id_traslado', 'id']);
        if (!id) return { error: r.error };
        setLastTrId(id);
        setOverrideTrId(id);
      }
      return { error: r.error };
    });
  };

  const insertTrDet = async () => {
    const client = getSupabaseClient();
    let tid = overrideTrId.trim() || lastTrId;
    if (!client) {
      setInsertMsg('Sin cliente Supabase');
      return;
    }
    const { data: sess } = await client.auth.getSession();
    const uid = sess.session?.user.id;
    if (!tid) {
      let latest = client.from('traslados_encabezado').select('id,id_traslado').limit(1);
      if (rlsCtx?.empresa_id) latest = latest.eq('empresa_id', rlsCtx.empresa_id);
      if (rlsCtx?.sucursal_id) latest = latest.eq('id_sucursal_origen', rlsCtx.sucursal_id);
      if (uid) latest = latest.eq('empleado_asignado_id', uid);
      const lr = await latest.maybeSingle();
      if (lr.data) {
        const id = pickRowKey(lr.data, ['id_traslado', 'id']);
        if (!id) return;
        tid = id;
        setLastTrId(tid);
        setOverrideTrId(tid);
      }
    }
    if (!tid && rlsCtx?.sucursal_id && uid) {
      const numTraslado = makeAutoDocNumber('TR');
      const base = {
        empresa_id: rlsCtx.empresa_id,
        id_sucursal_origen: rlsCtx.sucursal_id,
        empleado_asignado_id: uid,
        estado: 'BORRADOR' as const,
        num_traslado: numTraslado,
        fecha_traslado: todayIsoDate(),
        created_by: uid,
      };
      let cr = await client
        .from('traslados_encabezado')
        .insert({
          ...base,
          nota_traslado: trNota.trim() || null,
        })
        .select('*')
        .single();
      if (cr.error && postgrestColumnMissing(cr.error, 'nota_traslado')) {
        cr = await client.from('traslados_encabezado').insert(base).select('*').single();
      }
      if (!cr.error && cr.data) {
        const id = pickRowKey(cr.data, ['id_traslado', 'id']);
        if (!id) return;
        tid = id;
        setLastTrId(tid);
        setOverrideTrId(tid);
      }
    }
    if (!tid) {
      setInsertMsg('No hay traslado disponible. Carga contexto con sucursal e inicia sesión.');
      return;
    }
    const codProducto = trLineCod.trim() || prodSku.trim() || makeAutoStamp('DEMO-P');
    const qty = Number(trLineQty.replace(',', '.'));
    await withInsert(async () => {
      const trEnc = await client
        .from('traslados_encabezado')
        .select('empresa_id, id_sucursal_origen')
        .eq('id_traslado', tid)
        .maybeSingle();
      const trEmpresa =
        trEnc.data && typeof trEnc.data === 'object' && 'empresa_id' in trEnc.data
          ? String((trEnc.data as { empresa_id?: string | null }).empresa_id ?? '')
          : '';
      const trSucursal =
        trEnc.data && typeof trEnc.data === 'object' && 'id_sucursal_origen' in trEnc.data
          ? String((trEnc.data as { id_sucursal_origen?: string | null }).id_sucursal_origen ?? '')
          : '';
      let r = await insertWithVariants(client, 'traslados_detalle', [
        {
          id_traslado: tid,
          cod_producto: codProducto,
          cantidad: Number.isFinite(qty) ? qty : 1,
          created_by: uid ?? null,
          empresa_id: trEmpresa || rlsCtx?.empresa_id || null,
          id_sucursal_origen: trSucursal || rlsCtx?.sucursal_id || null,
        },
        {
          id_traslado: tid,
          cod_producto: codProducto,
          cantidad: Number.isFinite(qty) ? qty : 1,
          created_by: uid ?? null,
        },
        {
          id_traslado: tid,
          cod_producto: codProducto,
          cantidad: Number.isFinite(qty) ? qty : 1,
        },
      ]);
      if (isRlsViolation(r.error) && rlsCtx?.sucursal_id && uid) {
        const base = {
          empresa_id: rlsCtx.empresa_id,
          id_sucursal_origen: rlsCtx.sucursal_id,
          empleado_asignado_id: uid,
          estado: 'BORRADOR' as const,
          num_traslado: makeAutoDocNumber('TR'),
          fecha_traslado: todayIsoDate(),
          created_by: uid,
        };
        let cr = await client
          .from('traslados_encabezado')
          .insert({
            ...base,
            nota_traslado: trNota.trim() || null,
          })
          .select('*')
          .single();
        if (cr.error && postgrestColumnMissing(cr.error, 'nota_traslado')) {
          cr = await client.from('traslados_encabezado').insert(base).select('*').single();
        }
        if (!cr.error && cr.data) {
          const fresh = pickRowKey(cr.data, ['id_traslado', 'id']);
          if (!fresh) return { error: r.error };
          setLastTrId(fresh);
          setOverrideTrId(fresh);
          const freshEnc = await client
            .from('traslados_encabezado')
            .select('empresa_id, id_sucursal_origen')
            .eq('id_traslado', fresh)
            .maybeSingle();
          const freshEmpresa =
            freshEnc.data && typeof freshEnc.data === 'object' && 'empresa_id' in freshEnc.data
              ? String((freshEnc.data as { empresa_id?: string | null }).empresa_id ?? '')
              : '';
          const freshSucursal =
            freshEnc.data && typeof freshEnc.data === 'object' && 'id_sucursal_origen' in freshEnc.data
              ? String((freshEnc.data as { id_sucursal_origen?: string | null }).id_sucursal_origen ?? '')
              : '';
          r = await insertWithVariants(client, 'traslados_detalle', [
            {
              id_traslado: fresh,
              cod_producto: codProducto,
              cantidad: Number.isFinite(qty) ? qty : 1,
              created_by: uid,
              empresa_id: freshEmpresa || rlsCtx.empresa_id,
              id_sucursal_origen: freshSucursal || rlsCtx.sucursal_id,
            },
            {
              id_traslado: fresh,
              cod_producto: codProducto,
              cantidad: Number.isFinite(qty) ? qty : 1,
              created_by: uid,
            },
            {
              id_traslado: fresh,
              cod_producto: codProducto,
              cantidad: Number.isFinite(qty) ? qty : 1,
            },
          ]);
        }
      }
      if (!r.error) {
        setTrLineCod(codProducto);
      }
      return { error: r.error };
    });
  };

  const runDemoAll = async () => {
    const client = getSupabaseClient();
    if (!client) {
      setInsertMsg('Sin cliente Supabase');
      return;
    }
    const { data: sess } = await client.auth.getSession();
    const uid = sess.session?.user?.id;
    if (!uid) {
      setInsertMsg('Inicia sesión primero (Entrar)');
      return;
    }

    setInsertBusy(true);
    setInsertMsg(null);
    const errs: string[] = [];
    const mark = String(Date.now());
    const skuDemo = `DEMO-${mark}`;

    let prof = await client
      .from('user_profiles')
      .select('empresa_id, sucursal_id, rol_principal')
      .eq('id', uid)
      .maybeSingle();
    if (prof.error) {
      prof = await client
        .from('user_profiles')
        .select('empresa_id, sucursal_id, app_role')
        .eq('id', uid)
        .maybeSingle();
    }
    if (prof.error) {
      prof = await client
        .from('user_profiles')
        .select('empresa_id, sucursal_id')
        .eq('id', uid)
        .maybeSingle();
    }
    if (!prof.error && !prof.data) {
      prof = await client
        .from('user_profiles')
        .select('empresa_id, sucursal_id, rol_principal')
        .eq('user_id', uid)
        .maybeSingle();
    }
    if (!prof.error && !prof.data) {
      prof = await client
        .from('user_profiles')
        .select('empresa_id, sucursal_id')
        .eq('user_id', uid)
        .maybeSingle();
    }
    if (prof.error) {
      setInsertMsg(`user_profiles: ${prof.error.message} (¿existe public.user_profiles?)`);
      setInsertBusy(false);
      return;
    }

    let empresaId: string;
    let sucursalId: string;
    const row = prof.data as Record<string, unknown> | null;
    const existingRole = mapUserProfileRole(row);

    if (!prof.data) {
      const me = manualEmpresaId.trim();
      const ms = manualSucursalId.trim();
      if (isLikelyUuid(me) && isLikelyUuid(ms)) {
        empresaId = me;
        sucursalId = ms;
      } else {
        empresaId = randomUuid();
        sucursalId = randomUuid();
      }
      const baseProfile = {
        id: uid,
        user_id: uid,
        empresa_id: empresaId,
        sucursal_id: sucursalId,
      };
      const bareProfile = { user_id: uid, empresa_id: empresaId, sucursal_id: sucursalId };
      let ins = await client.from('user_profiles').insert({
        ...baseProfile,
        rol_principal: 'admin',
      });
      if (ins.error) {
        ins = await client.from('user_profiles').insert({
          ...baseProfile,
          app_role: 'admin',
        });
      }
      if (ins.error) {
        ins = await client.from('user_profiles').insert(baseProfile);
      }
      if (ins.error) {
        ins = await client.from('user_profiles').insert({ ...bareProfile, rol_principal: 'admin' });
      }
      if (ins.error) {
        ins = await client.from('user_profiles').insert(bareProfile);
      }
      if (ins.error) {
        setInsertMsg(formatUserProfilesRlsHint('insert', ins.error));
        setInsertBusy(false);
        return;
      }
    } else {
      const e0 = prof.data.empresa_id != null ? String(prof.data.empresa_id) : '';
      const s0 = prof.data.sucursal_id != null ? String(prof.data.sucursal_id) : '';
      if (!e0 || !s0) {
        empresaId = e0 || randomUuid();
        sucursalId = s0 || randomUuid();
        const upPayloadRol = {
          empresa_id: empresaId,
          sucursal_id: sucursalId,
          rol_principal: existingRole || 'admin',
        };
        const upPayloadApp = {
          empresa_id: empresaId,
          sucursal_id: sucursalId,
          app_role: existingRole || 'admin',
        };
        const upPayloadBare = { empresa_id: empresaId, sucursal_id: sucursalId };
        let up = await client.from('user_profiles').update(upPayloadRol).eq('id', uid);
        if (up.error) up = await client.from('user_profiles').update(upPayloadRol).eq('user_id', uid);
        if (up.error) {
          up = await client.from('user_profiles').update(upPayloadApp).eq('id', uid);
        }
        if (up.error) up = await client.from('user_profiles').update(upPayloadApp).eq('user_id', uid);
        if (up.error) {
          up = await client.from('user_profiles').update(upPayloadBare).eq('id', uid);
        }
        if (up.error) up = await client.from('user_profiles').update(upPayloadBare).eq('user_id', uid);
        if (up.error) {
          setInsertMsg(formatUserProfilesRlsHint('update', up.error));
          setInsertBusy(false);
          return;
        }
      } else {
        empresaId = e0;
        sucursalId = s0;
      }
    }

    setRlsCtx({
      empresa_id: empresaId,
      sucursal_id: sucursalId,
      app_role: existingRole || 'admin',
      source: 'user_profiles',
    });
    setCtxMsg('Contexto generado / actualizado desde user_profiles');
    setProdSku(skuDemo);
    setProdNombre(`Producto demo ${mark}`);
    setCliDoc(`DEMO-C-${mark}`);
    setCliRazon(`Cliente demo ${mark}`);
    setProvDoc(`DEMO-V-${mark}`);
    setProvRazon(`Proveedor demo ${mark}`);
    setOcNota(`OC demo ${mark}`);
    setOcLineCod(skuDemo);
    setOcLineQty('1');
    setTrNota(`Traslado demo ${mark}`);
    setTrLineCod(skuDemo);
    setTrLineQty('1');

    const rProd = await client.from('productos').insert({
      empresa_id: empresaId,
      sku_codigo: skuDemo,
      nombre: `Producto demo ${mark}`,
    });
    if (rProd.error) errs.push(`producto: ${rProd.error.message}`);

    const rCli = await client.from('clientes').insert({
      empresa_id: empresaId,
      num_documento: `DEMO-C-${mark}`,
      razon_social: `Cliente demo ${mark}`,
    });
    if (rCli.error) errs.push(`cliente: ${rCli.error.message}`);

    const rProv = await client.from('proveedores').insert({
      empresa_id: empresaId,
      num_documento: `DEMO-V-${mark}`,
      razon_social: `Proveedor demo ${mark}`,
    });
    if (rProv.error) errs.push(`proveedor: ${rProv.error.message}`);

    const rCe = await client
      .from('compras_encabezado')
      .insert({
        empresa_id: empresaId,
        id_sucursal: sucursalId,
        num_compra: makeAutoDocNumber('COMP'),
        fecha_compra: todayIsoDate(),
        created_by: uid,
      })
      .select('*')
      .single();
    if (rCe.error) errs.push(`compra enc: ${rCe.error.message}`);
    else if (rCe.data) {
      const cid = pickRowKey(rCe.data, ['id_compra', 'id']);
      if (!cid) {
        errs.push('compra enc: no se pudo resolver id');
      } else {
      setLastCompraId(cid);
      setOverrideCompraId(cid);
      const rCd = await client.from('compras_detalle').insert({ id_compra: cid });
      if (rCd.error) errs.push(`compra det: ${rCd.error.message}`);
      }
    }

    const ocBase = {
      empresa_id: empresaId,
      id_sucursal: sucursalId,
      empleado_asignado_id: uid,
      estado: 'BORRADOR' as const,
      num_oc: makeAutoDocNumber('OC'),
      fecha_oc: todayIsoDate(),
      created_by: uid,
    };
    let rOe = await client
      .from('ordenes_compra_encabezado')
      .insert({
        ...ocBase,
        nota_encargado: `OC demo ${mark}`,
      })
      .select('*')
      .single();
    if (rOe.error && postgrestColumnMissing(rOe.error, 'nota_encargado')) {
      rOe = await client.from('ordenes_compra_encabezado').insert(ocBase).select('*').single();
    }
    if (rOe.error) errs.push(`OC enc: ${rOe.error.message}`);
    else if (rOe.data) {
      const oid = pickRowKey(rOe.data, ['id_orden_compra', 'id']);
      if (!oid) {
        errs.push('OC enc: no se pudo resolver id');
      } else {
      setLastOcId(oid);
      setOverrideOcId(oid);
      const rOd = await client.from('ordenes_compra_detalle').insert({
        id_orden_compra: oid,
        cod_producto: skuDemo,
        cantidad: 1,
      });
      if (rOd.error) errs.push(`OC det: ${rOd.error.message}`);
      }
    }

    const trBase = {
      empresa_id: empresaId,
      id_sucursal_origen: sucursalId,
      empleado_asignado_id: uid,
      estado: 'BORRADOR' as const,
      num_traslado: makeAutoDocNumber('TR'),
      fecha_traslado: todayIsoDate(),
      created_by: uid,
    };
    let rTe = await client
      .from('traslados_encabezado')
      .insert({
        ...trBase,
        nota_traslado: `Traslado demo ${mark}`,
      })
      .select('*')
      .single();
    if (rTe.error && postgrestColumnMissing(rTe.error, 'nota_traslado')) {
      rTe = await client.from('traslados_encabezado').insert(trBase).select('*').single();
    }
    if (rTe.error) errs.push(`traslado enc: ${rTe.error.message}`);
    else if (rTe.data) {
      const tid = pickRowKey(rTe.data, ['id_traslado', 'id']);
      if (!tid) {
        errs.push('traslado enc: no se pudo resolver id');
      } else {
      setLastTrId(tid);
      setOverrideTrId(tid);
      const rTd = await client.from('traslados_detalle').insert({
        id_traslado: tid,
        cod_producto: skuDemo,
        cantidad: 1,
      });
      if (rTd.error) errs.push(`traslado det: ${rTd.error.message}`);
      }
    }

    const rlsBulk = errs.some((e) => /row-level security/i.test(e));
    setInsertMsg(
      errs.length > 0
        ? `Parcial: ${errs.join(' · ')}${
            rlsBulk
              ? "\n\nRLS: vuelve a ejecutar docs/sql/rls_session_helpers_user_profiles.sql (postgres); confirma empresa_id y rol admin en user_profiles; API → Reload schema. Si sigue igual, revisa políticas: en SQL Editor, SELECT policyname, with_check FROM pg_policies WHERE schemaname = 'public' AND tablename = 'productos';"
              : ''
          }`
        : 'Listo: perfil (si faltaba) + producto, cliente, proveedor, compra, OC, traslado.',
    );
    await loadRlsContext();
    await runProbes();
    setInsertBusy(false);
  };

  const runOneClickAll = async () => {
    const client = getSupabaseClient();
    if (!client) {
      setInsertMsg('Sin cliente Supabase');
      return;
    }
    const { data: sess } = await client.auth.getSession();
    if (!sess.session) {
      if (!email.trim() || !password) {
        setInsertMsg('Para 1 clic: inicia sesión o completa email/contraseña y vuelve a pulsar.');
        return;
      }
      setSessionBusy(true);
      const { error } = await client.auth.signInWithPassword({
        email: email.trim(),
        password,
      });
      setSessionBusy(false);
      if (error) {
        setInsertMsg(`Login: ${formatAuthError(error.message)}`);
        return;
      }
      await refreshSession();
    }
    await runDemoAll();
  };

  const autoRealtimeTick = useCallback(async () => {
    if (autoTickRef.current || insertBusy || sessionBusy || ctxBusy || loading) return;
    autoTickRef.current = true;
    try {
      const client = getSupabaseClient();
      if (!client) {
        setAutoStatus('sin cliente');
        return;
      }

      const { data: sess } = await client.auth.getSession();
      if (!sess.session) {
        if (!email.trim() || !password) {
          setAutoStatus('esperando login');
          return;
        }
        setAutoStatus('iniciando sesión...');
        const { error } = await client.auth.signInWithPassword({
          email: email.trim(),
          password,
        });
        if (error) {
          setAutoStatus('login falló');
          setInsertMsg(`Login: ${formatAuthError(error.message)}`);
          return;
        }
      }

      await loadRlsContext();

      const mustHave = [
        'productos',
        'clientes',
        'proveedores',
        'compras_encabezado',
        'compras_detalle',
        'ordenes_compra_encabezado',
        'ordenes_compra_detalle',
        'traslados_encabezado',
        'traslados_detalle',
      ];
      let needsHydration = false;
      for (const t of mustHave) {
        const { data, error } = await client.from(t).select('*').limit(1);
        if (error || !Array.isArray(data) || data.length === 0) {
          needsHydration = true;
          break;
        }
      }

      if (needsHydration) {
        setAutoStatus('generando faltantes...');
        await runOneClickAll();
      } else {
        setAutoStatus('ok en tiempo real');
        await runProbes();
      }
    } finally {
      autoTickRef.current = false;
    }
  }, [
    ctxBusy,
    email,
    insertBusy,
    loadRlsContext,
    loading,
    password,
    runOneClickAll,
    runProbes,
    sessionBusy,
  ]);

  useEffect(() => {
    // Evita autoarranque por rehidratación/fast-refresh: solo corre si el usuario lo activó.
    if (!autoRealtime || !autoRealtimeUserEnabledRef.current) return;
    setAutoStatus('activo');
    void autoRealtimeTick();
    const id = setInterval(() => {
      void autoRealtimeTick();
    }, 12000);
    return () => clearInterval(id);
  }, [autoRealtime, autoRealtimeTick]);

  useEffect(() => {
    // En cada montaje queda apagado por defecto.
    autoRealtimeUserEnabledRef.current = false;
    setAutoRealtime(false);
    setAutoStatus('inactivo');
  }, []);

  return (
    <ScrollView contentContainerStyle={styles.scroll} keyboardShouldPersistTaps="always">
      <Text style={styles.title}>Supabase · health (dev)</Text>
      <Text style={styles.muted}>
        Conexión con anon key. Los resultados dependen de RLS y de si hay sesión. No uses esto en
        producción pública.
      </Text>

      <View style={styles.card}>
        <Text style={styles.label}>Entorno</Text>
        <Text>Host: {env.urlHost}</Text>
        <Text>Anon key: {env.keySuffix}</Text>
        <Text>Configurado: {env.configured ? 'sí' : 'no'}</Text>
      </View>

      <View style={styles.card}>
        <Text style={styles.label}>Sesión (prueba RLS)</Text>
        <Text style={styles.small}>{userLabel ?? 'Pulsa «Refrescar sesión»'}</Text>
        <TextInput
          style={styles.input}
          placeholder="email de prueba"
          placeholderTextColor="#888"
          autoCapitalize="none"
          keyboardType="email-address"
          value={email}
          onChangeText={setEmail}
        />
        <TextInput
          style={styles.input}
          placeholder="contraseña"
          placeholderTextColor="#888"
          secureTextEntry
          value={password}
          onChangeText={setPassword}
        />
        <View style={styles.authButtons}>
          <Pressable
            style={({ pressed }) => [styles.btn, styles.btnBlock, pressed && styles.btnPressed]}
            disabled={sessionBusy}
            onPress={() => {
              void signIn();
            }}
            hitSlop={{ top: 8, bottom: 8, left: 8, right: 8 }}>
            <Text style={styles.btnText}>Entrar</Text>
          </Pressable>
          <Pressable
            style={({ pressed }) => [
              styles.btn,
              styles.btnSecondary,
              styles.btnBlock,
              pressed && styles.btnPressed,
            ]}
            disabled={sessionBusy}
            onPress={() => void signOut()}
            hitSlop={{ top: 8, bottom: 8, left: 8, right: 8 }}>
            <Text style={styles.btnTextDark}>Salir</Text>
          </Pressable>
          <Pressable
            style={({ pressed }) => [
              styles.btn,
              styles.btnSecondary,
              styles.btnBlock,
              pressed && styles.btnPressed,
            ]}
            disabled={sessionBusy}
            onPress={() => void refreshSession()}
            hitSlop={{ top: 8, bottom: 8, left: 8, right: 8 }}>
            <Text style={styles.btnTextDark}>Refrescar sesión</Text>
          </Pressable>
        </View>
        {sessionBusy ? (
          <View style={styles.busyRow}>
            <ActivityIndicator />
            <Text style={styles.small}> Actualizando…</Text>
          </View>
        ) : null}
        {authMsg ? <Text style={styles.warn}>{authMsg}</Text> : null}
      </View>

      <View style={styles.card}>
        <Text style={styles.label}>Insertar filas manualmente (RLS)</Text>
        <Text style={styles.small}>
          Si no tienes fila en user_profiles, rellena empresa y sucursal (UUID arriba) antes del clic para
          reutilizar esos UUID en el insert; si no, se generan al azar. Crea la fila en public.user_profiles
          solo si tu proyecto tiene política INSERT para tu usuario (copiar SQL desde docs/sql/user_profiles_rls_dev_policies.sql o profiles_rls_dev_policies.sql).
          Luego inserta producto, cliente, proveedor, compra, OC y traslado DEMO-*. Cliente/Proveedor ya no
          requieren carga manual: si dejas campos vacíos, se autogeneran.
        </Text>
        <Pressable
          style={[styles.btn, styles.btnBlock, insertBusy && styles.btnDisabled]}
          disabled={insertBusy || sessionBusy}
          onPress={() => void runOneClickAll()}>
          <Text style={styles.btnText}>1 clic: generar e insertar todo</Text>
        </Pressable>
        <Pressable
          style={[
            styles.btn,
            styles.btnSecondary,
            styles.btnBlock,
            (insertBusy || sessionBusy) && styles.btnDisabled,
          ]}
          disabled={insertBusy || sessionBusy}
          onPress={() =>
            setAutoRealtime((v) => {
              const next = !v;
              autoRealtimeUserEnabledRef.current = next;
              if (!next) setAutoStatus('inactivo');
              return next;
            })
          }>
          <Text style={styles.btnTextDark}>
            {autoRealtime ? 'Detener tiempo real' : 'Activar tiempo real'}
          </Text>
        </Pressable>
        <Text style={styles.small}>Auto realtime: {autoStatus}</Text>
        <Text style={styles.small}>
          Tras entrar: «Cargar contexto» si ya existe tu fila en Supabase. UUID manuales en la app no sustituyen
          esa fila para RLS del servidor (productos/clientes/proveedores suelen exigir admin vía BD; OC y traslados
          usan tu id como empleado_asignado).
        </Text>
        <Pressable
          style={[styles.btn, styles.btnSecondary, styles.btnBlock, insertBusy && styles.btnDisabled]}
          disabled={insertBusy || ctxBusy}
          onPress={() => void loadRlsContext()}>
          <Text style={styles.btnTextDark}>Cargar contexto (user_profiles)</Text>
        </Pressable>
        {ctxBusy ? (
          <View style={styles.busyRow}>
            <ActivityIndicator />
            <Text style={styles.small}> Leyendo perfil…</Text>
          </View>
        ) : null}
        {ctxMsg ? <Text style={styles.hint}>{ctxMsg}</Text> : null}
        {rlsCtx ? (
          <Text style={styles.mono}>
            empresa_id: {rlsCtx.empresa_id.slice(0, 8)}…{'\n'}
            sucursal_id: {rlsCtx.sucursal_id ? `${rlsCtx.sucursal_id.slice(0, 8)}…` : '(null)'}{'\n'}
            rol: {rlsCtx.app_role ?? '—'} · origen: {rlsCtx.source}
            {lastCompraId ? `\núltima compra: ${lastCompraId.slice(0, 8)}…` : ''}
            {lastOcId ? `\núltima OC: ${lastOcId.slice(0, 8)}…` : ''}
            {lastTrId ? `\núltimo traslado: ${lastTrId.slice(0, 8)}…` : ''}
          </Text>
        ) : null}
        <Text style={styles.subLabel}>Contexto manual (si falla la lectura de perfil)</Text>
        <Text style={styles.hint}>
          No hace falta pegar UUID a mano: usa los botones. Si inventas empresa/sucursal nuevos,
          tu fila en user_profiles (en Supabase) debe usar los mismos UUID o RLS rechazará inserts.
        </Text>
        <View style={styles.genRow}>
          <Pressable
            style={[styles.btnGen, styles.btnSecondary]}
            onPress={() => setManualEmpresaId(randomUuid())}>
            <Text style={styles.btnTextDark}>UUID empresa</Text>
          </Pressable>
          <Pressable
            style={[styles.btnGen, styles.btnSecondary]}
            onPress={() => setManualSucursalId(randomUuid())}>
            <Text style={styles.btnTextDark}>UUID sucursal</Text>
          </Pressable>
          <Pressable
            style={[styles.btnGen, styles.btn]}
            onPress={() => {
              setManualEmpresaId(randomUuid());
              setManualSucursalId(randomUuid());
            }}>
            <Text style={styles.btnText}>Ambos</Text>
          </Pressable>
        </View>
        <TextInput
          style={styles.input}
          placeholder="empresa_id UUID"
          placeholderTextColor="#888"
          autoCapitalize="none"
          value={manualEmpresaId}
          onChangeText={setManualEmpresaId}
        />
        <TextInput
          style={styles.input}
          placeholder="sucursal_id UUID (recomendado para OC/traslados/compras)"
          placeholderTextColor="#888"
          autoCapitalize="none"
          value={manualSucursalId}
          onChangeText={setManualSucursalId}
        />
        <Pressable
          style={[styles.btn, styles.btnSecondary, styles.btnBlock]}
          onPress={applyManualContext}>
          <Text style={styles.btnTextDark}>Aplicar manual</Text>
        </Pressable>

        <Text style={styles.subLabel}>Producto</Text>
        <TextInput
          style={styles.input}
          placeholder="sku_codigo (opcional)"
          placeholderTextColor="#888"
          value={prodSku}
          onChangeText={setProdSku}
        />
        <TextInput
          style={styles.input}
          placeholder="nombre (opcional)"
          placeholderTextColor="#888"
          value={prodNombre}
          onChangeText={setProdNombre}
        />
        <Pressable
          style={[styles.btn, styles.btnBlock, insertBusy && styles.btnDisabled]}
          disabled={insertBusy}
          onPress={() => void insertProducto()}>
          <Text style={styles.btnText}>Insertar producto</Text>
        </Pressable>

        <Text style={styles.subLabel}>Cliente</Text>
        <TextInput
          style={styles.input}
          placeholder="num_documento"
          placeholderTextColor="#888"
          value={cliDoc}
          onChangeText={setCliDoc}
        />
        <TextInput
          style={styles.input}
          placeholder="razon_social"
          placeholderTextColor="#888"
          value={cliRazon}
          onChangeText={setCliRazon}
        />
        <Pressable
          style={[styles.btn, styles.btnBlock, insertBusy && styles.btnDisabled]}
          disabled={insertBusy}
          onPress={() => void insertCliente()}>
          <Text style={styles.btnText}>Insertar cliente</Text>
        </Pressable>

        <Text style={styles.subLabel}>Proveedor</Text>
        <TextInput
          style={styles.input}
          placeholder="num_documento"
          placeholderTextColor="#888"
          value={provDoc}
          onChangeText={setProvDoc}
        />
        <TextInput
          style={styles.input}
          placeholder="razon_social"
          placeholderTextColor="#888"
          value={provRazon}
          onChangeText={setProvRazon}
        />
        <Pressable
          style={[styles.btn, styles.btnBlock, insertBusy && styles.btnDisabled]}
          disabled={insertBusy}
          onPress={() => void insertProveedor()}>
          <Text style={styles.btnText}>Insertar proveedor</Text>
        </Pressable>

        <Text style={styles.subLabel}>Compra</Text>
        <Pressable
          style={[styles.btn, styles.btnBlock, insertBusy && styles.btnDisabled]}
          disabled={insertBusy}
          onPress={() => void insertCompraEnc()}>
          <Text style={styles.btnText}>Crear compras_encabezado</Text>
        </Pressable>
        <TextInput
          style={styles.input}
          placeholder="id_compra UUID (o vacío = última creada aquí)"
          placeholderTextColor="#888"
          autoCapitalize="none"
          value={overrideCompraId}
          onChangeText={setOverrideCompraId}
        />
        <Pressable
          style={[styles.btn, styles.btnBlock, insertBusy && styles.btnDisabled]}
          disabled={insertBusy}
          onPress={() => void insertCompraDet()}>
          <Text style={styles.btnText}>Insertar compras_detalle (línea vacía)</Text>
        </Pressable>

        <Text style={styles.subLabel}>Orden de compra</Text>
        <TextInput
          style={styles.input}
          placeholder="nota_encargado"
          placeholderTextColor="#888"
          value={ocNota}
          onChangeText={setOcNota}
        />
        <Pressable
          style={[styles.btn, styles.btnBlock, insertBusy && styles.btnDisabled]}
          disabled={insertBusy}
          onPress={() => void insertOcEnc()}>
          <Text style={styles.btnText}>Crear ordenes_compra_encabezado (BORRADOR)</Text>
        </Pressable>
        <TextInput
          style={styles.input}
          placeholder="id_orden_compra (o vacío = última OC)"
          placeholderTextColor="#888"
          autoCapitalize="none"
          value={overrideOcId}
          onChangeText={setOverrideOcId}
        />
        <TextInput
          style={styles.input}
          placeholder="cod_producto línea"
          placeholderTextColor="#888"
          value={ocLineCod}
          onChangeText={setOcLineCod}
        />
        <TextInput
          style={styles.input}
          placeholder="cantidad"
          placeholderTextColor="#888"
          keyboardType="decimal-pad"
          value={ocLineQty}
          onChangeText={setOcLineQty}
        />
        <Pressable
          style={[styles.btn, styles.btnBlock, insertBusy && styles.btnDisabled]}
          disabled={insertBusy}
          onPress={() => void insertOcDet()}>
          <Text style={styles.btnText}>Insertar ordenes_compra_detalle</Text>
        </Pressable>

        <Text style={styles.subLabel}>Traslado</Text>
        <TextInput
          style={styles.input}
          placeholder="nota_traslado"
          placeholderTextColor="#888"
          value={trNota}
          onChangeText={setTrNota}
        />
        <Pressable
          style={[styles.btn, styles.btnBlock, insertBusy && styles.btnDisabled]}
          disabled={insertBusy}
          onPress={() => void insertTrEnc()}>
          <Text style={styles.btnText}>Crear traslados_encabezado (BORRADOR)</Text>
        </Pressable>
        <TextInput
          style={styles.input}
          placeholder="id_traslado (o vacío = último traslado)"
          placeholderTextColor="#888"
          autoCapitalize="none"
          value={overrideTrId}
          onChangeText={setOverrideTrId}
        />
        <TextInput
          style={styles.input}
          placeholder="cod_producto línea"
          placeholderTextColor="#888"
          value={trLineCod}
          onChangeText={setTrLineCod}
        />
        <TextInput
          style={styles.input}
          placeholder="cantidad"
          placeholderTextColor="#888"
          keyboardType="decimal-pad"
          value={trLineQty}
          onChangeText={setTrLineQty}
        />
        <Pressable
          style={[styles.btn, styles.btnBlock, insertBusy && styles.btnDisabled]}
          disabled={insertBusy}
          onPress={() => void insertTrDet()}>
          <Text style={styles.btnText}>Insertar traslados_detalle</Text>
        </Pressable>

        {insertMsg ? <Text style={styles.warn}>{insertMsg}</Text> : null}
      </View>

      <Pressable
        style={[styles.btn, styles.btnWide, loading && styles.btnDisabled]}
        onPress={runProbes}
        disabled={loading}>
        {loading ? (
          <ActivityIndicator color="#fff" />
        ) : (
          <Text style={styles.btnText}>Ejecutar pruebas SELECT (1 fila)</Text>
        )}
      </Pressable>

      {probes?.map((p) => (
        <View key={p.table} style={[styles.card, p.ok ? styles.cardOk : styles.cardBad]}>
          <Text style={styles.tableName}>{p.table}</Text>
          <Text style={styles.small}>{p.detail}</Text>
        </View>
      ))}

      <Text style={styles.footer}>
        Para pruebas por rol automatizadas usa: scripts/rls-diagnostics (npm run diag).
      </Text>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  scroll: { padding: 16, paddingBottom: 48 },
  center: { flex: 1, padding: 24, justifyContent: 'center' },
  title: { fontSize: 20, fontWeight: '700', marginBottom: 8 },
  muted: { opacity: 0.75, marginBottom: 16, lineHeight: 20 },
  card: {
    borderWidth: 1,
    borderColor: 'rgba(128,128,128,0.35)',
    borderRadius: 10,
    padding: 12,
    marginBottom: 12,
  },
  cardOk: { borderColor: 'rgba(34,197,94,0.5)' },
  cardBad: { borderColor: 'rgba(239,68,68,0.55)' },
  label: { fontWeight: '600', marginBottom: 6 },
  tableName: { fontWeight: '700', marginBottom: 4 },
  small: { fontSize: 13, opacity: 0.9 },
  input: {
    borderWidth: 1,
    borderColor: 'rgba(128,128,128,0.4)',
    borderRadius: 8,
    paddingHorizontal: 12,
    paddingVertical: 10,
    marginBottom: 8,
    fontSize: 16,
  },
  row: { flexDirection: 'row', flexWrap: 'wrap', gap: 8, marginTop: 8 },
  authButtons: { marginTop: 8, gap: 10 },
  btnBlock: {
    minHeight: 48,
    width: '100%',
    maxWidth: 400,
    alignSelf: 'center',
  },
  btnPressed: { opacity: 0.85 },
  busyRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: 8,
    gap: 8,
  },
  btn: {
    backgroundColor: '#2563eb',
    paddingVertical: 12,
    paddingHorizontal: 14,
    borderRadius: 8,
    alignItems: 'center',
    justifyContent: 'center',
  },
  btnSecondary: { backgroundColor: '#e5e7eb' },
  btnWide: { marginBottom: 16 },
  btnDisabled: { opacity: 0.6 },
  btnText: { color: '#fff', fontWeight: '600' },
  btnTextDark: { color: '#111', fontWeight: '600' },
  warn: { color: '#b45309', marginTop: 8, fontSize: 13 },
  hint: { fontSize: 12, opacity: 0.8, marginTop: 8, lineHeight: 18 },
  subLabel: { fontWeight: '600', marginTop: 14, marginBottom: 6, fontSize: 14 },
  mono: {
    fontFamily: Platform.select({ ios: 'Menlo', android: 'monospace', default: 'monospace' }),
    fontSize: 11,
    marginTop: 8,
    lineHeight: 16,
    opacity: 0.9,
  },
  genRow: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 8,
    marginBottom: 10,
    marginTop: 4,
  },
  btnGen: {
    paddingVertical: 10,
    paddingHorizontal: 12,
    borderRadius: 8,
    alignItems: 'center',
    justifyContent: 'center',
  },
  footer: { fontSize: 12, opacity: 0.65, marginTop: 24, lineHeight: 18 },
});
