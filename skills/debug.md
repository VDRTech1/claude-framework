Structured debugging workflow. Use when something is broken and the cause is not obvious.

Work through these steps IN ORDER. Do not skip ahead. Each step narrows the problem.

---

## 1. REPRODUCE
- What is the exact error? (Copy the full error message/stack trace)
- What was the user doing when it happened?
- Can you reproduce it consistently?
- Does it happen in all environments or just one?

## 2. LOCATE
- Read the full stack trace — identify the exact file and line
- If no stack trace, check logs:
  ```bash
  timeout 10s tail -50 /var/log/[app].log
  # or journalctl, docker logs, etc.
  ```
- If no logs, add temporary logging at suspected locations

## 3. RECENT CHANGES
- Check what changed recently:
  ```bash
  git log --oneline -10
  git diff HEAD~3..HEAD --stat
  ```
- Did this work before? If yes, which commit broke it?
  ```bash
  git log --oneline --since="3 days ago"
  ```
- Use `git blame` on the failing file/line to find who changed it and when

## 4. ISOLATE
- Is it a code bug, config issue, or environment problem?
- Test the smallest possible unit:
  - Can the database be reached?
  - Does the API respond at all?
  - Is the service running?
  - Are environment variables set?
- Check dependencies:
  ```bash
  # Service running?
  systemctl status [service]
  # Port open?
  ss -tlnp | grep [port]
  # DB reachable?
  timeout 5 bash -c 'echo > /dev/tcp/localhost/5432' && echo OK || echo FAIL
  ```

## 5. ROOT CAUSE
- Now that you've narrowed it down, read the actual code at the failure point
- Trace the data flow: what goes in, what comes out, where does it diverge?
- Check for common causes:
  - Null/undefined where object expected
  - Type mismatch
  - Missing environment variable
  - Permission denied
  - Race condition / timing issue
  - Stale cache or build artifact

## 6. FIX
- Write the minimal fix
- Verify it doesn't break anything else
- Add a regression test if applicable

## 7. VERIFY
- Reproduce the original steps — confirm the error is gone
- Run the test suite
- Check logs are clean

---

## Output

After debugging, summarize:

```markdown
## Debug Report

**Issue:** [one-line description]
**Root Cause:** [what actually went wrong]
**Fix:** [what was changed, with file:line references]
**Verified:** [how you confirmed it's fixed]
**Regression Test:** [added / not applicable]
```
