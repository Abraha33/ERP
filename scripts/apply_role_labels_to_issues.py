#!/usr/bin/env python3
"""
Assign a single role/* label to open issues that lack one, using title + existing area/*.

  cd erp-satelite
  python scripts/apply_role_labels_to_issues.py --dry-run
  python scripts/apply_role_labels_to_issues.py

Requires: gh authenticated, labels created (ensure_role_labels.py).
"""
from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
import time
import unicodedata
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent

# [T01] .. [T35] roadmap satellite numbering (approximate focus)
T_NUM_ROLE: dict[int, str] = {
    1: "role/docs-adr",
    2: "role/platform",
    3: "role/database",
    4: "role/integration",
    5: "role/frontend",
    6: "role/integration",
    7: "role/database",
    8: "role/backend",
    9: "role/backend",
    10: "role/backend",
    11: "role/frontend",
    12: "role/frontend",
    13: "role/frontend",
    14: "role/frontend",
    15: "role/offline-sync",
    16: "role/frontend",
    17: "role/frontend",
    18: "role/frontend",
    19: "role/frontend",
    20: "role/offline-sync",
    21: "role/frontend",
    22: "role/frontend",
    23: "role/frontend",
    24: "role/frontend",
    25: "role/frontend",
    26: "role/frontend",
    27: "role/frontend",
    28: "role/frontend",
    29: "role/frontend",
    30: "role/frontend",
    31: "role/backend",
    32: "role/frontend",
    33: "role/frontend",
    34: "role/frontend",
    35: "role/frontend",
}

AREA_TO_ROLE = {
    "area/app": "role/frontend",
    "area/api": "role/backend",
    "area/db": "role/database",
    "area/docs": "role/docs-adr",
    "area/web": "role/frontend",
    "area/mobile": "role/frontend",
}

# (substring in normalized title, role) — order matters for first-match sections below
KEYWORD_ROLES: list[tuple[str, str]] = [
    ("pending_sync", "role/offline-sync"),
    ("resolucion de conflictos", "role/offline-sync"),
    ("indicador de conexion", "role/offline-sync"),
    ("sync subida", "role/offline-sync"),
    ("sync descarga", "role/offline-sync"),
    ("base de datos local", "role/offline-sync"),
    ("modelos locales", "role/offline-sync"),
    ("watermelon", "role/offline-sync"),
    ("playwright", "role/integration"),
    ("scraper", "role/integration"),
    ("milestones", "role/platform"),
    ("repo y entorno", "role/platform"),
    ("configuracion del repositorio", "role/platform"),
    ("variables de entorno", "role/platform"),
    ("cursor_context", "role/docs-adr"),
    ("excel_analysis", "role/integration"),
    ("analizar estructura del excel", "role/integration"),
    ("analizar el excel", "role/integration"),
    ("documentar columnas", "role/docs-adr"),
    ("stack tecnologico", "role/docs-adr"),
    ("stack definido", "role/docs-adr"),
    ("definicion y documentacion del stack", "role/docs-adr"),
    ("margin formula (document)", "role/docs-adr"),
    ("export format (document)", "role/docs-adr"),
    ("document deployment", "role/docs-adr"),
    ("document permission", "role/docs-adr"),
    ("order state machine (document)", "role/docs-adr"),
    ("picking list logic (document)", "role/docs-adr"),
    ("health check in deployment", "role/qa-release"),
    ("stability and performance", "role/qa-release"),
    ("integration test", "role/qa-release"),
    ("audit log", "role/security"),
    ("permission matrix", "role/security"),
    ("role middleware", "role/security"),
    ("role-based menu", "role/security"),
    ("restrict catalog", "role/security"),
    ("user roles (db + api)", "role/security"),
    ("politicas de seguridad por rol", "role/security"),
    ("whatsapp", "role/crm"),
    ("meta app", "role/crm"),
    ("webhook", "role/backend"),
    ("transcribe", "role/backend"),
    ("whisper", "role/backend"),
    ("fastapi", "role/backend"),
    ("openapi", "role/backend"),
    ("pydantic", "role/backend"),
    ("crud api", "role/backend"),
    ("get /", "role/backend"),
    ("post create", "role/backend"),
    ("storage bucket", "role/database"),
    ("supabase", "role/database"),
    ("tablas:", "role/database"),
    ("tabla ", "role/database"),
    ("trigger updated_at", "role/database"),
    ("import_log", "role/database"),
    ("seed script", "role/database"),
    ("run draft sql", "role/database"),
    ("core tables", "role/database"),
    ("provision supabase", "role/database"),
    ("db connection", "role/backend"),
    ("env validation on startup", "role/backend"),
    ("dependency injection", "role/backend"),
    ("validate adjustment", "role/backend"),
    ("unit tests for one crud", "role/qa-release"),
    ("pantalla ", "role/frontend"),
    ("vista admin", "role/frontend"),
    ("vista empleado", "role/frontend"),
    ("vista encargado", "role/frontend"),
    ("catalogo de productos", "role/frontend"),
    ("detalle de producto", "role/frontend"),
    ("login ", "role/frontend"),
    ("navegacion condicional", "role/frontend"),
    ("android app", "role/frontend"),
    ("responsive layout", "role/frontend"),
    ("chat view", "role/frontend"),
    ("conversations list", "role/frontend"),
    ("login page", "role/frontend"),
    ("order form", "role/frontend"),
    ("orders list", "role/frontend"),
    ("order detail", "role/frontend"),
    ("dashboard:", "role/frontend"),
    ("export financial", "role/backend"),
    ("create order button", "role/frontend"),
]


