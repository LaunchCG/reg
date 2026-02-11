package {
  name        = "github-workflows"
  version     = "0.1.0"
  description = "GitHub PR/issue automation and workflow management with MCP server"
  platforms   = ["claude-code", "github-copilot"]
}

dependency "base-dev" {
  version = ">=0.1.0"  # For commit standards
}

# GitHub MCP server (moved from base-dev@0.3.1)
mcp_server "github" {
  description = "GitHub MCP server for PR/issue management"
  command     = "npx"
  args        = ["-y", "@modelcontextprotocol/server-github"]

  env = {
    GITHUB_PERSONAL_ACCESS_TOKEN = "$${GITHUB_PERSONAL_ACCESS_TOKEN}"
  }
}

# GitHub MCP permissions (moved from base-dev@0.3.1)
claude_settings "mcp-permissions" {
  allow = [
    "mcp__github__*"
  ]
}

# Skills for GitHub workflows (commands converted to skills)
claude_skill "pr-writing" {
  description = "Create high-quality pull requests with structured descriptions"
  content     = file("skills/pr-writing.md")
}

claude_skill "issue-writing" {
  description = "Create well-structured GitHub issues with clear descriptions"
  content     = file("skills/issue-writing.md")
}

claude_skill "github-operations" {
  description = "GitHub workflow automation and issue/PR management"
  content     = file("skills/github-operations.md")
}

claude_skill "create-pr" {
  description = "Guide for creating pull requests via GitHub"
  content     = file("skills/create-pr.md")
}

claude_skill "create-issue" {
  description = "Guide for creating GitHub issues"
  content     = file("skills/create-issue.md")
}

claude_skill "work-on-issue" {
  description = "Comprehensive workflow for analyzing, planning, and implementing GitHub issues with plan mode"
  content     = file("skills/work-on-issue.md")
}

claude_skill "my-issues" {
  description = "Guide for viewing assigned GitHub issues"
  content     = file("skills/my-issues.md")
}

# Rules for GitHub workflows
claude_rule "github-prs" {
  description = "PR quality and workflow standards"
  content     = file("rules/github-prs.md")
}

claude_rule "github-issues" {
  description = "Issue creation and management standards"
  content     = file("rules/github-issues.md")
}

# GitHub Copilot Resources

copilot_skill "pr-writing" {
  description = "Create high-quality pull requests with structured descriptions"
  content     = file("skills/pr-writing.md")
}

copilot_skill "issue-writing" {
  description = "Create well-structured GitHub issues with clear descriptions"
  content     = file("skills/issue-writing.md")
}

copilot_skill "github-operations" {
  description = "GitHub workflow automation and issue/PR management"
  content     = file("skills/github-operations.md")
}

copilot_skill "create-pr" {
  description = "Guide for creating pull requests via GitHub"
  content     = file("skills/create-pr.md")
}

copilot_skill "create-issue" {
  description = "Guide for creating GitHub issues"
  content     = file("skills/create-issue.md")
}

copilot_skill "work-on-issue" {
  description = "Comprehensive workflow for analyzing, planning, and implementing GitHub issues with plan mode"
  content     = file("skills/work-on-issue.md")
}

copilot_skill "my-issues" {
  description = "Guide for viewing assigned GitHub issues"
  content     = file("skills/my-issues.md")
}
