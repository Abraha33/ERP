#!/usr/bin/env python3
r"""
Política de producto (repo + Project):

- Cada **milestone sprint** `Fase N · S#` debe tener al menos un issue **[Stack]** que fije
  stack/librerías antes de implementar (ver `docs/reference/STACK_POR_FASE.md`).
- Cada **milestone rollup** `Fase N — …` (fases 0, 2–5) debe tener un issue **[Stack] Fase N — …**
  que fije stack de la fase; si no existe, se crea. La **Fase 1** no tiene rollup en GitHub (solo sprints).

Tras crear issues, los enlaza al **Project 11** (si existe y `gh` tiene permiso).

  cd erp-satelite
  python scripts/ensure_milestone_stack_and_coverage.py --all-repos --dry-run
  python scripts/ensure_milestone_stack_and_coverage.py --all-repos --apply
  python scripts/ensure_milestone_stack_and_coverage.py --all-repos --repos-file mi_lista.txt --apply
  python scripts/ensure_milestone_stack_and_coverage.py -R Abraha33/erp-satelite --apply --no-project-add

Antes conviene: `python scripts/ensure_roadmap_milestones.py` (por repo) y
`python scripts/sync_issue_milestones.py --apply` para alinear milestones en issues existentes.
"""
from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
_SCRIPTS = Path(__file__).resolve().parent
if str(_SCRIPTS) not in sys.path:
    sys.path.insert(0, str(_SCRIPTS))

from roadmap_milestones import (  # noqa: E402
    all_rollup_milestone_titles,
    all_sprint_milestone_titles,
    parse_sprint_milestone_title,
)

LIST_FILE = _SCRIPTS / "project_milestone_repos.txt"
PROJECT_NUMBER = 11
PROJECT_OWNER = "Abraha33"


def load_repos(path: Path) -> list[str]:
    out: list[str] = []
    if not path.exists():
        return out
    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.split("#", 1)[0].strip()
        if line and "/" in line:
            out.append(line)
    return out


def run_gh(args: list[str], repo: str | None = None, cwd: Path = ROOT) -> tuple[int, str]:
    cmd: list[str] = ["gh"]
    if not args:
        pass
    elif args[0] == "api":
        cmd.extend(args)
    elif repo and len(args) >= 2 and args[0] == "repo" and args[1] == "view":
        cmd.extend(["repo", "view", repo, *args[2:]])
    elif repo:
        cmd.append(args[0])
        cmd.extend(["-R", repo])
        cmd.extend(args[1:])
    else:
        cmd.extend(args)
    r = subprocess.run(
        cmd,
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
        cwd=cwd,
    )
    out = (r.stdout or "") + (r.stderr or "")
    return r.returncode, out.strip()


def issues_for_milestone(repo: str, milestone_title: str, limit: int) -> list[dict]:
    code, out = run_gh(
        [
            "issue",
            "list",
            "--state",
            "all",
            "--limit",
            str(limit),
            "--milestone",
            milestone_title,
            "--json",
            "number,title,url",
        ],
        repo=repo,
    )
    if code != 0:
        print(f"WARN list milestone {milestone_title!r}: {out}", file=sys.stderr)
        return []
    try:
        return json.loads(out)
    except json.JSONDecodeError:
        return []


def sprint_has_stack_gate(issues: list[dict], phase: int, stream: int) -> bool:
    prefixes = (
        f"[Stack] Fase {phase} · S{stream}",
        f"[Stack] Fase {phase} · S{stream} —",
    )
    for it in issues:
        t = (it.get("title") or "").strip()
        for p in prefixes:
            if t.startswith(p):
                return True
    return False


