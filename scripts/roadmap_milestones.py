"""
Map ROADMAP / SCRUM ticket ids a milestones GitHub (Fase 0–5).

Cada fase 1–5 tiene milestones **por sprint** (Tb.c → sprint Sb dentro de Fase T).
- Fase 1 = **ERP Satélite** (MVP campo), sprints S1–S5 según ROADMAP.
- Fase 2–3: S1–S4; Fase 4 (CRM): S1–S5; Fase 5 (offline): S1–S2.
- T0.*.* → milestone de fase (Fase 0) o rollup de fase cuando no hay stream de sprint.
- [E##-S##-##]: sprints 1–6 → F1 S1–S5; 7–10 → F2 S1–S4 (plan 5 meses).

En GitHub: **rollup** `Fase N — …` por fase **y** milestones `Fase N · S#` por sprint
(`ensure_roadmap_milestones.py` crea ambos).
"""
from __future__ import annotations

import re
import unicodedata

# Títulos canónicos para `gh issue edit --milestone` (crear con ensure_roadmap_milestones.py)
PHASE_TO_MILESTONE: dict[int, str] = {
    0: "Fase 0 — Fundación",
    1: "Fase 1 — ERP Satélite (MVP)",
    2: "Fase 2 — ERP Básico",
    3: "Fase 3 — ERP Completo",
    4: "Fase 4 — CRM",
    5: "Fase 5 — Offline-First",
}

# Sprints por fase (segundo índice del id T{phase}.{stream}.*)
FASE_1_SPRINT_TITLES: dict[int, str] = {
    1: "Fase 1 · S1 — Modelo de datos e importación",
    2: "Fase 1 · S2 — Login y catálogo",
    3: "Fase 1 · S3 — Recepción y traslados",
    4: "Fase 1 · S4 — Misiones de conteo",
    5: "Fase 1 · S5 — Arqueo de caja",
}
FASE_2_SPRINT_TITLES: dict[int, str] = {
    1: "Fase 2 · S1 — Catálogos",
    2: "Fase 2 · S2 — Compras",
    3: "Fase 2 · S3 — Ventas",
    4: "Fase 2 · S4 — Inventario",
}
FASE_3_SPRINT_TITLES: dict[int, str] = {
    1: "Fase 3 · S1 — Contabilidad",
    2: "Fase 3 · S2 — RRHH",
    3: "Fase 3 · S3 — Reportes gerenciales",
    4: "Fase 3 · S4 — Auditoría y trazabilidad",
}
FASE_4_SPRINT_TITLES: dict[int, str] = {
    1: "Fase 4 · S1 — Comunicación interna",
    2: "Fase 4 · S2 — Transcripción y audio",
    3: "Fase 4 · S3 — Casos y tickets",
    4: "Fase 4 · S4 — Pipeline de ventas",
    5: "Fase 4 · S5 — Historial por cliente",
}
FASE_5_SPRINT_TITLES: dict[int, str] = {
    1: "Fase 5 · S1 — DB local y UI offline",
    2: "Fase 5 · S2 — Sync y conflictos",
}

SPRINT_TITLES_BY_PHASE: dict[int, dict[int, str]] = {
    1: FASE_1_SPRINT_TITLES,
    2: FASE_2_SPRINT_TITLES,
    3: FASE_3_SPRINT_TITLES,
    4: FASE_4_SPRINT_TITLES,
    5: FASE_5_SPRINT_TITLES,
}

_MAX_STREAM_BY_PHASE: dict[int, int] = {1: 5, 2: 4, 3: 4, 4: 5, 5: 2}


def milestone_title_for_sprint(phase: int, stream: int) -> str | None:
    """stream = segundo dígito del id T2.3.1 → 3."""
    return SPRINT_TITLES_BY_PHASE.get(phase, {}).get(stream)


def sprint_stream_from_granular_t_id(ticket_id: str) -> tuple[int, int] | None:
    """T1.2.3 → (1,2); T4.5.1 → (4,5); T5.2.1 → (5,2)."""
    m = re.match(r"^T(\d+)\.(\d+)\.\d+\b", ticket_id.strip(), re.I)
    if not m:
        return None
    phase, stream = int(m.group(1)), int(m.group(2))
    if phase not in _MAX_STREAM_BY_PHASE:
        return None
    mx = _MAX_STREAM_BY_PHASE[phase]
    if 1 <= stream <= mx:
        return (phase, stream)
    return None


def milestone_title_for_granular_roadmap_id(ticket_id: str) -> str | None:
    """T1–T5 con stream válido → sprint; T0 → milestone de fase."""
    ss = sprint_stream_from_granular_t_id(ticket_id)
    if ss:
        p, s = ss
        return milestone_title_for_sprint(p, s)
    p = phase_from_granular_roadmap_id(ticket_id)
    if p is not None:
        return milestone_title_for_phase(p)
    return None


