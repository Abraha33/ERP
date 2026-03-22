#!/usr/bin/env python3
r"""
Asigna milestone (fase rollup y, cuando aplica, sprint Fase N·S#) según título o Source: en el cuerpo.

  cd erp-satelite
  python scripts/ensure_roadmap_milestones.py   # crear milestones si faltan
  python scripts/sync_issue_milestones.py --dry-run
  python scripts/sync_issue_milestones.py --apply
  python scripts/sync_issue_milestones.py --apply --state open --limit 50

Corrige el caso en que todo quedó en un solo milestone al importar sin mapeo por sprint/mes.
"""
from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
import time
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
_SCRIPTS = Path(__file__).resolve().parent
if str(_SCRIPTS) not in sys.path:
    sys.path.insert(0, str(_SCRIPTS))
from roadmap_milestones import (  # noqa: E402
    milestone_title_for_phase,
    milestone_title_from_issue_title,
    norm_milestone_key,
    phase_from_e_ticket_id,
)


def run_gh(args: list[str]) -> tuple[int, str]:
    r = subprocess.run(
        ["gh"] + args,
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
        cwd=REPO_ROOT,
    )
    out = (r.stdout or "") + (r.stderr or "")
    return r.returncode, out.strip()


def fetch_milestone_title_map() -> tuple[dict[str, str], list[str]]:
    """(norm_key -> título exacto), lista de todos los títulos abiertos."""
    code, out = run_gh(
        [
            "api",
            "repos/{owner}/{repo}/milestones",
            "--paginate",
            "--jq",
            ".[] | .title",
        ]
    )
    if code != 0:
        print(out, file=sys.stderr)
        sys.exit(1)
    m: dict[str, str] = {}
    titles: list[str] = []
    for line in out.splitlines():
        t = line.strip().strip('"')
        if t:
            titles.append(t)
            m[norm_milestone_key(t)] = t
    return m, titles


def resolve_milestone_for_phase(phase: int, by_norm: dict[str, str], all_titles: list[str]) -> str | None:
    want = milestone_title_for_phase(phase)
    if not want:
        return None
    k = norm_milestone_key(want)
    if k in by_norm:
        return by_norm[k]
    # Coincidir milestones ya existentes: "Fase 1 - ...", sin tildes, etc.
    for title in all_titles:
        mm = re.match(r"^\s*Fase\s*(\d+)", title, re.I)
        if mm and int(mm.group(1)) == phase:
            return title
    return None


def resolve_wanted_milestone(want: str, by_norm: dict[str, str], all_titles: list[str]) -> str | None:
    """Resuelve título canónico o equivalente en repo (incl. Fase N · Sm — …)."""
    kn = norm_milestone_key(want)
    if kn in by_norm:
        return by_norm[kn]
    sm = re.search(r"Fase\s*(\d+)\s*·\s*S(\d+)", want, re.I)
    if sm:
        pf, sf = int(sm.group(1)), int(sm.group(2))
        for title in all_titles:
            pm = re.search(r"Fase\s*(\d+)\s*·\s*S(\d+)", title, re.I)
            if pm and int(pm.group(1)) == pf and int(pm.group(2)) == sf:
                return title
        return resolve_milestone_for_phase(pf, by_norm, all_titles)
    mphase = re.match(r"^\s*Fase\s*(\d+)", want, re.I)
    if mphase:
        return resolve_milestone_for_phase(int(mphase.group(1)), by_norm, all_titles)
    return None


def phase_from_body(body: str | None) -> int | None:
    if not body:
        return None
    m = re.search(
        r"Source:\s*(E\d+-P-\d+|E\d+-S\d+-\d+)",
        body,
        re.I,
    )
    if not m:
        return None
    tid = m.group(1).strip()
    return phase_from_e_ticket_id(tid)


def main() -> None:
    if hasattr(sys.stdout, "reconfigure"):
        try:
            sys.stdout.reconfigure(encoding="utf-8", errors="replace")
            sys.stderr.reconfigure(encoding="utf-8", errors="replace")
        except Exception:
            pass
    ap = argparse.ArgumentParser()
    ap.add_argument("--apply", action="store_true", help="Escribir en GitHub (sin esto: solo vista previa)")
    ap.add_argument(
        "--dry-run",
        action="store_true",
        help="Solo vista previa (equivalente a no pasar --apply)",
    )
    ap.add_argument("--state", choices=("open", "closed", "all"), default="all")
    ap.add_argument("--limit", type=int, default=500)
    ap.add_argument("--sleep", type=float, default=0.12)
    args = ap.parse_args()
    if args.apply and args.dry_run:
        print("Usa solo --apply o solo --dry-run.", file=sys.stderr)
        sys.exit(2)
    do_apply = args.apply and not args.dry_run

    code, _ = run_gh(["repo", "view", "--json", "name"])
    if code != 0:
        print("Ejecuta desde erp-satelite/ con gh autenticado.", file=sys.stderr)
        sys.exit(1)

    gh_by_norm, gh_all_titles = fetch_milestone_title_map()
    code, out = run_gh(
        [
            "issue",
            "list",
            "--state",
            args.state,
            "--limit",
            str(args.limit),
            "--json",
            "number,title,body,milestone",
        ]
    )
    if code != 0:
        print(out, file=sys.stderr)
        sys.exit(1)

    issues = json.loads(out)
    updated = 0
    would = 0
    skipped = 0
    missing_ms = 0

    for item in issues:
        num = item["number"]
        title = item.get("title") or ""
        body = item.get("body") or ""
        want = milestone_title_from_issue_title(title)
        if want is None:
            ph = phase_from_body(body)
            want = milestone_title_for_phase(ph) if ph is not None else None
        if want is None:
            skipped += 1
            continue

        actual = resolve_wanted_milestone(want, gh_by_norm, gh_all_titles)
        if not actual:
            print(f"  ! No hay milestone en repo para: {want!s} (#{num})", file=sys.stderr)
            missing_ms += 1
            continue

        cur = (item.get("milestone") or {}).get("title")
        if cur == actual:
            skipped += 1
            continue

        if do_apply:
            code, err = run_gh(
                ["issue", "edit", str(num), "--milestone", actual]
            )
            if code != 0:
                print(f"  ERR #{num}: {err}", file=sys.stderr)
            else:
                print(f"  OK #{num} -> {actual}")
                updated += 1
            if args.sleep:
                time.sleep(args.sleep)
        else:
            print(f"  would #{num}: {(cur or '(ninguno)')!s} -> {actual} | {title[:65]}")
            would += 1

    mode = "apply" if do_apply else "dry-run"
    print(
        f"\n{mode}: updated={updated}, would_update={would}, unchanged/no_rules={skipped}, "
        f"milestone_not_in_repo={missing_ms}"
    )


if __name__ == "__main__":
    main()
