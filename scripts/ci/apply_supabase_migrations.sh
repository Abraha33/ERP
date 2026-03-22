#!/usr/bin/env bash
# Aplica supabase/ci/*_stubs.sql y luego todas las migraciones en orden.
# Uso local: PGHOST PGPORT PGUSER PGPASSWORD PGDATABASE exportados (ej. contenedor Postgres).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
STUB="$ROOT/supabase/ci/0000_local_pg_supabase_stubs.sql"
MIG_DIR="$ROOT/supabase/migrations"

export PGHOST="${PGHOST:-localhost}"
export PGPORT="${PGPORT:-5432}"
export PGUSER="${PGUSER:-postgres}"
export PGDATABASE="${PGDATABASE:-postgres}"

if [[ ! -f "$STUB" ]]; then
  echo "Missing stub: $STUB" >&2
  exit 1
fi

echo "==> Stubs (auth / authenticated)"
psql -v ON_ERROR_STOP=1 -f "$STUB"

if [[ ! -d "$MIG_DIR" ]]; then
  echo "No migrations dir: $MIG_DIR" >&2
  exit 1
fi

mapfile -t migs < <(find "$MIG_DIR" -maxdepth 1 -name '*.sql' -type f | sort)
if [[ ${#migs[@]} -eq 0 ]]; then
  echo "No .sql files in $MIG_DIR" >&2
  exit 1
fi

for f in "${migs[@]}"; do
  echo "==> $(basename "$f")"
  psql -v ON_ERROR_STOP=1 -f "$f"
done

echo "==> OK: all migrations applied"
