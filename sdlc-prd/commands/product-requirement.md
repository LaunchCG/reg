---
description: Generate or validate product requirement documents (PRDs) using template-based methodology
---

# /product-requirement

Creates evidence-based PRDs or validates existing Epics against PRD standards.

## Usage

```bash
# Build mode - Generate new PRD
/product-requirement [build] <description>

# Test mode - Validate existing Epic
/product-requirement test <epic-id>
```

## Parameters

- **description**: Natural language problem or feature description (build mode)
- **epic-id**: Jira Epic key to validate (test mode, e.g., PROD-123)

## Execution Instructions

**CRITICAL: When this command is invoked, you MUST follow these steps exactly:**

### Step 1: Parse Arguments and Determine Mode

Extract the mode and content from command arguments:
- Mode: `build` (default) or `test`
- Content: Description (build mode) or epic-id (test mode)

**Examples:**
- `/product-requirement build User notification system` -> mode="build", content="User notification system"
- `/product-requirement User notification system` -> mode="build" (default), content="User notification system"
- `/product-requirement test PROD-123` -> mode="test", content="PROD-123"

### Step 1.5: Fetch Epic Data (Test Mode Only)

**CRITICAL: If test mode, fetch the epic before invoking agent**

**Check mode:**
- If build mode: Skip to Step 2
- If test mode: Continue below

1. **Extract epic-id** from content
2. **Validate epic-id format:** `^[A-Z][A-Z0-9]+-[0-9]+$`
3. **Invoke the jira-cli-service skill:**
   - Use the **Skill tool**
   - Skill name: `"jira-cli-service"`
   - Args: `"view <epic-id>"`
4. **Store the epic data** returned by the skill
5. **If fetch fails:** Report error to user and DO NOT invoke agent

**Example:**
- Skill tool with skill="jira-cli-service" and args="view PROD-123"

### Step 2: Invoke Agent with Pre-Fetched Data (REQUIRED)

Choose the appropriate invocation based on mode:

#### Build Mode:
```
Task tool with:
  subagent_type: "ai-sdlc:product-requirement"
  description: "Generate PRD"
  prompt: """
Mode: build
Description: <description>

Generate PRD from this description.
"""
```

#### Test Mode:
```
Task tool with:
  subagent_type: "ai-sdlc:product-requirement"
  description: "Validate PRD"
  prompt: """
Mode: test
Epic ID: <epic-id>

=== EPIC DATA (PRE-FETCHED) ===
<paste epic JSON or formatted data from Step 1.5>
=== END EPIC DATA ===

IMPORTANT: Epic data is already fetched. DO NOT call jira-cli-service.
Validate this epic against PRD standards.
"""
```

**Examples:**
- Build: User types `/product-requirement build User notification system`
- Test: User types `/product-requirement test PROD-123`, you fetch epic, then invoke agent with epic data

### Step 3: What NOT to Do (CRITICAL)

**DO NOT** invoke skills directly (e.g., `product-requirement-build`, `product-requirement-test-create`)
**DO NOT** generate the PRD yourself
**DO NOT** call MCP tools directly
**DO NOT** create Jira Epics yourself
**DO NOT** validate PRD standards yourself
**DO NOT** fetch epic again (already provided to agent in test mode)

### Step 4: Wait for Agent Results

The `ai-sdlc:product-requirement` agent will:
1. Parse pre-fetched epic data from prompt (if test mode)
2. **Build mode**: Generate PRD using evidence-based templates, create Epic in Jira
3. **Test mode**: Validate against PRD standards using provided epic data
4. Retry up to 3 times if validation fails
5. Return comprehensive results with quality scores

### Step 5: Present Results to User

Once the agent completes, present its results to the user without modification.

---

## What This Command Does

Generates or validates product requirement documents:

- **Build mode** (default): Generate PRD using templates, create Epic in Jira
- **Test mode**: Validate existing Epic against PRD standards

**Workflow:**

**Build Mode:**
1. Parse description from arguments
2. Pass to product-requirement agent
3. Agent generates evidence-based PRD
4. Agent creates Epic in Jira

**Test Mode:**
1. Parse epic-id from arguments
2. Fetch epic data via jira-cli-service skill
3. Pass epic data to agent
4. Agent validates against PRD standards
5. Agent posts feedback to Jira

**PRD includes:**
- Executive summary
- Problem statement with evidence
- User personas and research
- Success metrics (leading/lagging indicators)
- Technical approach
- Go-to-market strategy
- Risk assessment
- Resource requirements
