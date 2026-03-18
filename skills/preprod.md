Perform a full pre-production readiness check before promoting the application to production.

This is a MANDATORY gate. Do NOT approve promotion unless ALL applicable sections pass.

Work through each section sequentially. Report results as PASS/FAIL/SKIP (skip only if not applicable to this project).

---

## 1. UNIT TESTS

- Run the full unit test suite
- Verify all tests pass (zero failures)
- Check test coverage — flag any critical paths with no coverage
- If no unit tests exist, flag as **FAIL** and list what needs coverage

```bash
# Detect and run test framework
# Node: npm test / npx jest / npx vitest
# Python: pytest / python -m unittest
# Go: go test ./...
```

## 2. INTEGRATION TESTS

- Run integration test suite if it exists
- Verify API endpoints return expected responses
- Test database operations (CRUD) work end-to-end
- Test external service integrations (payment, email, auth)
- Verify error responses match expected format

## 3. FUNCTIONAL TESTS

- Test all user-facing features against requirements
- Verify form submissions, navigation, authentication flows
- Test role-based access control (admin vs user vs guest)
- Verify email/notification triggers work
- Test file upload/download if applicable
- Test search/filter/pagination functionality

## 4. BUILD VERIFICATION

- Run a clean production build (`npm run build`, `go build`, etc.)
- Verify zero build warnings that could indicate issues
- Confirm all environment variables are documented
- Verify `.env.example` or equivalent exists with all required vars
- Check that no development dependencies leak into production build

```bash
# Clean build
rm -rf dist/ build/ .next/ out/
# Run production build
```

## 5. DATABASE READINESS

- Verify all migrations are up to date
- Export current database schema to `/docs/database/`
- Check for pending migrations not yet applied
- Verify indexes exist for frequently queried columns
- Check for N+1 query issues in critical paths
- Confirm backup/restore procedure is documented

## 6. SECURITY — OWASP TOP 10

### A01: Broken Access Control
- Verify authentication is required on all protected routes
- Test that users cannot access other users' data (IDOR)
- Verify CORS is properly configured (not wildcard in production)
- Test that API endpoints enforce authorization, not just authentication
- Check directory listing is disabled

### A02: Cryptographic Failures
- Verify all data in transit uses TLS/HTTPS (no HTTP fallback)
- Check passwords are hashed with bcrypt/argon2 (not MD5/SHA1)
- Verify no secrets/API keys in source code or logs
- Check sensitive data is not stored in localStorage/cookies without encryption
- Verify database connection uses SSL

```bash
# Search for hardcoded secrets
grep -rn "password\s*=\|api_key\s*=\|secret\s*=" --include="*.py" --include="*.js" --include="*.ts" --include="*.env" . | grep -v node_modules | grep -v .git
```

### A03: Injection
- Verify all database queries use parameterized statements (no string concatenation)
- Check for SQL injection in search/filter parameters
- Test for command injection in any system exec calls
- Verify NoSQL injection protection if using MongoDB
- Check for LDAP injection if applicable

### A04: Insecure Design
- Verify rate limiting on authentication endpoints
- Check for account lockout after failed login attempts
- Verify CAPTCHA or equivalent on public forms
- Check that business logic cannot be bypassed (e.g., price manipulation)
- Verify multi-step processes cannot be skipped

### A05: Security Misconfiguration
- Verify no default credentials exist
- Check that error messages don't leak stack traces or internal paths in production
- Verify unnecessary HTTP methods are disabled
- Check security headers are set:
  - `Strict-Transport-Security`
  - `X-Content-Type-Options: nosniff`
  - `X-Frame-Options: DENY` or `SAMEORIGIN`
  - `Content-Security-Policy`
  - `Referrer-Policy`
- Verify `X-Powered-By` header is removed
- Check that debug mode is OFF in production config

```bash
# Check security headers
curl -I https://[APP_URL] 2>/dev/null | grep -iE "strict-transport|x-content-type|x-frame|content-security|referrer-policy|x-powered"
```

### A06: Vulnerable and Outdated Components
- Run dependency vulnerability scan
- Check for known CVEs in dependencies
- Verify no EOL runtimes (Node <18, Python <3.9, etc.)

```bash
# Node
npm audit
# Python
pip-audit  # or safety check
# Go
govulncheck ./...
```

### A07: Identification and Authentication Failures
- Verify password policy enforcement (min length, complexity)
- Check session timeout is configured
- Verify session tokens are invalidated on logout
- Test that password reset tokens expire
- Check for brute force protection on login
- Verify MFA is available for admin accounts

### A08: Software and Data Integrity Failures
- Verify CI/CD pipeline integrity (no unauthorized modifications)
- Check that dependencies are pinned (lockfile exists and committed)
- Verify Subresource Integrity (SRI) on CDN resources
- Check for auto-update mechanisms that could be compromised

### A09: Security Logging and Monitoring Failures
- Verify login attempts (success/failure) are logged
- Check that authorization failures are logged
- Verify logs don't contain sensitive data (passwords, tokens, PII)
- Confirm log rotation is configured
- Check that alerts exist for suspicious activity

### A10: Server-Side Request Forgery (SSRF)
- Verify URL inputs are validated and sanitized
- Check that internal network access is restricted from user-supplied URLs
- Verify allowlists for any URL fetch functionality
- Test that redirects don't lead to internal services

## 7. PERFORMANCE CHECK

- Verify no obvious N+1 queries
- Check that static assets are cached/compressed
- Verify database connection pooling is configured
- Test response times on critical endpoints (should be <500ms)
- Check for memory leaks in long-running processes

## 8. DEPLOYMENT READINESS

- Verify Dockerfile / deployment config exists and builds
- Check health check endpoint exists and works
- Verify graceful shutdown handling
- Confirm rollback procedure is documented
- Verify environment-specific configs are separated (dev/staging/prod)

---

## REPORT FORMAT

After completing all checks, output a summary:

```
## Pre-Production Readiness Report

**Date:** YYYY-MM-DD
**Application:** [name] v[version]
**Reviewer:** Claude Code

| Section | Status | Notes |
|---------|--------|-------|
| Unit Tests | PASS/FAIL/SKIP | |
| Integration Tests | PASS/FAIL/SKIP | |
| Functional Tests | PASS/FAIL/SKIP | |
| Build Verification | PASS/FAIL/SKIP | |
| Database Readiness | PASS/FAIL/SKIP | |
| OWASP A01 - Access Control | PASS/FAIL | |
| OWASP A02 - Crypto Failures | PASS/FAIL | |
| OWASP A03 - Injection | PASS/FAIL | |
| OWASP A04 - Insecure Design | PASS/FAIL | |
| OWASP A05 - Misconfiguration | PASS/FAIL | |
| OWASP A06 - Vulnerable Components | PASS/FAIL | |
| OWASP A07 - Auth Failures | PASS/FAIL | |
| OWASP A08 - Integrity Failures | PASS/FAIL | |
| OWASP A09 - Logging Failures | PASS/FAIL | |
| OWASP A10 - SSRF | PASS/FAIL | |
| Performance | PASS/FAIL/SKIP | |
| Deployment Readiness | PASS/FAIL | |

**Overall Verdict:** READY / NOT READY

### Blockers (must fix before prod)
- [list]

### Warnings (should fix, not blocking)
- [list]
```

Save the report to `/docs/preprod-report-YYYY-MM-DD.md`.

If ANY security section (OWASP) is FAIL, the overall verdict MUST be **NOT READY**.
