# Claude Framework

A lean, opinionated setup for Claude Code projects. Provides session continuity, development rules, and pre-production quality gates.

## What's Included

| File | Purpose |
|------|---------|
| `RULES.md` | Mandatory development & session guidelines |
| `CLAUDE.md.template` | Project context template (customise per project) |
| `skills/handover.md` | `/handover` — Session handover with checkpoint, versioning, db export |
| `skills/resume.md` | `/resume` — Resume from latest checkpoint |
| `skills/preprod.md` | `/preprod` — Pre-production readiness (SDLC tests + OWASP Top 10) |
| `install.sh` | One-command installer |

## Install

### Option 1: One-liner (from any project directory)

```bash
curl -sL https://raw.githubusercontent.com/vji11/claude-framework/main/install.sh | bash
```

### Option 2: Clone and install

```bash
git clone https://github.com/vji11/claude-framework.git /tmp/claude-framework
bash /tmp/claude-framework/install.sh /path/to/your/project
rm -rf /tmp/claude-framework
```

### Option 3: Install into a specific project

```bash
bash install.sh /path/to/your/project
```

## What It Does

The installer:

1. **Copies `RULES.md`** into your project root (always updated)
2. **Creates `CLAUDE.md`** from template if it doesn't exist (won't overwrite)
3. **Creates `CHANGELOG.md`** if it doesn't exist
4. **Creates directories**: `docs/checkpoints/`, `scripts/`
5. **Installs skills** to `~/.claude/commands/` (global, works in all projects)

## Skills

### `/handover`

Run before ending any session. It will:
- Bump app version (if applicable)
- Export database and document schema (if applicable)
- Update CLAUDE.md, CHANGELOG.md, README.md
- Create a checkpoint in `docs/checkpoints/`
- Git commit and push everything

### `/resume`

Start a new session with this. Reads the latest checkpoint and summarises where you left off.

### `/preprod`

Full pre-production readiness gate. Runs sequentially:

1. **Unit tests** — Run full suite, check coverage
2. **Integration tests** — API endpoints, database CRUD, external services
3. **Functional tests** — User flows, RBAC, forms, search
4. **Build verification** — Clean production build, env vars documented
5. **Database readiness** — Migrations current, schema exported, indexes checked
6. **OWASP Top 10 security audit:**
   - A01: Broken Access Control
   - A02: Cryptographic Failures
   - A03: Injection
   - A04: Insecure Design
   - A05: Security Misconfiguration
   - A06: Vulnerable Components
   - A07: Auth Failures
   - A08: Integrity Failures
   - A09: Logging Failures
   - A10: SSRF
7. **Performance** — N+1 queries, caching, response times
8. **Deployment readiness** — Dockerfile, health checks, rollback procedure

Outputs a pass/fail report to `docs/preprod-report-YYYY-MM-DD.md`. Any OWASP failure = NOT READY.

## Update

Re-run the installer to update RULES.md and skills. Your CLAUDE.md and CHANGELOG.md won't be touched.

```bash
curl -sL https://raw.githubusercontent.com/vji11/claude-framework/main/install.sh | bash
```
