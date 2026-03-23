/**
 * Pantalla solo para desarrollo: prueba conexión a Supabase y SELECT mínimos
 * (útil para ver errores RLS / PostgREST en dispositivo o web local).
 *
 * En builds de producción __DEV__ es false: no se muestra el contenido útil.
 */
import { useCallback, useEffect, useState } from 'react';
import {
  ActivityIndicator,
  Pressable,
  ScrollView,
  StyleSheet,
  TextInput,
} from 'react-native';
import { useRouter } from 'expo-router';

import { Text, View } from '@/components/Themed';
import { getSupabaseClient, getSupabaseEnvSummary } from '@/lib/supabase';

type Probe = { table: string; ok: boolean; detail: string };

const TABLES: { table: string; select: string }[] = [
  { table: 'profiles', select: 'id, app_role, empresa_id' },
  { table: 'productos', select: 'id, empresa_id' },
  { table: 'compras_encabezado', select: 'id, empresa_id' },
  { table: 'compras_detalle', select: 'id, id_compra' },
  { table: 'ordenes_compra_encabezado', select: 'id, estado, empresa_id' },
  { table: 'ordenes_compra_detalle', select: 'id, id_orden_compra' },
  { table: 'traslados_encabezado', select: 'id, estado, empresa_id' },
  { table: 'traslados_detalle', select: 'id, id_traslado' },
  { table: 'clientes', select: 'id, empresa_id' },
  { table: 'proveedores', select: 'id, empresa_id' },
];

export default function SupabaseHealthScreen() {
  const router = useRouter();
  const env = getSupabaseEnvSummary();
  const supabase = getSupabaseClient();

  const [probes, setProbes] = useState<Probe[] | null>(null);
  const [loading, setLoading] = useState(false);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [authMsg, setAuthMsg] = useState<string | null>(null);
  const [userLabel, setUserLabel] = useState<string | null>(null);

  const runProbes = useCallback(async () => {
    const client = getSupabaseClient();
    if (!client) {
      setProbes([
        {
          table: '—',
          ok: false,
          detail: 'Falta EXPO_PUBLIC_SUPABASE_URL o EXPO_PUBLIC_SUPABASE_ANON_KEY en apps/mobile/.env',
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

  const refreshSession = useCallback(async () => {
    const client = getSupabaseClient();
    if (!client) return;
    const { data } = await client.auth.getSession();
    const u = data.session?.user;
    setUserLabel(u ? `${u.email ?? u.id}` : 'Sin sesión');
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
    if (error) setAuthMsg(error.message);
    else {
      setAuthMsg('Sesión OK');
      await refreshSession();
      await runProbes();
    }
  }, [email, password, refreshSession, runProbes]);

  const signOut = useCallback(async () => {
    const client = getSupabaseClient();
    if (!client) return;
    await client.auth.signOut();
    setAuthMsg('Sesión cerrada');
    setUserLabel('Sin sesión');
    await runProbes();
  }, [runProbes]);

  useEffect(() => {
    void refreshSession();
  }, [refreshSession]);

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

  return (
    <ScrollView contentContainerStyle={styles.scroll} keyboardShouldPersistTaps="handled">
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
        <View style={styles.row}>
          <Pressable style={styles.btn} onPress={signIn}>
            <Text style={styles.btnText}>Entrar</Text>
          </Pressable>
          <Pressable style={[styles.btn, styles.btnSecondary]} onPress={signOut}>
            <Text style={styles.btnTextDark}>Salir</Text>
          </Pressable>
          <Pressable style={[styles.btn, styles.btnSecondary]} onPress={refreshSession}>
            <Text style={styles.btnTextDark}>Refrescar sesión</Text>
          </Pressable>
        </View>
        {authMsg ? <Text style={styles.warn}>{authMsg}</Text> : null}
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
  btn: {
    backgroundColor: '#2563eb',
    paddingVertical: 10,
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
  footer: { fontSize: 12, opacity: 0.65, marginTop: 24, lineHeight: 18 },
});
