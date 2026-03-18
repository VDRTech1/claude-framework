#!/bin/bash
# Claude Framework Status Bar
# Shows: git branch/status (single or multi-repo), Star Wars quote (colored)

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
    # Star Wars
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
    "I am your father."
    "It's a trap!"
    "The dark side clouds everything."
    "So this is how liberty dies... with thunderous applause."
    "Hope is like the sun. If you only believe in it when you can see it, you'll never make it through the night."
    "Who's the more foolish, the fool or the fool who follows him?"
    "The ability to speak does not make you intelligent."
    "You were the chosen one!"
    "Hello there."
    "I have the high ground."
    "This is where the fun begins."
    "Chewie, we're home."
    "Judge me by my size, do you?"
    "There's always a bigger fish."
    "Power! Unlimited power!"
    "The circle is now complete."
    "I know what I have to do, but I don't know if I have the strength to do it."
    "Let go of your hate."
    "Wars not make one great."
    "You underestimate my power."
    "The belonging you seek is not behind you, it is ahead."
    "I've been waiting for you, Obi-Wan."
    "Truly wonderful, the mind of a child is."
    "Now I am the master."
    "Be careful not to choke on your aspirations."
    "Only a Sith deals in absolutes."
    "You don't know the power of the dark side."
    "That's no moon."
    "Luminous beings are we, not this crude matter."
    "I know."
    # South Park
    "Respect my authoritah!"
    "Oh my God, they killed Kenny!"
    "Screw you guys, I'm going home."
    "I'm not fat, I'm big-boned."
    "You're gonna have a bad time."
    "Drugs are bad, mmkay."
    "I learned something today."
    "How would you like to suck my balls, Mr. Garrison?"
    "Blame Canada!"
    "Whateva! I do what I want!"
    "That's like, super cool."
    "Timmy!"
    "They took our jobs!"
    "You bastards!"
    "I'm super serial."
    "Butters, you're grounded!"
    "Put it down! It's super bad!"
    "Tree fiddy."
    "Kick the baby!"
    "Aaand it's gone."
)

MINUTE=$(date +%M)
IDX=$(( (MINUTE / 3) % ${#QUOTES[@]} ))
QUOTE="${DIM}${QUOTES[$IDX]}${RESET}"

# --- Output ---
echo -e "${GIT_DISPLAY} ${DIM}|${RESET} ${QUOTE}"
