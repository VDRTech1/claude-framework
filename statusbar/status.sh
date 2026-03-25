#!/bin/bash
# Claude Framework Status Bar
# Shows: git branch/status (single or multi-repo), Star Wars / South Park / Ashy quote (colored)

# --- Colors ---
GREEN="\033[32m"
YELLOW="\033[33m"
DIM="\033[2m"
RESET="\033[0m"

# --- Git status helper ---
repo_status() {
    local dir="$1"
    local name="$2"
    local dirty=$(git -C "$dir" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    if [ "$dirty" -gt 0 ] 2>/dev/null; then
        echo -n "${YELLOW}${name}:${dirty}M${RESET}"
    else
        echo -n "${GREEN}${name}:ok${RESET}"
    fi
}

# --- Git status ---
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    # Single-repo project
    BRANCH=$(git branch --show-current 2>/dev/null || echo "??")
    DIRTY=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    if [ "$DIRTY" -gt 0 ] 2>/dev/null; then
        GIT_DISPLAY="${YELLOW}${BRANCH}:${DIRTY}M${RESET}"
    else
        GIT_DISPLAY="${GREEN}${BRANCH}:ok${RESET}"
    fi
else
    # Multi-repo project — scan subdirectories for .git folders
    GIT_PARTS=()
    for dir in */; do
        if [ -d "${dir}.git" ]; then
            GIT_PARTS+=("$(repo_status "$dir" "${dir%/}")")
        fi
    done
    if [ ${#GIT_PARTS[@]} -gt 0 ]; then
        GIT_DISPLAY=$(IFS=' '; echo "${GIT_PARTS[*]}")
    else
        GIT_DISPLAY="${DIM}no git${RESET}"
    fi
fi

# --- Quotes ---
QUOTES=(
    # Star Wars (top 10)
    "Do. Or do not. There is no try."
    "I am your father."
    "May the Force be with you."
    "I find your lack of faith disturbing."
    "It's a trap!"
    "The Force will be with you. Always."
    "Never tell me the odds."
    "Hello there."
    "This is the way."
    "I've got a bad feeling about this."
    # South Park (top 10)
    "Respect my authoritah!"
    "Oh my God, they killed Kenny!"
    "Screw you guys, I'm going home."
    "I'm not fat, I'm big-boned."
    "You're gonna have a bad time."
    "Drugs are bad, mmkay."
    "They took our jobs!"
    "Blame Canada!"
    "Aaand it's gone."
    "Tree fiddy."
    # Ashy
    "IA PULA !"
    "NPN !"
    "Mai porti pantofi de Alladin ?"
)

MINUTE=$(date +%M)
IDX=$(( (MINUTE / 3) % ${#QUOTES[@]} ))
QUOTE="${DIM}${QUOTES[$IDX]}${RESET}"

# --- Output ---
echo -e "${GIT_DISPLAY} ${DIM}|${RESET} ${QUOTE}"
