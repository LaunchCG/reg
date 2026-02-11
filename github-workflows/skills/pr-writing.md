---
name: pr-writing
description: Create high-quality pull requests with structured descriptions
---

# PR Writing Skill

Expert guidance for creating well-structured, informative pull requests on GitHub.

## Core Principles

1. **Clear Title**: Concise summary of changes (under 70 characters)
2. **Structured Description**: What, why, and how of the changes
3. **Context**: Link to related issues, discussions, or documentation
4. **Testing**: Describe how changes were tested
5. **Checklist**: Ensure all requirements are met before merging

## PR Template Structure

```markdown
## Summary
Brief description of what this PR accomplishes (1-3 sentences)

## Changes
- Bullet list of key changes
- Focus on what changed, not how

## Motivation
Why these changes are needed

## Testing
- How you tested these changes
- Any manual testing steps
- Automated test coverage

## Related Issues
Closes #123
Related to #456

## Checklist
- [ ] Tests pass
- [ ] Documentation updated
- [ ] No linting errors
- [ ] Breaking changes documented
```

## Best Practices

- Keep PRs focused and atomic (one logical change per PR)
- Include screenshots for UI changes
- Tag relevant reviewers and teams
- Link to design documents or RFCs for architectural changes
- Use draft PRs for work-in-progress to get early feedback

## Anti-Patterns

- ❌ Vague titles like "fix bug" or "update code"
- ❌ No description or context
- ❌ Mixing unrelated changes
- ❌ Large PRs (>500 lines) without justification
- ❌ No test plan or testing steps

<!-- To be populated from /Users/jim/Projects/draftbox/.claude/skills/pr_writing/ -->
