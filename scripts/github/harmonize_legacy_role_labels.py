#!/usr/bin/env python3
"""
Align GitHub issues with the role/* taxonomy from README:
- If an issue has any role/*, remove legacy flat labels: frontend, backend, database, docs.
- If an issue has no role/* but has legacy label(s), add the matching role/* (one role:
  priority database > backend > frontend > docs if several legacies) and remove legacies.

  cd erp-satelite
  python scripts/harmonize_legacy_role_labels.py --dry-run
  python scripts/harmonize_legacy_role_labels.py
"""
from __future__ import annotations

import argparse
import json
import subprocess
import sys
import time
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent

LEGACY = frozenset({"frontend", "backend", "database", "docs"})
LEGACY_TO_ROLE = {
    "frontend": "role/frontend",
    "backend": "role/backend",
    "database": "role/database",
    "docs": "role/docs-adr",
}
# Si hay varias legacy sin role, una sola fuente de verdad (mas especificas primero)
LEGACY_PRIORITY = ["database", "backend", "frontend", "docs"]


def run_gh(args: list[str]) -> tuple[int, str]:
    r = subprocess.run(
        ["gh"] + args,
        capture_output=True,
        text=True,
        cwd=REPO_ROOT,
    )
    out = (r.stdout or "") + (r.stderr or "")
    return r.returncode, out.strip()


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--limit", type=int, default=500)
    ap.add_argument("--sleep", type=float, default=0.08)
    args = ap.parse_args()

    code, out = run_gh(["repo", "view", "--json", "name"])
    if code != 0:
        print("Run from erp-satelite/ with gh auth.", file=sys.stderr)
        sys.exit(1)

    code, out = run_gh(
        [
            "issue",
            "list",
            "--state",
            "all",
            "--limit",
            str(args.limit),
            "--json",
            "number,labels",
        ]
    )
    if code != 0:
        print(out, file=sys.stderr)
        sys.exit(1)

    issues = json.loads(out)
    changed = 0

    for item in issues:
        num = item["number"]
        names = {x["name"] for x in item.get("labels") or []}
        roles = {n for n in names if n.startswith("role/")}
        legacies_present = sorted(names & LEGACY)

        if not legacies_present:
            continue

        to_remove = list(legacies_present)
        to_add: list[str] = []

        if roles:
            action = f"#{num}: remove legacy {to_remove} (has {sorted(roles)})"
        else:
            chosen_legacy = None
            for key in LEGACY_PRIORITY:
                if key in names:
                    chosen_legacy = key
                    break
            if not chosen_legacy:
                continue
            new_role = LEGACY_TO_ROLE[chosen_legacy]
            to_add.append(new_role)
            action = f"#{num}: add {new_role}, remove {to_remove}"

        if args.dry_run:
            print(f"  would {action}")
            changed += 1
            continue

        for lbl in to_add:
            code, err = run_gh(["issue", "edit", str(num), "--add-label", lbl])
            if code != 0:
                print(f"  ERR add #{num} {lbl}: {err}", file=sys.stderr)
            elif args.sleep:
                time.sleep(args.sleep)
        for lbl in to_remove:
            code, err = run_gh(["issue", "edit", str(num), "--remove-label", lbl])
            if code != 0:
                print(f"  ERR remove #{num} {lbl}: {err}", file=sys.stderr)
            elif args.sleep:
                time.sleep(args.sleep)
        print(f"  OK {action}")
        changed += 1

    print(f"\nDone. Issues touched: {changed}")


if __name__ == "__main__":
    main()
