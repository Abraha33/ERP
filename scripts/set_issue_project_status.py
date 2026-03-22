#!/usr/bin/env python3
"""
Pone el campo **Status** del Project 11 para issues concretos del repo erp-satelite.

Uso (desde la raíz del repo erp-satelite, `gh` autenticado):
  python scripts/set_issue_project_status.py --issue 195 --status "In progress"
  python scripts/set_issue_project_status.py --issue 194,196,197,198 --status Ready
"""
from __future__ import annotations

import argparse
import json
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent
REPO_ROOT = ROOT.parent
GRAPHQL = ROOT / "graphql"

PROJECT_ID = "PVT_kwHOCgQ2Ec4BSVkL"
STATUS_FIELD_ID = "PVTSSF_lAHOCgQ2Ec4BSVkLzg_5tbo"
REPO_FULL = "Abraha33/erp-satelite"


def gh_graphql(query_file: Path, variables: dict) -> dict:
    cmd = ["gh", "api", "graphql", "-F", f"query=@{query_file}"]
    for k, v in variables.items():
        if v is None:
            continue
        cmd.extend(["-f", f"{k}={v}"])
    r = subprocess.run(cmd, capture_output=True, text=True, cwd=REPO_ROOT)
    if r.returncode != 0:
        print(r.stderr or r.stdout, file=sys.stderr)
        sys.exit(r.returncode)
    return json.loads(r.stdout)


def status_option_ids() -> dict[str, str]:
    data = gh_graphql(GRAPHQL / "project-fields.graphql", {"id": PROJECT_ID})
    nodes = data["data"]["node"]["fields"]["nodes"]
    for n in nodes:
        if not n or n.get("name") != "Status":
            continue
        return {o["name"]: o["id"] for o in n.get("options") or []}
    print("Status field not found", file=sys.stderr)
    sys.exit(1)


def iter_project_issues() -> list[tuple[str, int, str]]:
    """Yield (item_id, issue_number, current_status_name)."""
    after: str | None = None
    out: list[tuple[str, int, str]] = []
    while True:
        data = gh_graphql(
            GRAPHQL / "project-items-title-and-fields.graphql",
            {"id": PROJECT_ID, "after": after},
        )
        node = data.get("data", {}).get("node")
        if not node:
            break
        items = node["items"]
        for n in items["nodes"]:
            content = n.get("content")
            if not content or content.get("number") is None:
                continue
            repo = (content.get("repository") or {}).get("nameWithOwner")
            if repo != REPO_FULL:
                continue
            num = int(content["number"])
            st = ""
            for fv in (n.get("fieldValues") or {}).get("nodes") or []:
                if not fv:
                    continue
                fn = (fv.get("field") or {}).get("name")
                if fn == "Status":
                    st = fv.get("name") or ""
                    break
            out.append((n["id"], num, st))
        page = items["pageInfo"]
        if not page["hasNextPage"]:
            break
        after = page["endCursor"]
    return out


def set_status(item_id: str, option_id: str) -> bool:
    data = gh_graphql(
        GRAPHQL / "set-status.graphql",
        {
            "projectId": PROJECT_ID,
            "itemId": item_id,
            "fieldId": STATUS_FIELD_ID,
            "optionId": option_id,
        },
    )
    if data.get("errors"):
        print(data["errors"], file=sys.stderr)
        return False
    return True


def main() -> None:
    p = argparse.ArgumentParser(description="Project 11: Status por número de issue.")
    p.add_argument(
        "--issue",
        required=True,
        help="Número(s) de issue separados por coma, ej. 195 o 194,196,197",
    )
    p.add_argument(
        "--status",
        required=True,
        choices=[
            "Icebox",
            "Backlog",
            "Ready",
            "In progress",
            "In review",
            "Done",
        ],
        help="Valor del campo Status en el proyecto.",
    )
    p.add_argument(
        "--sleep",
        type=float,
        default=0.2,
        help="Pausa entre llamadas API (default 0.2).",
    )
    args = p.parse_args()
    want = {int(x.strip()) for x in args.issue.split(",") if x.strip()}
    options = status_option_ids()
    opt_id = options.get(args.status)
    if not opt_id:
        print("Unknown status", args.status, file=sys.stderr)
        sys.exit(1)

    by_num = {num: (iid, st) for iid, num, st in iter_project_issues()}
    for n in sorted(want):
        if n not in by_num:
            print(f"Issue #{n} not in Project 11 (or not linked as issue). Skip.", file=sys.stderr)
            continue
        iid, cur = by_num[n]
        if cur == args.status:
            print(f"#{n} already {args.status!r}")
            continue
        if set_status(iid, opt_id):
            print(f"#{n} {cur!r} -> {args.status!r}")
        time.sleep(args.sleep)


if __name__ == "__main__":
    main()
