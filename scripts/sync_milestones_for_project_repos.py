#!/usr/bin/env python3
r"""
Para cada línea en `scripts/project_milestone_repos.txt` (Owner/repo), ejecuta:
  python scripts/ensure_roadmap_milestones.py --repo <línea>
  python scripts/sync_issue_milestones.py --apply --repo <línea> [--state ...]

Uso (desde erp-satelite/):
  python scripts/sync_milestones_for_project_repos.py
  python scripts/sync_milestones_for_project_repos.py --dry-run
  python scripts/sync_milestones_for_project_repos.py --repos-file mi_lista.txt

Antes de incluir un repo: enlázalo al Project 11 para que las issues aparezcan en el tablero:
  gh project link 11 --owner Abraha33 --repo NOMBRE_REPO
"""
from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
LIST_DEFAULT = Path(__file__).resolve().parent / "project_milestone_repos.txt"


def load_repos(path: Path) -> list[str]:
    out: list[str] = []
    raw = path.read_text(encoding="utf-8")
    for line in raw.splitlines():
        line = line.split("#", 1)[0].strip()
        if not line or "/" not in line:
            continue
        out.append(line)
    return out


def main() -> None:
    ap = argparse.ArgumentParser(description="Ensure + sync milestones en varios repos.")
    ap.add_argument("--repos-file", type=Path, default=LIST_DEFAULT, help="Lista Owner/repo")
    ap.add_argument("--dry-run", action="store_true", help="Solo sync en dry-run (no --apply)")
    ap.add_argument("--state", choices=("open", "closed", "all"), default="all")
    ap.add_argument("--limit", type=int, default=500)
    ap.add_argument("--sleep", type=float, default=0.12)
    args = ap.parse_args()

    repos = load_repos(args.repos_file)
    if not repos:
        print(f"Sin repos en {args.repos_file}", file=sys.stderr)
        sys.exit(1)

    py = sys.executable
    for r in repos:
        print(f"\n=== {r} ===")
        e = subprocess.run(
            [py, str(REPO_ROOT / "scripts" / "ensure_roadmap_milestones.py"), "--repo", r],
            cwd=REPO_ROOT,
        )
        if e.returncode != 0:
            sys.exit(e.returncode)
        sync_cmd = [
            py,
            str(REPO_ROOT / "scripts" / "sync_issue_milestones.py"),
            "--repo",
            r,
            "--state",
            args.state,
            "--limit",
            str(args.limit),
            "--sleep",
            str(args.sleep),
        ]
        if args.dry_run:
            sync_cmd.append("--dry-run")
        else:
            sync_cmd.append("--apply")
        s = subprocess.run(sync_cmd, cwd=REPO_ROOT)
        if s.returncode != 0:
            sys.exit(s.returncode)

    print("\nListo para todos los repos listados.")


if __name__ == "__main__":
    main()
