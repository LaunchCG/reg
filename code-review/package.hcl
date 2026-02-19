package {
  name        = "code-review"
  version     = "0.2.1"
  description = "Code review toolkit with review standards, code-reviewer agent, and integration with Serena and Context7 MCP servers"
  platforms   = ["claude-code", "github-copilot"]
}

dependency "base-dev" {
  version = ">=0.1.0"
}

claude_skill "code-review" {
  description = "Expert guidance for conducting thorough code reviews, identifying issues, and providing actionable feedback"
  content     = file("skills/code-review/SKILL.md")

  file {
    src  = "skills/code-review/resources/review-dimensions.md"
    dest = "resources/review-dimensions.md"
  }

  file {
    src  = "skills/code-review/resources/severity-levels.md"
    dest = "resources/severity-levels.md"
  }

  file {
    src  = "skills/code-review/resources/language-detection.md"
    dest = "resources/language-detection.md"
  }

  file {
    src  = "skills/code-review/resources/feedback-patterns.md"
    dest = "resources/feedback-patterns.md"
  }
}

claude_skill "software-engineering" {
  description = "Expert guidance for software engineering best practices, architecture patterns, and code quality"
  content     = file("skills/software-engineering/SKILL.md")

  file {
    src  = "skills/software-engineering/resources/dry-principle.md"
    dest = "resources/dry-principle.md"
  }

  file {
    src  = "skills/software-engineering/resources/solid-principles.md"
    dest = "resources/solid-principles.md"
  }

  file {
    src  = "skills/software-engineering/resources/module-organization.md"
    dest = "resources/module-organization.md"
  }

  file {
    src  = "skills/software-engineering/resources/abstraction-patterns.md"
    dest = "resources/abstraction-patterns.md"
  }

  file {
    src  = "skills/software-engineering/resources/refactoring-strategies.md"
    dest = "resources/refactoring-strategies.md"
  }
}

claude_rules "review-standards" {
  description = "Code review standards and best practices"

  file {
    src  = "rules/review-standards.md"
    dest = "review-standards.md"
  }
}

claude_subagent "code-reviewer" {
  description = "Specialized agent for conducting thorough code reviews and providing detailed feedback"
  content     = file("agents/code-reviewer.md")
}

file "tasks" {
  src  = "tasks.yaml"
  dest = ".dev_workflow/code-review.yaml"
}

# serena, context7, and mcp-permissions are inherited from base-dev dependency

# GitHub Copilot Resources

copilot_skill "code-review" {
  description = "Expert guidance for conducting thorough code reviews, identifying issues, and providing actionable feedback"
  content     = file("skills/code-review/SKILL.md")

  file {
    src  = "skills/code-review/resources/review-dimensions.md"
    dest = "resources/review-dimensions.md"
  }

  file {
    src  = "skills/code-review/resources/severity-levels.md"
    dest = "resources/severity-levels.md"
  }

  file {
    src  = "skills/code-review/resources/language-detection.md"
    dest = "resources/language-detection.md"
  }

  file {
    src  = "skills/code-review/resources/feedback-patterns.md"
    dest = "resources/feedback-patterns.md"
  }
}

copilot_skill "software-engineering" {
  description = "Expert guidance for software engineering best practices, architecture patterns, and code quality"
  content     = file("skills/software-engineering/SKILL.md")

  file {
    src  = "skills/software-engineering/resources/dry-principle.md"
    dest = "resources/dry-principle.md"
  }

  file {
    src  = "skills/software-engineering/resources/solid-principles.md"
    dest = "resources/solid-principles.md"
  }

  file {
    src  = "skills/software-engineering/resources/module-organization.md"
    dest = "resources/module-organization.md"
  }

  file {
    src  = "skills/software-engineering/resources/abstraction-patterns.md"
    dest = "resources/abstraction-patterns.md"
  }

  file {
    src  = "skills/software-engineering/resources/refactoring-strategies.md"
    dest = "resources/refactoring-strategies.md"
  }
}

copilot_instruction "review-standards" {
  description = "Code review standards and best practices"
  content     = file("rules/review-standards.md")
}

copilot_agent "code-reviewer" {
  description = "Specialized agent for conducting thorough code reviews and providing detailed feedback"
  content     = file("agents/code-reviewer.md")
}
