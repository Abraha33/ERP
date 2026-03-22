#!/usr/bin/env python3
"""
Replace Project 11 Status field (Icebox + Priority-board columns) and remap items.

Preserves current statuses when re-running (Ready, In progress, …). Legacy:
To Do -> Ready, In Progress -> In progress, Testing / QA -> In review.

Run:  python scripts/migrate_status_to_priority_board.py
Requires: gh auth, network.
"""
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
GRAPHQL = ROOT / "graphql"

PROJECT_ID = "PVT_kwHOCgQ2Ec4BSVkL"
STATUS_FIELD_ID = "PVTSSF_lAHOCgQ2Ec4BSVkLzg_5tbo"

# Legacy / renamed options -> canonical Status name
OLD_TO_NEW: dict[str, str] = {
    "Icebox": "Icebox",
    "Backlog": "Backlog",
    "To Do": "Ready",
    "In Progress": "In progress",
    "Testing / QA": "In review",
    "Review/Testing": "In review",
    "Ready": "Ready",
    "In progress": "In progress",
    "In review": "In review",
    "Done": "Done",
}

# After a schema replace, these names are valid without remapping
CURRENT_STATUSES = (
    "Icebox",
    "Backlog",
    "Ready",
    "In progress",
    "In review",
    "Done",
)


def resolve_new_status_name(old: str | None) -> str:
    if not old:
        return "Backlog"
    if old in OLD_TO_NEW:
        return OLD_TO_NEW[old]
    if old in CURRENT_STATUSES:
        return old
    return "Backlog"


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


def status_name_for_item(item: dict) -> str | None:
    for fv in (item.get("fieldValues") or {}).get("nodes") or []:
        if not fv:
            continue
        field = fv.get("field") or {}
        if field.get("name") == "Status":
            return fv.get("name")
    return None


def collect_items_status() -> list[tuple[str, str | None]]:
    out: list[tuple[str, str | None]] = []
    after: str | None = None
    while True:
        data = gh_graphql(
            GRAPHQL / "project-items-status-page.graphql",
            {"id": PROJECT_ID, "after": after},
        )
        node = data["data"]["node"]
        if not node:
            print("No project node", file=sys.stderr)
            sys.exit(1)
        items = node["items"]
        for n in items["nodes"]:
            out.append((n["id"], status_name_for_item(n)))
        page = items["pageInfo"]
        if not page["hasNextPage"]:
            break
        after = page["endCursor"]
    return out


def fetch_option_name_to_id() -> dict[str, str]:
    data = gh_graphql(GRAPHQL / "project-fields.graphql", {"id": PROJECT_ID})
    nodes = data["data"]["node"]["fields"]["nodes"]
    for n in nodes:
        if not n or n.get("name") != "Status":
            continue
        return {o["name"]: o["id"] for o in n.get("options") or []}
    print("Status field not found", file=sys.stderr)
    sys.exit(1)


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


def main():
    print("1) Snapshot current Status per item...", flush=True)
    snapshot = collect_items_status()
    print(f"   {len(snapshot)} items", flush=True)

    print("2) Applying replace-status-priority-board mutation...", flush=True)
    r = subprocess.run(
        [
            "gh",
            "api",
            "graphql",
            "-F",
            f"query=@{GRAPHQL / 'replace-status-priority-board.graphql'}",
            "-f",
            f"fieldId={STATUS_FIELD_ID}",
        ],
        capture_output=True,
        text=True,
        cwd=ROOT.parent,
    )
    if r.returncode != 0:
        print(r.stderr, file=sys.stderr)
        sys.exit(r.returncode)
    parsed = json.loads(r.stdout)
    if parsed.get("errors"):
        print(parsed["errors"], file=sys.stderr)
        sys.exit(1)

    print("3) Resolving new option ids...", flush=True)
    by_name = fetch_option_name_to_id()
    for need in CURRENT_STATUSES:
        if need not in by_name:
            print(f"Missing option: {need}", file=sys.stderr)
            sys.exit(1)

    print("4) Rewriting Status on each item...", flush=True)
    ok = 0
    for item_id, old in snapshot:
        new_name = resolve_new_status_name(old)
        oid = by_name.get(new_name)
        if not oid:
            new_name = "Backlog"
            oid = by_name["Backlog"]
        if set_status(item_id, oid):
            ok += 1
    print(f"Done. Updated {ok}/{len(snapshot)} items.", flush=True)


if __name__ == "__main__":
    main()
