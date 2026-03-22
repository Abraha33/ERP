#!/usr/bin/env python3
"""
Comprueba si la vista Team items parece Factura SaaS (tabla + grupos por Status).

En Project 11, Team items suele ser la vista numero 3. Factura (Project 5) usa:
  layout TABLE_LAYOUT, groupByFields = Status, verticalGroupByFields vacio.

Si tu Team items esta en BOARD_LAYOUT con Status en verticalGroupByFields, la UI
es un Kanban, no la tabla con lateral Assignees de la referencia.

  python scripts/verify_team_items_layout.py
  python scripts/verify_team_items_layout.py --view-number 3 --project 11
"""
from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
QUERY = ROOT / "graphql" / "project-team-view-layout-check.graphql"


def gh_graphql(query: str, variables: dict) -> dict:
    cmd = ["gh", "api", "graphql", "-f", f"query={query}"]
    for k, v in variables.items():
        cmd.extend(["-F", f"{k}={v}"])
    r = subprocess.run(cmd, capture_output=True, text=True, cwd=ROOT.parent)
    if r.returncode != 0:
        print(r.stderr, file=sys.stderr)
        sys.exit(r.returncode)
    out = json.loads(r.stdout)
    if out.get("errors"):
        print(json.dumps(out["errors"], indent=2), file=sys.stderr)
        sys.exit(1)
    return out["data"]


def names(nodes: list) -> list[str]:
    return [n["name"] for n in (nodes or []) if n and n.get("name")]


def main() -> None:
    p = argparse.ArgumentParser()
    p.add_argument("--project", type=int, default=11)
    p.add_argument("--view-number", type=int, default=3)
    p.add_argument("--view-name", default="Team items")
    args = p.parse_args()

    q = QUERY.read_text()
    data = gh_graphql(q, {"projectNumber": args.project})
    proj = (data.get("viewer") or {}).get("projectV2")
    if not proj:
        print("No se encontro el proyecto.", file=sys.stderr)
        sys.exit(1)

    view = None
    for n in proj["views"]["nodes"]:
        if n["number"] == args.view_number or n["name"] == args.view_name:
            view = n
            break
    if not view:
        print(f"No hay vista #{args.view_number} / {args.view_name!r}.", file=sys.stderr)
        sys.exit(1)

    layout = view.get("layout")
    g = names((view.get("groupByFields") or {}).get("nodes"))
    v = names((view.get("verticalGroupByFields") or {}).get("nodes"))

    print(f"Proyecto: {proj.get('title')}")
    print(f"Vista: #{view['number']} - {view['name']}")
    print(f"  layout:                  {layout}")
    print(f"  groupByFields:           {g or ['(vacio)']}")
    print(f"  verticalGroupByFields:   {v or ['(vacio)']}")

    ok_table = layout == "TABLE_LAYOUT" and "Status" in g and len(v) == 0
    if ok_table:
        print("\nOK: tabla con Group by Status (como Factura SaaS Team items).")
        print("En la UI: View -> Slice by -> Assignees (no aparece en esta API).")
        return

    print("\nNO coincide con Factura Team items (tabla).")
    print("\nEn GitHub (~60 s):")
    print("  1. Abre https://github.com/users/Abraha33/projects/11/views/3")
    print("  2. View -> Layout -> Table  (si ves columnas Kanban, estabas en Board)")
    print("  3. View -> Slice by -> Assignees  (panel izquierdo por persona)")
    print("  4. View -> Group by -> Status  (grupos Backlog / Ready / ... en la tabla)")
    print("  5. View -> Field sum -> Size  (cabeceras tipo Estimate)")
    print("  6. View -> Fields -> Title, Status, Linked pull requests, Sub-issues progress, Size")
    print("     (opcional: Labels, Priority, Milestone, Repository, Assignees, Status update)")
    sys.exit(2)


if __name__ == "__main__":
    main()
