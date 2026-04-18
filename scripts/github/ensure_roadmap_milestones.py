#!/usr/bin/env python3
"""
Create Fase 0–5 rollups + sprints por fase (F1 S1–S5 ERP Satélite, F2–F5 según ROADMAP).

  cd erp-satelite
  python scripts/ensure_roadmap_milestones.py
  python scripts/ensure_roadmap_milestones.py --dry-run
  python scripts/ensure_roadmap_milestones.py -R Abraha33/otro-repo

Ejecutar antes de importar backlog o sincronizar milestones en issues.
Varios repos: `scripts/project_milestone_repos.txt` + `sync_milestones_for_project_repos.py`.
"""
from __future__ import annotations

import argparse
import os
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
_SCRIPTS = Path(__file__).resolve().parent
if str(_SCRIPTS) not in sys.path:
    sys.path.insert(0, str(_SCRIPTS))
from roadmap_milestones import all_ensure_milestone_titles, norm_milestone_key  # noqa: E402


def run_gh(args: list[str], repo: str | None = None) -> tuple[int, str]:
    """En Windows, `gh -R` global no existe; issue usa `gh issue -R repo subcmd ...`; repo view usa argumento posicional."""
    cmd: list[str] = ["gh"]
    if not args:
        cmd.extend(args)
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
        cwd=REPO_ROOT,
    )
    out = (r.stdout or "") + (r.stderr or "")
    return r.returncode, out.strip()


def _repos_api_base(repo: str | None) -> str:
    """Segmento de ruta REST: repos/OWNER/REPO o repos/{owner}/{repo} (resuelto por gh)."""
    return f"repos/{repo}" if repo else "repos/{owner}/{repo}"


def list_open_milestone_titles(repo: str | None) -> set[str]:
    code, out = run_gh(
        [
            "api",
            f"{_repos_api_base(repo)}/milestones",
            "--paginate",
            "--jq",
            ".[].title",
        ],
        repo=repo,
    )
    if code != 0:
        print(out, file=sys.stderr)
        sys.exit(1)
    titles = []
    for line in out.splitlines():
        line = line.strip().strip('"')
        if line:
            titles.append(line)
    return set(titles)


def create_milestone(title: str, repo: str | None) -> bool:
    code, out = run_gh(
        [
            "api",
            "-X",
            "POST",
            f"{_repos_api_base(repo)}/milestones",
            "-f",
            f"title={title}",
            "-f",
            "state=open",
        ],
        repo=repo,
    )
    if code != 0:
        print(f"  FAIL {title}: {out}", file=sys.stderr)
        return False
    return True


def main() -> None:
    ap = argparse.ArgumentParser(
        description="Crea milestones del roadmap en un repositorio GitHub.",
    )
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument(
        "--repo",
        "-R",
        default=os.environ.get("GH_REPO"),
        metavar="OWNER/REPO",
        help="Repositorio destino (por defecto GH_REPO o el repo actual de gh).",
    )
    args = ap.parse_args()
    repo = (args.repo or "").strip() or None
    if repo and "/" not in repo:
        print("Usa --repo Owner/nombre (ej. Abraha33/erp-satelite).", file=sys.stderr)
        sys.exit(2)

    code, _ = run_gh(["repo", "view", "--json", "name"], repo=repo)
    if code != 0:
        print("Ejecuta con gh autenticado y repo válido (--repo o cwd en el clone).", file=sys.stderr)
        sys.exit(1)

    if repo:
        print(f"Repositorio: {repo}")

    existing = list_open_milestone_titles(repo)
    existing_norm = {norm_milestone_key(x) for x in existing}

    created = 0
    for title in all_ensure_milestone_titles():
        if norm_milestone_key(title) in existing_norm:
            print(f"  skip: {title}")
            continue
        if args.dry_run:
            print(f"  would create: {title}")
            created += 1
            continue
        print(f"  creating: {title}...", end=" ", flush=True)
        if create_milestone(title, repo):
            print("OK")
            created += 1
            existing_norm.add(norm_milestone_key(title))
        else:
            print("FAIL")

    print(f"\nListo. Nuevos: {created}")


if __name__ == "__main__":
    main()
