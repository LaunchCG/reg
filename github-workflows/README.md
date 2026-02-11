# github-workflows

GitHub PR/issue automation and workflow management package for Claude Code and GitHub Copilot.

## Overview

This package provides comprehensive GitHub workflow guidance including:
- GitHub MCP server for PR/issue management
- Skills for creating and managing PRs and issues
- Rules for PR and issue quality standards

## Contents

### MCP Server
- **github** - GitHub MCP server moved from base-dev@0.3.1

### Skills
- **pr-writing** - Create high-quality pull requests
- **issue-writing** - Create well-structured GitHub issues
- **github-operations** - GitHub workflow automation
- **create-pr** - Guide for creating PRs
- **create-issue** - Guide for creating issues
- **work-on-issue** - Guide for starting work on issues
- **my-issues** - View and manage assigned issues

### Rules
- **github-prs** - PR quality and workflow standards
- **github-issues** - Issue creation and management standards

## Dependencies

- `base-dev@^0.4.0` - For serena, context7, and commit standards

## Installation

Add to your `dex.hcl`:

```hcl
plugin "github-workflows" {
  registry = "dex-dev-registry"
  version  = "^0.1.0"
}
```

## Environment Variables

The GitHub MCP server requires:
```bash
export GITHUB_PERSONAL_ACCESS_TOKEN="your-token-here"
```

## Usage

### Creating a PR

Use the `create-pr` skill for guidance on creating quality pull requests with proper descriptions and linking.

### Creating an Issue

Use the `create-issue` skill for guidance on creating clear, actionable issues with proper templates.

### Managing Issues

Use the `my-issues` skill to view and manage your assigned GitHub issues.

## Version History

### 0.1.0 (Initial Release)
- Extracted GitHub MCP server from base-dev
- Converted GitHub commands to skills
- Added comprehensive PR and issue guidance
- Added workflow automation skills

## Migration from base-dev

If you were using base-dev@0.3.1 or earlier for GitHub integration:
1. Update to base-dev@^0.4.0
2. Add github-workflows@^0.1.0
3. GitHub MCP server now comes from github-workflows instead of base-dev
