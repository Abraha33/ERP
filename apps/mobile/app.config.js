/**
 * Lee apps/mobile/.env en Node (donde corre Expo CLI) y lo expone en `extra` para que
 * la app no dependa solo del inline de Metro de process.env (a veces vacío si falla la resolución).
 */
const fs = require('fs');
const path = require('path');

const appJson = require('./app.json');

function parseEnvFile(filePath) {
  const out = {};
  if (!fs.existsSync(filePath)) return out;
  let text = fs.readFileSync(filePath, 'utf8');
  if (text.charCodeAt(0) === 0xfeff) text = text.slice(1);
  for (const line of text.split(/\r?\n/)) {
    const t = line.trim();
    if (!t || t.startsWith('#')) continue;
    const i = t.indexOf('=');
    if (i === -1) continue;
    const key = t.slice(0, i).trim();
    let val = t.slice(i + 1).trim();
    if (
      (val.startsWith('"') && val.endsWith('"')) ||
      (val.startsWith("'") && val.endsWith("'"))
    ) {
      val = val.slice(1, -1);
    }
    out[key] = val;
  }
  return out;
}

function loadEnvFiles(projectRoot) {
  const merged = {};
  // Orden: los últimos ganan. Incluye .en / .env.txt por si el archivo quedó mal nombrado (Windows).
  for (const name of ['.en', '.env.txt', '.env', '.env.local']) {
    Object.assign(merged, parseEnvFile(path.join(projectRoot, name)));
  }
  return merged;
}

const fileEnv = loadEnvFiles(__dirname);

function pick(name) {
  const v = process.env[name] ?? fileEnv[name];
  return typeof v === 'string' ? v.trim() : '';
}

const supabaseUrl = pick('EXPO_PUBLIC_SUPABASE_URL');
let supabaseAnonKey = pick('EXPO_PUBLIC_SUPABASE_ANON_KEY');
if (!supabaseAnonKey) {
  const alt = pick('EXPO_PUBLIC_SUPABASE_KEY');
  if (alt.startsWith('eyJ')) supabaseAnonKey = alt;
}

module.exports = {
  expo: {
    ...appJson.expo,
    extra: {
      ...(appJson.expo.extra ?? {}),
      supabaseUrl,
      supabaseAnonKey,
    },
  },
};
