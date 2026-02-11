---
description: Generate or validate user stories using template-based methodology with Definition of Ready compliance
---

# /story

Generates DoR-compliant user stories from descriptions or validates existing stories.

## Usage

```bash
# Build mode - Generate new story
/story [build] <description>

# Test mode - Validate existing story
/story test <jira-key>
```

## Parameters

- **description**: Natural language feature description (build mode)
- **jira-key**: Jira story key to validate (test mode, e.g., PROJ-123)

## Execution Instructions

**CRITICAL: When this command is invoked, you MUST follow these steps exactly:**

### Step 1: Parse Arguments and Determine Mode

Extract the mode and content from command arguments:
- Mode: `build` (default) or `test`
- Content: Description (build mode) or jira-key (test mode)

**Examples:**
- `/story build User authentication` -> mode="build", content="User authentication"
- `/story User authentication` -> mode="build" (default), content="User authentication"
- `/story test PROJ-123` -> mode="test", content="PROJ-123"

### Step 1.5A: Parse Epic Reference (Build Mode Only)

**If build mode:** Check if description contains epic reference

**Pattern to detect:** `(from EPIC-XXX)` or `from EPIC-XXX`
**Regex:** `\(from ([A-Z][A-Z0-9]+-\d+)\)|from ([A-Z][A-Z0-9]+-\d+)`

**Processing:**
1. Search description for epic reference pattern
2. If found: Extract epic key (e.g., "EPIC-456")
3. If found: Remove epic reference from description (create clean_description)
4. If epic found: Proceed to Step 1.5B
5. If no epic: Skip to Step 2 (Build Mode - No Epic case)

**Examples:**
- `"User auth (from EPIC-456)"` -> epic_key="EPIC-456", clean_description="User auth"
- `"User auth from EPIC-456"` -> epic_key="EPIC-456", clean_description="User auth"
- `"User auth"` -> No epic, clean_description="User auth"

### Step 1.5B: Fetch Epic Data (Build Mode with Epic)

**CRITICAL: If epic was referenced in build mode, fetch it before invoking agent**

1. **Validate epic-key format:** `^[A-Z][A-Z0-9]+-[0-9]+$`
2. **Invoke the jira-cli-service skill:**
   - Use the **Skill tool**
   - Skill name: `"jira-cli-service"`
   - Args: `"view <epic-key>"`
3. **Store the epic data** returned by the skill
4. **If fetch fails:** Report error to user and DO NOT invoke agent

**Example:**
- Skill tool with skill="jira-cli-service" and args="view EPIC-456"

### Step 1.5C: Fetch Story Data (Test Mode)

**CRITICAL: If test mode, fetch the story before invoking agent**

1. **Extract jira-key** from content
2. **Validate jira-key format:** `^[A-Z][A-Z0-9]+-[0-9]+$`
3. **Invoke the jira-cli-service skill:**
   - Use the **Skill tool**
   - Skill name: `"jira-cli-service"`
   - Args: `"view <jira-key>"`
4. **Store the story data** returned by the skill
5. **If fetch fails:** Report error to user and DO NOT invoke agent

**Example:**
- Skill tool with skill="jira-cli-service" and args="view PROJ-123"

### Step 2: Invoke Agent with Pre-Fetched Data (REQUIRED)

Choose the appropriate invocation based on mode and data availability:

#### Build Mode (No Epic):
```
Task tool with:
  subagent_type: "ai-sdlc:story"
  description: "Generate user story"
  prompt: """
Mode: build
Description: <description>

Generate a new story from this description.
"""
```

#### Build Mode (With Epic):
```
Task tool with:
  subagent_type: "ai-sdlc:story"
  description: "Generate user story with epic context"
  prompt: """
Mode: build
Description: <clean_description>
Epic Key: <epic-key>

=== EPIC CONTEXT (PRE-FETCHED) ===
<paste epic JSON or formatted data from Step 1.5B>
=== END EPIC CONTEXT ===

IMPORTANT: Epic context is already fetched. DO NOT call jira-cli-service.
Generate story within this epic's context.
"""
```

#### Test Mode:
```
Task tool with:
  subagent_type: "ai-sdlc:story"
  description: "Validate user story"
  prompt: """
Mode: test
Jira Key: <jira-key>

=== STORY DATA (PRE-FETCHED) ===
<paste story JSON or formatted data from Step 1.5C>
=== END STORY DATA ===

IMPORTANT: Story data is already fetched. DO NOT call jira-cli-service.
Validate this story against DoR standards.
"""
```

### Step 3: What NOT to Do (CRITICAL)

- **DO NOT** invoke skills directly (e.g., `story-test-create`, `story-build`, `story-test-verify`)
- **DO NOT** generate the story yourself
- **DO NOT** call MCP tools directly
- **DO NOT** create Jira issues yourself
- **DO NOT** validate DoR criteria yourself
- **DO NOT** fetch story or epic again (already provided to agent)

### Step 4: Wait for Agent Results

The `ai-sdlc:story` agent will:
1. Parse pre-fetched data from prompt (if applicable)
2. **Build mode**: Generate story from description, create in Jira
3. **Test mode**: Validate against DoR using provided story data
4. Retry up to 3 times if validation fails
5. Return results with quality scores

### Step 5: Present Results to User

Once the agent completes, present its results to the user without modification.

---

## What This Command Does

Generates DoR-compliant user stories or validates existing ones:

- **Build mode** (default): Generate story using templates, create in Jira
  - Optional: Include epic context by adding `(from EPIC-XXX)` to description
- **Test mode**: Validate existing story against DoR standards

**Workflow:**

**Build Mode (No Epic):**
1. Parse description from arguments
2. Pass to story agent
3. Agent generates DoR-compliant story
4. Agent creates story in Jira

**Build Mode (With Epic):**
1. Parse description and detect epic reference
2. Fetch epic data via jira-cli-service skill
3. Pass clean description + epic context to agent
4. Agent generates story aligned with epic goals
5. Agent creates and links story to epic in Jira

**Test Mode:**
1. Parse jira-key from arguments
2. Fetch story data via jira-cli-service skill
3. Pass story data to agent
4. Agent validates against DoR standards
5. Agent posts feedback to Jira

**Story includes:**
- User story format (As a... I want... So that...)
- Acceptance criteria (testable, measurable)
- Technical approach
- DoR compliance validation
