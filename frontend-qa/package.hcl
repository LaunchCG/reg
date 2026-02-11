package {
  name        = "frontend-qa"
  version     = "0.1.0"
  description = "Comprehensive QA toolkit with adversarial testing mindset, Playwright E2E testing, TDD enforcement, and exploratory testing techniques"
  platforms   = ["claude-code", "github-copilot"]
}

dependency "base-dev" {
  version = ">=0.1.0"
}

# QA mindset skill - adversarial testing approach
claude_skill "qa-mindset" {
  description = "Adopt the adversarial mindset of a professional QA tester - break things, find edge cases, and thoroughly test every interaction"
  content     = file("skills/qa-mindset.md")
}

# Playwright testing skill
claude_skill "playwright-testing" {
  description = "Expert in Playwright E2E testing with focus on best practices and test reliability"
  content     = file("skills/playwright-testing.md")
}

# TDD enforcement rule
claude_rule "test-driven-development" {
  description = "Mandatory TDD workflow - tests must be written before implementation"
  content     = file("rules/test-driven-development.md")
}

# QA subagent for E2E testing
claude_subagent "frontend-qa" {
  description = "E2E testing specialist with Playwright expertise"
  content     = file("agents/frontend-qa.md")
}

# Test command
claude_command "test" {
  description = "Run Playwright E2E tests"
  content     = file("commands/test.md")
}

# GitHub Copilot Resources

copilot_skill "qa-mindset" {
  description = "Adopt the adversarial mindset of a professional QA tester - break things, find edge cases, and thoroughly test every interaction"
  content     = file("skills/qa-mindset.md")
}

copilot_skill "playwright-testing" {
  description = "Expert in Playwright E2E testing with focus on best practices and test reliability"
  content     = file("skills/playwright-testing.md")
}

copilot_instruction "test-driven-development" {
  description = "Mandatory TDD workflow - tests must be written before implementation"
  content     = file("rules/test-driven-development.md")
}

copilot_agent "frontend-qa" {
  description = "E2E testing specialist with Playwright expertise"
  content     = file("agents/frontend-qa.md")
}
