#!/usr/bin/env python3
"""
Unifica las dos filas *No priority* del Priority board (Project 11).

GitHub muestra una fila para items sin valor en Priority y otra para la opcion
explicita "No Priority". Este script asigna "No Priority" a todo lo que esta vacio,
dejando una sola swimlane (la de la opcion explicita). No borra issues ni items.

  cd erp-satelite
  python scripts/merge_empty_priority_to_no_priority.py --dry-run
  python scripts/merge_empty_priority_to_no_priority.py
"""
from __future__ import annotations

import argparse
import json
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
PROJECT_NUMBER = 11
OWNER = "Abraha33"
PROJECT_ID = "PVT_kwHOCgQ2Ec4BSVkL"


def run_gh(args: list[str], cwd: Path = ROOT) -> tuple[int, str]:
    r = subprocess.run(
        ["gh"] + args,
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
        cwd=cwd,
    )
    out = (r.stdout or "") + (r.stderr or "")
    return r.returncode, out.strip()


def load_priority_field_ids() -> tuple[str, str]:
    code, out = run_gh(
        [
            "project",
            "field-list",
            str(PROJECT_NUMBER),
            "--owner",
            OWNER,
            "--format",
            "json",
        ]
    )
    if code != 0:
        print(out, file=sys.stderr)
        sys.exit(1)
    data = json.loads(out)
    field_id = None
    no_priority_opt = None
    for f in data.get("fields", []):
        if f.get("name") != "Priority":
            continue
        field_id = f["id"]
        for opt in f.get("options") or []:
            if opt.get("name") == "No Priority":
                no_priority_opt = opt["id"]
                break
        break
    if not field_id or not no_priority_opt:
        print("Priority field or 'No Priority' option not found.", file=sys.stderr)
        sys.exit(1)
    return field_id, no_priority_opt


def fetch_all_items(limit: int = 5000) -> list[dict]:
    code, out = run_gh(
        [
            "project",
            "item-list",
            str(PROJECT_NUMBER),
            "--owner",
            OWNER,
            "-L",
            str(limit),
            "--format",
            "json",
        ]
    )
    if code != 0:
        print(out, file=sys.stderr)
        sys.exit(1)
    data = json.loads(out)
    return data.get("items", [])


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--sleep", type=float, default=0.15, help="Pause between edits (rate limit)")
    args = parser.parse_args()

    code, _ = run_gh(["project", "view", str(PROJECT_NUMBER), "--owner", OWNER])
    if code != 0:
        print("gh project not available or not authenticated.", file=sys.stderr)
        sys.exit(1)

    field_id, no_priority_id = load_priority_field_ids()
    items = fetch_all_items()
    empty = [it for it in items if not it.get("priority")]
    already = sum(1 for it in items if it.get("priority") == "No Priority")
    other = [it for it in items if it.get("priority") and it.get("priority") != "No Priority"]

    print(f"Total items: {len(items)}")
    print(f"  Priority empty (swimlane duplicada): {len(empty)}")
    print(f"  Already 'No Priority': {already}")
    print(f"  P0/P1/P2/otros: {len(other)}")

    if not empty:
        print("Nada que unificar.")
        return

    if args.dry_run:
        print(f"\n--dry-run: se asignaria 'No Priority' a {len(empty)} items.")
        for it in empty[:15]:
            print(f"  - {it.get('id')}: {it.get('title', '')[:70]}")
        if len(empty) > 15:
            print(f"  ... y {len(empty) - 15} mas")
        return

    ok = 0
    for i, it in enumerate(empty):
        item_id = it["id"]
        code, out = run_gh(
            [
                "project",
                "item-edit",
                "--id",
                item_id,
                "--project-id",
                PROJECT_ID,
                "--field-id",
                field_id,
                "--single-select-option-id",
                no_priority_id,
            ]
        )
        if code != 0:
            print(f"FAIL {item_id}: {out}", file=sys.stderr)
        else:
            ok += 1
        if args.sleep and i < len(empty) - 1:
            time.sleep(args.sleep)
    print(f"Hecho. Asignado 'No Priority': {ok} / {len(empty)}")


if __name__ == "__main__":
    main()
