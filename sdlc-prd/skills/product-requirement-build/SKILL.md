---
name: product-requirement-build
description: Generate comprehensive product requirement documents (PRDs) following evidence-based product management principles using the unified product-requirement-build.md template
allowed-tools: []
---

# Product Requirement Build Skill

Generates comprehensive Product Requirement Documents (PRDs) following evidence-based product management principles using the unified product-requirement-build.md template.

## When This Skill is Invoked

This skill is automatically invoked by the `product-requirement` agent during BUILD mode when a user provides natural language input.

## Core Philosophy

### 1. Focus on the Problem, Not the Solution
- PRDs start with problem exploration
- Multiple solution hypotheses considered
- Evidence validates assumptions

### 2. Validate Before You Build
- Discovery activities included
- Risk assessment across 4 dimensions
- Validation plans defined

### 3. Outcome Over Output
- Success measured by business results
- Metrics tied to customer outcomes
- Not just "shipped feature X"

### 4. Continuous Discovery
- Interactive questioning to uncover assumptions
- Iterative refinement based on evidence
- Post-launch learning loops

## PRD Generation Process

### Step 1: Parse Natural Language Input

**Extract key elements:**
- What customer problem is described?
- What evidence is provided (if any)?
- What solution is mentioned (if any)?
- What context or constraints are given?

### Step 2: Apply Unified Template

**Use product-requirement-build.md template** which includes:

1. **Problem Statement** - Describe problem, evidence, and impact
2. **Opportunity** - Why now, business impact, strategic alignment
3. **Solution Approach** - Proposed solution, features, UX, technical approach
4. **Success Metrics** - Primary and secondary metrics, measurement approach
5. **Risk Assessment** - Value, Usability, Feasibility, Viability risks
6. **Critical Questions** - Information gaps and next steps
7. **Implementation Plan** - Phases, timeline, dependencies
8. **Next Steps** - Immediate actions and decision criteria

### Step 3: Populate All Sections

**Make good faith effort to fill every section:**
- Use information provided in natural language input
- Make reasonable inferences where appropriate
- Note assumptions explicitly
- Leave sections minimal if no information available

### Step 4: Identify Information Gaps

**Populate Critical Questions section with:**
- Questions about the problem (validation needed)
- Questions about the solution (technical unknowns)
- Questions about success (metrics, baselines)
- Specific next steps to answer questions

## Output Format

Return complete PRD using the product-requirement-build.md template structure:

```markdown
# Product Requirements: [Feature Name]

**Created:** [Date]
**Status:** Draft

---

## Problem Statement

### The Problem
[Describe the customer problem based on input]

### Evidence
[List any evidence provided or note gaps]

### Impact
[Who is affected and how severely]

---

## Opportunity

### Why Now?
[Context for timing]

### Business Impact
[Metrics and targets]

### Strategic Alignment
[How this fits strategy]

---

## Solution Approach

[Continue with all template sections...]

---

## Critical Questions

> **Purpose:** Identify information gaps that need answers.

### About the Problem
[List specific questions about problem validation]

### About the Solution
[List questions about technical feasibility and approach]

### About Success
[List questions about metrics and measurement]

### Next Steps to Answer These Questions
1. [Specific discovery activity]
2. [Research needed]
3. [Stakeholder conversations]

---

## Next Steps
[Immediate actions and decision criteria]

---

**Document Version:** 1.0
**Last Updated:** [Date]
```

## Integration

This skill is invoked by the `product-requirement` agent in BUILD mode:
- **Input:** Natural language feature description
- **Processing:** Apply product-requirement-build.md template
- **Output:** Complete PRD with Critical Questions section
- **Next:** User reviews PRD, answers critical questions, creates Epic in Jira

## Coaching Principles

Throughout generation, apply evidence-based product management coaching:

**If solution-first detected:**
> I notice we're jumping to solutions. Let's explore the problem first:
> - What's the customer pain point?
> - What evidence supports this?
> - Are there other ways to solve this?

**If metrics are output-focused:**
> These measure what we ship, not what changes. Let's reframe:
> - Instead of "Launch feature X" → "Increase [metric] by Y%"
> - What customer/business result are we trying to achieve?

**If no evidence:**
> We need evidence to validate this is worth building:
> - Customer interviews
> - Usage data
> - Market research
> What evidence can we gather?

---

This skill generates high-quality, evidence-based PRDs following a discovery-first philosophy.