def run_gh(args: list[str]) -> tuple[int, str]:
    r = subprocess.run(
        ["gh"] + args,
        capture_output=True,
        text=True,
        cwd=REPO_ROOT,
    )
    out = (r.stdout or "") + (r.stderr or "")
    return r.returncode, out.strip()


def norm(s: str) -> str:
    s = s.lower()
    s = unicodedata.normalize("NFKD", s)
    return "".join(c for c in s if not unicodedata.combining(c))


def role_from_granular_t(t: str) -> str | None:
    """T0.1.1 .. T5.2.4 (phase.sprint.item)."""
    m = re.match(r"^T(\d+)\.(\d+)\.(\d+)\b", t)
    if not m:
        return None
    a, b, c = int(m.group(1)), int(m.group(2)), int(m.group(3))
    if a == 0 and b == 1:
        return {
            1: "role/platform",
            2: "role/database",
            3: "role/docs-adr",
            4: "role/platform",
            5: "role/integration",
            6: "role/integration",
            7: "role/docs-adr",
        }.get(c)
    if a == 1:
        if b == 1:
            return "role/database"
        if b == 2:
            return "role/frontend"
        if b == 3:
            return "role/database" if c == 1 else "role/frontend"
        if b == 4:
            return "role/database" if c == 1 else "role/frontend"
        if b == 5:
            return "role/database" if c == 1 else "role/frontend"
    if a == 5:
        return "role/offline-sync"
    return None


def infer_role(title: str, label_names: set[str]) -> str | None:
    for ln in label_names:
        if ln.startswith("role/"):
            return None
    for ln, role in AREA_TO_ROLE.items():
        if ln in label_names:
            return role

    t = title.strip()
    nt = norm(t)

    m = re.match(r"^\[T(\d+)\]\s*", t, re.I)
    if m:
        n = int(m.group(1))
        # [T06] en roadmap = Excel; en issues moviles a veces es otro tema
        if n == 6:
            if "excel" in nt or "analizar" in nt and "sae" in nt:
                return "role/integration"
            if "auth" in nt and "rol" in nt:
                return "role/security"
        if n in T_NUM_ROLE:
            return T_NUM_ROLE[n]

    m = re.match(r"^T(\d+)\.(\d+)\.(\d+)\s*[-–]\s*", t)
    if m:
        r = role_from_granular_t(t)
        if r:
            return r

    if re.match(r"^\[E\d+-S\d+-\d+\]", t, re.I):
        for kw, role in KEYWORD_ROLES:
            if kw in nt:
                return role
        if "frontend:" in nt or "frontend " in nt:
            return "role/frontend"
        return "role/backend"

    if re.match(r"^\[E\d+-P-\d+\]", t, re.I):
        if "repo structure" in nt or "python env" in nt:
            return "role/platform"
        if "schema" in nt or "migration" in nt or "database" in nt:
            return "role/database"
        if "api convention" in nt:
            return "role/backend"
        return "role/platform"

    for kw, role in KEYWORD_ROLES:
        if kw in nt:
            return role

    if "database schema draft" in nt or "migration strategy" in nt:
        return "role/database"
    if "api conventions" in nt:
        return "role/backend"
    return None


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--limit", type=int, default=400)
    ap.add_argument("--sleep", type=float, default=0.08)
    args = ap.parse_args()

    code, out = run_gh(
        [
            "issue",
            "list",
            "--state",
            "all",
            "--limit",
            str(args.limit),
            "--json",
            "number,title,labels,state",
        ]
    )
    if code != 0:
        print(out, file=sys.stderr)
        sys.exit(1)

    issues = json.loads(out)
    applied = 0
    skipped = 0
    unknown = 0

    for item in issues:
        num = item["number"]
        title = item.get("title") or ""
        state = item.get("state") or ""
        names = {x["name"] for x in item.get("labels") or []}
        if any(n.startswith("role/") for n in names):
            skipped += 1
            continue
        role = infer_role(title, names)
        if not role:
            print(f"  ? #{num} (no rule): {title[:70]}")
            unknown += 1
            continue
        if args.dry_run:
            print(f"  would #{num} -> {role}: {title[:65]}")
        else:
            code, err = run_gh(["issue", "edit", str(num), "--add-label", role])
            if code != 0:
                print(f"  ERR #{num}: {err}", file=sys.stderr)
            else:
                print(f"  OK #{num} -> {role}")
            if args.sleep:
                time.sleep(args.sleep)
        applied += 1

    print(
        f"\nSummary: applied/would={applied}, already had role={skipped}, unknown={unknown}"
    )


if __name__ == "__main__":
    main()