def milestone_title_from_issue_title(title: str) -> str | None:
    """
    Título de issue: T2.1.3 - …, [E05-S10-01] …, [T01] …
    """
    t = title.strip()
    m = re.match(r"^T(\d+)\.(\d+)\.\d+\b", t, re.I)
    if m:
        phase, stream = int(m.group(1)), int(m.group(2))
        ss = sprint_stream_from_granular_t_id(t)
        if ss:
            p, s = ss
            return milestone_title_for_sprint(p, s)
        if 0 <= phase <= 5:
            return milestone_title_for_phase(phase)
        return None
    if re.match(r"^\[E\d+-P-\d+\]", t, re.I):
        return milestone_title_for_phase(0)
    m = re.match(r"^\[E\d+-S(\d+)-\d+\]", t, re.I)
    if m:
        sn = int(m.group(1))
        ph = phase_from_scrum_sprint_number(sn)
        # Sprints 1–6 → Fase 1 (ERP Satélite), S1–S5; sprint 6 comparte S5
        if ph == 1 and 1 <= sn <= 6:
            return milestone_title_for_sprint(1, min(sn, 5))
        if ph == 2 and 7 <= sn <= 10:
            return milestone_title_for_sprint(2, sn - 6)
        ms = milestone_title_from_epic_sprint_number(sn)
        if ms:
            return ms
        if ph is not None:
            return milestone_title_for_phase(ph)
        return None
    p = phase_from_issue_title(t)
    if p is None:
        return None
    return milestone_title_for_phase(p)


def month_int_from_csv_row(row: dict[str, str]) -> int | None:
    month_raw = (row.get("Month") or "").strip()
    if not month_raw or month_raw in ("—", "-", "–", "N/A", "n/a"):
        return None
    try:
        return int(float(month_raw))
    except ValueError:
        return None


def milestone_title_for_csv_row(row: dict[str, str]) -> str | None:
    """
    Fase 1: mes 1–3 → reparto S1/S3/S5; o número de sprint SCRUM 1–6 → S1–S5.
    Fase 2: mes 4–7 → S1–S4; Fase 3: mes 8–9 → S1–S2; mes 10 → S3 o S4 según sprint CSV.
    """
    phase = phase_from_csv_row(row)
    if phase is None:
        return None
    month = month_int_from_csv_row(row)
    sprint_raw = (row.get("Sprint") or "").strip()
    if phase == 1:
        if not sprint_raw.upper().startswith("PRE"):
            try:
                sp = int(float(sprint_raw))
                if 1 <= sp <= 6:
                    return milestone_title_for_sprint(1, min(sp, 5))
            except ValueError:
                pass
        if month is not None and 1 <= month <= 3:
            stream = min((month - 1) * 2 + 1, 5)
            return milestone_title_for_sprint(1, stream)
    if phase == 2 and month is not None and 4 <= month <= 7:
        return milestone_title_for_sprint(2, month - 3)
    if phase == 3 and month is not None and 8 <= month <= 10:
        if month <= 9:
            stream = month - 7
        else:
            try:
                sp = int(float(sprint_raw)) if sprint_raw else 0
            except ValueError:
                sp = 0
            stream = 4 if sp >= 20 else 3
        ms = milestone_title_for_sprint(3, stream)
        if ms:
            return ms
    if phase == 4 and month is not None and 11 <= month <= 12:
        stream = 1 if month == 11 else 3
        return milestone_title_for_sprint(4, stream)
    if phase == 5 and month is not None and 13 <= month <= 14:
        return milestone_title_for_sprint(5, month - 12)
    return milestone_title_for_phase(phase)


def all_ensure_milestone_titles() -> list[str]:
    """Orden: milestones rollup fase 0–5, luego sprints F1→F5."""
    out: list[str] = [PHASE_TO_MILESTONE[i] for i in sorted(PHASE_TO_MILESTONE)]
    for ph in sorted(SPRINT_TITLES_BY_PHASE):
        d = SPRINT_TITLES_BY_PHASE[ph]
        out.extend(d[i] for i in sorted(d))
    return out


def phase_from_calendar_month(month: int) -> int:
    """Mes 1–14 del roadmap largo → fase (1-indexed meses)."""
    if month <= 0:
        return 0
    if month <= 3:
        return 1
    if month <= 7:
        return 2
    if month <= 10:
        return 3
    if month <= 12:
        return 4
    return 5


def phase_from_scrum_sprint_number(sprint_num: int) -> int:
    """
    Plan SCRUM 5 meses (docs/SCRUM_5MONTH_TICKETS.csv): sprints 1–2 → mes 1, 3–4 → mes 2, …
    """
    if sprint_num <= 0:
        return 0
    # sprint 1-2 → month 1, 3-4 → 2, 5-6 → 3, 7-8 → 4, 9-10 → 5
    month = (sprint_num + 1) // 2
    return phase_from_calendar_month(month)


