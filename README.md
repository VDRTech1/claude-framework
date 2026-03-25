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
| `skills/codex.md` | `/codex` — Joint review with OpenAI Codex CLI (two-model analysis) |
| `statusbar/status.sh` | Status bar — git branch/status + Star Wars quote |
| `install.sh` | One-command installer |

## Install

### macOS / Linux

```bash
curl -sL https://raw.githubusercontent.com/VDRTech1/claude-framework/main/install.sh | bash
```

Or clone and install into a specific project:

```bash
git clone https://github.com/VDRTech1/claude-framework.git /tmp/claude-framework
bash /tmp/claude-framework/install.sh /path/to/your/project
rm -rf /tmp/claude-framework
```

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/VDRTech1/claude-framework/main/install.ps1 | iex
```

Or clone and install into a specific project:

```powershell
git clone https://github.com/VDRTech1/claude-framework.git $env:TEMP\claude-framework
& $env:TEMP\claude-framework\install.ps1 C:\path\to\your\project
Remove-Item $env:TEMP\claude-framework -Recurse -Force
```

## What It Does

The installer:

1. **Copies `RULES.md`** into your project root (always updated on re-install)
2. **Creates `CLAUDE.md`** from template if it doesn't exist (won't overwrite)
3. **Creates `CHANGELOG.md`** if it doesn't exist
4. **Creates directories**: `docs/checkpoints/`, `scripts/`
5. **Installs 6 skills** to `~/.claude/commands/` (global, works in all projects)
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

### `/codex`
Joint code review and bug resolution using OpenAI Codex CLI alongside Claude Code. Runs Codex as a second reviewer — Claude analyzes first, Codex provides a second pass, then findings are cross-referenced into a unified report with confidence levels. Requires `codex` CLI installed (`npm install -g @openai/codex`) and `OPENAI_API_KEY` set.

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

**macOS / Linux:**
```bash
curl -sL https://raw.githubusercontent.com/VDRTech1/claude-framework/main/install.sh | bash
```

**Windows:**
```powershell
irm https://raw.githubusercontent.com/VDRTech1/claude-framework/main/install.ps1 | iex
```

## Uninstall

```bash
rm -f ~/.claude/commands/{handover,resume,review,debug,preprod,codex}.md
rm -f ~/.claude/hooks/status.sh
# Remove statusLine from ~/.claude/settings.json manually
# Project files (RULES.md, CLAUDE.md, etc.) can stay or be deleted per project
```
