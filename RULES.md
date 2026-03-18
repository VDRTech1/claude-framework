# RULES.MD - MANDATORY DEVELOPMENT & SESSION GUIDELINES

**DO NOT DEVIATE - ALWAYS FOLLOW THESE RULES**

---

work on single tasks at one time.
always perform end to end testing to verify is the implementation is succesfull
always implement error handling with meaningfull error display.
use specialized tools, agents and skills for complex tasks.


## PART 1: SESSION INITIALIZATION PROTOCOL

### MANDATORY Session Start Requirements
Before responding to ANY user request in a new session:

1. **READ CLAUDE.md** - Understand application context and current state
2. **READ CHANGELOG.md** - Understand recent changes and current version
3. **CHECK LATEST CHECKPOINT** - Read most recent checkpoint in `/docs/checkpoints`
4. **REVIEW CURRENT STATUS** - Verify git status and service status

---

## PART 2: FILE ORGANIZATION

### Root Directory Rules
**MANDATORY**: The root folder MUST contain ONLY these markdown files:
- `CLAUDE.md` - Project context and guidance
- `README.md` - Public-facing documentation
- `RULES.md` - Development guidelines (this file)
- `CHANGELOG.md` - Version history

### Documentation Folder Rules
**ALL OTHER MARKDOWN FILES** must be placed in `/docs/` folder.

### Scripts Folder Rules
**ALL SCRIPTS** must be placed in `/scripts/` folder.

---

## PART 3: DEVELOPMENT GUIDELINES

### 1. ERROR HANDLING PROTOCOL

**NEVER** allow silent failures. **ALWAYS** provide user feedback.

#### Frontend:
- Wrap API calls in try-catch blocks
- Display user-friendly error messages
- Show loading states during API calls
- Log errors to console for debugging

#### Backend:
- Return meaningful HTTP status codes
- Include human-readable error messages
- Validate input data
- Handle database errors gracefully
- Log errors with context

### 2. SOURCE CODE VERIFICATION

#### Before Any Edit:
- **ALWAYS** read the target file first
- **VERIFY** correct file path and location
- **UNDERSTAND** surrounding context

#### After Any Edit:
- **CHECK** edit confirmation
- **VERIFY** changes applied correctly
- **INVESTIGATE** immediately if edit fails

### 3. SOURCE CODE ONLY - NO COMPILED FILES

- **ALWAYS** fix source files
- **NEVER** modify compiled output
- **ENSURE** all changes survive build cycles

### 4. BUILD AND RESTART PROTOCOL

- Build before restart
- Verify service status after restart
- Check logs for errors

#### Service Logs Timeout Rule
- **NEVER** run log commands for more than 10 seconds
- **ALWAYS** use timeout: `timeout 10s <log-command>`

### 5. DATABASE WORKFLOW

- Use parameterized queries
- **NEVER** concatenate user input into SQL
- **NEVER** hardcode credentials
- Validate queries match database structure

### 6. COMMIT SAFETY PROTOCOL

Before ANY commit:
1. Verify all edits in source files
2. Build applications
3. Check for errors
4. Test core functionality

### 7. GIT SAFETY PROTOCOL

- **NEVER** update git config without permission
- **NEVER** run destructive git commands without explicit request
- **NEVER** skip hooks unless explicitly requested
- **NEVER** force push to main/master
- **ALWAYS** create NEW commits rather than amending (unless requested)
- **PREFER** adding specific files over `git add -A` or `git add .`
