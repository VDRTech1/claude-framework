# Claude Framework

A lean setup for Claude Code projects. Session continuity, development rules, code review, debugging, and pre-production quality gates.

## What's Included

| File | Purpose |
|------|---------|
| `RULES.md` | Mandatory development & session guidelines |
| `CLAUDE.md.template` | Project context template (customise per project) |
| `skills/handover.md` | `/handover` — Session handover with checkpoint, versioning, db export |
| `skills/resume.md` | `/resume` — Resume from latest checkpoint |
| `skills/review.md` | `/review` — Structured code review |
| `skills/debug.md` | `/debug` — Structured debugging workflow (5 Whys) |
| `skills/preprod.md` | `/preprod` — Pre-production readiness (SDLC + OWASP Top 10) |
| `statusbar/status.sh` | Status bar — git branch/status + Star Wars quote |
| `install.sh` | One-command installer |

## Install

### One-liner (from any project directory)

```bash
curl -sL https://raw.githubusercontent.com/vji11/claude-framework/main/install.sh | bash
```

### Clone and install into a specific project

```bash
git clone https://github.com/vji11/claude-framework.git /tmp/claude-framework
bash /tmp/claude-framework/install.sh /path/to/your/project
rm -rf /tmp/claude-framework
```

## What It Does

The installer:

1. **Copies `RULES.md`** into your project root (always updated on re-install)
2. **Creates `CLAUDE.md`** from template if it doesn't exist (won't overwrite)
3. **Creates `CHANGELOG.md`** if it doesn't exist
4. **Creates directories**: `docs/checkpoints/`, `scripts/`
5. **Installs 5 skills** to `~/.claude/commands/` (global, works in all projects)
6. **Installs status bar** to `~/.claude/hooks/` and registers in `settings.json`

## Skills

### `/handover`
Run before ending any session. Bumps app version, exports database, updates CLAUDE.md + CHANGELOG.md, creates checkpoint in `docs/checkpoints/`, commits and pushes.

### `/resume`
Start a new session. Reads the latest checkpoint and summarises where you left off.

### `/review`
Structured code review on session changes. Checks: correctness, error handling, security, code quality, dead code, tests. Outputs pass/warn/fail per category.

### `/debug`
Structured debugging workflow with **5 Whys** root cause analysis: reproduce → locate → recent changes → isolate → 5 Whys → fix → verify.

### `/preprod`
Full pre-production readiness gate:

1. Unit tests + coverage
2. Integration tests
3. Functional tests
4. Build verification
5. Database readiness
6. **OWASP Top 10** — all 10 categories checked individually
7. Performance
8. Deployment readiness

Outputs a pass/fail report. Any OWASP failure = NOT READY.

## Status Bar

Shows git branch status and a rotating Star Wars quote:

```
main:clean | Do. Or do not. There is no try.
main:3M    | Stay on target.
```

- **Green** `main:clean` — no uncommitted changes
- **Yellow** `main:3M` — 3 modified files

## Update

Re-run the installer to update RULES.md, skills, and status bar. Your CLAUDE.md and CHANGELOG.md won't be touched.

```bash
curl -sL https://raw.githubusercontent.com/vji11/claude-framework/main/install.sh | bash
```

## Uninstall

```bash
rm -f ~/.claude/commands/{handover,resume,review,debug,preprod}.md
rm -f ~/.claude/hooks/status.sh
# Remove statusLine from ~/.claude/settings.json manually
# Project files (RULES.md, CLAUDE.md, etc.) can stay or be deleted per project
```
