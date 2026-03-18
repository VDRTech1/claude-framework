#!/bin/bash
# Context Guard Hook — triggers /compact when context usage is high
# Runs on: Stop event
# Reads context percentage from Claude's input and blocks if >= 80%

input=$(cat)

# Extract context percentage from the stop hook input
context_pct=$(echo "$input" | jq -r '.stop_hook_context_percentage // empty' 2>/dev/null)

# If we can't read context percentage, pass through
if [ -z "$context_pct" ]; then
    echo '{"decision": "allow"}'
    exit 0
fi

# Block if context is >= 80%
if [ "$context_pct" -ge 80 ] 2>/dev/null; then
    cat <<EOF
{
    "decision": "block",
    "reason": "Context at ${context_pct}%. Run /compact to save a checkpoint before context is lost."
}
EOF
else
    echo '{"decision": "allow"}'
fi
