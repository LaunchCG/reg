---
name: create-issue
description: Guide for creating GitHub issues
---

# Create GitHub Issue

Step-by-step guide for creating clear, actionable issues.

## Workflow

1. **Determine issue type**
   - Bug report
   - Feature request
   - Documentation
   - Question

2. **Create issue using gh CLI**
   ```bash
   gh issue create --title "Issue title" --body "$(cat <<'EOF'
   ## Description
   Clear description of the issue or request

   ## Steps to Reproduce (for bugs)
   1. Step one
   2. Step two

   ## Expected Behavior
   What should happen

   ## Actual Behavior
   What actually happens

   ## Additional Context
   Environment, versions, screenshots

   EOF
   )"
   ```

3. **Or create via GitHub UI**
   - Navigate to repository
   - Click "Issues" → "New issue"
   - Select template if available
   - Fill in title and description
   - Add labels, assignees, milestone
   - Click "Submit new issue"

## Issue Quality Checklist

- [ ] Descriptive title that summarizes the issue
- [ ] Clear problem statement or feature description
- [ ] Reproduction steps (for bugs)
- [ ] Expected vs actual behavior (for bugs)
- [ ] Environment details (OS, versions, etc.)
- [ ] Screenshots or error logs (if applicable)
- [ ] Labels added for categorization

## Tips

- Search existing issues first to avoid duplicates
- Use labels to categorize (bug, enhancement, documentation)
- Assign to appropriate team member if known
- Link to related issues or PRs

<!-- To be populated from /Users/jim/Projects/draftbox/.claude/commands/create_issue.md -->
