package {
  name        = "jira-tools"
  version     = "0.1.0"
  description = "Shared Jira CLI integration using Atlassian CLI (acli) wrapper scripts for reliable local execution"
  platforms   = ["claude-code", "github-copilot"]
}

claude_skill "jira-cli-service" {
  description = "Jira service layer using Atlassian CLI wrapper scripts for issue management, transitions, and JQL search"
  content     = file("skills/jira-cli-service/SKILL.md")

  file {
    src  = "skills/jira-cli-service/resources/examples.md"
    dest = "resources/examples.md"
  }
}

claude_rule "project-management" {
  description = "Use Jira for all project management tasks - stories, bugs, sprint planning, and work tracking"
  content     = file("rules/project-management.md")
}

copilot_skill "jira-cli-service" {
  description = "Jira service layer using Atlassian CLI wrapper scripts for issue management, transitions, and JQL search"
  content     = file("skills/jira-cli-service/SKILL.md")

  file {
    src  = "skills/jira-cli-service/resources/examples.md"
    dest = "resources/examples.md"
  }
}

copilot_instruction "project-management" {
  description = "Use Jira for all project management tasks - stories, bugs, sprint planning, and work tracking"
  content     = file("rules/project-management.md")
}
