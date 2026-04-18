#!/usr/bin/env python3
"""
Comprueba por GraphQL si la vista Priority board coincide con Factura SaaS:

  - Filas (Group by): Priority
  - Columnas (Column field): Status

Sin Group by -> Priority la UI se ve como un Kanban plano aunque los datos esten bien.

  python scripts/verify_priority_board_layout.py
  python scripts/verify_priority_board_layout.py --project 11 --view-number 2
"""
from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
GRAPHQL = ROOT / "graphql"
QUERY = GRAPHQL / "project-priority-board-layout-check.graphql"


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
    out: list[str] = []
    for n in nodes or []:
        if not n:
            continue
        name = n.get("name")
        if name:
            out.append(name)
    return out


def main() -> None:
    p = argparse.ArgumentParser()
    p.add_argument("--project", type=int, default=11)
    p.add_argument("--view-number", type=int, default=2)
    p.add_argument("--view-name", default="Priority board")
    args = p.parse_args()

    q = QUERY.read_text()
    data = gh_graphql(q, {"projectNumber": args.project})
    proj = (data.get("viewer") or {}).get("projectV2")
    if not proj:
        print("No se encontro el proyecto (numero o sesion gh?).", file=sys.stderr)
        sys.exit(1)

    view = None
    for n in proj["views"]["nodes"]:
        if n["number"] == args.view_number or n["name"] == args.view_name:
            view = n
            break
    if not view:
        print(f"No hay vista #{args.view_number} / {args.view_name!r}.", file=sys.stderr)
        sys.exit(1)

    g = names((view.get("groupByFields") or {}).get("nodes"))
    v = names((view.get("verticalGroupByFields") or {}).get("nodes"))

    print(f"Proyecto: {proj.get('title')}")
    print(f"Vista: #{view['number']} - {view['name']}")
    print(f"  groupByFields (filas / Group by):     {g or ['(vacio)']}")
    print(f"  verticalGroupByFields (columnas):       {v or ['(vacío)']}")

    ok = "Priority" in g and "Status" in v
    if ok:
        print("\nOK: misma logica que Factura SaaS (Project 5 / Priority board).")
        return

    print(
        "\nFALTA configuracion en la UI de GitHub (la API REST publica no permite fijar group_by en vistas de usuario)."
    )
    print(
        "\nHazlo en el tablero (~60 s):\n"
        "  1. Abre https://github.com/users/Abraha33/projects/11/views/2\n"
        "  2. View -> Group by -> Priority   (obligatorio: filas P0-P3 / No priority)\n"
        "  3. View -> Column field -> Status\n"
        "  4. View -> Field sum -> Size\n"
        "  5. View -> Fields -> Assignees, Labels, Priority, Milestone en tarjetas\n"
    )
    sys.exit(2)


if __name__ == "__main__":
    main()
