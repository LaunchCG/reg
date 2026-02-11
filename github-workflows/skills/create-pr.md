---
name: create-pr
description: Guide for creating pull requests via GitHub
---

# Create Pull Request

Step-by-step guide for creating high-quality pull requests.

## Workflow

1. **Ensure changes are committed**
   ```bash
   git status
   git add .
   git commit -m "Your commit message"
   ```

2. **Push branch to remote**
   ```bash
   git push origin your-branch-name
   ```

3. **Create PR using gh CLI**
   ```bash
   gh pr create --title "Your PR title" --body "$(cat <<'EOF'
   ## Summary
   Brief description

   ## Changes
   - Change 1
   - Change 2

   ## Testing
   How you tested

   EOF
   )"
   ```

4. **Or create via GitHub UI**
   - Navigate to repository on GitHub
   - Click "Pull requests" → "New pull request"
   - Select base and compare branches
   - Fill in title and description
   - Click "Create pull request"

## PR Quality Checklist

Before creating a PR, ensure:
- [ ] All tests pass locally
- [ ] Linting passes without errors
- [ ] Commit messages are clear and descriptive
- [ ] PR title is concise (under 70 characters)
- [ ] Description explains what, why, and how
- [ ] Related issues are linked

## Tips

- Use draft PRs for work in progress
- Request specific reviewers
- Add labels for categorization
- Link to design docs or RFCs for large changes

<!-- To be populated from /Users/jim/Projects/draftbox/.claude/commands/create_pr.md -->