def stack_issue_body(milestone_title: str, repo: str) -> str:
    base = f"https://github.com/{repo}/blob/main"
    return f"""## Stack por sprint (regla de oro)

Antes de cerrar trabajo de **este milestone**, define o valida stack y librerías concretas para este bloque.

- Guía por fase: [`docs/reference/STACK_POR_FASE.md`]({base}/docs/reference/STACK_POR_FASE.md)
- Stack global: [`ADR/ADR-001-stack-tecnologico.md`]({base}/ADR/ADR-001-stack-tecnologico.md)

## Checklist

- [ ] Leído el apartado de esta fase en STACK_POR_FASE
- [ ] Listadas dependencias nuevas (Gradle / pip / GitHub Actions) con versión objetivo
- [ ] Si cambia el criterio: actualizar ADR o `DECISIONS.md`

**Milestone GitHub:** `{milestone_title}`
"""


def rollup_has_stack_gate(issues: list[dict], phase: int) -> bool:
    prefix = f"[Stack] Fase {phase} —"
    for it in issues:
        t = (it.get("title") or "").strip()
        if t.startswith(prefix):
            return True
    return False


def rollup_stack_issue_body(milestone_title: str, repo: str, phase_hint: str) -> str:
    base = f"https://github.com/{repo}/blob/main"
    return f"""## Stack de la fase (rollup)

Define o valida **stack y librerías** para toda esta fase antes de implementar módulos grandes.

- Guía por fase: [`docs/reference/STACK_POR_FASE.md`]({base}/docs/reference/STACK_POR_FASE.md) (Fase {phase_hint})
- Stack global: [`ADR/ADR-001-stack-tecnologico.md`]({base}/ADR/ADR-001-stack-tecnologico.md)
- Cada sprint **Fase {phase_hint} · S#** tiene además su issue **[Stack] Fase {phase_hint} · S…**.

## Checklist

- [ ] Revisado el apartado de esta fase en STACK_POR_FASE
- [ ] Listadas dependencias nuevas con versión objetivo
- [ ] Si cambia el criterio: actualizar ADR o `DECISIONS.md`

**Milestone GitHub:** `{milestone_title}`
"""


def extract_phase_from_rollup(title: str) -> str:
    m = re.match(r"^\s*Fase\s*(\d+)", title.strip(), re.I)
    return m.group(1) if m else "?"


def create_issue(
    repo: str,
    title: str,
    body: str,
    milestone: str,
    dry_run: bool,
) -> str | None:
    if dry_run:
        print(f"  would create issue: {title[:75]}...")
        return "dry-run"
    args = [
        "issue",
        "create",
        "--title",
        title,
        "--body",
        body,
        "--milestone",
        milestone,
        "--label",
        "role/docs-adr",
        "--label",
        "priority/P3",
    ]
    code, out = run_gh(args, repo=repo)
    if code != 0:
        print(f"  FAIL create: {out}", file=sys.stderr)
        return None
    for line in out.splitlines():
        if "github.com" in line and "/issues/" in line:
            return line.strip()
    return None


def add_to_project(issue_url: str, dry_run: bool) -> bool:
    if dry_run:
        return True
    code, out = run_gh(
        [
            "project",
            "item-add",
            str(PROJECT_NUMBER),
            "--owner",
            PROJECT_OWNER,
            "--url",
            issue_url,
        ],
        repo=None,
    )
    if code != 0:
        print(f"  WARN project add: {out}", file=sys.stderr)
        return False
    return True


