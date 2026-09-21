---
name: executing-plans
description: Use when a reviewed implementation plan exists and work on it is starting or resuming. Also use when returning to a partly finished plan after a break or after context compaction.
---

# Executing Plans

## Overview

**Core principle:** execute continuously. The user asked for the plan to be
built, so build it. Do not check in between tasks.

**Rulings, not stalls.** A running plan does not wait on a human. Conflicts,
ambiguities, a plan defect, a gap between two tasks' interfaces: decide them.
The spec is the authority, the plan is its argument, and your judgment settles
what neither answers.

Record each decision in the commit or the progress note as:

> Ruling: <what you decided> — <why> — <what it costs if wrong>

A wrong ruling costs rework the user can see and undo. A session parked on a
question costs their whole day and buys nothing.

## Four things stop you, and only these

1. An irreversible or destructive operation.
2. A security-sensitive action.
3. A side effect outside this working tree that norms say you ask about first:
   a merge, a push to a shared branch, a publish.
4. A plan so broken that every path forward is a guess.

Everything else is a ruling.

## The loop, per task

1. Read the task in full, including its `Interfaces` block. Read the spec
   section it implements.
2. Work the steps in order. They are already sized: write the test, watch it
   fail, implement, watch it pass, run the suite, commit.
3. Tick the checkboxes in the plan file as you go. The plan file is the ledger;
   it survives compaction and your context does not.
4. Commit per task, with a message that names what the task delivered.
5. Move to the next task. Do not summarize progress at the user.

**REQUIRED SUB-SKILL:** Use test-driven-development

Commands come from `docs/agents/toolchain.md`.

## Narration

At most one short line between tool calls. The plan file and the commits carry
the record. "Should I continue?" and progress summaries waste the user's time:
they asked for the plan to be executed, so execute it.

## When a task carries risk

Some tasks in an ordinary plan touch authentication, data, or a public
contract. The overlay applies per task, not per plan.

**REQUIRED SUB-SKILL for those tasks:** Use high-risk-changes

## When a task will not work as written

The plan was written before the code existed, so some tasks are wrong. In
order of preference:

1. **The step is wrong but the intent is clear** — do the intended thing, note
   the ruling, keep going.
2. **Two tasks' interfaces disagree** — pick the one the spec supports, fix the
   other task's text in the plan file, note the ruling.
3. **A task depends on something that does not exist** — check whether an
   earlier task was meant to create it. If the plan genuinely omitted it, add
   the work to the task that needs it and note the ruling.
4. **Every path forward is a guess** — that is stop condition 4. Say what is
   ambiguous and what you would need.

Update the plan file when you rule against it. A plan that no longer describes
the code is worse than no plan.

## When something breaks

A failing test during execution is a bug, not a step to retry.

**REQUIRED SUB-SKILL:** Use systematic-debugging

Do not skip, disable or mark a test xfail to get past it.

## Resuming

The plan file's checkboxes are the source of truth, not memory. On resuming:
read the plan, find the first unticked box, verify the previous task actually
landed (`git log`, run the suite), then continue from there.

## Finishing

When every task is ticked and the suite is green:

**REQUIRED SUB-SKILL:** Use requesting-code-review

Then:

**REQUIRED SUB-SKILL:** Use finishing-a-development-branch

Do not re-enter brainstorming or writing-plans at the end. If new information
invalidated the design, say what it was and stop; otherwise the plan is done.

## Red Flags

| Thought | Reality |
|---|---|
| "I'll check in before task three" | They asked for the plan. Execute it. |
| "This task is ambiguous, I'll ask" | Make a ruling and record it. |
| "I'll summarize progress so far" | The commits are the record. |
| "The test fails, I'll adjust it" | The test is failing for a reason. Debug it. |
| "I'll skip this task and come back" | Then the ledger lies. Rule on it or stop. |
| "I'll do the tasks in a different order" | Check the blocking edges first. |
| "I'll tick the boxes at the end" | Compaction will lose the progress. Tick as you go. |
| "The plan is wrong, let me re-plan" | Fix the task, note the ruling, keep going. |

## Checklist

- [ ] Plan and spec both read before starting
- [ ] Tasks executed in an order the blocking edges allow
- [ ] Checkboxes ticked in the plan file as each step lands
- [ ] One commit per task, named for what it delivered
- [ ] Rulings recorded with reason and cost-if-wrong
- [ ] Risky tasks got the overlay
- [ ] Failures debugged, never skipped or disabled
- [ ] Review requested and branch finished at the end
