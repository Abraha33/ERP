#!/usr/bin/env python3
r"""Sync ROADMAP T#.#.# tickets to GitHub issues + Project 11.

Asigna milestone: T2.b.* / T3.b.* → sprint dentro de ERP Básico / ERP Completo; resto T* → fase.
Antes (una vez): python scripts/ensure_roadmap_milestones.py

Run from erp-satelite/:
  python scripts/sync_roadmap_granular_issues.py --dry-run
  python scripts/sync_roadmap_granular_issues.py
  python scripts/sync_roadmap_granular_issues.py --report-e-duplicates
"""
from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
import time
from collections import defaultdict
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
_SCRIPTS = Path(__file__).resolve().parent
if str(_SCRIPTS) not in sys.path:
    sys.path.insert(0, str(_SCRIPTS))
from roadmap_milestones import milestone_title_for_granular_roadmap_id  # noqa: E402

ROADMAP_PATH = (REPO_ROOT / "ROADMAP.md").resolve()
PROJECT_OWNER = "Abraha33"
PROJECT_NUMBER = 11

ALIAS_TITLE_REGEX: dict[str, list[str]] = {
    "T0.1.1": [r"^\[T02\]"],
    "T0.1.2": [r"^\[T03\]"],
    "T0.1.3": [r"^\[T01\]"],
    "T0.1.5": [r"^\[T06\]"],
}

E_TITLE_RE = re.compile(r"^\[E(\d+)-S(\d+)-(\d+)\]\s*", re.I)


def run_gh(args: list[str], capture: bool = True) -> tuple[int, str]:
    result = subprocess.run(
        ["gh"] + args,
        capture_output=capture,
        text=True,
        cwd=REPO_ROOT,
    )
    out = (result.stdout or "") + (result.stderr or "")
    return result.returncode, out.strip()


def parse_roadmap(path: Path) -> list[dict[str, str]]:
    rows: list[dict[str, str]] = []
    if not path.exists():
        print(f"ROADMAP not found: {path}", file=sys.stderr)
        return rows
    for line in path.read_text(encoding="utf-8").splitlines():
        if not line.startswith("|"):
            continue
        if re.match(r"^\|\s*[-:]+\s*\|", line):
            continue
        if "Ticket" in line and "Tarea" in line:
            continue
        parts = [p.strip() for p in line.split("|")]
        if len(parts) < 5:
            continue
        ticket = parts[1]
        if ".x" in ticket or not re.fullmatch(r"T\d+\.\d+\.\d+", ticket):
            continue
        rows.append(
            {
                "id": ticket,
                "task": parts[2],
                "hours": parts[3],
                "priority": parts[4],
            }
        )
    return rows


def fetch_issue_titles(state: str = "all") -> list[str]:
    code, out = run_gh(
        [
            "issue",
            "list",
            "--state",
            state,
            "--limit",
            "600",
            "--json",
            "title",
        ]
    )
    if code != 0:
        print(f"gh issue list failed: {out}", file=sys.stderr)
        sys.exit(1)
    data = json.loads(out)
    return [item["title"] for item in data]


def ticket_satisfied(ticket_id: str, titles: list[str]) -> bool:
    patterns: list[str] = [rf"^{re.escape(ticket_id)}(\s|[-\u2013])"]
    for rx in ALIAS_TITLE_REGEX.get(ticket_id, []):
        patterns.append(rx)
    for title in titles:
        t = title.strip()
        for p in patterns:
            if re.search(p, t, re.IGNORECASE):
                return True
    return False


def report_e_duplicates(titles: list[str]) -> None:
    buckets: dict[str, list[str]] = defaultdict(list)
    for t in titles:
        m = E_TITLE_RE.match(t.strip())
        if not m:
            continue
        key = f"E{int(m.group(1)):02d}-S{int(m.group(2)):02d}-{int(m.group(3)):02d}"
        buckets[key].append(t.strip())
    dups = {k: v for k, v in buckets.items() if len(v) > 1}
    if not dups:
        print("No duplicate [E##-S##-##] titles.")
        return
    print(f"Duplicate E-prefix keys ({len(dups)}):\n")
    for key in sorted(dups.keys()):
        print(f"  {key} ({len(dups[key])} issues):")
        for title in dups[key]:
            print(f"    - {title[:100]}..." if len(title) > 100 else f"    - {title}")


def add_to_project(issue_url: str) -> bool:
    code, out = run_gh(
        [
            "project",
            "item-add",
            str(PROJECT_NUMBER),
            "--owner",
            PROJECT_OWNER,
            "--url",
            issue_url,
        ]
    )
    if code != 0:
        print(f"  WARN project add: {out}", file=sys.stderr)
        return False
    return True


def create_roadmap_issue(row: dict[str, str]) -> str | None:
    tid = row["id"]
    title = f"{tid} - {row['task']}"
    body = "\n\n".join(
        [
            "## Origen",
            "Ticket granular de `ROADMAP.md` (ERP Satélite, 14 meses).",
            "",
            "| Campo | Valor |",
            "|-------|-------|",
            f"| Estimación | {row['hours']} |",
            f"| Prioridad roadmap | {row['priority']} |",
        ]
    )
    args = ["issue", "create", "--title", title, "--body", body]
    ms = milestone_title_for_granular_roadmap_id(tid)
    if ms:
        args.extend(["--milestone", ms])
    code, out = run_gh(args)
    if code != 0:
        print(f"  ERROR: {out}", file=sys.stderr)
        return None
    for line in out.splitlines():
        if "github.com" in line and "/issues/" in line:
            return line.strip()
    return None


def main() -> None:
    if hasattr(sys.stdout, "reconfigure"):
        try:
            sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        except Exception:
            pass
    parser = argparse.ArgumentParser()
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--report-e-duplicates", action="store_true")
    parser.add_argument("--sleep", type=float, default=0.6)
    args = parser.parse_args()

    code, _ = run_gh(["repo", "view", "--json", "name"])
    if code != 0:
        print("Ejecuta desde erp-satelite/ con gh autenticado.", file=sys.stderr)
        sys.exit(1)

    titles = fetch_issue_titles()
    if args.report_e_duplicates:
        report_e_duplicates(titles)
        return

    roadmap = parse_roadmap(ROADMAP_PATH)
    if not roadmap:
        sys.exit(1)

    missing = [r for r in roadmap if not ticket_satisfied(r["id"], titles)]

    print(
        f"Roadmap: {len(roadmap)} tickets; cubiertos: {len(roadmap) - len(missing)}; faltantes: {len(missing)}"
    )
    for r in missing:
        tail = "..." if len(r["task"]) > 70 else ""
        print(f"  - {r['id']}: {r['task'][:70]}{tail}")

    if args.dry_run:
        print("\n--dry-run: no se crearon issues.")
        return

    if not missing:
        print("Nada que crear.")
        return

    created = 0
    for i, row in enumerate(missing):
        print(f"[{i + 1}/{len(missing)}] {row['id']}...", end=" ", flush=True)
        url = create_roadmap_issue(row)
        if url:
            if add_to_project(url):
                print(f"OK + project {url}")
            else:
                print(f"OK issue, fallo project {url}")
            created += 1
        else:
            print("FAILED")
        if args.sleep and i < len(missing) - 1:
            time.sleep(args.sleep)

    print(f"\nListo. Creados: {created} / {len(missing)}")


if __name__ == "__main__":
    main()
