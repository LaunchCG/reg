---
name: nexus-methodology
description: Launch Consulting Nexus AI-SDLC methodology - Director/Verifier model with DoR, TDD, and DoD quality gates
---

# Nexus AI-SDLC Methodology

Launch Consulting's structured approach to AI-augmented software delivery.

## Overview

Nexus AI-SDLC combines proven software engineering practices with AI capabilities to accelerate delivery while maintaining quality. It implements a **Director/Verifier model** where humans direct and verify, while AI executes.

## Core Philosophy

### Director/Verifier Model

**Humans Direct**: Define requirements, make architectural decisions, set priorities
**AI Executes**: Implement features using TDD, write tests and documentation, calculate metrics
**Humans Verify**: Review PRs, validate business logic, approve merges

## The Framework

### 1. Definition of Ready (DoR)
Stories must be ready before development begins:
- Clear user story format (As a... I want... So that...)
- Testable acceptance criteria (Given/When/Then)
- Appropriate size (1-3 days of work)
- Dependencies identified
- Technical approach understood

### 2. Test-Driven Development (TDD)
All features implemented using RED-GREEN-REFACTOR cycle:
- **RED**: Write failing tests from acceptance criteria
- **GREEN**: Write minimal code to pass tests
- **REFACTOR**: Clean up code while keeping tests passing

### 3. Definition of Done (DoD)
Work must be complete before PR merge:
- Tests for all acceptance criteria
- All tests passing
- Code refactored
- Documentation updated
- No security issues
- Commits include work item ID

### 4. Continuous Improvement
- Track DORA metrics (deployment frequency, lead time, MTTR, CFR)
- Track flow metrics (cycle time, throughput, WIP)
- Track quality metrics (test coverage, DoR/DoD compliance)
- Weekly, monthly, quarterly review cadence

## Metrics and Benchmarks

### DORA Metrics
| Metric | Elite | High | Medium | Low |
|--------|-------|------|--------|-----|
| Deployment Frequency | Multiple/day | Daily-weekly | Weekly-monthly | Monthly+ |
| Lead Time | <1 hour | 1 day-1 week | 1 week-1 month | 1 month+ |
| MTTR | <1 hour | <1 day | 1 day-1 week | 1 week+ |
| Change Failure Rate | 0-15% | 16-30% | 31-45% | 46%+ |

## Getting Started

### Week 1: Foundation - Review methodology, set up agents, define DoR/DoD
### Week 2-3: Pilot - Select 2-3 stories, use TDD, gather feedback
### Week 4: Expand - Full team, first DORA assessment, establish baseline
### Quarter 1: Mature - Run quarterly assessment, compare to baseline
