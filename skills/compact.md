Context is getting full. Create an emergency checkpoint before context is lost.

This skill is triggered automatically by a hook OR can be run manually with `/compact`.

## Steps

1. Run `git diff --stat` and `git log --oneline -5` to capture current state
2. Write an emergency checkpoint to `/docs/checkpoints/checkpoint-YYYY-MM-DD-HHMM-UTC.md` with:

   - **What was being worked on** — current task, what was the goal
   - **What's done** — completed changes (from git diff and conversation)
   - **What's in progress** — partially done work, uncommitted changes
   - **What's next** — remaining steps to complete the current task
   - **Key context** — any non-obvious decisions, file paths, commands that would be hard to reconstruct

3. Update CHANGELOG.md with a brief entry
4. Git add, commit, and push the checkpoint

Keep it fast — this is an emergency save, not a full handover. Focus on preserving enough context that `/resume` can pick up exactly where we left off.

After saving, inform the user: "Context checkpoint saved. Run `/resume` in your next session to continue."
