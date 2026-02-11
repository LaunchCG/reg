# GitHub Pull Request Rules

## Mandatory Requirements

### Before Creating a PR

1. **All tests must pass** - Run the full test suite locally
2. **Linting must pass** - No linting errors or warnings
3. **Branch is up to date** - Rebase or merge latest from base branch
4. **Commits are clean** - Well-structured, atomic commits with clear messages

### PR Content Requirements

1. **Descriptive Title**
   - Under 70 characters
   - Starts with action verb (Add, Fix, Update, Remove, Refactor)
   - Clear and specific

2. **Complete Description**
   - Summary of changes (what was done)
   - Motivation (why it was needed)
   - Testing approach
   - Links to related issues

3. **Linked Issues**
   - Use "Closes #123" or "Fixes #123" for issues this PR resolves
   - Use "Related to #123" for related but not fully resolved issues

### PR Size Guidelines

- **Small PR** (< 200 lines): Preferred size
- **Medium PR** (200-500 lines): Acceptable with good description
- **Large PR** (> 500 lines): Requires justification and thorough review plan

If a PR is too large, consider breaking it into smaller, focused PRs.

### Review Process

1. **Request appropriate reviewers** - At least one team member
2. **Respond to feedback** - Address all comments before merging
3. **No force-push after reviews** - Makes it hard to track changes
4. **CI must pass** - All status checks must be green

### Merge Requirements

- All review comments resolved
- All CI checks passing
- Branch up to date with base
- Approved by required reviewers

## Anti-Patterns to Avoid

❌ PRs without description
❌ Vague titles like "update code" or "fix bug"
❌ Mixing unrelated changes
❌ Large refactors combined with features
❌ Not linking related issues
❌ Ignoring review feedback
❌ Force-pushing after review started

## Best Practices

✅ Keep PRs focused on single concern
✅ Include screenshots for UI changes
✅ Add test coverage for new features
✅ Update documentation as needed
✅ Use draft PRs for early feedback
✅ Self-review before requesting reviews
✅ Thank reviewers for their time

<!-- To be populated from /Users/jim/Projects/draftbox/.claude/rules/github/github-prs.md -->
