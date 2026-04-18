#!/usr/bin/env python3
"""
Mejoras de datos para el Priority board (Project 11): Size en trabajo activo y subida de prioridad floja.

1) --fill-size: si Status es Ready / In progress / In review y Size vacio -> --default-size (default 2).
2) --bump-active-priority: si Status en esa lista y Priority es "No Priority" (o vacio) -> P2.

Requiere gh autenticado. IDs de campo se leen de `gh project field-list` (no hardcode P2 option si cambia el nombre).

  python scripts/priority_board_hygiene.py --dry-run
  python scripts/priority_board_hygiene.py --fill-size
  python scripts/priority_board_hygiene.py --bump-active-priority
  python scripts/priority_board_hygiene.py --fill-size --bump-active-priority
"""
from __future__ import annotations

import argparse
import json
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent
GRAPHQL = ROOT / "graphql"
PROJECT_ID = "PVT_kwHOCgQ2Ec4BSVkL"
PROJECT_NUMBER = 11
OWNER = "Abraha33"

ACTIVE_STATUSES = frozenset({"Ready", "In progress", "In review"})


def gh_graphql(query_file: Path, variables: dict) -> dict:
    cmd = ["gh", "api", "graphql", "-F", f"query=@{query_file}"]
    for k, v in variables.items():
        if v is None:
            continue
        cmd.extend(["-f", f"{k}={v}"])
    r = subprocess.run(cmd, capture_output=True, text=True, cwd=ROOT.parent)
    if r.returncode != 0:
        print(r.stderr, file=sys.stderr)
        sys.exit(r.returncode)
    return json.loads(r.stdout)


def load_project_fields() -> dict:
    r = subprocess.run(
        [
            "gh",
            "project",
            "field-list",
            str(PROJECT_NUMBER),
            "--owner",
            OWNER,
            "--format",
            "json",
        ],
        capture_output=True,
        text=True,
        cwd=ROOT.parent,
    )
    if r.returncode != 0:
        print(r.stderr, file=sys.stderr)
        sys.exit(r.returncode)
    return json.loads(r.stdout)


def field_id_by_name(data: dict, name: str) -> str:
    for f in data.get("fields", []):
        if f.get("name") == name:
            return f["id"]
    raise SystemExit(f"Campo no encontrado: {name}")


def priority_option_id(data: dict, label: str) -> str:
    for f in data.get("fields", []):
        if f.get("name") != "Priority":
            continue
        for opt in f.get("options") or []:
            if opt.get("name") == label:
                return opt["id"]
    raise SystemExit(f"Opcion Priority no encontrada: {label}")


def single_select_for_item(item: dict, field_name: str) -> str | None:
    for fv in (item.get("fieldValues") or {}).get("nodes") or []:
        if not fv or fv.get("name") is None:
            continue
        fn = (fv.get("field") or {}).get("name")
        if fn == field_name:
            return fv.get("name")
    return None


def number_for_item(item: dict, field_name: str) -> float | None:
    for fv in (item.get("fieldValues") or {}).get("nodes") or []:
        if fv.get("number") is None:
            continue
        fn = (fv.get("field") or {}).get("name")
        if fn == field_name:
            return float(fv["number"])
    return None


def run_item_edit_number(
    item_id: str, field_id: str, value: float, dry_run: bool
) -> bool:
    cmd = [
        "gh",
        "project",
        "item-edit",
        "--id",
        item_id,
        "--project-id",
        PROJECT_ID,
        "--field-id",
        field_id,
        "--number",
        str(value),
    ]
    if dry_run:
        print("  [dry-run]", " ".join(cmd))
        return True
    r = subprocess.run(cmd, capture_output=True, text=True, cwd=ROOT.parent)
    if r.returncode != 0:
        print(r.stderr or r.stdout, file=sys.stderr)
        return False
    return True


def run_item_edit_priority(
    item_id: str, field_id: str, option_id: str, dry_run: bool
) -> bool:
    cmd = [
        "gh",
        "project",
        "item-edit",
        "--id",
        item_id,
        "--project-id",
        PROJECT_ID,
        "--field-id",
        field_id,
        "--single-select-option-id",
        option_id,
    ]
    if dry_run:
        print("  [dry-run]", " ".join(cmd))
        return True
    r = subprocess.run(cmd, capture_output=True, text=True, cwd=ROOT.parent)
    if r.returncode != 0:
        print(r.stderr or r.stdout, file=sys.stderr)
        return False
    return True


def issue_label(item: dict) -> str:
    c = item.get("content")
    if not c:
        return item["id"]
    repo = (c.get("repository") or {}).get("nameWithOwner", "?")
    num = c.get("number")
    title = (c.get("title") or "")[:60]
    return f"{repo}#{num} {title}"


def main() -> None:
    p = argparse.ArgumentParser()
    p.add_argument("--dry-run", action="store_true")
    p.add_argument(
        "--fill-size",
        action="store_true",
        help="Rellenar Size en Ready / In progress / In review si falta",
    )
    p.add_argument(
        "--bump-active-priority",
        action="store_true",
        help='Poner Priority P2 si esta vacia o "No Priority" en columnas activas',
    )
    p.add_argument("--default-size", type=float, default=2.0)
    p.add_argument("--sleep", type=float, default=0.2)
    args = p.parse_args()

    if not args.fill_size and not args.bump_active_priority:
        p.error("Indica --fill-size y/o --bump-active-priority")

    meta = load_project_fields()
    size_field_id = field_id_by_name(meta, "Size")
    priority_field_id = field_id_by_name(meta, "Priority")
    p2_id = priority_option_id(meta, "P2")

    stats = {
        "items": 0,
        "size_set": 0,
        "size_skip": 0,
        "priority_set": 0,
        "priority_skip": 0,
    }

    after: str | None = None
    qfile = GRAPHQL / "project-items-title-and-fields.graphql"
    while True:
        data = gh_graphql(qfile, {"id": PROJECT_ID, "after": after})
        node = data.get("data", {}).get("node")
        if not node:
            print("No project", file=sys.stderr)
            sys.exit(1)
        items = node["items"]
        for n in items["nodes"]:
            stats["items"] += 1
            iid = n["id"]
            status = single_select_for_item(n, "Status")
            pri = single_select_for_item(n, "Priority")
            size_val = number_for_item(n, "Size")

            if status not in ACTIVE_STATUSES:
                if args.fill_size:
                    stats["size_skip"] += 1
                if args.bump_active_priority:
                    stats["priority_skip"] += 1
                continue

            if args.fill_size:
                if size_val is not None:
                    stats["size_skip"] += 1
                else:
                    print(issue_label(n))
                    if run_item_edit_number(
                        iid, size_field_id, args.default_size, args.dry_run
                    ):
                        stats["size_set"] += 1
                    time.sleep(args.sleep)

            if args.bump_active_priority:
                if pri and pri != "No Priority":
                    stats["priority_skip"] += 1
                else:
                    print(issue_label(n))
                    if run_item_edit_priority(
                        iid, priority_field_id, p2_id, args.dry_run
                    ):
                        stats["priority_set"] += 1
                    time.sleep(args.sleep)

        page = items["pageInfo"]
        if not page["hasNextPage"]:
            break
        after = page["endCursor"]

    print(json.dumps(stats, indent=2), flush=True)


if __name__ == "__main__":
    main()
