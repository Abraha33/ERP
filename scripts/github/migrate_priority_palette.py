#!/usr/bin/env python3
"""
Re-apply Priority single_select options (colors) on Project 11 and remap item values.

Run after editing replace-priority-palette.graphql:
  python scripts/migrate_priority_palette.py
"""
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
GRAPHQL = ROOT / "graphql"

PROJECT_ID = "PVT_kwHOCgQ2Ec4BSVkL"
PRIORITY_FIELD_ID = "PVTSSF_lAHOCgQ2Ec4BSVkLzg_6wRI"

CURRENT = ("P0", "P1", "P2", "P3")


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


def priority_name_for_item(item: dict) -> str | None:
    for fv in (item.get("fieldValues") or {}).get("nodes") or []:
        if not fv:
            continue
        field = fv.get("field") or {}
        if field.get("name") == "Priority":
            return fv.get("name")
    return None


def collect_items_priority() -> list[tuple[str, str | None]]:
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
            out.append((n["id"], priority_name_for_item(n)))
        page = items["pageInfo"]
        if not page["hasNextPage"]:
            break
        after = page["endCursor"]
    return out


def fetch_priority_option_ids() -> dict[str, str]:
    data = gh_graphql(GRAPHQL / "project-fields.graphql", {"id": PROJECT_ID})
    for n in data["data"]["node"]["fields"]["nodes"]:
        if n and n.get("name") == "Priority":
            return {o["name"]: o["id"] for o in n.get("options") or []}
    print("Priority field not found", file=sys.stderr)
    sys.exit(1)


def set_priority(item_id: str, option_id: str) -> bool:
    data = gh_graphql(
        GRAPHQL / "set-status.graphql",
        {
            "projectId": PROJECT_ID,
            "itemId": item_id,
            "fieldId": PRIORITY_FIELD_ID,
            "optionId": option_id,
        },
    )
    if data.get("errors"):
        print(data["errors"], file=sys.stderr)
        return False
    return True


def main():
    print("1) Snapshot Priority per item...", flush=True)
    snapshot = collect_items_priority()
    print(f"   {len(snapshot)} items", flush=True)

    print("2) Applying replace-priority-palette mutation...", flush=True)
    r = subprocess.run(
        [
            "gh",
            "api",
            "graphql",
            "-F",
            f"query=@{GRAPHQL / 'replace-priority-palette.graphql'}",
            "-f",
            f"fieldId={PRIORITY_FIELD_ID}",
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

    print("3) Resolving new Priority option ids...", flush=True)
    by_name = fetch_priority_option_ids()
    for need in CURRENT:
        if need not in by_name:
            print(f"Missing option: {need}", file=sys.stderr)
            sys.exit(1)

    print("4) Rewriting Priority on items that had a value...", flush=True)
    ok = 0
    for item_id, old in snapshot:
        if not old or old not in by_name:
            continue
        if set_priority(item_id, by_name[old]):
            ok += 1
    print(f"Done. Restored Priority on {ok} items (others were empty).", flush=True)


if __name__ == "__main__":
    main()
