---
name: my-issues
description: Guide for viewing and managing assigned GitHub issues
---

# View My GitHub Issues

Guide for tracking and managing your assigned issues.

## View Issues

### Using gh CLI

```bash
# View all your assigned issues
gh issue list --assignee @me

# View your assigned issues with specific state
gh issue list --assignee @me --state open
gh issue list --assignee @me --state closed

# View issues with specific labels
gh issue list --assignee @me --label bug
gh issue list --assignee @me --label enhancement

# View detailed issue information
gh issue view 123
```

### Using GitHub Web UI

1. Navigate to repository
2. Click "Issues"
3. Filter by assignee: `assignee:@me`
4. Or use quick filter: "Assigned to you"

## Issue Organization

### Priority Workflow

1. **High Priority**
   - Critical bugs
   - Blocking issues
   - Issues with upcoming deadlines

2. **Medium Priority**
   - Feature requests
   - Non-critical bugs
   - Improvements

3. **Low Priority**
   - Nice-to-have features
   - Documentation improvements
   - Minor enhancements

### Issue Status Tracking

Use project boards or labels to track:
- **Todo** - Not started
- **In Progress** - Currently working on
- **In Review** - PR created, awaiting review
- **Done** - Completed and merged

## Useful Commands

```bash
# Count your open issues
gh issue list --assignee @me --state open | wc -l

# View issues created by you
gh issue list --author @me

# Search issues by keyword
gh issue list --search "authentication"

# View PRs related to your issues
gh pr list --search "author:@me"
```

## Tips

- Review assigned issues at start of day
- Update issue status when starting work
- Comment on blockers or questions
- Close issues when PRs are merged
- Unassign if you can't work on an issue

<!-- To be populated from /Users/jim/Projects/draftbox/.claude/commands/my_issues.md -->
