---
name: story-test-verify
description: Verify user story meets DoR standards defined in test-create phase
allowed-tools: []
---

# Story Test Verify Skill

Validates that generated or refined user stories meet the Definition of Ready (DoR) standards defined in the test-create phase.

## When This Skill is Invoked

This skill is automatically invoked by the `story` agent during the VERIFY phase of the TDD cycle, after the story has been built.

## Purpose

Validates story against:
1. Format and structure tests
2. Acceptance criteria quality tests
3. Definition of Ready tests
4. AI-readiness tests
5. Quality scoring rubric

## Verification Process

### Step 1: Run Format Tests

```markdown
## Format Validation

- [x/☐] Story follows "As a [persona] I want [capability] So that [benefit]"
- [x/☐] Persona is specific (not "user" or "someone")
- [x/☐] Capability is actionable and clear
- [x/☐] Business value is stated
- [x/☐] Context section provides background

**Format Score:** X/5
```

### Step 2: Validate Acceptance Criteria

```markdown
## Acceptance Criteria Validation

- [x/☐] At least 3 Given/When/Then scenarios present
- [x/☐] Happy path scenario included
- [x/☐] Edge case scenario included
- [x/☐] Error handling scenario included
- [x/☐] All criteria are testable (measurable outcomes)
- [x/☐] No implementation details (behavior only)

**AC Score:** X/6

### AC Quality Assessment

**Scenario 1:** [Pass/Fail]
- Given/When/Then format: [Yes/No]
- Measurable outcome: [Yes/No]
- Testable: [Yes/No]

**Scenario 2:** [Pass/Fail]
[Same checks]

**Scenario 3:** [Pass/Fail]
[Same checks]
```

### Step 3: Check Definition of Ready

```markdown
## Definition of Ready Validation

- [x/☐] Story size: 1-3 days (Small/Medium)
- [x/☐] Dependencies identified
- [x/☐] Complexity estimated
- [x/☐] Test data requirements specified
- [x/☐] Technical approach outlined
- [x/☐] Designs available (if UI work)

**DoR Score:** X/6
```

### Step 4: Assess AI-Readiness

```markdown
## AI-Readiness Validation

- [x/☐] Context sufficient for AI understanding
- [x/☐] Technical approach clear for implementation
- [x/☐] AC specific enough to generate tests
- [x/☐] No ambiguous requirements
- [x/☐] External dependencies documented

**AI-Readiness Score:** X/5
```

### Step 5: Calculate Quality Scores

```markdown
## Quality Score Breakdown

### Completeness (20 points)
**Score:** X/20 (Threshold: 16)

All sections present and detailed:
- Story format: [x/☐]
- Context: [x/☐]
- Acceptance criteria: [x/☐]
- Technical approach: [x/☐]
- DoR checklist: [x/☐]

**Status:** [PASS/FAIL]

### Clarity (20 points)
**Score:** X/20 (Threshold: 16)

No ambiguity, crystal clear:
- Persona specific: [x/☐]
- Capability clear: [x/☐]
- Benefit stated: [x/☐]
- AC unambiguous: [x/☐]

**Status:** [PASS/FAIL]

### Testability (20 points)
**Score:** X/20 (Threshold: 16)

All AC are automatable:
- Given/When/Then format: [x/☐]
- Measurable outcomes: [x/☐]
- Behavior-focused: [x/☐]
- Specific assertions: [x/☐]

**Status:** [PASS/FAIL]

### Scoping (20 points)
**Score:** X/20 (Threshold: 16)

Appropriate size:
- Estimated 1-3 days: [x/☐]
- Single feature/flow: [x/☐]
- Manageable dependencies: [x/☐]
- Sprint-sized: [x/☐]

**Status:** [PASS/FAIL]

### AI-Readiness (20 points)
**Score:** X/20 (Threshold: 16)

AI can implement:
- Context complete: [x/☐]
- Tech approach clear: [x/☐]
- AC specific: [x/☐]
- No ambiguity: [x/☐]

**Status:** [PASS/FAIL]

---

**Total Score:** X/100
**Minimum Passing:** 80/100
**Status:** [PASS/FAIL]
```

## Output Format

Format results using the template in `templates/output.md`.

See the template file for the complete output structure and variables to populate.

### When Tests Fail (Score < 80)

