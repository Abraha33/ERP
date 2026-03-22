#!/usr/bin/env python3
"""Set every item in GitHub Project 11 to Status = Backlog (clears No Status column)."""
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
GRAPHQL = ROOT / "graphql"

PROJECT_ID = "PVT_kwHOCgQ2Ec4BSVkL"
STATUS_FIELD_ID = "PVTSSF_lAHOCgQ2Ec4BSVkLzg_5tbo"


def gh_graphql(query_file: Path, variables: dict) -> dict:
    cmd = ["gh", "api", "graphql", "-F", f"query=@{query_file}"]
    for k, v in variables.items():
        cmd.extend(["-f", f"{k}={v}"])
    r = subprocess.run(cmd, capture_output=True, text=True, cwd=ROOT.parent)
    if r.returncode != 0:
        print(r.stderr, file=sys.stderr)
        sys.exit(r.returncode)
    return json.loads(r.stdout)


def fetch_backlog_option_id() -> str:
    data = gh_graphql(GRAPHQL / "project-fields.graphql", {"id": PROJECT_ID})
    nodes = data["data"]["node"]["fields"]["nodes"]
    for n in nodes:
        if not n or not isinstance(n, dict) or n.get("name") != "Status":
            continue
        for opt in n.get("options") or []:
            if opt.get("name") == "Backlog":
                return opt["id"]
    print("Could not find Status > Backlog option", file=sys.stderr)
    sys.exit(1)


def fetch_all_item_ids() -> list[str]:
    ids: list[str] = []
    data = gh_graphql(GRAPHQL / "project-items-first.graphql", {"id": PROJECT_ID})
    while True:
        node = data["data"]["node"]
        if not node:
            print("No project node", file=sys.stderr)
            sys.exit(1)
        items = node["items"]
        for n in items["nodes"]:
            ids.append(n["id"])
        page = items["pageInfo"]
        if not page["hasNextPage"]:
            break
        data = gh_graphql(
            GRAPHQL / "project-items-next.graphql",
            {"id": PROJECT_ID, "after": page["endCursor"]},
        )
    return ids


def set_backlog(item_id: str, backlog_option_id: str) -> bool:
    data = gh_graphql(
        GRAPHQL / "set-status.graphql",
        {
            "projectId": PROJECT_ID,
            "itemId": item_id,
            "fieldId": STATUS_FIELD_ID,
            "optionId": backlog_option_id,
        },
    )
    err = data.get("errors")
    if err:
        print(err, file=sys.stderr)
        return False
    return True


def main():
    backlog_id = fetch_backlog_option_id()
    print(f"Backlog option id: {backlog_id}", flush=True)
    print("Fetching project items...", flush=True)
    ids = fetch_all_item_ids()
    print(f"Found {len(ids)} items. Setting Status=Backlog...", flush=True)
    ok = 0
    for i, item_id in enumerate(ids, 1):
        if set_backlog(item_id, backlog_id):
            ok += 1
        if i % 50 == 0:
            print(f"  ... {i}/{len(ids)}", flush=True)
    print(f"Done. Updated {ok}/{len(ids)} items.", flush=True)


if __name__ == "__main__":
    main()
