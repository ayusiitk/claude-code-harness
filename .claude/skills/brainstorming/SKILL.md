---
name: brainstorming
description: Use when a change needs a design before implementation, which is any task sized NORMAL or LARGE. Also use when a request is ambiguous about intent, when several approaches are plausible, or when the user asks to think something through.
---

# Brainstorming

## Overview

**Core principle:** the outcome is an understanding the user can recognise and
correct, grounded in what they are trying to accomplish.

Not a feature list. Not a plan. An agreed understanding of the problem, the
constraints, and which approach is being taken.

**This skill does not classify the task.** `using-skills` already did that.
Take the size as given and do the design work the size calls for:

| Size | What this skill produces |
|---|---|
| NORMAL | a short design in chat: approach, files touched, how it is tested |
| LARGE | a written spec at `docs/specs/YYYY-MM-DD-<topic>.md` |

If the classification was wrong, say so once and let `using-skills` re-decide.
Do not re-run classification here.

## Start from context, not from questions

You have already read the relevant code. Use it. Questions whose answers are
sitting in the repo waste the user's attention and make the agent look like it
did not look.

Ask about **intent and constraints**, which the code cannot tell you:

- What is the outcome they want, and for whom?
- What does success look like, concretely?
- What must not change?
- What is deliberately out of scope?

Knowing what kind of thing is being built does not tell you why they want it.

## Interviewing well

One question at a time. A list of six questions gets three answered.

Work a **frontier**: each answer opens the next question. Follow the branch that
most changes the design, not the one that is easiest to ask.

**Separate facts from decisions.** A fact is something true about the world or
the codebase; you can go and check it. A decision is a choice someone has to
make; it needs an owner. Mixing them is how a design ends up resting on an
assumption nobody agreed to.

Keep going until the remaining unknowns would not change the design. That is the
completion criterion, not a question count.

## Write the understanding back

Before proposing anything, summarize what you understood: the outcome, the
constraints, the success criteria. Mark clearly what they told you and what you
inferred.

This is the cheapest correction point in the whole task. A misunderstanding
caught here costs a sentence; caught after implementation it costs the change.

## Propose approaches

For LARGE, offer two or three with real trade-offs and say which you recommend
and why. An approach with no downside listed has not been thought about.

For NORMAL, one approach is usually right. Say what you considered and
discarded, in a clause.

## The gate

<HARD-GATE>
Do not write implementation code, scaffold a project, add dependencies, or
create external resources until the design for the task's size has been agreed.

NORMAL: the short in-chat design has been accepted.
LARGE: the written spec has been reviewed.

Reading the codebase is always allowed. Approval of an idea is not approval of
an artifact that does not exist yet.
</HARD-GATE>

## Stop only for decisions the user owns

Not every design question is theirs. The rule from `using-skills` holds here:

> Stop only when the next step commits the user to a consequential product,
> architectural, security, or irreversible decision that cannot reasonably be
> inferred from the repository and the request.

"Must the new address be verified before it becomes active?" is theirs: it is
product behavior with a security consequence. "Which module does the helper live
in?" is yours; the repo's conventions already answer it.

Presenting a design and beginning implementation in the same breath skips the
gate. Presenting a design nobody needed to see wastes their time. Both are
failures.

## Where this hands off

- **NORMAL**, once the design is accepted: implement directly. No plan document.
- **LARGE**, once the spec is reviewed: **REQUIRED SUB-SKILL:** Use writing-plans

Those are the only two terminal states. Do not invoke an implementation skill
from here, and do not re-enter this skill later unless new information
invalidated the design, in which case say what it was.

## Red Flags

| Thought | Reality |
|---|---|
| "I'll ask a few clarifying questions first" | Read the code first. Ask what it cannot tell you. |
| "Let me list everything I need to know" | One question at a time. Lists get partly answered. |
| "They said build X, so the intent is clear" | X is the shape. You still do not know why. |
| "I'll design and start implementing" | That skips the gate. Present, then stop. |
| "This is obviously the only approach" | Then say what you discarded, in one clause. |
| "I'll write the spec and start on task one" | Spec approval is approval of the spec. |
| "This feels more complex than SMALL" | Say so and let the classification be revisited. Do not silently escalate. |

## Checklist

- [ ] Relevant code read before any question asked
- [ ] Questions asked one at a time, about intent and constraints
- [ ] Facts separated from decisions, decisions given an owner
- [ ] Understanding written back and corrected before proposing
- [ ] Approaches proposed with real trade-offs and a recommendation
- [ ] Design presented at the right weight for the size
- [ ] Stopped for the user's decisions, and only those
- [ ] Handed off to implementation (NORMAL) or writing-plans (LARGE)
