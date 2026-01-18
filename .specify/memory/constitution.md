<!--
Sync Impact Report
- Version change: N/A → 0.1.0
- Modified principles: Initial set (I–V)
- Added sections: Product Boundaries & Content Rules; Development Workflow & Quality Gates
- Removed sections: None
- Templates requiring updates: ✅ .specify/templates/plan-template.md; ✅ .specify/templates/spec-template.md; ✅ .specify/templates/tasks-template.md
- Follow-up TODOs: TODO(RATIFICATION_DATE): original adoption date unknown
-->
# Let It Be Constitution

## Core Principles

### I. User Compassion & Non-Judgment
Content and UX MUST avoid guilt, shame, or forced positivity. Copy MUST avoid
imperative "you should" language, promises of outcomes, or comparisons to others.

### II. Single-Purpose Minimalism
The product MUST focus on emotional buffering and low-effort recovery. No social
features, gamification, goal tracking, or engagement traps are allowed.

### III. Test-Driven Development (NON-NEGOTIABLE)
All behavior changes MUST be implemented via TDD: write the failing test first,
confirm it fails, then implement, then refactor. Every user story MUST have
automated tests that cover the acceptance scenarios.

### IV. Privacy & Local-First
The app MUST work without accounts and remain usable offline. No emotional
telemetry, behavioral tracking, or user profiling is permitted.

### V. Simple, Explicit Code Quality
Prefer the smallest viable design, avoid speculative abstractions, and keep
data structures straightforward. Code MUST be readable, tested, and reviewed
against this constitution.

## Product Boundaries & Content Rules

- The product MUST NOT provide diagnosis or replace professional care.
- The product MUST NOT introduce social/community or competitive mechanics.
- Content MUST avoid commands, promises, comparisons, and guilt framing.
- State selection and cards MUST remain low-friction and short-form.

## Development Workflow & Quality Gates

- Every change MUST include tests created before implementation.
- Features MUST ship with acceptance scenarios mapped to automated tests.
- Content changes MUST be reviewed against Principle I and Product Boundaries.
- Local-first and privacy constraints MUST be validated during review.

## Governance
<!-- Example: Constitution supersedes all other practices; Amendments require documentation, approval, migration plan -->

- Amendments require updating this constitution and the Sync Impact Report,
  plus explicit approval from the project maintainer.
- Versioning follows semantic versioning: MAJOR for breaking governance changes,
  MINOR for new principles or materially expanded guidance, PATCH for clarifications.
- Every plan/spec/tasks document MUST include a Constitution Check and confirm
  compliance before implementation.

**Version**: 0.1.0 | **Ratified**: TODO(RATIFICATION_DATE): original adoption date unknown | **Last Amended**: 2026-01-17
