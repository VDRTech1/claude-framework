#!/bin/bash
set -e

# Claude Framework Installer
# Usage: curl -s https://raw.githubusercontent.com/vji11/claude-framework/main/install.sh | bash
# Or:    git clone https://github.com/VDRTech1/claude-framework.git && cd claude-framework && bash install.sh

REPO_URL="https://raw.githubusercontent.com/VDRTech1/claude-framework/main"
PROJECT_DIR="${1:-.}"

echo "=== Claude Framework Installer ==="
echo "Target: $PROJECT_DIR"
echo ""

# Detect if running from cloned repo or curl
if [ -f "$(dirname "$0")/RULES.md" ]; then
    SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)"
    echo "Installing from local clone: $SOURCE_DIR"
    LOCAL=true
else
    echo "Installing from GitHub..."
    LOCAL=false
fi

copy_file() {
    local src="$1"
    local dest="$2"

    if [ "$LOCAL" = true ]; then
        cp "$SOURCE_DIR/$src" "$dest"
    else
        curl -sL "$REPO_URL/$src" -o "$dest"
    fi
}

# --- Project files ---

# RULES.md — always overwrite (framework-managed)
copy_file "RULES.md" "$PROJECT_DIR/RULES.md"
echo "  RULES.md installed"

# CLAUDE.md — only if not exists (project-specific, don't overwrite)
if [ ! -f "$PROJECT_DIR/CLAUDE.md" ]; then
    copy_file "CLAUDE.md.template" "$PROJECT_DIR/CLAUDE.md"
    echo "  CLAUDE.md created from template"
else
    echo "  CLAUDE.md already exists — skipped"
fi

# CHANGELOG.md — only if not exists
if [ ! -f "$PROJECT_DIR/CHANGELOG.md" ]; then
    echo "# CHANGELOG" > "$PROJECT_DIR/CHANGELOG.md"
    echo "  CHANGELOG.md created"
else
    echo "  CHANGELOG.md already exists — skipped"
fi

# --- Directories ---
mkdir -p "$PROJECT_DIR/docs/checkpoints"
echo "  docs/checkpoints/ created"

mkdir -p "$PROJECT_DIR/scripts"
echo "  scripts/ created"

# --- Skills (global ~/.claude/commands/) ---
COMMANDS_DIR="$HOME/.claude/commands"
mkdir -p "$COMMANDS_DIR"

for skill in handover resume preprod review debug codex ashy-init; do
    copy_file "skills/$skill.md" "$COMMANDS_DIR/$skill.md"
    echo "  /$skill skill installed"
done

# --- Status bar ---
HOOKS_DIR="$HOME/.claude/hooks"
mkdir -p "$HOOKS_DIR"

copy_file "statusbar/status.sh" "$HOOKS_DIR/status.sh"
chmod +x "$HOOKS_DIR/status.sh"
echo "  status bar installed"

# --- Register status bar in settings.json ---
SETTINGS_FILE="$HOME/.claude/settings.json"

if [ ! -f "$SETTINGS_FILE" ]; then
    echo '{}' > "$SETTINGS_FILE"
fi

if grep -q "status.sh" "$SETTINGS_FILE" 2>/dev/null; then
    echo "  status bar already registered in settings.json — skipped"
else
    python3 -c "
import json, os

settings_file = os.path.expanduser('$SETTINGS_FILE')

try:
    with open(settings_file) as f:
        settings = json.load(f)
except:
    settings = {}

settings['statusLine'] = {
    'type': 'command',
    'command': 'bash \$HOME/.claude/hooks/status.sh'
}

with open(settings_file, 'w') as f:
    json.dump(settings, f, indent=2)
" 2>/dev/null && echo "  status bar registered in settings.json" || echo "  WARN: could not register status bar — add manually (see README)"
fi

echo ""
echo "=== Done ==="
echo ""
echo "Skills installed (~/.claude/commands/):"
echo "  /handover  — Session handover with checkpoint, versioning, db export"
echo "  /resume    — Resume from latest checkpoint"
echo "  /preprod   — Pre-production readiness (SDLC + OWASP Top 10)"
echo "  /review    — Structured code review (correctness, security, quality)"
echo "  /debug     — Structured debugging workflow (5 Whys)"
echo "  /codex     — Joint review with OpenAI Codex CLI (two-model analysis)"
echo "  /ashy-init — Interactive project setup wizard (run first after install)"
echo ""
echo "Status bar: git branch/status | rotating quote"
echo ""
echo "Project files:"
echo "  RULES.md      — Development rules (updated)"
echo "  CLAUDE.md     — Project context (edit for your project)"
echo "  CHANGELOG.md  — Version history"
echo "  docs/checkpoints/ — Session checkpoints"
echo "  scripts/      — Utility scripts"
