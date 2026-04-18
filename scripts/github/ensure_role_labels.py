#!/usr/bin/env python3
"""
Create the minimal repo labels: role/* and priority/P0–P3.
No area/*, tipo/*, fase/* — etapas van en el campo Status del Project.

  cd erp-satelite && python scripts/ensure_role_labels.py
"""
from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent

# name -> (color without #, description)
LABELS: dict[str, tuple[str, str]] = {
    "role/frontend": ("1D76DB", "Compose / Android — UI producto (pantallas, navegacion)"),
    "role/backend": ("5319E7", "API, logica de negocio, servicios server-side"),
    "role/database": ("0E8A16", "Schema, migrations, RLS, SQL, Supabase"),
    "role/platform": ("FBCA04", "Repo, CI/CD, scripts, env, hygiene del Project"),
    "role/integration": ("D93F0B", "Excel SAE, scraper, import/export, mapeo legacy"),
    "role/qa-release": ("C2E0C6", "Pruebas dispositivo, release, verificacion pre-Done"),
    "role/crm": ("006B75", "WhatsApp, inbox, pipeline comercial (fases CRM)"),
    "role/offline-sync": ("BFDADC", "DB local, sync, conflictos (fase offline)"),
    "role/security": ("B60205", "Auth, secretos, hardening, revision RLS/authz"),
    "role/docs-adr": ("FEF2C0", "README, ADR, CURSOR_CONTEXT, guias"),
    "priority/P0": ("B60205", "Urgente / bloqueante (alinear con campo Priority P0 en el Project)"),
    "priority/P1": ("D93F0B", "Alta — sprint actual (campo Priority P1)"),
    "priority/P2": ("1D76DB", "Media (campo Priority P2)"),
    "priority/P3": ("6B7280", "Baja (campo Priority P3)"),
}


def run_gh(args: list[str]) -> tuple[int, str]:
    r = subprocess.run(
        ["gh"] + args,
        capture_output=True,
        text=True,
        cwd=REPO_ROOT,
    )
    out = (r.stdout or "") + (r.stderr or "")
    return r.returncode, out.strip()


def existing_labels() -> set[str]:
    code, out = run_gh(["label", "list", "--json", "name"])
    if code != 0:
        print(out, file=sys.stderr)
        sys.exit(1)
    data = json.loads(out)
    return {x["name"] for x in data}


def main() -> None:
    code, _ = run_gh(["repo", "view", "--json", "nameWithOwner"])
    if code != 0:
        print("Run from erp-satelite/ with gh authenticated.", file=sys.stderr)
        sys.exit(1)

    have = existing_labels()
    created = 0
    for name, (color, desc) in LABELS.items():
        if name in have:
            print(f"  skip (exists): {name}")
            continue
        code, out = run_gh(
            [
                "label",
                "create",
                name,
                "--color",
                color,
                "--description",
                desc,
            ]
        )
        if code != 0:
            print(f"  FAIL {name}: {out}", file=sys.stderr)
            continue
        print(f"  created: {name}")
        created += 1
    print(f"Done. Created: {created}")


if __name__ == "__main__":
    main()
