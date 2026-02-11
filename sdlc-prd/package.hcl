package {
  name        = "sdlc-prd"
  version     = "0.1.0"
  description = "Product requirement document generation following evidence-based product management principles"
  platforms   = ["claude-code", "github-copilot"]
}

dependency "nexus-dev" {
  version = ">=0.1.0"
}

claude_skill "product-requirement-build" {
  description = "Generate comprehensive product requirement documents (PRDs) following evidence-based product management"
  content     = file("skills/product-requirement-build/SKILL.md")

  file {
    src  = "skills/product-requirement-build/resources/output-template.md"
    dest = "resources/output-template.md"
  }

  file {
    src  = "skills/product-requirement-build/resources/prd-template.md"
    dest = "resources/prd-template.md"
  }
}

claude_subagent "product-requirement" {
  description = "Product requirement document generation agent"
  content     = file("agents/product-requirement.md")
}

claude_command "product-requirement" {
  description = "Generate or validate product requirement documents"
  content     = file("commands/product-requirement.md")
}

copilot_skill "product-requirement-build" {
  description = "Generate comprehensive product requirement documents (PRDs) following evidence-based product management"
  content     = file("skills/product-requirement-build/SKILL.md")

  file {
    src  = "skills/product-requirement-build/resources/output-template.md"
    dest = "resources/output-template.md"
  }

  file {
    src  = "skills/product-requirement-build/resources/prd-template.md"
    dest = "resources/prd-template.md"
  }
}

copilot_agent "product-requirement" {
  description = "Product requirement document generation agent"
  content     = file("agents/product-requirement.md")
}
