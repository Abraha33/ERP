#!/usr/bin/env python3
"""
Create Fase 0–5 rollups + sprints por fase (F1 S1–S5 ERP Satélite, F2–F5 según ROADMAP).

  cd erp-satelite
  python scripts/ensure_roadmap_milestones.py
  python scripts/ensure_roadmap_milestones.py --dry-run

Ejecutar antes de importar backlog o sincronizar milestones en issues.
"""
from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
_SCRIPTS = Path(__file__).resolve().parent
if str(_SCRIPTS) not in sys.path:
    sys.path.insert(0, str(_SCRIPTS))
from roadmap_milestones import all_ensure_milestone_titles, norm_milestone_key  # noqa: E402


def run_gh(args: list[str]) -> tuple[int, str]:
    r = subprocess.run(
        ["gh"] + args,
        capture_output=True,
        text=True,
        cwd=REPO_ROOT,
    )
    out = (r.stdout or "") + (r.stderr or "")
    return r.returncode, out.strip()


def list_open_milestone_titles() -> set[str]:
    code, out = run_gh(
        [
            "api",
            "repos/{owner}/{repo}/milestones",
            "--paginate",
            "--jq",
            ".[].title",
        ]
    )
    if code != 0:
        print(out, file=sys.stderr)
        sys.exit(1)
    titles = []
    for line in out.splitlines():
        line = line.strip().strip('"')
        if line:
            titles.append(line)
    return set(titles)


def create_milestone(title: str) -> bool:
    code, out = run_gh(
        [
            "api",
            "-X",
            "POST",
            "repos/{owner}/{repo}/milestones",
            "-f",
            f"title={title}",
            "-f",
            "state=open",
        ]
    )
    if code != 0:
        print(f"  FAIL {title}: {out}", file=sys.stderr)
        return False
    return True


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    code, _ = run_gh(["repo", "view", "--json", "name"])
    if code != 0:
        print("Ejecuta desde erp-satelite/ con gh autenticado.", file=sys.stderr)
        sys.exit(1)

    existing = list_open_milestone_titles()
    existing_norm = {norm_milestone_key(x) for x in existing}

    created = 0
    for title in all_ensure_milestone_titles():
        if norm_milestone_key(title) in existing_norm:
            print(f"  skip: {title}")
            continue
        if args.dry_run:
            print(f"  would create: {title}")
            created += 1
            continue
        print(f"  creating: {title}...", end=" ", flush=True)
        if create_milestone(title):
            print("OK")
            created += 1
            existing_norm.add(norm_milestone_key(title))
        else:
            print("FAIL")

    print(f"\nListo. Nuevos: {created}")


if __name__ == "__main__":
    main()
