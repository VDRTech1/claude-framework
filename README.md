# Claude Framework

A lean setup for Claude Code projects. Session continuity, development rules, code review, debugging, and pre-production quality gates.

## What's Included

| File | Purpose |
|------|---------|
| `RULES.md` | Mandatory development & session guidelines |
| `CLAUDE.md.template` | Project context template (customise per project) |
| `INSTALL.md` | Installation instructions for Claude Code |
| `skills/handover.md` | `/handover` — Session handover with checkpoint, versioning, db export |
| `skills/QQQ.md` | `/QQQ` — Resume from latest checkpoint |
| `skills/review.md` | `/review` — Structured code review |
| `skills/debug.md` | `/debug` — Structured debugging workflow (5 Whys) |
| `skills/preprod.md` | `/preprod` — Pre-production readiness (SDLC + OWASP Top 10) |
| `skills/codex.md` | `/codex` — Joint review with OpenAI Codex CLI (two-model analysis) |
| `skills/ashy-init.md` | `/ashy-init` — Interactive project setup wizard (run first) |
| `skills/inov.md` | `/inov` — Radical innovation proposals |
| `statusbar/status.sh` | Status bar — git branch/status + rotating quote |

## Install

1. Clone the framework:

```bash
git clone https://github.com/VDRTech1/claude-framework.git /opt/claude-framework
```

2. Tell Claude Code to install it into your project:

```
Install the Claude Framework from /opt/claude-framework into this project
```

Or run `/ashy-init` which handles installation + project setup interactively.

Claude Code reads `INSTALL.md` and performs all installation steps automatically — no scripts needed.

## What It Does

The installation:

1. **Copies `RULES.md`** into your project root (always updated on re-install)
2. **Creates `CLAUDE.md`** from template if it doesn't exist (won't overwrite)
3. **Creates `CHANGELOG.md`** if it doesn't exist
4. **Creates directories**: `docs/checkpoints/`, `scripts/`
5. **Installs 8 skills** to `~/.claude/commands/` (global, works in all projects)
6. **Installs status bar** to `~/.claude/hooks/` and registers in `settings.json`

## Skills

### `/handover`
Run before ending any session. Bumps app version, exports database, updates CLAUDE.md + CHANGELOG.md, creates checkpoint in `docs/checkpoints/`, commits and pushes.

### `/QQQ`
Start a new session. Reads the latest checkpoint and summarises where you left off.

### `/review`
Structured code review on session changes. Checks: correctness, error handling, security, code quality, dead code, tests. Outputs pass/warn/fail per category.

### `/debug`
Structured debugging workflow with **5 Whys** root cause analysis: reproduce → locate → recent changes → isolate → 5 Whys → fix → verify.

### `/ashy-init`
Interactive project setup wizard. Run this first after installing the framework. Walks you through project name, type, tech stack, git init, GitHub credentials, remote setup, `.gitignore` generation, development preferences, and environment checks. Supports both new projects and importing existing ones.

### `/codex`
Joint code review and bug resolution using OpenAI Codex CLI alongside Claude Code. Runs Codex as a second reviewer — Claude analyzes first, Codex provides a second pass, then findings are cross-referenced into a unified report with confidence levels. Requires `codex` CLI installed (`npm install -g @openai/codex`) and `OPENAI_API_KEY` set.

### `/inov`
Analyze the current project and propose radically innovative, high-impact improvements. Generates bold ideas that go beyond incremental fixes.

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

Shows context utilization, git branch status, and a rotating quote (Star Wars, South Park, Ashy):

```
CTX:16% | main:ok | Do. Or do not. There is no try.
CTX:55% | main:3M | Respect my authoritah!
```

Context thresholds:
- **Green** `CTX:16%` — plenty of room
- **Yellow** `CTX:55%` — over half used
- **Red** `CTX:72%` + warning — consider `/handover` soon
- **DANGER** `CTX:85%+` — full-screen red alert, all work stops, `/handover` mandatory

Git status:
- **Green** `main:ok` — no uncommitted changes
- **Yellow** `main:3M` — 3 modified files

## Update

Re-run the installation (tell Claude Code to install again). `RULES.md`, skills, and status bar will be updated. Your `CLAUDE.md` and `CHANGELOG.md` won't be touched.

## Uninstall

```bash
rm -f ~/.claude/commands/{handover,QQQ,review,debug,preprod,codex,ashy-init,inov}.md
rm -f ~/.claude/hooks/status.sh
# Remove statusLine from ~/.claude/settings.json manually
# Project files (RULES.md, CLAUDE.md, etc.) can stay or be deleted per project
```
