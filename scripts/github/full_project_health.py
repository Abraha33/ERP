#!/usr/bin/env python3
r"""
Orquestador para el Project 11 y todos los repos listados:

1. Por cada repo: crear hitos del roadmap si faltan + alinear milestones en issues.
2. Unificar swimlanes de Priority vacías → "No Priority" (tablero).
3. Asegurar issue **[Stack]** en cada sprint y **[Stack]** en cada rollup de fase (0 y 2–5).

  cd erp-satelite
  python scripts/full_project_health.py --dry-run
  python scripts/full_project_health.py --apply

Equivale a encadenar `sync_milestones_for_project_repos`, `merge_empty_priority_to_no_priority`
y `ensure_milestone_stack_and_coverage`, con el mismo modo dry/apply en los pasos que lo admiten.
"""
from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
SCRIPTS = REPO_ROOT / "scripts"
LIST_DEFAULT = SCRIPTS / "project_milestone_repos.txt"


def load_repos(path: Path) -> list[str]:
    out: list[str] = []
    if not path.exists():
        return out
    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.split("#", 1)[0].strip()
        if line and "/" in line:
            out.append(line)
    return out


def run_script(args: list[str], *, cwd: Path = REPO_ROOT) -> None:
    r = subprocess.run([sys.executable, *args], cwd=cwd)
    if r.returncode != 0:
        sys.exit(r.returncode)


def main() -> None:
    ap = argparse.ArgumentParser(
        description="Hitos en todos los repos + Priority + issues Stack/Meta.",
    )
    ap.add_argument(
        "--repos-file",
        type=Path,
        default=LIST_DEFAULT,
        help="Lista Owner/repo (misma que project_milestone_repos.txt)",
    )
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--apply", action="store_true")
    ap.add_argument(
        "--skip-milestone-sync",
        action="store_true",
        help="No ejecutar ensure_roadmap + sync_issue por repo",
    )
    ap.add_argument(
        "--skip-priority-merge",
        action="store_true",
        help="No ejecutar merge_empty_priority_to_no_priority",
    )
    ap.add_argument(
        "--skip-stack-coverage",
        action="store_true",
        help="No ejecutar ensure_milestone_stack_and_coverage",
    )
    ap.add_argument("--state", choices=("open", "closed", "all"), default="all")
    ap.add_argument("--limit", type=int, default=500)
    ap.add_argument("--sleep-sync", type=float, default=0.12)
    args = ap.parse_args()

    if args.apply and args.dry_run:
        print("Usa solo --apply o solo --dry-run.", file=sys.stderr)
        sys.exit(2)
    if not args.apply and not args.dry_run:
        print("Indica --dry-run (vista previa) o --apply (escribir en GitHub).", file=sys.stderr)
        sys.exit(2)

    apply = args.apply
    repos = load_repos(args.repos_file)
    if not repos:
        print(f"Sin repos en {args.repos_file}", file=sys.stderr)
        sys.exit(1)

    if not args.skip_milestone_sync:
        print("\n=== Paso 1: hitos + alinear milestones en issues ===\n")
        for r in repos:
            print(f"\n--- {r} ---")
            ensure = [
                str(SCRIPTS / "ensure_roadmap_milestones.py"),
                "--repo",
                r,
            ]
            if not apply:
                ensure.append("--dry-run")
            run_script(ensure)

            sync = [
                str(SCRIPTS / "sync_issue_milestones.py"),
                "--repo",
                r,
                "--state",
                args.state,
                "--limit",
                str(args.limit),
                "--sleep",
                str(args.sleep_sync),
            ]
            if apply:
                sync.append("--apply")
            run_script(sync)

    if not args.skip_priority_merge:
        print("\n=== Paso 2: Priority vacío → No Priority (Project 11) ===\n")
        merge = [str(SCRIPTS / "merge_empty_priority_to_no_priority.py")]
        if not apply:
            merge.append("--dry-run")
        run_script(merge)

    if not args.skip_stack_coverage:
        print("\n=== Paso 3: [Stack] por sprint + [Stack] en rollups de fase ===\n")
        stack = [
            str(SCRIPTS / "ensure_milestone_stack_and_coverage.py"),
            "--all-repos",
            "--repos-file",
            str(args.repos_file),
        ]
        if apply:
            stack.append("--apply")
        run_script(stack)

    print("\nListo (full_project_health).")


if __name__ == "__main__":
    main()
