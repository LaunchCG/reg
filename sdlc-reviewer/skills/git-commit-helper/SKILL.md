---
name: git-commit-helper
description: Generates commit messages following conventional commit format and creates git commits
allowed-tools: Bash, Read, Glob
mcpServers:
  - github
---

# Git Commit Helper Skill

This skill provides **intelligent git commit message generation** following conventional commit format with automatic Jira ticket linking.

## When This Skill is Invoked

Claude will automatically use this skill when you mention:
- "create a commit"
- "git commit"
- "commit changes"
- "generate commit message"

## How to Use This Skill

### Step 1: Check Staged Changes

**Use Bash to run git status:**
```bash
git status --porcelain
git diff --staged --stat
```

**Parse output to identify:**
- Files staged for commit
- Change types (added, modified, deleted)
- Number of files changed

### Step 2: Analyze Changes

**Use git diff to understand changes:**
```bash
git diff --staged
```

**Identify:**
- What was added/removed/modified
- Which files/modules affected
- Scope of changes

### Step 3: Determine Commit Type

**Based on changes, classify as:**
- `feat`: New feature added
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code formatting
- `refactor`: Code restructuring
- `test`: Test additions/updates
- `chore`: Maintenance tasks

### Step 4: Find Jira Tickets

**Check for Jira ticket references:**
- Branch name (e.g., `feature/PROJ-123-description`)
- Recent commit messages
- File comments
- Context from user

**Extract ticket pattern:** `[A-Z]+-\d+` (e.g., PROJ-123, ENG-456)

### Step 5: Generate Message

**Format as conventional commit:**
```
<type>(<scope>): <subject>

<body>

<footer>
```

**Example:**
```
feat(auth): Add JWT authentication

Implements token-based authentication for API endpoints.
Includes token generation, validation, and refresh logic.

Closes PROJ-123
```

**Message Guidelines:**
- Subject: 50 chars or less, imperative mood
- Body: Explain WHY, not WHAT (optional)
- Footer: Reference Jira tickets

### Step 6: Create Commit

**Execute git commit:**
```bash
git commit -m "$(cat <<'EOF'
feat(auth): Add JWT authentication

Implements token-based authentication for API endpoints.
Includes token generation, validation, and refresh logic.

Closes PROJ-123
EOF
)"
```

### Step 7: Return Results

**Format output:**
```markdown
## Commit Created Successfully

**Type:** feat
**Scope:** auth
**Subject:** Add JWT authentication

**Message:**
```
feat(auth): Add JWT authentication

Implements token-based authentication for API endpoints.
Includes token generation, validation, and refresh logic.

Closes PROJ-123
```

**Files Committed:** 3
- src/auth/jwt.js
- src/middleware/auth.js
- tests/auth.test.js

**Next Steps:**
- Push to remote: `git push`
- Create PR if needed
```

## Commit Type Classification

**How to determine type:**

| Change Pattern | Type |
|----------------|------|
| New files in feature/ | feat |
| Modified existing features | feat or refactor |
| Files in bugfix/ or fix/ branch | fix |
| Only documentation files | docs |
| Only test files | test |
| Code formatting only | style |
| Restructuring without behavior change | refactor |
| Build configs, tooling | chore |

## Jira Ticket Detection

**Check these sources in order:**

1. **Branch name:**
   ```bash
   git rev-parse --abbrev-ref HEAD
   # Extract: feature/PROJ-123-add-auth -> PROJ-123
   ```

2. **Recent commits:**
   ```bash
   git log -1 --pretty=%B
   # Look for: PROJ-123, Closes PROJ-123, etc.
   ```

3. **User context:**
   - Ask user if ticket reference should be included
   - Parse from user's message

**Footer formats:**
- `Closes PROJ-123` - Issue is resolved by this commit
- `Refs PROJ-123` - Issue is related but not closed
- `PROJ-123` - Simple reference

## Error Handling

### No Staged Changes
```markdown
**Error:** No staged changes found

**Solution:**
Stage your changes first:
```
git add <files>
```

Then run /git-commit again.
```

### Git Not Initialized
```markdown
**Error:** Not a git repository

**Solution:**
Initialize git first:
```
git init
```
```

### Commit Failed
```markdown
**Error:** Git commit failed

**Details:** <error message>

**Solution:** Address the error and try again.
```

## Best Practices

1. **Be Descriptive:** Subject line should be clear
2. **Be Consistent:** Follow conventional commit format
3. **Link Tickets:** Always reference Jira issues when relevant
4. **Add Body:** Explain WHY for non-trivial changes
5. **Atomic Commits:** Each commit should be logical unit

## Example Commit Messages

### Feature Addition
```
feat(payment): Add Stripe payment integration

Implements credit card processing via Stripe API.
Includes payment form, validation, and webhook handling.

Closes PROJ-456
```

### Bug Fix
```
fix(login): Resolve session timeout issue

Fixes race condition in session refresh logic that caused
premature logouts during concurrent requests.

Closes PROJ-789
```

### Documentation
```
docs(readme): Update installation instructions

Adds Docker setup steps and troubleshooting section.
```

### Refactoring
```
refactor(api): Extract validation middleware

Moves validation logic into reusable middleware functions
to improve code organization and testability.
```

## Integration with Agent

**The git-operations-agent will:**
1. Invoke this skill for commit operations
2. Receive commit message and execution status
3. Present results to user
4. Suggest next steps (push, PR, etc.)

**This skill:**
- Analyzes staged changes
- Generates commit message
- Executes git commit
- Returns structured results

---

When invoked, this skill will create well-formatted git commits with intelligent message generation and automatic Jira ticket linking.
