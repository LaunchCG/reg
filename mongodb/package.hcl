package {
  name        = "mongodb"
  version     = "0.1.0"
  description = "MongoDB and Mongoose ODM expertise for Node.js"
  platforms   = ["claude-code", "github-copilot"]
}

dependency "typescript" {
  version = ">=0.1.0"
}

# MongoDB/Mongoose skill
claude_skill "mongodb" {
  description = "Expert in MongoDB and Mongoose ODM for Node.js"
  content     = file("skills/mongodb.md")
}

# GitHub Copilot Resources

copilot_skill "mongodb" {
  description = "Expert in MongoDB and Mongoose ODM for Node.js"
  content     = file("skills/mongodb.md")
}
