Perform a structured code review on the changes made this session.

Review all modified files (from `git diff` and `git diff --staged`) against these categories. Report each as PASS/WARN/FAIL.

---

## 1. CORRECTNESS
- Does the code do what it's supposed to?
- Are edge cases handled?
- Are there off-by-one errors, null checks missing, or wrong variable references?

## 2. ERROR HANDLING
- Are all external calls (API, DB, file I/O) wrapped in error handling?
- Do errors produce meaningful messages (not generic "something went wrong")?
- Are errors logged with enough context to debug?
- Are there any silent failures (empty catch blocks, ignored return values)?

## 3. SECURITY
- SQL injection: Are all queries parameterized?
- XSS: Is user input sanitized before rendering?
- Auth: Are new endpoints properly protected?
- Secrets: Any hardcoded credentials, API keys, or tokens?
- Input validation: Is user input validated at the boundary?

## 4. CODE QUALITY
- Is there duplicated code that should be extracted?
- Are variable/function names clear and descriptive?
- Is the code readable without comments? (If not, add comments)
- Are there any TODO/FIXME/HACK comments that should be addressed?

## 5. DEAD CODE & IMPORTS
- Are there unused imports?
- Are there unreachable code paths?
- Are there commented-out code blocks that should be removed?

## 6. TESTS
- Do new features have corresponding tests?
- Do bug fixes have regression tests?
- Are existing tests still passing?

---

## Output

```markdown
## Code Review — YYYY-MM-DD

| Category | Status | Notes |
|----------|--------|-------|
| Correctness | PASS/WARN/FAIL | |
| Error Handling | PASS/WARN/FAIL | |
| Security | PASS/WARN/FAIL | |
| Code Quality | PASS/WARN/FAIL | |
| Dead Code | PASS/WARN/FAIL | |
| Tests | PASS/WARN/FAIL | |

### Issues Found
- [list specific issues with file:line references]

### Suggestions
- [optional improvements, not blocking]
```

If any FAIL is found, list the specific fix needed. Do NOT auto-fix — present findings and ask before making changes.
