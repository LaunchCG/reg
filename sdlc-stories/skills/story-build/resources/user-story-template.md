# User Story Template

## Variables

- `{{STORY_TITLE}}` - Descriptive title for the story
- `{{STORY_ID}}` - Jira key (e.g., PROJ-123) or TBD
- `{{STORY_TYPE}}` - Feature | Bug | Technical | Spike
- `{{STORY_STATUS}}` - Ready for Development | Draft
- `{{PERSONA}}` - Specific user persona (not "user")
- `{{CAPABILITY}}` - What the user wants to do
- `{{BENEFIT}}` - Business value or outcome
- `{{CONTEXT}}` - Background information
- `{{SCENARIO_1_TITLE}}` - Happy path title
- `{{SCENARIO_1_GIVEN}}` - Initial context/state
- `{{SCENARIO_1_WHEN}}` - Action taken
- `{{SCENARIO_1_THEN}}` - Expected outcome
- `{{SCENARIO_2_TITLE}}` - Edge case title
- `{{SCENARIO_2_GIVEN}}` - Edge case context
- `{{SCENARIO_2_WHEN}}` - Edge case action
- `{{SCENARIO_2_THEN}}` - Edge case outcome
- `{{SCENARIO_3_TITLE}}` - Error handling title
- `{{SCENARIO_3_GIVEN}}` - Error condition
- `{{SCENARIO_3_WHEN}}` - Error trigger
- `{{SCENARIO_3_THEN}}` - Error handling behavior
- `{{TECHNICAL_APPROACH}}` - High-level implementation strategy
- `{{COMPONENTS}}` - List of affected components
- `{{DEPENDENCIES}}` - External systems or other stories
- `{{TEST_DATA}}` - Test data requirements
- `{{SIZE}}` - Small | Medium
- `{{EFFORT}}` - Estimated days (1-3)
- `{{NOTES}}` - Additional context
- `{{TIMESTAMP}}` - Creation timestamp

---

## Story Template

```markdown
# User Story: {{STORY_TITLE}}

**ID:** {{STORY_ID}}
**Type:** {{STORY_TYPE}}
**Status:** {{STORY_STATUS}}

---

## Story

**As a** {{PERSONA}}
**I want** {{CAPABILITY}}
**So that** {{BENEFIT}}

---

## Context

{{CONTEXT}}

---

## Acceptance Criteria

### Scenario 1: {{SCENARIO_1_TITLE}}
**Given** {{SCENARIO_1_GIVEN}}
**When** {{SCENARIO_1_WHEN}}
**Then** {{SCENARIO_1_THEN}}

### Scenario 2: {{SCENARIO_2_TITLE}}
**Given** {{SCENARIO_2_GIVEN}}
**When** {{SCENARIO_2_WHEN}}
**Then** {{SCENARIO_2_THEN}}

### Scenario 3: {{SCENARIO_3_TITLE}}
**Given** {{SCENARIO_3_GIVEN}}
**When** {{SCENARIO_3_WHEN}}
**Then** {{SCENARIO_3_THEN}}

---

## Technical Approach

{{TECHNICAL_APPROACH}}

**Components Affected:**
{{COMPONENTS}}

**Dependencies:**
{{DEPENDENCIES}}

**Test Data Requirements:**
{{TEST_DATA}}

---

## Definition of Ready Checklist

- [ ] Story follows standard format
- [ ] User persona is specific
- [ ] Acceptance criteria are testable
- [ ] At least 3 scenarios (happy, edge, error)
- [ ] Dependencies identified
- [ ] Complexity estimated
- [ ] Technical approach outlined
- [ ] Test data requirements specified
- [ ] Sized appropriately (1-3 days)

---

## Estimated Complexity

**Size:** {{SIZE}}
**Estimated Effort:** {{EFFORT}}

---

## Notes

{{NOTES}}

---

**Created:** {{TIMESTAMP}}
**Version:** 1.0
**Ready for Development:** {{READY_STATUS}}
```

---

## Quality Criteria

### Good Acceptance Criteria Examples

**Testable and Specific:**
```
Given I am on the user profile page
When I click "Upload Photo" and select a 2MB PNG file
Then the photo uploads successfully within 5 seconds
And I see a success message "Photo updated"
And the new photo displays in the profile avatar
```

### Bad Acceptance Criteria Examples

**Vague and Not Testable:**
```
The photo upload should work
Users should be able to upload photos
The system should be fast
```

---

## Scoping Guidelines

| Size | Description | Action |
|------|-------------|--------|
| Too Large (>3 days) | Multiple distinct user flows | Split into smaller stories |
| Good (1-3 days) | Single user flow, clear scope | Keep as-is |
| Too Small (<1 day) | Trivial change | Combine with related work |

**Note:** A single feature that touches backend, frontend, and database should remain ONE story so it can be evaluated in a single PR.
