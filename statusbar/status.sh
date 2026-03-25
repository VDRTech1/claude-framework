#!/bin/bash
# Claude Framework Status Bar
# Shows: context usage | git branch/status | rotating quote (Star Wars / South Park / Ashy)

# --- Colors ---
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
DIM="\033[2m"
BOLD="\033[1m"
BLINK="\033[5m"
BG_RED="\033[41m"
WHITE="\033[97m"
RESET="\033[0m"

# --- Context utilization ---
# Find the most recently modified .jsonl conversation file for the current project
PROJECT_PATH=$(pwd | sed "s|/|-|g; s|^-||")
CONV_DIR="$HOME/.claude/projects/-${PROJECT_PATH}"

if [ -d "$CONV_DIR" ]; then
    CONV_FILE=$(ls -t "$CONV_DIR"/*.jsonl 2>/dev/null | head -1)
fi

# Fallback: find the most recently modified .jsonl anywhere in ~/.claude/projects
if [ -z "$CONV_FILE" ]; then
    CONV_FILE=$(find "$HOME/.claude/projects" -name "*.jsonl" -type f -print0 2>/dev/null | xargs -0 ls -t 2>/dev/null | head -1)
fi

if [ -n "$CONV_FILE" ] && [ -f "$CONV_FILE" ]; then
    FILE_BYTES=$(wc -c < "$CONV_FILE" | tr -d ' ')
    # 1M tokens ~ 4MB text, but usable context ~800K tokens after system prompts/tools
    # Effective capacity ~3.2MB of conversation text
    MAX_BYTES=3200000
    PCT=$(( FILE_BYTES * 100 / MAX_BYTES ))
    [ "$PCT" -gt 100 ] && PCT=100

    if [ "$PCT" -ge 85 ]; then
        # DANGER ZONE
        CTX_DISPLAY="${BG_RED}${WHITE}${BOLD}${BLINK} !!!  DANGER DANGER - LOSING MEMORY  !!! ${RESET} ${RED}${BOLD}CTX:${PCT}%${RESET} ${BG_RED}${WHITE}${BOLD} STOP ALL WORK -> /handover NOW ${RESET}"
    elif [ "$PCT" -ge 70 ]; then
        CTX_DISPLAY="${RED}${BOLD}CTX:${PCT}%${RESET} ${RED}WARNING: context high - consider /handover soon${RESET}"
    elif [ "$PCT" -ge 50 ]; then
        CTX_DISPLAY="${YELLOW}CTX:${PCT}%${RESET}"
    else
        CTX_DISPLAY="${GREEN}CTX:${PCT}%${RESET}"
    fi
else
    CTX_DISPLAY="${DIM}CTX:??${RESET}"
fi

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
    BRANCH=$(git branch --show-current 2>/dev/null || echo "??")
    DIRTY=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    if [ "$DIRTY" -gt 0 ] 2>/dev/null; then
        GIT_DISPLAY="${YELLOW}${BRANCH}:${DIRTY}M${RESET}"
    else
        GIT_DISPLAY="${GREEN}${BRANCH}:ok${RESET}"
    fi
else
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
if [ "$PCT" -ge 85 ] 2>/dev/null; then
    # Critical: show danger prominently, quote replaced with urgency
    echo -e "${CTX_DISPLAY}"
    echo -e "${RED}${BOLD}  >>>  DO NOT CONTINUE  <<<  Run /handover immediately to save your work  <<<${RESET}"
else
    echo -e "${CTX_DISPLAY} ${DIM}|${RESET} ${GIT_DISPLAY} ${DIM}|${RESET} ${QUOTE}"
fi