```markdown
# Story Verification Results

## TESTS FAILED

**Total Score:** X/100 (Minimum: 80)
**Status:** Needs Revision

---

## Score Breakdown

| Criterion | Score | Threshold | Status |
|-----------|-------|-----------|--------|
| Completeness | X/20 | 16 | [PASS/FAIL] |
| Clarity | X/20 | 16 | [PASS/FAIL] |
| Testability | X/20 | 16 | [PASS/FAIL] |
| Scoping | X/20 | 16 | [PASS/FAIL] |
| AI-Readiness | X/20 | 16 | [PASS/FAIL] |

---

## Issues Identified

### [Failed Criterion 1]: Testability (X/20)

**Problem:** Acceptance criteria are not testable

**Examples from Story:**
> [Quote showing vague AC like "should work well"]

**Required Fix:**
Acceptance criteria must be specific and measurable:

**Current (Bad):**
```
Then the feature works well
```

**Required (Good):**
```
Then the page loads within 2 seconds
And I see "Success" message
And the data table displays 10 rows
```

**Action:** Revise AC to include specific, measurable outcomes

---

### [Failed Criterion 2]: Scoping (X/20)

**Problem:** Story scope too large (estimated > 3 days)

**Current Scope:**
- [Large item 1]
- [Large item 2]
- [Large item 3]

**Recommended Split:**
1. **Story 1:** [Smaller scope]
2. **Story 2:** [Smaller scope]
3. **Story 3:** [Smaller scope]

**Action:** Split into smaller stories or reduce scope

---

## Required Actions

To reach passing score (80/100), you must:

1. **Fix Testability (+X points):**
   - Rewrite vague AC with specific Given/When/Then
   - Add measurable outcomes to each scenario
   - Remove implementation details

2. **Fix Scoping (+X points):**
   - Reduce to single feature/flow
   - Split into 2-3 smaller stories
   - Ensure 1-3 day estimate

3. **[Other actions as needed]**

---

## Retry Status

**Current Attempt:** X of 3
**Remaining Attempts:** X

**Action:** Returning to BUILD phase with feedback...

---

**Verification Complete:** [timestamp]
**Outcome:** Requires revision
```

### When Max Retries Reached (After 3 Failed Cycles)

```markdown
# Story Verification Results

## MAX RETRIES REACHED

**Total Score:** X/100 (Minimum: 80)
**Attempts:** 3 of 3 completed
**Status:** Manual intervention required

---

## Persistent Issues

After 3 build-verify cycles, the following issues remain:

### Issue 1: [Problem Area]
- **Criterion:** [e.g., Testability]
- **Current Score:** X/20 (Need: 16)
- **Gap:** -X points
- **Blocker:** [Why this can't be automatically fixed]

### Issue 2: [Problem Area]
- **Criterion:** [e.g., Clarity]
- **Current Score:** X/20 (Need: 16)
- **Gap:** -X points
- **Blocker:** [Why this can't be automatically fixed]

---

## Escalation Required

**This story requires human review because:**

1. **[Blocker 1]:** [e.g., "Insufficient context - need product owner clarification"]
2. **[Blocker 2]:** [e.g., "Scope too large - need to decide on split approach"]
3. **[Blocker 3]:** [e.g., "Technical approach unclear - need architect input"]

**Recommended Actions:**

1. **Gather Information:**
   - Schedule meeting with [stakeholder]
   - Review [related documentation]
   - Clarify [specific question]

2. **Make Decisions:**
   - Decide on scope: [options]
   - Choose technical approach: [options]
   - Confirm acceptance criteria with [stakeholder]

3. **Alternative Approaches:**
   - Create as spike story for discovery
   - Break into research + implementation stories
   - Defer until [dependency] is resolved

---

**Best Partial Story Saved:** [Location]
**Score:** X/100
**Usable Sections:** [List what passed]

---

**Verification Complete:** [timestamp]
**Escalation:** Manual review required
**Next Step:** Human intervention needed before proceeding
```

## Integration

This skill is the third step in the story TDD cycle:
1. **story-test-create** - Define validation criteria
2. **story-build** - Generate or refine story
3. **story-test-verify** (this skill) - Validate against criteria

**If verification fails:** Agent loops back to step 2 (build) with specific feedback
**Maximum loops:** 3 cycles, then escalate to user with detailed blockers

## Verification Principles

### Be Specific
Provide exact examples of what's wrong and how to fix it

### Be Actionable
Every failure includes concrete next steps to address the issue

### Be Educational
Explain WHY something fails to teach best practices

### Be Helpful
Show both bad and good examples for each issue

---

This skill ensures only high-quality, DoR-compliant stories are accepted, maintaining standards for AI-assisted development.
