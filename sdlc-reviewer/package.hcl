package {
  name        = "sdlc-reviewer"
  version     = "0.1.0"
  description = "PR review, creation, and git workflow with DoD validation, security scanning, and conventional commits"
  platforms   = ["claude-code", "github-copilot"]
}

dependency "nexus-dev" {
  version = ">=0.1.0"
}

dependency "code-review" {
  version = ">=0.1.0"
}

claude_skill "pr-creator" {
  description = "Creates pull requests with proper descriptions, linked issues, and review assignments"
  content     = file("skills/pr-creator/SKILL.md")

  file {
    src  = "skills/pr-creator/resources/output-template.md"
    dest = "resources/output-template.md"
  }
}

claude_skill "git-commit-helper" {
  description = "Generates commit messages following conventional commit format with Jira ticket detection"
  content     = file("skills/git-commit-helper/SKILL.md")
}

claude_subagent "pr-reviewer" {
  description = "PR reviewer agent combining DoD validation with code quality and security review"
  content     = file("agents/pr-reviewer.md")
}

copilot_skill "pr-creator" {
  description = "Creates pull requests with proper descriptions, linked issues, and review assignments"
  content     = file("skills/pr-creator/SKILL.md")

  file {
    src  = "skills/pr-creator/resources/output-template.md"
    dest = "resources/output-template.md"
  }
}

copilot_skill "git-commit-helper" {
  description = "Generates commit messages following conventional commit format with Jira ticket detection"
  content     = file("skills/git-commit-helper/SKILL.md")
}

copilot_agent "pr-reviewer" {
  description = "PR reviewer agent combining DoD validation with code quality and security review"
  content     = file("agents/pr-reviewer.md")
}
