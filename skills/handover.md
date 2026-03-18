Perform a full session handover. This is MANDATORY before ending any session.

## Steps

### 1. Versioning (where applicable)
- Bump the app version if new features or bug fixes were implemented
- Ensure the version is visible in the application itself (footer, settings, or wherever it's tracked)
- Keep versioning aligned across all apps in the project

### 2. Database (where applicable)
- Perform a database export
- Ensure database structure is documented in `/docs/database/`

### 3. Update project files
- **CLAUDE.md** — Update version number and date
- **CHANGELOG.md** — Add new version entry with all changes made this session
- **README.md** — Update version number if changed

### 4. Create checkpoint
Write a checkpoint file to `/docs/checkpoints/checkpoint-YYYY-MM-DD-HHMM-TIMEZONE.md` with these sections:

1. **Current State Snapshot** — Build status, files modified, services status, git status
2. **Work Completed** — Changes made, commands executed, git activity
3. **Work Remaining** — Immediate tasks, pending changes
4. **Critical Knowledge** — Environment details, known issues, file paths
5. **Recovery Information** — Rollback procedures, verify commands

### 5. Git push

**ABSOLUTELY MANDATORY**: All changes MUST be pushed to git:
- Source code modifications
- Documentation updates
- Checkpoint file
- CLAUDE.md, CHANGELOG.md, README.md updates

**Session NOT complete until `git push` succeeds.**

## Trigger phrases
- "handover"
- "save current state"
- "close session"

Before writing, review what was accomplished this session by checking git diff, git log, and conversation context.
