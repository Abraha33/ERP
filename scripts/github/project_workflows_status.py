#!/usr/bin/env python3
"""
Lista workflows del Project (GraphQL) y marca cuales faltan por activar.

No puede encenderlos por API (GitHub solo expone deleteProjectV2Workflow).
Uso tipico: ver que falta y luego UI -> ... -> Workflows.

  python scripts/project_workflows_status.py
  python scripts/project_workflows_status.py --project 11 --from-num 2 --to-num 7

--from-num / --to-num se refieren al numero que muestra GitHub en cada workflow
(en la respuesta API: campo \"number\"), no al # de la tabla de la doc antigua.
"""
from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
QUERY = ROOT / "graphql" / "project-workflows.graphql"
WORKFLOWS_URL = "https://github.com/users/Abraha33/projects/11/workflows"


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


def main() -> None:
    p = argparse.ArgumentParser()
    p.add_argument("--project", type=int, default=11)
    p.add_argument(
        "--from-num",
        type=int,
        default=2,
        help="Rango inclusivo: workflow.number >= from (default 2)",
    )
    p.add_argument(
        "--to-num",
        type=int,
        default=7,
        help="Rango inclusivo: workflow.number <= to (default 7)",
    )
    args = p.parse_args()

    q = QUERY.read_text()
    data = gh_graphql(q, {"n": args.project})
    proj = (data.get("viewer") or {}).get("projectV2")
    if not proj:
        print("Proyecto no encontrado.", file=sys.stderr)
        sys.exit(1)

    nodes = (proj.get("workflows") or {}).get("nodes") or []
    by_num = {n["number"]: n for n in nodes}

    print(f"Proyecto: {proj.get('title')} (#{args.project})")
    print(WORKFLOWS_URL)
    print()

    missing: list[str] = []
    for num in range(args.from_num, args.to_num + 1):
        w = by_num.get(num)
        if not w:
            print(f"  #{num}: (no existe en este proyecto)")
            continue
        st = "ON " if w["enabled"] else "OFF"
        line = f"  #{num} [{st}] {w['name']}"
        print(line)
        if not w["enabled"]:
            missing.append(w["name"])

    print()
    if missing:
        print("Activar en el navegador (no hay API soportada):")
        print("  Project -> ... -> Workflows -> cada uno -> Edit -> Save and turn on workflow")
        print()
        print("Pendientes OFF en el rango:", ", ".join(missing))
        sys.exit(2)
    print("OK: todos los workflows en el rango estan ON.")
    sys.exit(0)


if __name__ == "__main__":
    main()
