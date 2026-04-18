#!/usr/bin/env python3
"""
Normaliza prefijos de títulos de issues al estándar en docs/TICKET_ID_CONVENTION.md:
  - T01: Foo  ->  [T01] Foo
  - [T1] Foo  ->  [T01] Foo
  - [E5-S10-7] Foo  ->  [E05-S10-07] Foo

Uso:
  python scripts/normalize_issue_title_prefixes.py --dry-run
  python scripts/normalize_issue_title_prefixes.py --apply
"""
from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent


def run_gh(args: list[str]) -> str:
    r = subprocess.run(
        ["gh"] + args,
        capture_output=True,
        text=True,
        cwd=REPO_ROOT,
    )
    out = (r.stdout or "") + (r.stderr or "")
    if r.returncode != 0:
        print(out, file=sys.stderr)
        sys.exit(r.returncode)
    return r.stdout or ""


def normalize_title(title: str) -> tuple[str, bool]:
    t = title.strip()
    if not t:
        return title, False

    # [T1] or [T01] -> [T##] two digits for 1-99
    m = re.match(r"^\[T(\d{1,3})\]\s*(.+)$", t, re.DOTALL)
    if m:
        num = int(m.group(1))
        rest = m.group(2).strip()
        new = f"[T{num:02d}] {rest}" if num <= 99 else f"[T{num}] {rest}"
        return (new, new != t)

    # T01: or T1:
    m = re.match(r"^T(\d{1,3}):\s*(.+)$", t, re.DOTALL)
    if m:
        num = int(m.group(1))
        rest = m.group(2).strip()
        new = f"[T{num:02d}] {rest}" if num <= 99 else f"[T{num}] {rest}"
        return (new, True)

    # [E5-S10-07] or [E5-S10-7]
    m = re.match(r"^\[E(\d+)-S(\d+)-(\d+)\]\s*(.*)$", t, re.DOTALL)
    if m:
        e, s, i = int(m.group(1)), int(m.group(2)), int(m.group(3))
        rest = m.group(4).strip()
        new = f"[E{e:02d}-S{s:02d}-{i:02d}] {rest}".strip()
        return (new, new != t)

    return (title, False)


def main() -> None:
    p = argparse.ArgumentParser()
    p.add_argument("--apply", action="store_true", help="Ejecutar gh issue edit")
    p.add_argument("--state", choices=("open", "closed", "all"), default="open")
    args = p.parse_args()

    limit = 500
    cmd = ["issue", "list", "--limit", str(limit), "--json", "number,title"]
    if args.state != "all":
        cmd.extend(["--state", args.state])

    raw = run_gh(cmd)
    issues = json.loads(raw)
    changes: list[tuple[int, str, str]] = []

    for row in issues:
        num = row["number"]
        title = row["title"]
        new_title, changed = normalize_title(title)
        if changed:
            changes.append((num, title, new_title))

    if not changes:
        print("Nada que normalizar.")
        return

    for num, old, new in changes:
        print(f"#{num}")
        print(f"  - {old}")
        print(f"  + {new}")

    if not args.apply:
        print(f"\n{len(changes)} issues. Ejecuta con --apply para guardar.")
        return

    for num, _old, new in changes:
        r = subprocess.run(
            ["gh", "issue", "edit", str(num), "--title", new],
            cwd=REPO_ROOT,
            capture_output=True,
            text=True,
        )
        if r.returncode != 0:
            print(f"ERROR #{num}: {r.stderr}", file=sys.stderr)
        else:
            print(f"OK #{num}")

    print(f"Hecho: {len(changes)} issues.")


if __name__ == "__main__":
    main()
