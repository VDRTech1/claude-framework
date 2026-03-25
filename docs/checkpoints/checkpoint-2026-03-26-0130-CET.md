# Checkpoint — 2026-03-26 01:30 CET

## Current State Snapshot

- **Branch**: main
- **Build status**: N/A (framework is scripts/markdown, no build)
- **Git status**: clean before session; changes pending from this session
- **Files modified**: `install.sh`, `install.ps1`, `README.md`
- **Files created**: `CHANGELOG.md`, `docs/checkpoints/`

## Work Completed

1. **Installation verification** — Confirmed framework is cloned and up to date at `/opt/claude-framework`
2. **Identified 2 missing skills** — `/codex` and `/inov` were in the repo but not installed to `~/.claude/commands/`
3. **Installed missing skills** — Copied `codex.md` and `inov.md` to `~/.claude/commands/`
4. **Fixed `/inov` omission from installers** — The `/inov` skill existed in `skills/` but was never added to `install.sh`, `install.ps1`, or `README.md`
   - Added `inov` to the skill loop in both installers
   - Added `/inov` entry to README skills table, description section, and uninstall command
   - Updated skill count from 7 to 8
5. **Created CHANGELOG.md** for the framework repo
6. **Security note** — Flagged that the git remote URL contains a plaintext GitHub PAT

## Work Remaining

- **Rotate the GitHub PAT** exposed in the git remote URL and switch to SSH or credential-helper auth
- Consider running `/ashy-init` on target projects to set them up with the framework
- No other framework changes pending

## Critical Knowledge

- **Framework repo**: `/opt/claude-framework`
- **Remote**: `https://github.com/VDRTech1/claude-framework.git`
- **Skills install to**: `~/.claude/commands/`
- **Status bar installs to**: `~/.claude/hooks/status.sh`
- **Global settings**: `~/.claude/settings.json`
- **Extra custom skills** (not from framework): `cloudflare-manage`, `gcp-manage`, `gw-manage`

## Recovery Information

- **Rollback**: `git checkout HEAD -- install.sh install.ps1 README.md && rm CHANGELOG.md docs/checkpoints/`
- **Verify install**: Compare `ls ~/.claude/commands/` against skills listed in `install.sh`
- **Re-install**: `bash /opt/claude-framework/install.sh /path/to/project`
