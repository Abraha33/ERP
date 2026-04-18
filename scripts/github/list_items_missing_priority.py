#!/usr/bin/env python3
"""List Project 11 items with empty Priority (swimlane 'No priority')."""
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
GRAPHQL = ROOT / "graphql"
PROJECT_ID = "PVT_kwHOCgQ2Ec4BSVkL"


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


def issue_label(item: dict) -> str:
    c = item.get("content")
    if not c:
        return item["id"]
    repo = (c.get("repository") or {}).get("nameWithOwner", "?")
    num = c.get("number")
    title = (c.get("title") or "")[:70]
    return f"{repo}#{num}  {title}"


def main():
    missing: list[str] = []
    after: str | None = None
    while True:
        data = gh_graphql(
            GRAPHQL / "project-items-title-and-fields.graphql",
            {"id": PROJECT_ID, "after": after},
        )
        node = data["data"]["node"]
        if not node:
            print("No project", file=sys.stderr)
            sys.exit(1)
        items = node["items"]
        for n in items["nodes"]:
            if priority_for_item(n) is None:
                missing.append(issue_label(n))
        page = items["pageInfo"]
        if not page["hasNextPage"]:
            break
        after = page["endCursor"]

    print(f"Items sin Priority: {len(missing)}")
    for line in missing:
        print(f"  - {line}")
    print(
        "\nEn el Priority board, asigna P0-P3 en cada tarjeta para salir del swimlane No priority."
    )


if __name__ == "__main__":
    main()
