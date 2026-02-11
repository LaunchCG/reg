---
name: dor-validation
description: Validates work items meet Definition of Ready criteria before sprint planning or development begins
allowed-tools: mcp__azure-devops__*
mcpServers:
  - azure-devops
---

# Definition of Ready Validation Skill

This skill validates that user stories meet Definition of Ready (DoR) criteria before they enter sprint planning or development. It ensures work items are adequately prepared for implementation.

## When This Skill is Invoked

This skill will be used when you mention:
- "definition of ready"
- "DoR validation"
- "story readiness"
- "sprint planning prep"
- "backlog readiness"

## Definition of Ready Criteria

A story is **ready for development** when it meets ALL of these criteria:

### 1. Story Structure ✅
- [ ] Follows "As a [persona], I want [capability], so that [benefit]" format
- [ ] Persona is specific (not generic "user")
- [ ] Capability is clear and actionable
- [ ] Business value/benefit is explicit

### 2. Acceptance Criteria ✅
- [ ] At least 2-3 specific, testable criteria
- [ ] Uses Given/When/Then format OR clear checklist
- [ ] Covers happy path scenario
- [ ] Includes error handling/edge cases
- [ ] All criteria are measurable

### 3. Story Size ✅
- [ ] Estimated at 1-3 days of work (small to medium)
- [ ] Can be completed within a single sprint
- [ ] Not too complex for one person to understand
- [ ] Clear scope boundaries

### 4. Dependencies ✅
- [ ] External dependencies identified and documented
- [ ] Blocking dependencies resolved or planned
- [ ] Required APIs/services available
- [ ] No circular dependencies with other stories

### 5. Technical Context ✅
- [ ] Technical approach understood
- [ ] Architecture/design decisions made
- [ ] Required technologies/frameworks identified
- [ ] Performance requirements specified (if applicable)

### 6. Supporting Materials ✅
- [ ] Mockups/designs available (for UI changes)
- [ ] API contracts defined (for integration work)
- [ ] Test data requirements specified
- [ ] Business rules documented

## How to Use This Skill

**Step 1: Fetch Story from Jira**
```python
# Get story details
story = atlassian_jira_get_issue(
    issue_key="PROJ-123",
    expand=["links", "subtasks"],
    fields=["summary", "description", "acceptance_criteria", "customfield_10016", "labels", "components"]
)
```

**Step 2: Validate DoR Criteria**
```python
import sys
sys.path.append('/path/to/skills/dor-validation')
from validator import DoRValidator

validator = DoRValidator()

# Check each DoR criterion
structure_check = validator.validate_story_structure(story)
ac_check = validator.validate_acceptance_criteria(story)
size_check = validator.validate_story_size(story)
dependency_check = validator.validate_dependencies(story)
technical_check = validator.validate_technical_context(story)
materials_check = validator.validate_supporting_materials(story)

# Overall assessment
dor_result = validator.overall_assessment([
    structure_check, ac_check, size_check,
    dependency_check, technical_check, materials_check
])
```

## Validation Examples

### ✅ READY Story Example

**PROJ-123: Export Customer Health Scores**

```
As a customer success manager
I want to export customer health scores to CSV
So that I can analyze trends in Excel and create reports for leadership

Background:
CSM team currently screenshots health score dashboards, which is manual 
and error-prone. They need structured data for monthly trend analysis.

Acceptance Criteria:
1. Given I'm on the Customer Dashboard
   When I click "Export to CSV" 
   Then a CSV file downloads with customer_id, name, health_score, last_contact_date

2. Given there are no customers in the current view
   When I click "Export to CSV"
   Then I see message "No data to export"

3. Given the export service is unavailable  
   When I click "Export to CSV"
   Then I see error "Export failed, please try again later"

Technical Notes:
- Use existing customer health API endpoint
- CSV format per RFC 4180 standard
- Max 10,000 rows per export (current customer limit is 8,500)
- 30-second timeout for large exports

Dependencies:
- Customer health API (already available)
- File download service (ready)

Designs:
- Export button mockup: [Link to Figma]
- Error message patterns: [Link to design system]

Estimation: 3 story points (2-3 days)
```

