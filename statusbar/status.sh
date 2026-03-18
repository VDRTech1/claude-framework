#!/bin/bash
# Claude Framework Status Bar
# Shows: context %, hook health, project name, Star Wars quote

# --- Project name ---
PROJECT=$(basename "$(pwd)")

# --- Context percentage ---
# Read from Claude's context tracking file if available
CTX_FILE="/tmp/claude-context-pct-*.txt"
CTX_PCT=""
for f in $CTX_FILE; do
    if [ -f "$f" ]; then
        CTX_PCT=$(cat "$f" 2>/dev/null)
        break
    fi
done

if [ -n "$CTX_PCT" ]; then
    if [ "$CTX_PCT" -ge 80 ] 2>/dev/null; then
        CTX_DISPLAY="CTX:${CTX_PCT}%!"
    elif [ "$CTX_PCT" -ge 60 ] 2>/dev/null; then
        CTX_DISPLAY="CTX:${CTX_PCT}%"
    else
        CTX_DISPLAY="CTX:${CTX_PCT}%"
    fi
else
    CTX_DISPLAY="CTX:--"
fi

# --- Hook health ---
HOOKS_OK=true
HOOK_COUNT=0

for hook in "$HOME/.claude/hooks/context-guard.sh" "$HOME/.claude/hooks/precompact-save.sh"; do
    if [ -f "$hook" ] && [ -x "$hook" ]; then
        HOOK_COUNT=$((HOOK_COUNT + 1))
    else
        HOOKS_OK=false
    fi
done

# Check settings.json has hooks registered
if [ -f "$HOME/.claude/settings.json" ]; then
    if grep -q '"hooks"' "$HOME/.claude/settings.json" 2>/dev/null; then
        HOOK_COUNT=$((HOOK_COUNT + 1))
    else
        HOOKS_OK=false
    fi
fi

if [ "$HOOKS_OK" = true ]; then
    HOOK_DISPLAY="HOOKS:OK"
else
    HOOK_DISPLAY="HOOKS:ERR"
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

# Pick quote based on minute of the hour (changes every 3 min)
MINUTE=$(date +%M)
IDX=$(( (MINUTE / 3) % ${#QUOTES[@]} ))
QUOTE="${QUOTES[$IDX]}"

# --- Output ---
echo "${PROJECT} | ${CTX_DISPLAY} | ${HOOK_DISPLAY} | ${QUOTE}"
