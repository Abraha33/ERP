#!/usr/bin/env python3
r"""
Crea un issue contenedor por cada **sprint 1-5** del plan original MVP Satélite
(hitos tipo "Sprint N - …") y los asigna al milestone rollup **Fase 2 — ERP Básico**.

Idempotente: no crea si ya existe un issue abierto o cerrado con el mismo título.

  cd erp-satelite
  python scripts/ensure_legacy_sprint_issues_fase2.py --dry-run
  python scripts/ensure_legacy_sprint_issues_fase2.py --apply -R Abraha33/erp-satelite
"""
from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

# Títulos y descripciones alineados a los milestones legacy Sprint 1-5 del repo.
MILESTONE = "Fase 2 — ERP Básico"
SPRINT_TICKETS: list[tuple[str, str]] = [
    (
        "[Sprint 1/5] Setup y puente de datos",
        """## Sprint 1 del plan MVP (contenedor)

- Stack documentado, repo configurado, Supabase con tablas iniciales y scraper listo para importar datos del SAE.
- Referencia temporal del plan original: ~semanas 1-2.

Enlaza aquí los issues granulares (`T1.1.*`, `[T01]`…`[T05]`, etc.) que cubran este bloque.""",
    ),
    (
        "[Sprint 2/5] Autenticación y base de datos",
        """## Sprint 2 del plan MVP (contenedor)

- Auth con Supabase, roles (admin, encargado, empleado) y RLS; backend con endpoints protegidos.
- Referencia temporal: ~semanas 3-4.

Enlaza issues de auth, RLS y CRUD base que correspondan a este bloque.""",
    ),
    (
        "[Sprint 3/5] Catálogo y navegación",
        """## Sprint 3 del plan MVP (contenedor)

- App muestra catálogo al empleado desde dispositivo físico; navegación principal.

Enlaza issues de catálogo, tabs y detalle de producto de este tramo.""",
    ),
    (
        "[Sprint 4/5] Recepción y traslados",
        """## Sprint 4 del plan MVP (contenedor)

- Movimientos de mercancía y stock actualizado en el backend.

Enlaza issues de recepción, traslados e historial de movimientos.""",
    ),
    (
        "[Sprint 5/5] Misiones y arqueo",
        """## Sprint 5 del plan MVP (contenedor)

- MVP completo en manos de usuarios: misiones de conteo, arqueo de caja, dashboard encargado, notificaciones básicas.

Enlaza issues de misiones, arqueo y cierre de MVP.""",
    ),
]


def run_gh(args: list[str], repo: str | None, cwd: Path) -> tuple[int, str]:
    cmd = ["gh"]
    if args and args[0] == "api":
        cmd.extend(args)
    elif repo and len(args) >= 2 and args[0] == "repo" and args[1] == "view":
        cmd.extend(["repo", "view", repo, *args[2:]])
    elif repo:
        cmd.append(args[0])
        cmd.extend(["-R", repo])
        cmd.extend(args[1:])
    else:
        cmd.extend(args)
    r = subprocess.run(
        cmd,
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
        cwd=cwd,
    )
    out = (r.stdout or "") + (r.stderr or "")
    return r.returncode, out.strip()


def existing_titles(repo: str, limit: int) -> set[str]:
    code, out = run_gh(
        [
            "issue",
            "list",
            "--state",
            "all",
            "--limit",
            str(limit),
            "--json",
            "title",
        ],
        repo=repo,
        cwd=ROOT,
    )
    if code != 0:
        print(out, file=sys.stderr)
        return set()
    try:
        data = json.loads(out)
    except json.JSONDecodeError:
        return set()
    return {(it.get("title") or "").strip() for it in data}


def create_issue(repo: str, title: str, body: str, dry_run: bool) -> bool:
    if dry_run:
        print(f"  would create: {title}")
        return True
    args = [
        "issue",
        "create",
        "--title",
        title,
        "--body",
        body,
        "--milestone",
        MILESTONE,
        "--label",
        "priority/P3",
    ]
    code, out = run_gh(args, repo=repo, cwd=ROOT)
    if code != 0:
        print(f"  FAIL {title}: {out}", file=sys.stderr)
        return False
    print(f"  OK: {title}")
    return True


def main() -> None:
    ap = argparse.ArgumentParser(description="Issues contenedor Sprint 1-5 → Fase 2 — ERP Básico.")
    ap.add_argument("--repo", "-R", metavar="OWNER/REPO", required=True)
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--apply", action="store_true")
    ap.add_argument("--issue-limit", type=int, default=500)
    args = ap.parse_args()

    if args.apply and args.dry_run:
        print("Usa solo --apply o solo --dry-run.", file=sys.stderr)
        sys.exit(2)
    if not args.apply and not args.dry_run:
        print("Indica --dry-run o --apply.", file=sys.stderr)
        sys.exit(2)

    repo = args.repo.strip()
    if "/" not in repo:
        print("Owner/repo inválido.", file=sys.stderr)
        sys.exit(2)

    code, _ = run_gh(["repo", "view", "--json", "name"], repo=repo, cwd=ROOT)
    if code != 0:
        print("Sin acceso al repo o gh no autenticado.", file=sys.stderr)
        sys.exit(1)

    dry = not args.apply
    have = existing_titles(repo, args.issue_limit)
    created = 0
    skipped = 0

    for title, body in SPRINT_TICKETS:
        if title in have:
            print(f"  skip (ya existe): {title}")
            skipped += 1
            continue
        if create_issue(repo, title, body, dry):
            created += 1
            have.add(title)

    mode = "dry-run" if dry else "apply"
    print(f"\nListo ({mode}): creados={created}, omitidos={skipped}")


if __name__ == "__main__":
    main()
