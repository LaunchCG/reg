---
description: Assess and improve repository documentation structure following engineering best practices
---

# /architecture

Assesses repository documentation and generates drafts for missing artifacts.

## Usage

```bash
/architecture build
```

## Parameters

None required - analyzes current repository.

## Execution Instructions

**CRITICAL: When this command is invoked, you MUST follow these steps exactly:**

### Step 1: Invoke the Agent (REQUIRED)

Use the **Task tool** to invoke the specialized agent:

```
Task tool with:
  subagent_type: "ai-sdlc:architecture"
  description: "Assess repository documentation"
  prompt: "build"
```

**Example:**
- User types: `/architecture build`
- You invoke: Task tool with subagent_type="ai-sdlc:architecture" and prompt="build"

### Step 2: What NOT to Do (CRITICAL)

**DO NOT** scan the `/docs` directory yourself
**DO NOT** generate documentation drafts yourself
**DO NOT** evaluate architecture yourself
**DO NOT** create files directly

### Step 3: Wait for Agent Results

The `ai-sdlc:architecture` agent will:
1. Scan `/docs` directory for existing documentation
2. Evaluate against engineering best practices
3. Generate drafts for missing artifacts (README, ADRs, architecture docs, conventions)
4. Provide improvement recommendations
5. Return comprehensive assessment

### Step 4: Present Results to User

Once the agent completes, present its results to the user without modification.

---

## What This Command Does

Assesses repository documentation and generates drafts for missing artifacts:

**Evaluates:**
- README.md completeness
- Architecture documentation
- ADR (Architecture Decision Records)
- Coding conventions
- Testing conventions
- API documentation

**Generates drafts for:**
- Missing documentation files
- `/docs/conventions/` directory structure
- ADR templates
- Architecture diagrams
