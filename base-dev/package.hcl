package {
  name        = "base-dev"
  version     = "0.1.0"
  description = "Base development toolkit with commit standards, linting rules, CI/CD automation, serena and context7 MCP servers"
  platforms   = ["claude-code", "github-copilot"]
}

claude_skill "commit-messages" {
  description = "Expert in writing clear, conventional commit messages"
  content     = file("skills/commit-messages.md")
}

claude_rule "linting" {
  description = "Enforce code quality standards - linting must pass before commits"
  content     = file("rules/linting.md")
}

claude_rule "no-ai-attribution" {
  description = "Prohibit Claude from adding self-attribution in commits or pull requests"
  content     = <<-EOT
    # No AI Attribution

    **Never include attribution for Claude or AI assistance in commits, pull requests, or any code contributions.**

    Do not add:
    - `Co-Authored-By: Claude`
    - `Co-Authored-By: AI Assistant`
    - Any similar AI attribution
    - Comments crediting AI assistance

    Code contributions should reflect the repository owner's work. AI assistance is a tool, not a contributor.
  EOT
}

claude_subagent "cicd" {
  description = "Specialized CI/CD agent for automation and release management"
  content     = file("agents/cicd.md")
}

claude_settings "mcp-permissions" {
  allow = [
    "mcp__serena__*",
    "mcp__context7__*"
  ]
}  

mcp_server "serena" {
  description = "IDE assistant with project context"
  command     = "uvx"
  args = [
    "--from",
    "git+https://github.com/oraios/serena",
    "serena",
    "start-mcp-server",
    "--context",
    "ide-assistant",
    "--project",
    "$${PWD}"
  ]
}

mcp_server "context7" {
  description = "Context management and search"
  command     = "npx"
  args        = ["-y", "@upstash/context7-mcp"]
}

# GitHub Copilot Resources

copilot_skill "commit-messages" {
  description = "Expert in writing clear, conventional commit messages"
  content     = file("skills/commit-messages.md")
}

copilot_instruction "linting" {
  description = "Enforce code quality standards - linting must pass before commits"
  content     = file("rules/linting.md")
}

copilot_instruction "no-ai-attribution" {
  description = "Prohibit AI from adding self-attribution in commits or pull requests"
  content     = <<-EOT
    # No AI Attribution

    **Never include attribution for AI assistance in commits, pull requests, or any code contributions.**

    Do not add:
    - `Co-Authored-By: Claude`
    - `Co-Authored-By: AI Assistant`
    - Any similar AI attribution
    - Comments crediting AI assistance

    Code contributions should reflect the repository owner's work. AI assistance is a tool, not a contributor.
  EOT
}

copilot_agent "cicd" {
  description = "Specialized CI/CD agent for automation and release management"
  content     = file("agents/cicd.md")
}
