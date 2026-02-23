package {
  name        = "typescript"
  version     = "0.2.2"
  description = "TypeScript development toolkit with linting, testing, and E2E validation using Chrome DevTools MCP"
  platforms   = ["claude-code", "github-copilot"]
}

claude_skill "linting" {
  description = "Expert in maintaining code quality using ESLint and TypeScript. Enforces zero-error policy for linting and type checking."
  content     = file("skills/linting/SKILL.md")
}

claude_skill "testing" {
  description = "Expert in testing TypeScript applications with unit tests and E2E validation using Chrome DevTools MCP"
  content     = file("skills/testing/SKILL.md")
}

claude_rule "typescript-tasks-rule" {
  description = "Enforce MCP usage"
  content = "You must use the runbook MCP tools for all TypeScript operations including linting, type checking, testing, and building. Never run tsc, eslint, vitest, or other TypeScript commands directly via Bash."
}

file "tasks" {
  src  = "tasks.yaml"
  dest = ".runbook/typescript.yaml"
}

mcp_server "runbook" {
  description = "Runbook task automation (https://runbookmcp.dev)"
  command     = "runbook"
}

mcp_server "chrome-devtools" {
  description = "Chrome DevTools MCP for browser automation, E2E testing, and UI validation"
  command     = "npx"
  args = [
    "-y",
    "chrome-devtools-mcp@latest"
  ]
}

claude_settings "mcp-permissions" {
  allow = [
    "mcp__chrome-devtools__*",
    "mcp__runbook__*"
  ]
}

# GitHub Copilot Resources

copilot_skill "linting" {
  description = "Expert in maintaining code quality using ESLint and TypeScript. Enforces zero-error policy for linting and type checking."
  content     = file("skills/linting/SKILL.md")
}

copilot_skill "testing" {
  description = "Expert in testing TypeScript applications with unit tests and E2E validation using Chrome DevTools MCP"
  content     = file("skills/testing/SKILL.md")
}
