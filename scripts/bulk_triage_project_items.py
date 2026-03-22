#!/usr/bin/env python3
"""
Rellena en masa campo Priority del Project 11 y asigna issues en GitHub.

Project 11 no puede poner Assignees vía `gh project item-edit` (solo single-select,
texto, número, fecha). Los asignatarios viven en el issue: se usa `gh issue edit`.

Uso (desde repo erp-satelite, con `gh` autenticado):
  python scripts/bulk_triage_project_items.py --dry-run
  python scripts/bulk_triage_project_items.py --priority P3 --assignee Abraha33
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
PRIORITY_FIELD_ID = "PVTSSF_lAHOCgQ2Ec4BSVkLzg_6wRI"
PRIORITY_OPTIONS = {
    "P0": "9c41ebb8",
    "P1": "18e8af45",
    "P2": "4d9d570f",
    "P3": "f747537c",
}


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


def priority_for_item(item: dict) -> str | None:
    for fv in (item.get("fieldValues") or {}).get("nodes") or []:
        if not fv:
            continue
        if (fv.get("field") or {}).get("name") == "Priority":
            return fv.get("name")
    return None


def issue_ref(item: dict) -> tuple[str, int] | None:
    c = item.get("content")
    if not c or c.get("number") is None:
        return None
    repo = (c.get("repository") or {}).get("nameWithOwner")
    if not repo:
        return None
    return repo, int(c["number"])


def assignee_logins(item: dict) -> list[str]:
    c = item.get("content")
    if not c:
        return []
    nodes = ((c.get("assignees") or {}).get("nodes")) or []
    return [n["login"] for n in nodes if n and n.get("login")]


def run_item_edit(item_id: str, option_id: str, dry_run: bool) -> bool:
    cmd = [
        "gh",
        "project",
        "item-edit",
        "--id",
        item_id,
        "--project-id",
        PROJECT_ID,
        "--field-id",
        PRIORITY_FIELD_ID,
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


def run_issue_add_assignee(repo: str, number: int, login: str, dry_run: bool) -> bool:
    cmd = [
        "gh",
        "issue",
        "edit",
        str(number),
        "--repo",
        repo,
        "--add-assignee",
        login,
    ]
    if dry_run:
        print("  [dry-run]", " ".join(cmd))
        return True
    r = subprocess.run(cmd, capture_output=True, text=True, cwd=ROOT.parent)
    if r.returncode != 0:
        err = (r.stderr or r.stdout or "").strip()
        if "already assigned" in err.lower() or "nothing to do" in err.lower():
            return True
        print(err, file=sys.stderr)
        return False
    return True


def main() -> None:
    p = argparse.ArgumentParser(description="Triage masivo: Priority en proyecto + assignee en issue.")
    p.add_argument(
        "--priority",
        choices=list(PRIORITY_OPTIONS),
        default="P3",
        help="Valor de Priority para ítems que aún no lo tienen (default P3).",
    )
    p.add_argument("--assignee", default="Abraha33", help="Login a añadir si el issue no tiene asignados.")
    p.add_argument("--dry-run", action="store_true", help="Solo imprimir comandos.")
    p.add_argument(
        "--sleep",
        type=float,
        default=0.25,
        help="Pausa en segundos entre llamadas a la API (default 0.25).",
    )
    p.add_argument(
        "--skip-assignee",
        action="store_true",
        help="No modificar issues (solo Priority en el proyecto).",
    )
    p.add_argument(
        "--skip-priority",
        action="store_true",
        help="No escribir Priority (solo assignee en issues vacíos).",
    )
    args = p.parse_args()
    opt_id = PRIORITY_OPTIONS[args.priority]

    stats = {
        "items": 0,
        "priority_set": 0,
        "priority_skip": 0,
        "assignee_set": 0,
        "assignee_skip": 0,
        "no_issue": 0,
    }
    after: str | None = None
    while True:
        data = gh_graphql(
            GRAPHQL / "project-items-title-and-fields.graphql",
            {"id": PROJECT_ID, "after": after},
        )
        node = data.get("data", {}).get("node")
        if not node:
            print("No project node", file=sys.stderr)
            sys.exit(1)
        items = node["items"]
        for n in items["nodes"]:
            stats["items"] += 1
            iid = n["id"]
            ref = issue_ref(n)
            pri = priority_for_item(n)

            if not args.skip_priority and pri is None:
                if run_item_edit(iid, opt_id, args.dry_run):
                    stats["priority_set"] += 1
                time.sleep(args.sleep)
            elif not args.skip_priority:
                stats["priority_skip"] += 1

            if args.skip_assignee:
                continue
            if not ref:
                stats["no_issue"] += 1
                continue

            logins = assignee_logins(n)
            if logins:
                stats["assignee_skip"] += 1
                continue
            repo, num = ref
            if run_issue_add_assignee(repo, num, args.assignee, args.dry_run):
                stats["assignee_set"] += 1
            time.sleep(args.sleep)

        page = items["pageInfo"]
        if not page["hasNextPage"]:
            break
        after = page["endCursor"]

    print(json.dumps(stats, indent=2), flush=True)


if __name__ == "__main__":
    main()
