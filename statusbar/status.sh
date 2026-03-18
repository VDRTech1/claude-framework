#!/bin/bash
# Claude Framework Status Bar
# Shows: git branch/status, hook health, Star Wars quote (colored)

# --- Colors ---
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
CYAN="\033[36m"
DIM="\033[2m"
RESET="\033[0m"

# --- Git status ---
BRANCH=$(git branch --show-current 2>/dev/null || echo "??")
DIRTY=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
if [ "$DIRTY" -gt 0 ] 2>/dev/null; then
    GIT_DISPLAY="${YELLOW}${BRANCH}:${DIRTY}M${RESET}"
else
    GIT_DISPLAY="${GREEN}${BRANCH}:clean${RESET}"
fi

# --- Hook health ---
HOOKS_OK=true

for hook in "$HOME/.claude/hooks/context-guard.sh" "$HOME/.claude/hooks/precompact-save.sh"; do
    if [ ! -f "$hook" ] || [ ! -x "$hook" ]; then
        HOOKS_OK=false
    fi
done

if [ -f "$HOME/.claude/settings.json" ]; then
    grep -q '"hooks"' "$HOME/.claude/settings.json" 2>/dev/null || HOOKS_OK=false
fi

if [ "$HOOKS_OK" = true ]; then
    HOOK_DISPLAY="${GREEN}HOOKS:OK${RESET}"
else
    HOOK_DISPLAY="${RED}HOOKS:ERR${RESET}"
fi

# --- Star Wars quotes ---
QUOTES=(
    "Do. Or do not. There is no try."
    "The Force is strong with this one."
    "I find your lack of faith disturbing."
    "Stay on target."
    "This is the way."
    "Never tell me the odds."
    "Let the Wookiee win."
    "I've got a bad feeling about this."
    "The Force will be with you. Always."
    "In my experience there is no such thing as luck."
    "Your focus determines your reality."
    "Patience you must have, young Padawan."
    "Great, kid. Don't get cocky."
    "Try not. Do. Or do not."
    "The greatest teacher, failure is."
    "Impressive. Most impressive."
    "I am one with the Force. The Force is with me."
    "We are what they grow beyond."
    "Rebellions are built on hope."
    "May the Force be with you."
)

MINUTE=$(date +%M)
IDX=$(( (MINUTE / 3) % ${#QUOTES[@]} ))
QUOTE="${DIM}${QUOTES[$IDX]}${RESET}"

# --- Output ---
echo -e "${GIT_DISPLAY} ${DIM}|${RESET} ${HOOK_DISPLAY} ${DIM}|${RESET} ${QUOTE}"
