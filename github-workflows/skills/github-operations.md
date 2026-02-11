---
name: github-operations
description: GitHub workflow automation and issue/PR management
---

# GitHub Operations Skill

Expert guidance for GitHub workflow automation, issue tracking, and PR management.

## Core Operations

### Issue Management
- Creating and tracking issues
- Using labels and milestones
- Assigning issues to team members
- Linking issues to PRs

### PR Workflow
- Creating pull requests from branches
- Requesting reviews
- Managing review feedback
- Merging strategies (squash, merge, rebase)

### Branch Management
- Creating feature branches
- Keeping branches up to date
- Deleting merged branches

### Project Boards
- Organizing issues in project boards
- Tracking progress through columns
- Automating card movement

## GitHub CLI Commands

```bash
# Issues
gh issue create --title "Title" --body "Description"
gh issue list --assignee @me
gh issue view 123

# Pull Requests
gh pr create --title "Title" --body "Description"
gh pr list --author @me
gh pr checkout 456
gh pr merge 456 --squash

# Repositories
gh repo view
gh repo clone owner/repo
```

## Best Practices

- Use branch protection rules
- Require PR reviews before merging
- Enable status checks (tests, linting)
- Use CODEOWNERS for automatic review requests
- Keep main/master branch clean and stable

<!-- To be populated from /Users/jim/Projects/draftbox/.claude/skills/github_operations/ -->
