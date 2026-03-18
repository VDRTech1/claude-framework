#!/bin/bash
set -e

# Claude Framework Installer
# Usage: curl -s https://raw.githubusercontent.com/vji11/claude-framework/main/install.sh | bash
# Or:    git clone https://github.com/vji11/claude-framework.git && cd claude-framework && bash install.sh

REPO_URL="https://raw.githubusercontent.com/vji11/claude-framework/main"
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

copy_file "skills/handover.md" "$COMMANDS_DIR/handover.md"
echo "  /handover skill installed"

copy_file "skills/resume.md" "$COMMANDS_DIR/resume.md"
echo "  /resume skill installed"

copy_file "skills/preprod.md" "$COMMANDS_DIR/preprod.md"
echo "  /preprod skill installed"

echo ""
echo "=== Done ==="
echo ""
echo "Skills installed globally (~/.claude/commands/):"
echo "  /handover  — Session handover with checkpoint, versioning, db export"
echo "  /resume    — Resume from latest checkpoint"
echo "  /preprod   — Pre-production readiness (SDLC + OWASP Top 10)"
echo ""
echo "Project files:"
echo "  RULES.md      — Development rules (updated)"
echo "  CLAUDE.md     — Project context (edit for your project)"
echo "  CHANGELOG.md  — Version history"
echo "  docs/checkpoints/ — Session checkpoints"
echo "  scripts/      — Utility scripts"
