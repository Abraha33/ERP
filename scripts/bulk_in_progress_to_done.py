#!/usr/bin/env python3
"""
Project 11: todas las tarjetas del repo erp-satelite en **In progress** → **Done**,
opcionalmente con texto en **Status update**.

  python scripts/bulk_in_progress_to_done.py --dry-run
  python scripts/bulk_in_progress_to_done.py --message "Stack inicial listo (Android, worker, scraper, CI)."
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

DEFAULT_MESSAGE = (
    "Completado: inicialización stack ADR-001 (apps/android Compose, tools/worker FastAPI opcional, "
    "tools/scraper Playwright stub, .env.example, .gitignore, CI). Sin tablas Supabase."
)


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


def status_update_field_id() -> str | None:
    data = gh_graphql(GRAPHQL / "project-fields-all.graphql", {"id": PROJECT_ID})
    nodes = data["data"]["node"]["fields"]["nodes"]
    for n in nodes or []:
        if n and n.get("name") == "Status update":
            return n.get("id")
    return None


def iter_project_issues() -> list[tuple[str, int, str]]:
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


def set_status_update(item_id: str, field_id: str, text: str) -> bool:
    data = gh_graphql(
        GRAPHQL / "set-project-item-text.graphql",
        {
            "projectId": PROJECT_ID,
            "itemId": item_id,
            "fieldId": field_id,
            "text": text,
        },
    )
    if data.get("errors"):
        print(data["errors"], file=sys.stderr)
        return False
    return True


def main() -> None:
    p = argparse.ArgumentParser(
        description="Project 11: In progress → Done para erp-satelite, con Status update."
    )
    p.add_argument(
        "--message",
        "-m",
        default=DEFAULT_MESSAGE,
        help="Texto del campo Status update (default: resumen stack inicial).",
    )
    p.add_argument(
        "--skip-status-update",
        action="store_true",
        help="Solo cambiar Status a Done, sin tocar Status update.",
    )
    p.add_argument("--dry-run", action="store_true", help="Listar cambios sin aplicar.")
    p.add_argument(
        "--sleep",
        type=float,
        default=0.25,
        help="Pausa entre llamadas API (default 0.25).",
    )
    args = p.parse_args()

    options = status_option_ids()
    done_id = options.get("Done")
    if not done_id:
        print("Option Done not found", file=sys.stderr)
        sys.exit(1)

    update_fid = None if args.skip_status_update else status_update_field_id()
    if not args.skip_status_update and not update_fid:
        print(
            "Aviso: campo 'Status update' no encontrado; continúo solo con Status → Done.",
            file=sys.stderr,
        )

    targets = [(iid, num) for iid, num, st in iter_project_issues() if st == "In progress"]
    if not targets:
        print("No hay issues de erp-satelite en 'In progress'.")
        return

    print(f"Encontrados {len(targets)} ítem(s) en In progress: " f"{', '.join(f'#{n}' for _, n in targets)}")
    if args.dry_run:
        print("[dry-run] Se pondría Status update + Done en cada uno.")
        return

    for iid, num in targets:
        if update_fid and args.message:
            if set_status_update(iid, update_fid, args.message):
                print(f"#{num} Status update OK")
            time.sleep(args.sleep)
        if set_status(iid, done_id):
            print(f"#{num} -> Done")
        time.sleep(args.sleep)


if __name__ == "__main__":
    main()
