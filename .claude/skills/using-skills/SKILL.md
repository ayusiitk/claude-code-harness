---
name: using-skills
description: Use when starting any request that changes code, behavior, configuration, or docs, before exploring the codebase or asking clarifying questions. Establishes how much process the task needs.
---

# Using Skills

1. **Understand the repository before choosing a workflow.**
2. **Use the minimum process that makes the change safe.**
3. **Escalate when complexity or risk warrants it.**
4. **Never claim completion without evidence.**

## 1. Inspect the repository

Read enough to know what architecture exists, what conventions are in force,
how tests are structured, and which commands are authoritative
(`docs/agents/toolchain.md`).

## 2. Classify

| Class | Looks like | Process |
|---|---|---|
| TRIVIAL | typo, docs, mechanical rename | edit, verify |
| SMALL | isolated change to code already here | test, implement, verify |
| NORMAL | feature or bug fix | + brief design, + review |
| LARGE | subsystem, cross-cutting, interface-changing | + brainstorm, spec, plan |

**RISKY is an orthogonal overlay, not a fifth class.** It applies at any size,
when the change alters user-, security-, data-, or externally-observable
behavior: auth, payments, migrations, destructive operations.

**REQUIRED SUB-SKILL for the overlay:** Use high-risk-changes

Edge cases and worked examples:
[classification.md](references/classification.md)

## 3. Contract

Before writing any test or implementation, emit this block. **Always** emit it,
including when every line is settled. It is a few lines, not a planning
exercise.

```
Contract
| Decision | Source |
|---|---|
| accepted inputs          | REQUEST     |
| invalid input behavior   | UNRESOLVED  |
| normalization            | REPOSITORY  |
```

One row per externally observable decision you are about to encode. Sources:

- **REQUEST** — the user stated it
- **REPOSITORY** — an existing caller, test, spec or convention settles it
- **UNRESOLVED** — neither

**Any UNRESOLVED row: ask one focused question and stop.**

These are not sources. A row resting on any of them is UNRESOLVED:

- the function or parameter name
- a common convention, or what a well-designed API would plausibly do
- your own earlier implementation in this session
- a default you chose, whether or not you announce it

When the change alters no observable behavior, the whole block is one line:
`Contract: no observable behavior changes.`

**Classification chooses the workflow. It does not authorize implementation.**

What counts as externally observable, and which decisions are yours:
[contract-decisions.md](references/contract-decisions.md)

## 4. Select the workflow and execute

Say the class in one terse line, `<CLASS>[ + RISKY]: <why>`, plus any
**implementation** default you took. Never a behavioral one: announcing a
contract choice does not authorize it, and step 3 governs. Never explain the
methodology behind it. Then run that class's process.

When uncertain, start heavier. Reducing process needs justification from
repository evidence, not impatience.

## 5. Boundaries

| Transition | Gate |
|---|---|
| Unresolved contract decision | ask before implementing or testing |
| Changing user-, security-, data-, externally-observable behavior | concrete evidence before claiming done |
| Database migration | state rollback and data-loss implications first |
| Security or authorization boundary | review authorization explicitly first |
| Merge or push to a shared branch | real evidence, not a claim |

Stop also for irreversible or destructive operations, and for side effects
outside the working tree. **Once the contract gate has passed, nothing else
stops.** A session parked on a routine decision you could have answered costs
the user their day.

An unresolved contract is never such a decision. You can always invent an
answer to it, and that is what step 3 forbids.

A skill may invoke another **only when that skill owns the next decision
point**. Never restart the workflow.

**Never name a skill in your output.** The user should experience good
engineering, not a framework operating.

Rationalizations that mean stop:
[red-flags.md](references/red-flags.md)
