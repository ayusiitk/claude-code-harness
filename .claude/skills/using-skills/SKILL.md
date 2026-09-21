---
name: using-skills
description: Use at the start of any request that changes code, behavior, configuration, or docs, before exploring the codebase or asking clarifying questions. Establishes how much process the task needs.
---

# Using Skills

1. **Understand the repository before choosing a workflow.**
2. **Use the minimum process that makes the change safe.**
3. **Escalate when complexity or risk warrants it.**
4. **Never claim completion without evidence.**

## The pipeline

understand request → inspect repo context → classify size + risk → minimum
sufficient workflow → execute → verify → adversarial review if risk warrants → done

## 1. Inspect context first

Read enough to know: what architecture exists, what conventions are in force,
how tests are structured, which commands are authoritative
(`docs/agents/toolchain.md`), whether a similar feature already exists to
follow, what boundaries are established.

This is reading, not ceremony. It stops "add endpoint X" from summoning a
generic workflow when the repo already has one obvious way to do it.

## 2. Classify size, then overlay risk

| Class | Looks like | Process |
|---|---|---|
| TRIVIAL | typo, docs, comment, mechanical rename | edit → verify |
| SMALL | isolated change to code already here | understand → test → implement → verify |
| NORMAL | a feature or bug fix | + brief design, + review |
| LARGE | new subsystem, cross-cutting, interface-changing | + brainstorm → spec → plan → execute |

**RISKY is an overlay, not a fifth size.** It applies when the change alters
user-, security-, data-, or externally-observable behavior: auth, payments,
migrations, destructive operations, security boundaries. An internal helper is
SMALL. An API response shape is NORMAL. An authorization check is SMALL + RISKY.
A migration is whatever size it is, + RISKY.

**REQUIRED SUB-SKILL for the overlay:** Use high-risk-changes

## 3. Say the classification in one terse line

`<CLASS>[ + RISKY]: <why, in a clause>`

> `NORMAL + RISKY: account-email change touches authentication and user data.`

Never explain the methodology behind it. That is theater.

**When uncertain, start heavier.** Classification may change either way, but
reducing process needs justification from repository evidence. "There is already
a registry here, so this is an implementation, not an architecture" is a reason.
"This is taking a while" is not.

## Hard gates

| Transition | Gate |
|---|---|
| Changing user-, security-, data-, or externally-observable behavior | appropriate concrete verification evidence before claiming done |
| Database migration | state rollback path and data-loss implications first |
| Security or authorization boundary | review authorization explicitly before implementing |
| Merge or push to a shared branch | real verification evidence, not a claim |

Everything else is guidance you apply with judgment.

## Stop and ask only when

> The next step commits the user to a consequential product, architectural,
> security, or irreversible decision that cannot reasonably be inferred from the
> repository and the request.

Plus irreversible or destructive operations, and side effects outside the
working tree.

**Nothing else stops.** Routine decisions get made and recorded. "Must the new
address be verified before it becomes active?" is worth stopping for. "Which
module does the helper live in?" is not. A session parked on a question you
could have answered costs the user their day.

## No process recursion

A skill may invoke another **only when that skill owns the next decision point**.
Never restart the workflow from the beginning. Once a stage is complete, do not
re-enter it unless new information invalidates its output, and say what that was.

## Stay invisible

Never say "according to the high-risk-changes skill" or "the TDD skill requires
me to". Review the authorization because that is what a good engineer does.

## Red Flags

| Thought | Reality |
|---|---|
| "Let me explore the codebase first" | Yes — that is step 1. Then classify. |
| "I'll ask if they want me to proceed" | Only if the next step is consequential. Otherwise proceed. |
| "This is complex, so it's LARGE" | Read the repo first. Existing abstractions shrink tasks. |
| "It's only one line, so it's safe" | One line in an auth check is SMALL + RISKY. |
| "Tests probably pass" | Then you have no evidence. Run them. |
| "I should tell them which skill I'm using" | No. Just do the work. |
