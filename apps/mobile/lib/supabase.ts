import { createClient, type SupabaseClient } from '@supabase/supabase-js';

const url = process.env.EXPO_PUBLIC_SUPABASE_URL?.trim() ?? '';
const anonKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY?.trim() ?? '';

let client: SupabaseClient | null = null;

export function getSupabaseClient(): SupabaseClient | null {
  if (!url || !anonKey) return null;
  if (!client) {
    client = createClient(url, anonKey, {
      auth: { persistSession: true, autoRefreshToken: true },
    });
  }
  return client;
}

export function getSupabaseEnvSummary(): {
  configured: boolean;
  urlHost: string;
  keySuffix: string;
} {
  let host = '';
  try {
    if (url) host = new URL(url).host;
  } catch {
    host = '(URL inválida)';
  }
  const keySuffix =
    anonKey.length > 8 ? `…${anonKey.slice(-4)}` : anonKey ? '(corta)' : '—';
  return {
    configured: Boolean(url && anonKey),
    urlHost: host || '—',
    keySuffix,
  };
}
