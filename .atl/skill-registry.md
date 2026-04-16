# Skill Registry

**Delegator use only.** Any agent that launches sub-agents reads this registry to resolve compact rules, then injects them directly into sub-agent prompts. Sub-agents do NOT read this registry or individual SKILL.md files.

See `_shared/skill-resolver.md` in the Gentleman SDD skill pack for the full resolution protocol (if present in your environment).

## User Skills

User-level paths deduplicated by skill `name` using scan order: `.gemini/skills` → `.cursor/skills` → `.copilot/skills` → `.codex/skills` (project-level overrides would win if any existed).

| Trigger | Skill | Path |
|---------|-------|------|
| When creating a pull request, opening a PR, or preparing changes for review | branch-pr | `C:\Users\acace\.gemini\skills\branch-pr\SKILL.md` |
| When creating a GitHub issue, reporting a bug, or requesting a feature | issue-creation | `C:\Users\acace\.gemini\skills\issue-creation\SKILL.md` |
| When writing Go tests, using teatest, or adding test coverage | go-testing | `C:\Users\acace\.gemini\skills\go-testing\SKILL.md` |
| When user says judgment day, judgment-day, review adversarial, dual review, doble review, juzgar, que lo juzguen | judgment-day | `C:\Users\acace\.gemini\skills\judgment-day\SKILL.md` |
| When user asks to create a new skill, add agent instructions, or document patterns for AI | skill-creator | `C:\Users\acace\.gemini\skills\skill-creator\SKILL.md` |
| OpenAI products/APIs, models, official docs with citations | openai-docs | `C:\Users\acace\.codex\skills\.system\openai-docs\SKILL.md` |
| List/install Codex skills from curated GitHub or other repo path | skill-installer | `C:\Users\acace\.codex\skills\.system\skill-installer\SKILL.md` |
| Keep a PR merge-ready (comments, conflicts, CI) | babysit | `C:\Users\acace\.cursor\skills-cursor\babysit\SKILL.md` |
| Create hooks, hooks.json, hook scripts, agent event automation | create-hook | `C:\Users\acace\.cursor\skills-cursor\create-hook\SKILL.md` |
| Create Cursor rules, .cursor/rules, AGENTS.md, coding standards | create-rule | `C:\Users\acace\.cursor\skills-cursor\create-rule\SKILL.md` |
| Create/write Agent Skills for Cursor, SKILL.md format, best practices | create-skill | `C:\Users\acace\.cursor\skills-cursor\create-skill\SKILL.md` |
| Create custom subagents, .cursor/agents, specialized prompts | create-subagent | `C:\Users\acace\.cursor\skills-cursor\create-subagent\SKILL.md` |
| Migrate .mdc rules and slash commands to skills layout | migrate-to-skills | `C:\Users\acace\.cursor\skills-cursor\migrate-to-skills\SKILL.md` |
| User invoked `/shell` — run following text as literal shell command | shell | `C:\Users\acace\.cursor\skills-cursor\shell\SKILL.md` |
| Status line, statusline, CLI prompt footer, session context bar | statusline | `C:\Users\acace\.cursor\skills-cursor\statusline\SKILL.md` |
| Cursor CLI cli-config.json, permissions, sandbox, approval mode | update-cli-config | `C:\Users\acace\.cursor\skills-cursor\update-cli-config\SKILL.md` |
| Cursor/VS Code settings.json, editor preferences | update-cursor-settings | `C:\Users\acace\.cursor\skills-cursor\update-cursor-settings\SKILL.md` |

SDD workflow skills (`sdd-*`) and `skill-registry` are intentionally omitted from this catalog.

## Compact Rules

Pre-digested rules per skill. Delegators copy matching blocks into sub-agent prompts as `## Project Standards (auto-resolved)`.

### branch-pr
- Every PR MUST link an approved issue; every PR MUST have exactly one `type:*` label.
- Automated checks must pass before merge; blank PRs without issue linkage are blocked by automation.
- Branch naming and conventional commits follow the full skill workflow.

### issue-creation
- Blank issues disabled — MUST use a template (bug or feature).
- New issues get `status:needs-review`; maintainer adds `status:approved` before any PR.
- Use Discussions for questions, not issues (per linked repo policy in skill).

### go-testing
- Prefer table-driven tests for multiple cases; use `t.Run` per case.
- Bubbletea: test `Model.Update` directly for state transitions; use `teatest.NewTestModel` for full interactive flows.
- Golden files: store under `testdata/`, optional `-update` flag pattern for refreshing goldens.
- Integration/exec: use `--short` skips, `t.TempDir()`, mock `os/exec` via interfaces when needed.