def process_repo(
    repo: str,
    *,
    dry_run: bool,
    issue_limit: int,
    sleep_s: float,
    add_project: bool,
    skip_rollups: bool,
) -> dict[str, int]:
    stats = {
        "stack_created": 0,
        "rollup_stack_created": 0,
        "sprint_skipped": 0,
        "rollup_skipped": 0,
    }

    code, _ = run_gh(["repo", "view", "--json", "name"], repo=repo)
    if code != 0:
        print(f"Saltando {repo}: sin acceso o repo inválido.", file=sys.stderr)
        return stats

    print(f"\n=== {repo} ===")

    for ms in all_sprint_milestone_titles():
        issues = issues_for_milestone(repo, ms, issue_limit)
        parsed = parse_sprint_milestone_title(ms)
        if not parsed:
            continue
        ph, st = parsed
        need_stack = not issues or not sprint_has_stack_gate(issues, ph, st)
        if not need_stack:
            stats["sprint_skipped"] += 1
            continue
        title = f"[Stack] Fase {ph} · S{st} — Definir stack y librerías del sprint"
        body = stack_issue_body(ms, repo)
        url = create_issue(repo, title, body, ms, dry_run)
        if url and url != "dry-run":
            stats["stack_created"] += 1
            if add_project:
                add_to_project(url, dry_run)
            if sleep_s:
                time.sleep(sleep_s)
        elif url == "dry-run":
            stats["stack_created"] += 1

    if skip_rollups:
        return stats

    for ms in all_rollup_milestone_titles():
        issues = issues_for_milestone(repo, ms, issue_limit)
        phase_n = extract_phase_from_rollup(ms)
        try:
            ph_int = int(phase_n)
        except ValueError:
            stats["rollup_skipped"] += 1
            continue
        if rollup_has_stack_gate(issues, ph_int):
            stats["rollup_skipped"] += 1
            continue
        title = f"[Stack] {ms} — Definir stack tecnológico y librerías"
        body = rollup_stack_issue_body(ms, repo, phase_n)
        url = create_issue(repo, title, body, ms, dry_run)
        if url and url != "dry-run":
            stats["rollup_stack_created"] += 1
            if add_project:
                add_to_project(url, dry_run)
            if sleep_s:
                time.sleep(sleep_s)
        elif url == "dry-run":
            stats["rollup_stack_created"] += 1

    return stats


def main() -> None:
    ap = argparse.ArgumentParser(description="Issues [Stack] por sprint y [Stack] en rollups de fase.")
    g = ap.add_mutually_exclusive_group(required=True)
    g.add_argument(
        "--all-repos",
        action="store_true",
        help=f"Repos en {LIST_FILE.name}",
    )
    g.add_argument("--repo", "-R", metavar="OWNER/REPO")
    ap.add_argument(
        "--repos-file",
        type=Path,
        default=LIST_FILE,
        help=f"Lista Owner/repo cuando usas --all-repos (por defecto {LIST_FILE.name})",
    )
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--apply", action="store_true")
    ap.add_argument("--issue-limit", type=int, default=500)
    ap.add_argument("--sleep", type=float, default=0.2)
    ap.add_argument(
        "--no-project-add",
        action="store_true",
        help="No añadir al Project 11",
    )
    ap.add_argument(
        "--skip-rollups",
        action="store_true",
        help="No crear [Stack] en milestones rollup de fase",
    )
    args = ap.parse_args()

    if args.apply and args.dry_run:
        print("Usa solo --apply o solo --dry-run.", file=sys.stderr)
        sys.exit(2)
    dry_run = not args.apply

    if args.repo:
        repos = [args.repo.strip()]
        if "/" not in repos[0]:
            print("Owner/repo inválido.", file=sys.stderr)
            sys.exit(2)
    else:
        rf = args.repos_file
        repos = load_repos(rf)
        if not repos:
            print(f"Sin repos en {rf}", file=sys.stderr)
            sys.exit(1)

    tot = {
        "stack_created": 0,
        "rollup_stack_created": 0,
        "sprint_skipped": 0,
        "rollup_skipped": 0,
    }
    add_p = not args.no_project_add

    for r in repos:
        st = process_repo(
            r,
            dry_run=dry_run,
            issue_limit=args.issue_limit,
            sleep_s=args.sleep,
            add_project=add_p,
            skip_rollups=args.skip_rollups,
        )
        for k in tot:
            tot[k] += st[k]

    mode = "dry-run" if dry_run else "apply"
    print(f"\nResumen ({mode}): {tot}")


if __name__ == "__main__":
    main()
