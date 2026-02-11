package {
  name        = "sdlc-architecture"
  version     = "0.1.0"
  description = "Architecture documentation generation with repository scanning, convention detection, and ADR creation"
  platforms   = ["claude-code", "github-copilot"]
}

dependency "nexus-dev" {
  version = ">=0.1.0"
}

claude_skill "architecture-build" {
  description = "Analyze repository and generate architecture documentation, conventions, and ADRs"
  content     = file("skills/architecture-build/SKILL.md")

  file {
    src  = "skills/architecture-build/resources/output-template.md"
    dest = "resources/output-template.md"
  }
}

claude_subagent "architecture" {
  description = "Architecture documentation generation agent"
  content     = file("agents/architecture.md")
}

claude_command "architecture" {
  description = "Generate architecture documentation"
  content     = file("commands/architecture.md")
}

copilot_skill "architecture-build" {
  description = "Analyze repository and generate architecture documentation, conventions, and ADRs"
  content     = file("skills/architecture-build/SKILL.md")

  file {
    src  = "skills/architecture-build/resources/output-template.md"
    dest = "resources/output-template.md"
  }
}

copilot_agent "architecture" {
  description = "Architecture documentation generation agent"
  content     = file("agents/architecture.md")
}
