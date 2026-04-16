Interactive project setup wizard. Run this FIRST after installing the Claude Framework.

This skill walks the user through a guided setup to configure their project, git, and workspace. Use `AskUserQuestion` for every step — never assume answers.

---

## Step 1: Welcome

Display:
```
=== Claude Framework — Project Setup ===
Let's get your project configured. I'll ask a few questions.
```

---

## Step 2: New or Existing Project

Ask the user:
- **Is this a new project or an existing project?**
  - `New` — will scaffold from scratch
  - `Existing` — will import an existing codebase

### If Existing:
1. Ask: **What is the full path to your existing project?**
2. Verify the path exists
3. Ask: **Should I copy it into the current workspace directory, or work in-place?**
   - If copy: copy all files (excluding `.git` if present) into the current directory
   - If in-place: confirm the current working directory will be set to that path
4. Check if it already has a `CLAUDE.md`, `RULES.md`, `CHANGELOG.md` — skip creating those that exist
5. Continue to Step 3

### If New:
1. Create the project directory structure per RULES.md:
   - `docs/checkpoints/`
   - `scripts/`
2. Continue to Step 3

---

## Step 3: Project Identity

Ask the user:
1. **What is the project name?**
2. **Give a one-line description of the project.**
3. **What is the tech stack?** (e.g., Node.js + React, Python + FastAPI, Go, etc.)
4. **What type of project is this?** (web app, API, CLI tool, mobile app, library, monorepo, other)

---

## Step 4: Git Setup

Ask the user:
- **Do you want to initialize git for this project?**
  - If the directory already has `.git`, inform the user and skip init
  - If yes, run `git init`

Then ask:
- **Do you want a remote repository, or local-only git?**
  - `Local only` — no remote, skip to Step 5
  - `Remote` — continue below

### Remote Setup:
1. Ask: **What is the GitHub repository URL?** (e.g., `https://github.com/user/repo.git`)
2. Ask: **Do you want to configure GitHub credentials now?**
   - If yes, ask: **GitHub Personal Access Token (PAT)?**
   - Configure the remote with the token: `git remote add origin https://<TOKEN>@github.com/user/repo.git`
   - If no token, just add the plain URL: `git remote add origin <URL>`
3. Ask: **Do you want to push an initial commit now?**
   - If yes: stage all files, create initial commit, push to main

---

## Step 5: CLAUDE.md Configuration

Using the answers collected, populate `CLAUDE.md` from the template:

1. Replace `[PROJECT NAME]` with the project name
2. Add the tech stack to a `## Tech Stack` section
3. Add the project type and description
4. Set the `Updated:` date to today
5. Add any additional paths the user mentioned to the File Layout table

---

## Step 6: Development Preferences

Ask the user:
1. **What is your preferred language for commit messages?** (English, Romanian, etc.)
2. **Do you use a specific branching strategy?** (main only, gitflow, trunk-based, etc.)
3. **Do you have a preferred test framework?** (jest, pytest, go test, vitest, none yet, etc.)
4. **Do you want database tracking enabled?** (yes/no — if yes, `/handover` will export DB)
5. **Any services or ports to monitor?** (e.g., `localhost:3000`, `localhost:5432`)

Store these preferences in a `## Development Preferences` section in `CLAUDE.md`.

---

## Step 7: Environment Check

Automatically verify and report:

```bash
# Check installed tools
git --version 2>/dev/null || echo "git: NOT FOUND"
node --version 2>/dev/null || echo "node: not installed"
npm --version 2>/dev/null || echo "npm: not installed"
python3 --version 2>/dev/null || echo "python3: not installed"
codex --version 2>/dev/null || echo "codex CLI: not installed (optional — install with: npm install -g @openai/codex)"
```

Report what's available and flag anything missing that the tech stack requires.

---

## Step 8: Initial Commit (if git was set up)

If git was initialized and there are files to commit:
1. Create a `.gitignore` appropriate for the tech stack (node_modules, __pycache__, .env, dist, build, etc.)
2. Stage all files
3. Create initial commit: `Initial project setup via Claude Framework`
4. Push if remote was configured

---

## Step 9: Summary

Display a final summary:

```markdown
=== Project Setup Complete ===

Project:     [name]
Type:        [type]
Tech Stack:  [stack]
Git:         [initialized / existing] — [local only / remote: URL]
Skills:      /handover /QQQ /review /debug /preprod /codex /inov /ashy-init

Files created/updated:
  CLAUDE.md     — configured for your project
  RULES.md      — development rules
  CHANGELOG.md  — version history
  .gitignore    — configured for [stack]
  docs/         — documentation + checkpoints
  scripts/      — utility scripts

Next steps:
  1. Review CLAUDE.md and adjust as needed
  2. Start building — Claude will follow your project context
  3. Run /handover before ending each session
  4. Run /QQQ to pick up where you left off
```

---

## Important

- NEVER skip questions or assume defaults — always ask
- NEVER overwrite existing files without asking
- If any step fails, report the error and ask how to proceed
- All project files must follow RULES.md structure (only approved .md files in root)
