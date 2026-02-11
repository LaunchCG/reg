# Jira for Project Management

**Use Jira for all project management tasks.** Jira is the single source of truth for work items, sprint planning, and project tracking.

## When to Use Jira

- **Creating work items**: Stories, bugs, tasks, and epics must be created in Jira
- **Updating status**: Transition issues through workflow states in Jira when starting, completing, or blocking work
- **Linking work to code**: Reference Jira keys in branch names, commit messages, and PR titles
- **Querying backlog**: Use JQL through the jira-cli-service skill to search, filter, and prioritize work
- **Adding context**: Post comments on Jira issues to document decisions, blockers, and progress
- **Sprint management**: View and manage sprint scope through Jira

## How to Use Jira

Use the `jira-cli-service` skill and its wrapper scripts for all Jira operations. Never attempt to manage work items outside of Jira (e.g., in local files, GitHub issues, or ad-hoc lists).

When a user asks you to:
- "Create a story/task/bug" → create it in Jira
- "What's in the backlog?" → search Jira with JQL
- "Move this to in progress" → transition the Jira issue
- "What am I working on?" → query Jira for assigned issues
- "Add a comment about..." → add a comment to the Jira issue
