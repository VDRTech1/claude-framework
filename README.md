# Claude Framework

A lean, opinionated setup for Claude Code projects. Provides session continuity, development rules, code review, debugging, and pre-production quality gates.

## What's Included

| File | Purpose |
|------|---------|
| `RULES.md` | Mandatory development & session guidelines |
| `CLAUDE.md.template` | Project context template (customise per project) |
| **Skills** | |
| `skills/handover.md` | `/handover` — Session handover with checkpoint, versioning, db export |
| `skills/resume.md` | `/resume` — Resume from latest checkpoint |
| `skills/compact.md` | `/compact` — Emergency context save before auto-compact |
| `skills/review.md` | `/review` — Structured code review |
| `skills/debug.md` | `/debug` — Structured debugging workflow |
| `skills/preprod.md` | `/preprod` — Pre-production readiness (SDLC + OWASP Top 10) |
| **Hooks** | |
| `hooks/precompact-save.sh` | Warns before auto-compact wipes context |
| `hooks/context-guard.sh` | Blocks stop when context >= 80%, prompts `/compact` |
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
5. **Installs 6 skills** to `~/.claude/commands/` (global, works in all projects)
6. **Installs 2 hooks** to `~/.claude/hooks/` and registers them in `settings.json`

## Skills

### `/handover`
Run before ending any session. Bumps app version, exports database, updates CLAUDE.md + CHANGELOG.md, creates checkpoint in `docs/checkpoints/`, commits and pushes.

### `/resume`
Start a new session. Reads the latest checkpoint and summarises where you left off.

### `/compact`
Emergency context save. Creates a quick checkpoint when context is getting full. Triggered automatically by the `context-guard` hook, or run manually.

### `/review`
Structured code review on session changes. Checks: correctness, error handling, security, code quality, dead code, tests. Outputs pass/warn/fail per category.

### `/debug`
Structured debugging workflow: reproduce → locate → recent changes → isolate → root cause → fix → verify. Prevents random guessing.

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

## Hooks

### `precompact-save`
**Event:** PreCompact — Fires before Claude Code auto-compacts the context window. Injects a warning telling Claude to run `/compact` first.

### `context-guard`
**Event:** Stop — When Claude tries to stop and context usage is >= 80%, blocks and prompts to run `/compact` before continuing.

Together, these two hooks ensure you never lose session context silently.

## Update

Re-run the installer to update RULES.md, skills, and hooks. Your CLAUDE.md and CHANGELOG.md won't be touched.

```bash
curl -sL https://raw.githubusercontent.com/vji11/claude-framework/main/install.sh | bash
```

## Uninstall

```bash
# Remove skills
rm -f ~/.claude/commands/{handover,resume,compact,review,debug,preprod}.md

# Remove hooks
rm -f ~/.claude/hooks/{context-guard,precompact-save}.sh

# Remove hook registrations from settings.json (manually edit)
# Project files (RULES.md, CLAUDE.md, etc.) can stay or be deleted per project
```