**DoR Assessment: ✅ READY**
- ✅ Clear user story format with specific persona
- ✅ 3 specific, testable acceptance criteria  
- ✅ Appropriate size (2-3 days)
- ✅ Dependencies identified and available
- ✅ Technical approach documented
- ✅ Designs linked and available

### ❌ NOT READY Story Example

**PROJ-124: Improve User Experience**

```
As a user
I want the app to be better
So that it's easier to use

Description: Users are complaining that the app is slow and confusing.
We need to make it faster and more intuitive.

Acceptance Criteria:
- App should be fast
- Users should be happy
- Make it more user-friendly
```

**DoR Assessment: ❌ NOT READY**
- ❌ Generic "user" persona (not specific)
- ❌ Vague capability ("be better")
- ❌ Non-measurable acceptance criteria
- ❌ No size estimate (unclear scope)
- ❌ No technical approach defined
- ❌ Missing supporting materials

**Required Before Ready:**
1. Define specific user persona (e.g., "new customer")
2. Specify exact improvements (e.g., "reduce load time to <2 seconds")
3. Create measurable acceptance criteria with specific metrics
4. Break down into smaller, implementable stories
5. Conduct UX research to define "user-friendly"

## Batch Validation

For multiple stories (e.g., sprint backlog), provide summary:

```
DoR Validation - Sprint 46 Candidates (8 stories)

✅ READY: 5 stories (63%)
- PROJ-123: Export Customer Health Scores
- PROJ-125: Add Password Reset Link
- PROJ-127: Fix Mobile Navigation Bug
- PROJ-129: Update Terms of Service Page  
- PROJ-131: Integrate Payment Gateway

❌ NOT READY: 3 stories (37%)
- PROJ-124: Improve User Experience (vague scope)
- PROJ-126: Optimize Database Performance (no specific metrics)
- PROJ-128: Add Social Login (missing design specs)

Sprint Planning Recommendation:
- Proceed with 5 ready stories (estimated 18 points)
- Block 3 stories until DoR criteria met
- Need backlog refinement for blocked stories

Next Actions:
1. Schedule refinement session for PROJ-124, 126, 128
2. Product owner to define UX metrics for PROJ-124
3. DevOps to provide performance targets for PROJ-126
4. Design team to complete social login specs for PROJ-128
```

## Integration with Workflow

### Before Sprint Planning
1. Run DoR validation on candidate stories
2. Block non-ready stories from sprint commitment
3. Schedule refinement for blocked stories

### During Backlog Refinement  
1. Use DoR criteria as checklist
2. Identify missing information
3. Assign action items to complete DoR

### Before Story Development
1. Final DoR check before picking up story
2. Verify all supporting materials accessible
3. Confirm dependencies still valid

## Quick DoR Checklist

Use this checklist during refinement:

```markdown
## DoR Checklist for [STORY-KEY]

### Story Structure
- [ ] Specific persona (not "user")
- [ ] Clear capability described
- [ ] Business value explained

### Acceptance Criteria  
- [ ] 2-3 specific, testable criteria
- [ ] Given/When/Then format
- [ ] Covers success + error cases
- [ ] All measurable outcomes

### Size & Scope
- [ ] 1-3 day effort estimate
- [ ] Fits in one sprint
- [ ] Clear boundaries

### Dependencies
- [ ] External deps identified
- [ ] Blocking deps resolved
- [ ] APIs/services ready

### Technical Context
- [ ] Implementation approach clear
- [ ] Tech decisions made
- [ ] Performance criteria set

### Supporting Materials
- [ ] Designs ready (UI work)
- [ ] API specs defined
- [ ] Test data identified

**Overall: [ ] READY FOR DEVELOPMENT**
```

## Error Handling

- **Story Not Found:** Verify Jira key and permissions
- **Missing Fields:** Note which custom fields are unavailable
- **Incomplete Data:** Identify specific gaps requiring refinement
- **Dependency Issues:** Flag external blockers needing escalation

---

This skill ensures only well-prepared stories enter development, reducing rework and improving sprint success rates.