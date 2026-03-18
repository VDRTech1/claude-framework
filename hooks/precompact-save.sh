#!/bin/bash
# Pre-Compact Save Hook — triggers before auto-compact wipes context
# Runs on: PreCompact event
# Injects a reminder to save state before compact happens

cat <<EOF
{
    "additionalContext": "WARNING: Auto-compact is about to clear your context. Run /compact NOW to save a checkpoint before your session context is lost. After compact completes, use /resume to reload context."
}
EOF
