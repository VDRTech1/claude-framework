# Claude Framework — Installation Guide

This file tells Claude Code how to install the framework. No scripts needed — Claude Code reads this and does it.

**Usage:** Clone this repo, then tell Claude Code: "Install the Claude Framework into /path/to/my/project"

Or just run `/ashy-init` which handles everything including installation.

---

## Installation Steps

When asked to install the Claude Framework into a target project directory, follow these steps in order.

### 1. Project Files

Copy these files from the framework repo into the target project directory:

| Source | Destination | Rule |
|--------|------------|------|
| `RULES.md` | `<project>/RULES.md` | **Always overwrite** — framework-managed, updated on every install |
| `CLAUDE.md.template` | `<project>/CLAUDE.md` | **Only if `CLAUDE.md` does NOT exist** — never overwrite a project's CLAUDE.md |

If `CHANGELOG.md` does not exist in the target project, create it with:
```
# CHANGELOG
```

### 2. Directories

Create these directories in the target project (skip if they exist):

```
docs/checkpoints/
scripts/
```

### 3. Skills (Global)

Copy all `.md` files from `skills/` to `~/.claude/commands/`:

```
~/.claude/commands/handover.md
~/.claude/commands/QQQ.md
~/.claude/commands/preprod.md
~/.claude/commands/review.md
~/.claude/commands/debug.md
~/.claude/commands/codex.md
~/.claude/commands/ashy-init.md
~/.claude/commands/inov.md
```

Always overwrite — these are framework-managed.

### 4. Status Bar

1. Copy `statusbar/status.sh` to `~/.claude/hooks/status.sh`
2. Make it executable: `chmod +x ~/.claude/hooks/status.sh`
3. Register in `~/.claude/settings.json` — add this key (merge, don't overwrite the file):

```json
{
  "statusLine": {
    "type": "command",
    "command": "bash $HOME/.claude/hooks/status.sh"
  }
}
```

Skip if `status.sh` is already registered.

### 5. Verify

After installation, confirm:
- `RULES.md` exists in the project
- `CLAUDE.md` exists in the project (either pre-existing or newly created from template)
- `CHANGELOG.md` exists in the project
- `docs/checkpoints/` directory exists
- `scripts/` directory exists
- All 8 skills are in `~/.claude/commands/`
- Status bar is in `~/.claude/hooks/status.sh`

Report what was installed/skipped.

---

## Update

Re-run the installation. `RULES.md`, skills, and status bar will be updated. `CLAUDE.md` and `CHANGELOG.md` are never overwritten.

## Uninstall

```bash
rm -f ~/.claude/commands/{handover,QQQ,review,debug,preprod,codex,ashy-init,inov}.md
rm -f ~/.claude/hooks/status.sh
# Remove statusLine from ~/.claude/settings.json manually
# Project files (RULES.md, CLAUDE.md, etc.) can stay or be deleted per project
```
