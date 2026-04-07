/** UUID v4 para rellenar campos en dev (web: crypto.randomUUID; resto: fallback). */
export function randomUuid(): string {
  const c = globalThis.crypto;
  if (c != null && typeof c.randomUUID === 'function') {
    return c.randomUUID();
  }
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (ch) => {
    const r = (Math.random() * 16) | 0;
    const v = ch === 'x' ? r : (r & 0x3) | 0x8;
    return v.toString(16);
  });
}
