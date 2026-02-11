---
name: story-build
description: Generate or refine user stories with complete acceptance criteria and DoR compliance
allowed-tools: Bash
---

# Story Build Skill

Generates well-structured, AI-ready user stories with comprehensive acceptance criteria following Definition of Ready standards.

**Data Source:** This skill receives story data from the invoking agent. The agent is responsible for fetching Jira data (if needed) and providing it to this skill.

## When This Skill is Invoked

This skill is automatically invoked by the `story` agent during the BUILD phase of the TDD cycle, after tests have been created.

## Purpose

Creates or refines user stories that are:
1. Properly formatted (As a... I want... So that...)
2. Have testable acceptance criteria (Given/When/Then)
3. Meet Definition of Ready standards
4. Are AI-ready for implementation

## Story Generation Process

### Step 1: Parse Input

The agent provides story data in one of two formats:

**If Existing Story (from Jira):**
- Agent has already fetched story data using jira-cli-service
- Parse the provided story JSON
- Extract current content (summary, description, acceptance criteria)
- Identify what needs refinement

**If Natural Language Description:**
- Agent provides a text description
- Extract user persona from description
- Identify capability needed
- Determine business value
- Infer context from description

### Step 2: Generate Story Structure

Select the appropriate template based on story type:

| Story Type | Template File | When to Use |
|------------|---------------|-------------|
| Feature | `templates/user-story.md` | New functionality, user-facing features |
| Bug | `templates/bug-story.md` | Defects, broken functionality |
| Technical | `templates/technical-story.md` | Refactoring, infrastructure, tech debt, spikes |

**Template Selection Rules:**
- **Feature stories:** Use `user-story.md` - includes full Given/When/Then AC with 3+ scenarios
- **Bug stories:** Use `bug-story.md` - includes reproduction steps, severity, and regression checks
- **Technical stories:** Use `technical-story.md` - includes success metrics and rollback considerations

See each template file for:
- Complete structure with all required sections
- Variable definitions for dynamic content
- Quality criteria and examples
- Scoping guidelines

### Step 3: Generate Quality Acceptance Criteria

**Principles for Good AC:**

1. **Use Given/When/Then format consistently**
2. **Be specific about measurable outcomes**
3. **Focus on behavior, not implementation**
4. **Cover happy path, edge cases, and error handling**
5. **Ensure each scenario is testable**

**Examples:**

**Good AC (Testable, Specific):**
```
Given I am on the user profile page
When I click "Upload Photo" and select a 2MB PNG file
Then the photo uploads successfully within 5 seconds
And I see a success message "Photo updated"
And the new photo displays in the profile avatar
```

**Bad AC (Vague, Not Testable):**
```
The photo upload should work
Users should be able to upload photos
The system should be fast
```

### Step 4: Validate Scoping

Ensure story is appropriately sized:

**Too Large (Split Required):**
- Story involves multiple distinct user flows (not just multiple technical layers)
- Estimated > 3 days for a single feature
- Many dependencies on external systems
- **Action:** Suggest splitting into smaller stories
- **Note:** A single feature that touches backend, frontend, and database should remain ONE story so it can be evaluated in a single PR

**Good Size (1-3 days):**
- Single user flow or feature (even if it spans multiple technical layers)
- Clear scope
- Manageable dependencies
- Can be completed in one sprint
- Backend, frontend, and database changes for the same feature are kept together

**Too Small (Combine with others):**
- < 1 day of work
- Trivial change
- **Action:** Suggest combining with related work

## Output Format

Format results using the template in `templates/output.md`.

See the template file for the complete output structure and variables to populate.

## Special Cases

### Bug Stories

Use the `templates/bug-story.md` template for bug stories.

**Key sections:**
- Severity rating (Critical/High/Medium/Low)
- Steps to reproduce with expected vs actual behavior
- Fix verification AC
- Regression check AC

### Technical Stories

Use the `templates/technical-story.md` template for technical work.

**Categories:**
- **Refactoring:** Improving code structure without changing behavior
- **Infrastructure:** Deployment, CI/CD, hosting changes
- **Tech Debt:** Fixing shortcuts or outdated patterns
- **Spike:** Research or proof of concept (time-boxed)

**Key sections:**
- Technical context explaining why work is needed
- Detailed implementation approach
- Success metrics (performance, reliability)
- Rollback considerations

## Integration

This skill is the second step in the story TDD cycle:
1. **story-test-create** - Define validation criteria
2. **story-build** (this skill) - Generate or refine story
3. **story-test-verify** - Validate against criteria

## Error Handling

### Cannot Determine User Persona
```markdown
**Error:** Unable to identify specific user persona

**Problem:** The description is too generic (e.g., "users want a feature")

**Required:** Specific user type, such as:
- "customer success managers"
- "end customers"
- "system administrators"
- "mobile app users"

**Action:** Please specify who needs this capability
```

### Scope Too Large
```markdown
**Warning:** Story scope exceeds 3 days

**Estimated Scope:** [X days]

**Recommendation:** Split into smaller stories:
1. [Story 1 - Small scope]
2. [Story 2 - Small scope]
3. [Story 3 - Small scope]

**Action:** Should I generate split stories?
```

### Acceptance Criteria Not Testable
```markdown
**Warning:** Some AC are not testable

**Examples:**
- "The system should be fast" (not measurable)
- "Users should be happy" (not testable)

**Fixed Examples:**
- "Page load completes within 2 seconds"
- "User sees success message and new data appears"

**Action:** Revising AC to be testable...
```

---

This skill generates high-quality, DoR-compliant user stories that are ready for AI-assisted development.
