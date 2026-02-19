package {
  name        = "vite"
  version     = "0.2.1"
  description = "Vite expert: lightning-fast dev server, HMR, production builds, framework integration, and modern build optimization"
  platforms   = ["claude-code", "github-copilot"]
}

dependency "typescript" {
  version = ">=0.1.0"
}

claude_skill "vite" {
  description = "Expert in Vite development: native ES modules, HMR, Rollup-based builds, framework integration (React, Vue, Svelte), environment variables, and build optimization. Use when working with Vite projects or build tooling."
  content     = file("skills/vite/SKILL.md")
}

file "tasks" {
  src  = "tasks.yaml"
  dest = ".dev_workflow/vite.yaml"
}

mcp_server "runbook" {
  description = "Runbook task automation (https://runbookmcp.dev)"
  command     = "runbook"
}

claude_rule "vite-tasks-rule" {
  description = "Enforce MCP usage"
  content = "You must use the runbook MCP tools for all Vite operations including dev server, building, previewing, and type checking. Never run vite or tsc commands directly via Bash."
}

claude_settings "mcp-permissions" {
  allow = [
    "mcp__runbook__*"
  ]
}

# GitHub Copilot Resources

copilot_skill "vite" {
  description = "Expert in Vite development: native ES modules, HMR, Rollup-based builds, framework integration (React, Vue, Svelte), environment variables, and build optimization. Use when working with Vite projects or build tooling."
  content     = file("skills/vite/SKILL.md")
}
