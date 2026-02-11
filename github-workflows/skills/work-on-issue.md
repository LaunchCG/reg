---
name: work-on-issue
description: Comprehensive workflow for analyzing, planning, and implementing GitHub issues with plan mode
---

# Work on GitHub Issue

Comprehensive workflow for tackling GitHub issues from analysis through planning to implementation.

## Workflow Overview

1. Fetch and analyze issue details
2. Assign issue to yourself
3. Enter plan mode to design implementation approach
4. Enable relevant development skills
5. Set up git workflow
6. Execute implementation following the plan
7. Run quality checks (linting, testing)
8. Create pull request

## Phase 1: Fetch and Analyze Issue

When invoked with an issue number, fetch complete issue details.

**Prefer GitHub MCP tools:**
```
mcp__github__get_issue (owner, repo, issue_number)
```

**Fallback to gh CLI:**
```bash
gh issue view <ISSUE_NUMBER> --json title,body,labels,assignees,comments,milestone
```

**Extract and analyze:**
- Issue title and description
- Requirements and acceptance criteria
- Mentioned technologies (Python, TypeScript, React, Next.js, Docker, etc.)
- Labels indicating type (bug, feature, enhancement, documentation)
- Referenced files or code areas
- Comments providing additional context

## Phase 2: Assign Issue to Self

**CRITICAL: Assign the issue to yourself BEFORE entering plan mode.**

**Prefer GitHub MCP:**
- MCP: `mcp__github__update_issue` with assignees parameter
- Fallback: `gh issue edit <NUMBER> --add-assignee @me`

This ensures you have ownership before beginning planning work.

## Phase 3: Enter Plan Mode

**CRITICAL: You MUST enter plan mode before any implementation.**

Inform the user: "I'll enter plan mode to design a comprehensive implementation approach for this issue."

In plan mode:
1. Thoroughly explore the codebase using Read, Grep, Glob tools
2. Understand existing patterns and architecture
3. Design the implementation approach
4. Create a detailed step-by-step plan
5. Identify files to create/modify
6. Plan the testing strategy
7. Consider risks and edge cases

## Phase 4: Enable Relevant Skills

Based on issue analysis, identify and enable relevant skills:

**Language Skills:**
- Python → `python-style`, `python-testing`
- TypeScript/JavaScript → `typescript`
- Full-stack → Both frontend and backend skills

**Framework Skills:**
- Next.js → `nextjs`
- React + Tailwind → `tailwind-css`
- Docker → `docker-compose`

**Testing Skills (CRITICAL - Always Enable):**
- E2E testing → `playwright-testing`, `qa-mindset`
- Unit testing → Language-specific testing skills
- Always identify and use project's testing framework

**Database Skills:**
- MongoDB → `mongodb`

**Quality Skills:**
- Pre-PR review → `code-review`
- PR creation → `create-pr`

Explicitly state which skills will be used:
```
"For this implementation, I'll use:
- python-testing for comprehensive test coverage
- python-style for code quality"
```

## Phase 5: Git Workflow Setup

After planning is complete, set up the development environment:

**1. Create Feature Branch:**
```bash
git checkout main
git pull origin main
git checkout -b <type>/issue-<number>-<description>
```

Branch naming conventions:
- `feature/issue-N-description` - New features
- `fix/issue-N-description` - Bug fixes
- `docs/issue-N-description` - Documentation
- `refactor/issue-N-description` - Refactoring
- `test/issue-N-description` - Test additions

**2. Update Issue Status:**
- MCP: `mcp__github__create_issue_comment`
- Fallback: `gh issue comment <NUMBER> --body "Started work"`

## Phase 6: Execute Implementation

Follow the plan created in Phase 2:
1. Implement in the planned sequence
2. Write tests first (TDD approach)
3. Commit incrementally with descriptive messages
4. Reference issue in commits: "Relates to #<number>"
5. Run tests frequently during development
6. Fix any test failures immediately
7. Run linting during development and fix issues as they arise
8. Self-review using code-review skill throughout implementation

**Commit Message Pattern:**
```bash
git commit -m "Implement user authentication service

- Add login/logout methods
- Implement JWT token generation
- Add password hashing with bcrypt

Relates to #123"
```

## Phase 7: Quality Assurance (CRITICAL - Before PR)

**MANDATORY quality checks before PR creation:**

**1. Run All Tests:**
```bash
npm test  # or pytest, cargo test, etc.
```
- All tests MUST pass
- No skipped or failing tests
- Fix any test failures before proceeding

**2. Run Linting:**
```bash
npm run lint  # or pylint, eslint, cargo clippy, etc.
```
- **All linting errors MUST be resolved**
- Do NOT ignore, suppress, or bypass linting checks
- Fix all errors, warnings, and style violations
- Re-run linter to confirm clean output

**3. Run Type Checking (if applicable):**
```bash
npm run type-check  # or tsc --noEmit, mypy, pyright
```

**4. Self-Review Code Changes:**
- Use `code-review` skill for systematic review
- Check for security vulnerabilities
- Verify error handling
- Confirm no debugging code left behind
- Ensure code follows project conventions

**5. Verify Commit Messages:**
- Follow project commit standards
- Reference issue number
- Clear, descriptive messages

## Phase 8: Create Pull Request

Only after ALL quality checks pass:

1. Use `/create-pr` skill
2. Link PR with "Closes #<number>" or "Fixes #<number>"
3. Include test results and linting status in PR description
4. Reference related issues or design documents

## Best Practices

- **ALWAYS enter plan mode first** - No implementation without planning
- **Enable relevant skills** - Use specialized knowledge for the technology stack
- **Follow the git workflow** - Proper branching, commits, and PR linking
- **Test thoroughly** - Both during and after implementation
- **All linting must pass** - Before creating commits/PR
- **Communicate clearly** - Comment on issue, write good commits, create comprehensive PRs

## Integration with Other Skills

This skill works with:
- `github-operations` - General GitHub workflow guidance
- `create-pr` - PR creation workflow
- Language skills - Python, TypeScript, etc.
- Framework skills - Next.js, Tailwind, etc.
- Testing skills - Playwright, pytest, etc.
- `code-review` - Self-review before PR submission
