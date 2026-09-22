---
name: writing-plans
description: Use when a reviewed spec exists for a LARGE task and implementation has not started. Also use when a task has enough interdependent steps that the order matters, or when work will span more than one session.
---

# Writing Plans

## Overview

**Core principle:** write the plan for an engineer who is competent but has no
context for this codebase and will read the tasks out of order.

That reader is real: it is a future session after compaction, or a fresh
subagent. Everything they need is in the task, or they do not have it.

Save plans to `docs/plans/YYYY-MM-DD-<feature>.md`.

## Prerequisite

A reviewed spec. The plan argues from the spec; it does not redo it.

**If you arrived here from brainstorming, a spec exists by definition and this
section does not apply. Skip it.** Re-entering brainstorming from here is the
one loop this system can form, and it forms no other way.

If you arrived here some other way and there is no spec, the design work has not
happened. Stop and say so: the task needs sizing and a design before it needs a
plan. Do not invoke brainstorming yourself, because that is restarting the
workflow from the beginning rather than advancing to the next decision point.

## Plan header

Every plan starts with this:

```markdown
# <Feature> Implementation Plan

**Goal:** one sentence: what this builds.

**Approach:** two or three sentences on how.

**Spec:** path to the spec this implements. The plan argues from it, so it
travels with it. Executors read both.

## Global Constraints

The spec's project-wide requirements, one line each, values copied verbatim:
version floors, naming rules, platform requirements, anything every task must
respect.

## Review Focus

The inputs or failure modes the spec implies but no task's tests exercise, and
that would bite a real user. One line each, most likely first. The spec says
what the software must do, not everything it will meet, and its silence about
an input is not permission for that input to break the program.

Write this list once with the spec in front of you. Then push each line into
the task that owns that code, as a test in that task's own step style.
```

## Task structure

```markdown
### Task N: <name>

**Blocked by:** Task M  (or: nothing)

**Files:**
- Create: `src/pkg/thing.py`
- Modify: `src/pkg/existing.py`
- Test: `tests/test_thing.py`

**Interfaces:**
- Consumes: exact signatures this task relies on from earlier tasks
- Produces: exact names and types later tasks will call

- [ ] **Step 1: Write the failing test**

```python
def test_rejects_expired_token():
    with pytest.raises(TokenExpired):
        verify(expired_token(), now=FIXED)
```

- [ ] **Step 2: Run it and watch it fail**

Run: the one-test command from `docs/agents/toolchain.md`, for
`tests/test_thing.py::test_rejects_expired_token`
Expected: fails with `NameError: verify`

- [ ] **Step 3: Minimal implementation**

```python
def verify(token, *, now): ...
```

- [ ] **Step 4: Run it and watch it pass**

- [ ] **Step 5: Run the full suite**

- [ ] **Step 6: Commit**
```

Commands come from `docs/agents/toolchain.md`.

### Declare blocking edges

Every task says what blocks it, explicitly. That is what lets an executor see
which tasks are independent, and lets a reader pick up at task six without
reconstructing the graph.

If every task blocks the previous one, the plan is a list and that is fine. Say
so rather than leaving it implied.

### Interfaces are how tasks agree

A task's implementer may see only that task. The `Produces` block is where the
next task learns the names and types to call. Vague here means the two tasks
disagree and nobody notices until integration.

## Task right-sizing

A task is the smallest unit that carries its own test cycle and is worth a
reviewer's gate. Fold setup, configuration and docs into the task whose
deliverable needs them. Split only where a reviewer could reject one task while
accepting its neighbor.

Each step inside a task is one action, two to five minutes: write the test, run
it, implement, run it, commit.

## No placeholders

These are plan failures, not shorthand:

- "TBD", "TODO", "fill in details", "implement later"
- "Add appropriate error handling", "handle edge cases", "add validation"
- "Write tests for the above" with no test code
- "Similar to Task 3" — repeat it; the reader may not have read Task 3
- A step describing what to do without showing how
- References to a function or type no task defines

If you cannot write the code for a step, the design is not finished. Go back to
the spec rather than writing a placeholder.

## Handoff

The plan is written and saved. Ask the user to review it, then:

**REQUIRED SUB-SKILL:** Use executing-plans

## Red Flags

| Thought | Reality |
|---|---|
| "The implementer will figure that out" | They have no context. Write it. |
| "I'll put TBD and fill it in later" | Later is during implementation, which is too late. |
| "Similar to the previous task" | They may be reading out of order. Repeat it. |
| "The order is obvious" | Declare the blocking edges anyway. |
| "I'll leave the interface loose" | Then two tasks will disagree at integration. |
| "This plan is getting long" | Long is fine. Vague is not. |
| "I should re-brainstorm this part" | The spec is the authority. Go back to it, not to brainstorming. |

## Checklist

- [ ] A reviewed spec exists and is linked from the header
- [ ] Global Constraints copied verbatim from the spec
- [ ] Review Focus written, and each line pushed into an owning task as a test
- [ ] Every task declares its blocking edges
- [ ] Every task names exact files to create, modify and test
- [ ] Interfaces give exact signatures, both consumed and produced
- [ ] Every code step contains real code
- [ ] No placeholders anywhere
- [ ] Saved to `docs/plans/` and reviewed by the user
