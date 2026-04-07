import 'react-native-url-polyfill/auto';

import AsyncStorage from '@react-native-async-storage/async-storage';
import Constants from 'expo-constants';
import { createClient, type SupabaseClient } from '@supabase/supabase-js';
import { Platform } from 'react-native';

/** AsyncStorage en web usa `window` (localStorage); en el prerender de Expo Web (Node) no existe. */
function createMemoryAuthStorage() {
  const memory = new Map<string, string>();
  return {
    getItem: (key: string) => Promise.resolve(memory.get(key) ?? null),
    setItem: (key: string, value: string) => {
      memory.set(key, value);
      return Promise.resolve();
    },
    removeItem: (key: string) => {
      memory.delete(key);
      return Promise.resolve();
    },
  };
}

function authStorageForRuntime() {
  if (Platform.OS === 'web' && typeof window === 'undefined') {
    return createMemoryAuthStorage();
  }
  return AsyncStorage;
}

type Extra = {
  supabaseUrl?: string;
  supabaseAnonKey?: string;
};

function readExtra(): Extra {
  const e = Constants.expoConfig?.extra;
  return e && typeof e === 'object' ? (e as Extra) : {};
}

/** Prefer `extra` from app.config.js (lee .env en el CLI); luego inline de Metro. */
function readSupabaseUrl(): string {
  const fromExtra = readExtra().supabaseUrl;
  if (fromExtra && fromExtra.length > 0) return fromExtra.trim();
  const e = process.env.EXPO_PUBLIC_SUPABASE_URL;
  return typeof e === 'string' ? e.trim() : '';
}

function readSupabaseAnonKey(): string {
  const fromExtra = readExtra().supabaseAnonKey;
  if (fromExtra && fromExtra.length > 0) return fromExtra.trim();
  const a = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY;
  if (typeof a === 'string' && a.trim().length > 0) return a.trim();
  const alt = process.env.EXPO_PUBLIC_SUPABASE_KEY;
  if (typeof alt === 'string' && alt.startsWith('eyJ')) return alt.trim();
  return '';
}

let client: SupabaseClient | null = null;
let clientFingerprint = '';

export function getSupabaseClient(): SupabaseClient | null {
  const url = readSupabaseUrl();
  const anonKey = readSupabaseAnonKey();
  if (!url || !anonKey) {
    client = null;
    clientFingerprint = '';
    return null;
  }
  const storage = authStorageForRuntime();
  const fp = `${url}\n${anonKey}\n${storage === AsyncStorage ? 'async' : 'mem'}`;
  if (!client || fp !== clientFingerprint) {
    clientFingerprint = fp;
    client = createClient(url, anonKey, {
      auth: {
        storage,
        persistSession: true,
        autoRefreshToken: true,
        detectSessionInUrl: false,
      },
    });
  }
  return client;
}

export function getSupabaseEnvSummary(): {
  configured: boolean;
  urlHost: string;
  keySuffix: string;
} {
  const url = readSupabaseUrl();
  const anonKey = readSupabaseAnonKey();
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
