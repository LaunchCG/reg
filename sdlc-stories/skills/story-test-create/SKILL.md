---
name: story-test-create
description: Create TDD validation tests for user stories to ensure Definition of Ready compliance
allowed-tools: Bash
---

# Story Test Create Skill

Generates TDD-style validation tests for user stories to ensure they meet Definition of Ready (DoR) standards and are AI-ready for development.

**Data Source:** This skill receives story data from the invoking agent. The agent is responsible for fetching Jira data (if needed) and providing it to this skill.

## When This Skill is Invoked

This skill is automatically invoked by the `story` agent at the start of the TDD cycle to create validation criteria for user stories.

## Purpose

Creates test criteria to validate:
1. Story structure and format
2. Acceptance criteria quality
3. Definition of Ready compliance
4. AI-readiness for development
5. Testability

## Test Categories

### 1. Structure Tests
- [ ] Story follows "As a... I want... So that..." format
- [ ] User persona is specific (not generic)
- [ ] Capability is clear and actionable
- [ ] Business value/benefit is stated
- [ ] Context section provides background
- [ ] Technical approach is outlined

### 2. Acceptance Criteria Tests
- [ ] At least 3 Given/When/Then scenarios present
- [ ] Happy path scenario included
- [ ] Edge case scenario included
- [ ] Error handling scenario included
- [ ] All criteria are testable (measurable outcomes)
- [ ] No implementation details in AC (behavior only)

### 3. Definition of Ready Tests
- [ ] Story is sized appropriately (1-3 days)
- [ ] Dependencies are identified
- [ ] Estimated complexity provided
- [ ] Test data requirements specified
- [ ] Designs/mockups available (if UI work)
- [ ] Technical feasibility confirmed

### 4. AI-Readiness Tests
- [ ] Sufficient context for AI to understand
- [ ] Technical approach clear enough for implementation
- [ ] Acceptance criteria specific enough to generate tests
- [ ] No ambiguous requirements
- [ ] External dependencies documented

### 5. Quality Tests
- [ ] Completeness score >= 16/20
- [ ] Clarity score >= 16/20
- [ ] Testability score >= 16/20
- [ ] Overall DoR score >= 80/100

## Test Generation Process

### Step 1: Analyze Input

**If input is Jira key:**
- Fetch story from Jira using appropriate backend
- Extract existing content
- Identify gaps in current story

**Jira Fetch - REST API Backend (Headless):**
```bash
# Check for REST API mode
if [ -n "$JIRA_API_TOKEN" ] || [ -n "$JIRA_PASSWORD" ]; then
  # Build authentication header
  if [ -n "$JIRA_API_TOKEN" ]; then
    AUTH=$(echo -n "${JIRA_EMAIL}:${JIRA_API_TOKEN}" | base64)
  else
    AUTH=$(echo -n "${JIRA_USERNAME}:${JIRA_PASSWORD}" | base64)
  fi

  # Fetch issue
  curl -s -X GET \
    "${JIRA_BASE_URL}/rest/api/3/issue/PROJ-123?fields=summary,description,customfield_10016,labels,status" \
    -H "Authorization: Basic ${AUTH}" \
    -H "Content-Type: application/json"
fi
```

**If input is natural language description:**
- Parse for user, capability, and benefit
- Identify what type of story (feature/bug/technical)
- Determine scope and complexity

### Step 2: Create Validation Checklist

```markdown
## Story Validation Tests

### Format Tests
- [ ] Story Structure: Follows "As a... I want... So that..." format
- [ ] Persona: Specific user type identified (not "user" or "someone")
- [ ] Capability: Clear action or feature described
- [ ] Benefit: Business value or outcome stated
- [ ] Context: Background information provided

### Acceptance Criteria Tests
- [ ] Scenario Count: At least 3 Given/When/Then scenarios
- [ ] Happy Path: Normal flow covered
- [ ] Edge Cases: Boundary conditions addressed
- [ ] Error Handling: Failure modes specified
- [ ] Testability: All criteria can be automated
- [ ] Behavior Focus: No implementation details

### Definition of Ready Tests
- [ ] Size: Story is 1-3 days of work (small/medium)
- [ ] Dependencies: External dependencies listed
- [ ] Estimation: Complexity or points estimated
- [ ] Test Data: Requirements for test data specified
- [ ] Technical Approach: Implementation path clear
- [ ] Mockups: Designs available (if UI changes)

### AI-Readiness Tests
- [ ] Context Completeness: AI can understand requirements
- [ ] Technical Clarity: Implementation approach is clear
- [ ] AC Specificity: Can generate tests from criteria
- [ ] Ambiguity Check: No vague or unclear requirements
- [ ] Dependencies Documented: External systems identified
```

### Step 3: Define Quality Scoring

```markdown
## Quality Scoring Rubric

### Completeness (20 points)
- 20: All sections complete, comprehensive detail
- 15: Most sections complete, adequate detail
- 10: Several sections missing or incomplete
- 5: Minimal information provided

**Passing: >= 16/20**

### Clarity (20 points)
- 20: Crystal clear, no ambiguity
- 15: Mostly clear, minor ambiguities
- 10: Several unclear areas
- 5: Vague or confusing

**Passing: >= 16/20**

### Testability (20 points)
- 20: All AC testable, specific outcomes defined
- 15: Most AC testable, some vague
- 10: Several AC not testable
- 5: AC are implementation-focused, not testable

**Passing: >= 16/20**

### Scoping (20 points)
- 20: Perfect size (1-3 days), well-scoped
- 15: Slightly large but manageable
- 10: Too large, should split
- 5: Way too large or poorly scoped

**Passing: >= 16/20**

### AI-Readiness (20 points)
- 20: AI can implement with high confidence
- 15: AI can implement with clarifying questions
- 10: AI needs significant guidance
- 5: AI cannot implement without major clarification

**Passing: >= 16/20**

**Total Minimum Passing Score: 80/100**
```

### Step 4: Create Example Scenarios

Provide examples of good vs. bad for each test:

**Good Story Format:**
```
As a customer success manager
I want to export customer health scores to CSV
So that I can analyze trends in spreadsheet tools
```

**Bad Story Format:**
```
As a user
I want the export feature
So that it works
```

**Good Acceptance Criteria:**
```
Given I am on the customer dashboard
When I click "Export to CSV"
Then a CSV file downloads with columns: customer_id, health_score, last_updated
```

**Bad Acceptance Criteria:**
```
The export button should work and create a file
```

## Output Format

Format results using the template in `templates/output.md`.

See the template file for the complete output structure and variables to populate.

## Integration

This skill is the first step in the story TDD cycle:
1. **story-test-create** (this skill) - Define validation criteria
2. **story-build** - Generate or refine story
3. **story-test-verify** - Validate against criteria

## Error Handling

### Insufficient Input
```markdown
**Error:** Cannot create validation tests - input too vague

**Required:** Either:
- Jira story key (PROJ-123) with populated content
- Detailed feature description with user, capability, and benefit

**Received:** [what was provided]

**Action:** Please provide:
- WHO needs this (specific persona)
- WHAT they need (specific capability)
- WHY they need it (business value)
```

### Jira Story Not Found
```markdown
**Error:** Story [KEY] not found in Jira

**Possible causes:**
- Story key typo
- No access permissions
- Story exists in different project

**Action:** Verify story key and Jira permissions
```

---

This skill ensures user stories are validated against DoR standards before generation/refinement, following TDD principles.
