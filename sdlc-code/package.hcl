package {
  name        = "sdlc-code"
  version     = "0.1.0"
  description = "TDD code development workflow with RED-GREEN-REFACTOR cycle, test creation, implementation, and verification"
  platforms   = ["claude-code", "github-copilot"]
}

dependency "nexus-dev" {
  version = ">=0.1.0"
}

claude_skill "tdd-workflow" {
  description = "Guides Test-Driven Development implementation following RED-GREEN-REFACTOR cycle"
  content     = file("skills/tdd-workflow/SKILL.md")
}

claude_skill "code-build" {
  description = "Implement code to pass tests created in test-create phase following TDD GREEN phase"
  content     = file("skills/code-build/SKILL.md")

  file {
    src  = "skills/code-build/resources/output-template.md"
    dest = "resources/output-template.md"
  }
}

claude_skill "code-test-create" {
  description = "Create TDD test suite for code implementation based on story acceptance criteria"
  content     = file("skills/code-test-create/SKILL.md")

  file {
    src  = "skills/code-test-create/resources/output-template.md"
    dest = "resources/output-template.md"
  }
}

claude_skill "code-test-verify" {
  description = "Verify all tests pass and acceptance criteria are met following TDD verification"
  content     = file("skills/code-test-verify/SKILL.md")

  file {
    src  = "skills/code-test-verify/resources/output-template.md"
    dest = "resources/output-template.md"
  }
}

claude_subagent "code" {
  description = "TDD code implementation agent - RED-GREEN-REFACTOR workflow"
  content     = file("agents/code.md")
}

claude_command "code" {
  description = "Start TDD code implementation workflow"
  content     = file("commands/code.md")
}

copilot_skill "tdd-workflow" {
  description = "Guides Test-Driven Development implementation following RED-GREEN-REFACTOR cycle"
  content     = file("skills/tdd-workflow/SKILL.md")
}

copilot_skill "code-build" {
  description = "Implement code to pass tests created in test-create phase following TDD GREEN phase"
  content     = file("skills/code-build/SKILL.md")

  file {
    src  = "skills/code-build/resources/output-template.md"
    dest = "resources/output-template.md"
  }
}

copilot_skill "code-test-create" {
  description = "Create TDD test suite for code implementation based on story acceptance criteria"
  content     = file("skills/code-test-create/SKILL.md")

  file {
    src  = "skills/code-test-create/resources/output-template.md"
    dest = "resources/output-template.md"
  }
}

copilot_skill "code-test-verify" {
  description = "Verify all tests pass and acceptance criteria are met following TDD verification"
  content     = file("skills/code-test-verify/SKILL.md")

  file {
    src  = "skills/code-test-verify/resources/output-template.md"
    dest = "resources/output-template.md"
  }
}

copilot_agent "code" {
  description = "TDD code implementation agent - RED-GREEN-REFACTOR workflow"
  content     = file("agents/code.md")
}
