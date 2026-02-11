package {
  name        = "sdlc-stories"
  version     = "0.1.0"
  description = "User story generation, validation, and DoR compliance testing with support for user, bug, and technical story types"
  platforms   = ["claude-code", "github-copilot"]
}

dependency "nexus-dev" {
  version = ">=0.1.0"
}

dependency "jira-tools" {
  version = ">=0.1.0"
}

claude_skill "story-build" {
  description = "Generate or refine user stories with complete acceptance criteria and DoR compliance"
  content     = file("skills/story-build/SKILL.md")

  file {
    src  = "skills/story-build/resources/output-template.md"
    dest = "resources/output-template.md"
  }

  file {
    src  = "skills/story-build/resources/user-story-template.md"
    dest = "resources/user-story-template.md"
  }

  file {
    src  = "skills/story-build/resources/bug-story-template.md"
    dest = "resources/bug-story-template.md"
  }

  file {
    src  = "skills/story-build/resources/technical-story-template.md"
    dest = "resources/technical-story-template.md"
  }
}

claude_skill "story-test-create" {
  description = "Create TDD validation tests for user stories to ensure DoR compliance"
  content     = file("skills/story-test-create/SKILL.md")

  file {
    src  = "skills/story-test-create/resources/output-template.md"
    dest = "resources/output-template.md"
  }
}

claude_skill "story-test-verify" {
  description = "Verify user story meets DoR standards defined in test-create phase"
  content     = file("skills/story-test-verify/SKILL.md")

  file {
    src  = "skills/story-test-verify/resources/output-template.md"
    dest = "resources/output-template.md"
  }
}

claude_subagent "story" {
  description = "User story generation and validation agent"
  content     = file("agents/story.md")
}

claude_command "story" {
  description = "Generate or validate user stories"
  content     = file("commands/story.md")
}

copilot_skill "story-build" {
  description = "Generate or refine user stories with complete acceptance criteria and DoR compliance"
  content     = file("skills/story-build/SKILL.md")

  file {
    src  = "skills/story-build/resources/output-template.md"
    dest = "resources/output-template.md"
  }

  file {
    src  = "skills/story-build/resources/user-story-template.md"
    dest = "resources/user-story-template.md"
  }

  file {
    src  = "skills/story-build/resources/bug-story-template.md"
    dest = "resources/bug-story-template.md"
  }

  file {
    src  = "skills/story-build/resources/technical-story-template.md"
    dest = "resources/technical-story-template.md"
  }
}

copilot_skill "story-test-create" {
  description = "Create TDD validation tests for user stories to ensure DoR compliance"
  content     = file("skills/story-test-create/SKILL.md")

  file {
    src  = "skills/story-test-create/resources/output-template.md"
    dest = "resources/output-template.md"
  }
}

copilot_skill "story-test-verify" {
  description = "Verify user story meets DoR standards defined in test-create phase"
  content     = file("skills/story-test-verify/SKILL.md")

  file {
    src  = "skills/story-test-verify/resources/output-template.md"
    dest = "resources/output-template.md"
  }
}

copilot_agent "story" {
  description = "User story generation and validation agent"
  content     = file("agents/story.md")
}