### judgment-day
- Before judges: resolve skill registry (Engram or `.atl/skill-registry.md`); build identical `## Project Standards` for both judges and the fix agent.
- Launch **two** blind judges in parallel on the **same** target; orchestrator never substitutes as reviewer.
- Synthesize: Confirmed (both), Suspect (one), Contradiction (disagree); classify warnings as **real** vs **theoretical** (theoretical → info only, no fix/re-judge).
- After fixes for confirmed/real warnings: re-run both judges; escalate after two iterations if still failing.

### skill-creator
- Use Agent Skills layout: `SKILL.md` + optional `assets/`, `references/`; frontmatter with `name`, `description` (include explicit **Trigger:** line).
- Do not create a skill when docs suffice, pattern is trivial, or task is one-off.
- Keep body structured: When to Use, Critical Patterns, actionable steps — avoid essay-only prose.

### openai-docs
- Prefer OpenAI developer-docs MCP (`search_openai_docs`, `fetch_openai_doc`) over generic web search.
- Restrict fallback browsing to official OpenAI domains; cite retrieved docs for API and model guidance.

### skill-installer
- Default catalog: `openai/skills` `.curated`; `.experimental` when user asks.
- Use `list-skills.py` / `install-skill-from-github.py` from the skill’s scripts; network may need sandbox escalation.
- Installs to `$CODEX_HOME/skills/<name>`; abort if destination exists; tell user to restart Codex after install.

### babysit
- Triage every PR comment (including bots); fix only what you agree with; explain disagreements.
- Resolve merge conflicts only when intent clearly matches; otherwise stop for clarification.
- Fix CI with small scoped changes; re-check until green and mergeable.

### create-hook
- Project hooks: `.cursor/hooks.json` + `.cursor/hooks/*` (paths from repo root); user hooks under `~/.cursor/`.
- Narrowest hook event; decide fail-open vs fail-closed; support command vs prompt hooks and matchers when needed.

### create-rule
- Rules are `.mdc` in `.cursor/rules/` with YAML frontmatter: `description`, optional `globs`, `alwaysApply`.
- Clarify scope: always-on vs file patterns (`**/*.kt`, etc.) before writing.

### create-skill
- Choose personal (`~/.cursor/skills/`) vs project (`.cursor/skills/`) from user intent.
- `SKILL.md` required; optional `scripts/`, `references/`; frontmatter description must say when to apply the skill.

### create-subagent
- Project agents: `.cursor/agents/*.md` (wins over user); user agents: `~/.cursor/agents/*.md`.
- File = YAML frontmatter (`name`, `description`) + markdown system prompt body.

### migrate-to-skills
- **Copy verbatim** — do not rewrite or “improve” rule/command bodies when migrating.
- Migrate rules that have `description` but no `globs` and not `alwaysApply: true`; migrate all `.cursor/commands/*.md`.
- Ignore `~/.cursor/worktrees` and `~/.cursor/skills-cursor` as sources.

### shell
- Only when user explicitly uses `/shell`; treat everything after `/shell` as the literal command.
- Run immediately; do not rewrite or pre-analyze unless the command requires repo context.

### statusline
- Configure in `~/.cursor/cli-config.json` → `statusLine.command`; stdin JSON matches CLI `StatusLinePayload`.
- Respect `updateIntervalMs` (≥300), `timeoutMs`, `padding`; script must exit cleanly.

### update-cli-config
- User config: `~/.cursor/cli-config.json`; project merge: `.cursor/cli.json` from git root downward (deeper wins).
- After edits, user must restart CLI; preserve unrelated keys; validate JSON.

### update-cursor-settings
- Windows: `%APPDATA%\Cursor\User\settings.json`; read first, merge minimal deltas, validate JSON.
- Do not wipe unrelated settings; only change keys the user requested.

## Project Conventions

| File | Path | Notes |
|------|------|-------|
| Global ERP rules (stack, Supabase, RLS, migrations) | `c:\Users\acace\Downloads\proyects_coding\ERP\.cursor\rules\project.mdc` | `alwaysApply` — primary project standard |

No `agents.md`, `AGENTS.md`, `CLAUDE.md`, `.cursorrules`, `GEMINI.md`, or `copilot-instructions.md` found at repository root.

Read the convention files listed above for project-specific patterns. Referenced paths are explicit — no index indirection.