def milestone_title_from_epic_sprint_number(sn: int) -> str | None:
    """
    Milestone **por sprint** para títulos `[E*-S{sn}-*]` fuera del bloque F1 (S1–6) y F2 (S7–10).

    Calendario alineado a ROADMAP 14 meses: mes M ≈ (sn+1)//2 → fase vía phase_from_calendar_month.
    - Fase 3 (meses 8–10): sn 15–20 → S1..S4 (pares de 2 semanas por stream).
    - Fase 4 (meses 11–12): sn 21–24 → S1..S4; **S5** (Historial) sin par en sn → usar T4.5.* o rollup.
    - Fase 5 (meses 13–14): sn 25–28 → S1..S2.
    """
    if sn <= 0:
        return None
    month = (sn + 1) // 2
    ph = phase_from_calendar_month(month)
    # F2 “extra” (mismo trimestre ERP básico): sn 11–14 → reparto a S2–S4
    if ph == 2 and 11 <= sn <= 14:
        stream = min(max(sn - 9, 2), 4)
        return milestone_title_for_sprint(2, stream)
    if ph == 3 and 15 <= sn <= 20:
        stream = min((sn - 15) // 2 + 1, 4)
        return milestone_title_for_sprint(3, stream)
    if ph == 4 and 21 <= sn <= 24:
        stream = min(sn - 20, 4)
        return milestone_title_for_sprint(4, stream)
    if ph == 5 and 25 <= sn <= 28:
        stream = min((sn - 25) // 2 + 1, 2)
        return milestone_title_for_sprint(5, stream)
    return None


def phase_from_granular_roadmap_id(ticket_id: str) -> int | None:
    """T1.2.3 → fase 1; T0.1.1 → 0; T5.2.4 → 5."""
    m = re.match(r"^T(\d+)\.\d+\.\d+\b", ticket_id.strip(), re.I)
    if not m:
        return None
    p = int(m.group(1))
    if 0 <= p <= 5:
        return p
    return None


def phase_from_e_ticket_id(ticket_id: str) -> int | None:
    """
    E1-P-01 → Fase 0 (pre-sprint).
    E05-S10-07 → fase según número de sprint en el id (S10 → mes 5 → Fase 2).
    """
    s = ticket_id.strip()
    if re.match(r"^E\d+-P-\d+", s, re.I):
        return 0
    m = re.match(r"^E\d+-S(\d+)-\d+", s, re.I)
    if m:
        return phase_from_scrum_sprint_number(int(m.group(1)))
    return None


def phase_from_csv_row(row: dict[str, str]) -> int | None:
    """
    Columnas Epic, Sprint, Month del CSV SCRUM.
    Pre-S1 / E*-P-* → Fase 0; si hay Month numérico, manda sobre sprint.
    """
    tid = (row.get("ID") or "").strip()
    if re.match(r"^E\d+-P-\d+", tid, re.I):
        return 0
    month_raw = (row.get("Month") or "").strip()
    if month_raw and month_raw not in ("—", "-", "–", "N/A", "n/a"):
        try:
            # "1" … "5" en el CSV de 5 meses
            m = int(float(month_raw))
            return phase_from_calendar_month(m)
        except ValueError:
            pass
    sprint_raw = (row.get("Sprint") or "").strip()
    if sprint_raw.upper().startswith("PRE") or sprint_raw in ("Pre-S1", "Pre-Sprint"):
        return 0
    try:
        sp = int(float(sprint_raw))
        return phase_from_scrum_sprint_number(sp)
    except ValueError:
        pass
    return phase_from_e_ticket_id(tid)


def phase_from_issue_title(title: str) -> int | None:
    """Inferir fase desde el título del issue en GitHub."""
    t = title.strip()

    m = re.match(r"^T(\d+)\.\d+\.\d+\b", t, re.I)
    if m:
        p = int(m.group(1))
        if 0 <= p <= 5:
            return p

    m = re.match(r"^\[E(\d+)-P-\d+\]", t, re.I)
    if m:
        return 0

    m = re.match(r"^\[E\d+-S(\d+)-\d+\]", t, re.I)
    if m:
        return phase_from_scrum_sprint_number(int(m.group(1)))

    m = re.match(r"^\[T(\d+)\]\s*", t, re.I)
    if m:
        return _phase_from_coarse_t_number(int(m.group(1)))

    return None


def _phase_from_coarse_t_number(n: int) -> int | None:
    """
    [T01]…[T35] alineados al ROADMAP por número (aprox.).
    T01–T07 fundación + inicio satélite → F0/F1; el resto repartido por bloques del README.
    """
    if n <= 0:
        return None
    if n <= 7:
        return 0 if n <= 3 else 1
    if n <= 18:
        return 1
    if n <= 28:
        return 2
    if n <= 32:
        return 3
    if n <= 34:
        return 4
    return 5


def milestone_title_for_phase(phase: int) -> str | None:
    return PHASE_TO_MILESTONE.get(phase)


def norm_milestone_key(s: str) -> str:
    s = s.strip().lower()
    s = unicodedata.normalize("NFKD", s)
    return "".join(c for c in s if not unicodedata.combining(c))
