#!/usr/bin/env python3
"""One-shot: PATCH milestone M0 + create GitHub issues from docs/milestones/m0-issues/.

**No idempotente:** si falla a mitad, crear el resto a mano (gh issue create) o revisar issues
duplicados. Títulos sin caracteres fuera de cp1252 en consola Windows (evitar → en --title).
"""
from __future__ import annotations

import json
import re
import subprocess
import sys
from pathlib import Path

REPO = "Abraha33/ERP"
MILESTONE_TITLE = "M0 · Workflow & Foundation"
MILESTONE_NUMBER = 36
ROOT = Path(__file__).resolve().parent.parent
BODIES = ROOT / "docs" / "milestones" / "m0-issues"


def run(cmd: list[str]) -> str:
    r = subprocess.run(cmd, capture_output=True, text=True, cwd=ROOT)
    if r.returncode != 0:
        print(r.stderr or r.stdout, file=sys.stderr)
        sys.exit(r.returncode)
    return (r.stdout or "").strip()


def patch_milestone() -> None:
    desc = (
        "Validar que el método de trabajo, stack documentado y estructura del repo "
        "están operativos antes de escribir código de producto.\n\n"
        "Detalle W01–W08: docs/milestones/M0-workflow-foundation.md"
    )
    run(
        [
            "gh",
            "api",
            f"repos/{REPO}/milestones/{MILESTONE_NUMBER}",
            "-X",
            "PATCH",
            "-f",
            f"title={MILESTONE_TITLE}",
            "-f",
            f"description={desc}",
            "-f",
            "due_on=2026-04-15T23:59:59Z",
        ]
    )
    print("Milestone patched:", MILESTONE_TITLE)


def create_issue(title: str, body_file: Path, labels: list[str]) -> int:
    cmd = [
        "gh",
        "issue",
        "create",
        "-R",
        REPO,
        "--title",
        title,
        "--body-file",
        str(body_file),
        "-m",
        MILESTONE_TITLE,
    ]
    for lb in labels:
        cmd.extend(["-l", lb])
    out = run(cmd)
    m = re.search(r"/issues/(\d+)", out)
    if not m:
        print("Could not parse issue number from:", out, file=sys.stderr)
        sys.exit(1)
    return int(m.group(1))


def main() -> None:
    patch_milestone()

    specs: list[tuple[str, str, list[str]]] = [
        ("W01 — Actualizar ADR-001 con stack real (Kotlin + Room)", "W01.md", ["fase-0", "alta", "decision", "documentation"]),
        ("W02 — Estructura monorepo: apps/android/ + supabase/ + scripts/", "W02.md", ["fase-0", "alta", "infra"]),
        ("W03 — Commitear .env.example con variables canónicas", "W03.md", ["fase-0", "alta", "infra"]),
        ("W04 — schema-conventions.md: UUID, soft delete, sync_status, updated_at", "W04.md", ["fase-0", "alta", "database"]),
        ("W05 — Cursor rules operativas en flujo real", "W05.md", ["fase-0", "alta", "documentation"]),
        (
            "W06 — Workflow git end-to-end: feature a PR a develop",
            "W06.md",
            ["fase-0", "alta", "infra"],
        ),
    ]

    for title, fname, labels in specs:
        path = BODIES / fname
        if not path.exists():
            print("Missing", path, file=sys.stderr)
            sys.exit(1)
        n = create_issue(title, path, labels)
        print(f"Created #{n}: {title}")

    w7 = create_issue(
        "W07 — Ticket de prueba real: migración mínima Supabase",
        BODIES / "W07.md",
        ["fase-0", "alta", "database"],
    )
    print(f"Created #{w7}: W07")

    subs = [
        ("W07a — Migración 001_profiles (convenciones W04)", "W07a.md"),
        ("W07b — supabase db push local", "W07b.md"),
        ("W07c — Verificar RLS mínima (anon → 0 filas)", "W07c.md"),
    ]
    sub_nums: list[int] = []
    for title, fname in subs:
        extra = f"\n\n---\n**Epic / padre:** #{w7}\n"
        text = (BODIES / fname).read_text(encoding="utf-8") + extra
        tmp = BODIES / f"_{fname}.tmp"
        tmp.write_text(text, encoding="utf-8")
        n = create_issue(title, tmp, ["fase-0", "alta", "database"])
        sub_nums.append(n)
        print(f"Created #{n}: {title}")
        tmp.unlink(missing_ok=True)

    footer = (
        "\n\n---\n**Sub-issues:** "
        + ", ".join(f"#{n}" for n in sub_nums)
        + "\n"
    )
    new_body = (BODIES / "W07.md").read_text(encoding="utf-8") + footer
    payload = json.dumps({"body": new_body})
    r = subprocess.run(
        ["gh", "api", f"repos/{REPO}/issues/{w7}", "-X", "PATCH", "--input", "-"],
        input=payload,
        capture_output=True,
        text=True,
        cwd=ROOT,
    )
    if r.returncode != 0:
        print(r.stderr, file=sys.stderr)
        sys.exit(r.returncode)
    print(f"Updated W07 #{w7} with sub-issue links")

    n8 = create_issue(
        "W08 — session-context.md + CURSOR_CONTEXT.md post-M0",
        BODIES / "W08.md",
        ["fase-0", "alta", "documentation"],
    )
    print(f"Created #{n8}: W08")


if __name__ == "__main__":
    main()
