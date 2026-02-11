---
name: pr-creator
description: Creates pull requests with proper descriptions, linked issues, and review assignments
autoInvoke:
  onFileChange: false
  onKeyword: ["create PR", "pull request", "open PR"]
---

# PR Creator Skill

Creates well-structured pull requests with comprehensive descriptions, linked Jira stories, and appropriate reviewer assignments.

## When This Skill Activates

This skill activates when:
- Code is ready for review
- User mentions "create PR" or "pull request"
- Development cycle completes implementation

## PR Creation Process

### Step 1: Gather PR Information

Collect necessary details:
- Branch name and target branch
- Related Jira story/issue
- Changes made (from git diff)
- Test results

### Step 2: Generate PR Description

Create comprehensive description:
- Summary of changes
- Link to Jira story
- Testing performed
- Screenshots (if UI changes)
- Breaking changes noted

### Step 3: Create Pull Request

Use GitHub API to create PR:
- Set title from story/branch
- Add description
- Assign reviewers
- Add labels

### Step 4: Update Jira

Link PR to story and update status.

## Output Format

```markdown
## Pull Request Created

**PR:** #456 - Implement user authentication
**URL:** https://github.com/org/repo/pull/456

### PR Details

**Title:** PROJ-123: Implement user authentication with OAuth2

**Base:** main <- **Head:** feature/PROJ-123-user-authentication

**Labels:** enhancement, needs-review

**Reviewers:** @senior-dev, @security-reviewer

---

### PR Description

## Summary
Implements user authentication using OAuth2 with Google and GitHub providers.

## Changes
- Added OAuth2 integration with Google and GitHub
- Implemented session management with Redis
- Added login/logout endpoints
- Created user profile page

## Related Issue
Closes PROJ-123

## Testing
- [x] Unit tests for auth service (15 tests)
- [x] Integration tests for OAuth flow (8 tests)
- [x] Manual testing with both providers
- [x] Security review checklist completed

## Screenshots
[Login page screenshot]
[OAuth consent screen]

## Checklist
- [x] Tests pass
- [x] No linting errors
- [x] Documentation updated
- [x] Security considerations reviewed

---
Generated with [Claude Code](https://claude.ai/code)

---

### Jira Updated
- Status: PROJ-123 -> In Review
- PR linked to story
```

## PR Title Format

```
{STORY-KEY}: {Brief description}

Examples:
PROJ-123: Implement user authentication
PROJ-456: Fix null pointer in order processing
PROJ-789: Add dashboard export feature
```

## PR Description Template

```markdown
## Summary
[1-2 sentence overview of what this PR does]

## Changes
- [Change 1]
- [Change 2]
- [Change 3]

## Related Issue
Closes {STORY-KEY}

## Testing
- [ ] Unit tests
- [ ] Integration tests
- [ ] Manual testing
- [ ] Security review (if applicable)

## Screenshots
[For UI changes, include before/after screenshots]

## Breaking Changes
[List any breaking changes and migration steps]

## Checklist
- [ ] Tests pass
- [ ] No linting errors
- [ ] Documentation updated
- [ ] Ready for review
```

## Reviewer Selection

### Automatic Assignment
Based on:
- Code owners file
- File change patterns
- Recent contributors to affected files
- Team rotation

### Required Reviewers
For specific changes:
- Security changes -> Security team
- Database changes -> DBA
- API changes -> API team lead

## Labels

| Label | Applies When |
|-------|-------------|
| `enhancement` | New feature |
| `bug` | Bug fix |
| `breaking` | Breaking changes |
| `security` | Security-related |
| `needs-review` | Ready for review |
| `wip` | Work in progress |

## Integration

This skill is typically invoked by:
- `development-cycle` agent after implementation
- Manual PR creation requests

## Error Handling

### Branch Not Pushed
```markdown
**Error:** Branch not found on remote

**Solution:**
```bash
git push -u origin feature/PROJ-123-user-authentication
```

Then retry PR creation.
```

### No Changes
```markdown
**Error:** No changes between branches

**Check:**
- Are all changes committed?
- Is the target branch correct?
- Has the branch been rebased recently?
```

### PR Already Exists
```markdown
**Note:** PR already exists for this branch

**Existing PR:** #450
**URL:** https://github.com/org/repo/pull/450

Would you like to update the existing PR instead?
```
