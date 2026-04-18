#!/usr/bin/env python3
"""
Import SCRUM_5MONTH_TICKETS.csv to GitHub Issues and add to Project 11 (ERP).

Milestone por fila: Fase 0–5; si Month es 4–7 asigna sprint Fase 2 (S1–S4), si 8–10 sprint Fase 3 (S1–S3).
Antes: python scripts/ensure_roadmap_milestones.py

Run from erp-satelite/ with: python scripts/import-backlog-to-github.py
"""
import csv
import re
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
_SCRIPTS = Path(__file__).resolve().parent
if str(_SCRIPTS) not in sys.path:
    sys.path.insert(0, str(_SCRIPTS))
from roadmap_milestones import milestone_title_for_csv_row  # noqa: E402
# CSV lives in workspace root docs/ (or erp-satelite/docs/ if copied)
CSV_PATH = (REPO_ROOT.parent / "docs" / "SCRUM_5MONTH_TICKETS.csv").resolve()
if not CSV_PATH.exists():
    CSV_PATH = (REPO_ROOT / "docs" / "SCRUM_5MONTH_TICKETS.csv").resolve()
PROJECT_OWNER = "Abraha33"
PROJECT_NUMBER = 11


def normalize_ticket_id_for_title(ticket_id: str) -> str:
    """E5-S10-7 -> E05-S10-07 para orden lexicográfico correcto. Ver docs/TICKET_ID_CONVENTION.md."""
    s = ticket_id.strip()
    m = re.match(r"^E(\d+)-S(\d+)-(\d+)$", s, re.I)
    if m:
        return f"E{int(m.group(1)):02d}-S{int(m.group(2)):02d}-{int(m.group(3)):02d}"
    return s


def run_gh(args: list[str], capture: bool = True) -> tuple[int, str]:
    result = subprocess.run(
        ["gh"] + args,
        capture_output=capture,
        text=True,
        cwd=REPO_ROOT,
    )
    out = (result.stdout or "") + (result.stderr or "")
    return result.returncode, out.strip()


def create_issue(row: dict) -> str | None:
    ticket_id = row.get("ID", "").strip()
    title = row.get("Title", "").strip()
    if not title:
        return None
    if ticket_id:
        nid = normalize_ticket_id_for_title(ticket_id)
        display_title = f"[{nid}] {title}"
    else:
        display_title = title

    desc = row.get("Description", "").strip()
    criteria = row.get("Acceptance criteria", "").strip()
    body_parts = []
    if desc:
        body_parts.append(f"## Description\n{desc}")
    if criteria:
        body_parts.append(f"## Acceptance criteria\n{criteria}")
    body_parts.append(f"\n---\n*Source: {ticket_id} | Epic {row.get('Epic','')} | Sprint {row.get('Sprint','')}*")
    body = "\n\n".join(body_parts)

    args = ["issue", "create", "--title", display_title, "--body", body]
    ms = milestone_title_for_csv_row(row)
    if ms:
        args.extend(["--milestone", ms])
    code, out = run_gh(args)
    if code != 0:
        print(f"  ERROR creating {ticket_id}: {out}", file=sys.stderr)
        return None
    # gh returns URL like https://github.com/Abraha33/erp-satelite/issues/123
    for line in out.splitlines():
        if "github.com" in line and "/issues/" in line:
            return line.strip()
    return None


def add_to_project(issue_url: str) -> bool:
    code, out = run_gh([
        "project", "item-add", str(PROJECT_NUMBER),
        "--owner", PROJECT_OWNER,
        "--url", issue_url,
    ])
    if code != 0:
        print(f"  WARN: could not add to project: {out}", file=sys.stderr)
        return False
    return True


def main():
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--start", type=int, default=0, help="Skip first N rows")
    parser.add_argument("--limit", type=int, default=0, help="Process at most N rows (0=all)")
    args = parser.parse_args()

    if not CSV_PATH.exists():
        print(f"CSV not found: {CSV_PATH}", file=sys.stderr)
        sys.exit(1)

    # Ensure we're in the right repo
    code, _ = run_gh(["repo", "view", "--json", "name"])
    if code != 0:
        print("Run this script from erp-satelite/ (gh repo must resolve)", file=sys.stderr)
        sys.exit(1)

    created = 0
    failed = 0
    with open(CSV_PATH, encoding="utf-8") as f:
        reader = csv.DictReader(f)
        rows = list(reader)

    rows = rows[args.start:]
    if args.limit:
        rows = rows[: args.limit]
    print(f"Processing {len(rows)} rows (start={args.start})")

    for i, row in enumerate(rows):
        ticket_id = row.get("ID", "")
        print(f"[{i+1}/{len(rows)}] {ticket_id}...", end=" ")
        url = create_issue(row)
        if url:
            add_to_project(url)
            created += 1
            print("OK")
        else:
            failed += 1
            print("FAILED")

    print(f"\nDone. Created: {created}, Failed: {failed}")


if __name__ == "__main__":
    main()
