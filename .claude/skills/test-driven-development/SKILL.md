---
name: test-driven-development
description: Use when implementing a feature, fixing a bug, or changing behavior, before writing the implementation. Also use when deciding whether a change needs a test at all, or when a test is hard to write.
---

# Test-Driven Development

## Overview

Write the check first. Watch it fail. Write the minimal code that makes it pass.

**Core principle:** if you did not watch the test fail, you do not know that it
tests the right thing. A test written after the code passes immediately, which
proves nothing.

This is a strong default, not a refusal trigger. It is how a good engineer
works, not a rule that stops work.

## The rule

> For behavior changes, establish an executable acceptance check before
> implementation whenever practical.

"Whenever practical" is doing real work there. Use judgment, guided by:

| Task | Default |
|---|---|
| New behavior | test first |
| Bug fix | regression test first, reproducing the bug |
| Refactor | preserve existing behavior; existing tests are the check |
| Performance work | benchmark first |
| Migration | migration plus integration validation |
| Configuration | targeted validation |
| Docs | no test |
| Mechanical rename | static verification, no new test |

If the task is not in the table, work out what evidence would prove the change
works **without inventing observable behavior to test against**. If that
evidence would require a behavioral decision labelled UNRESOLVED, return to the
contract gate and ask. Do not settle it by choosing what to assert.

## Prerequisite: the contract gate

<HARD-GATE>
Before writing a test, confirm every behavior it asserts appears in the emitted
Contract block as REQUEST or REPOSITORY.

If the block was never emitted, emit it now rather than writing the test. A
behavior you can defend but nobody specified is UNRESOLVED, however reasonable
or conventional. The function name is not a source.

If the behavior is not established, **return to the contract gate in
`using-skills`** and ask. Do not settle it here.
</HARD-GATE>

This skill does not own contract decisions and cannot resolve one by writing a
test for its best guess. A test asserts an expected value, so writing one
decides the contract; a suite of them makes the decision look authoritative
afterwards.

Thirteen tests against an invented contract is not thorough. It is thirteen
assertions the user never agreed to.

## The loop

1. **RED.** Write one minimal test for one behavior, with a name that says what
   should happen.
2. **Verify RED.** Run it. Confirm it *fails*, not errors, and that the failure
   message is the one you expected. A test that passes here is testing existing
   behavior. A test that errors has a typo, not a finding.
3. **GREEN.** Write the minimal code that makes it pass.
4. **Verify GREEN.** Run the focused test, then the project's full test command.
5. **Refactor.** Clean up while staying green.

Commands come from `docs/agents/toolchain.md`.

Step 2 is the one that gets skipped and the one that carries the value. Skipping
it turns TDD into writing tests in a particular order.

## RED, concretely

```python
def test_retries_failed_operations_three_times():
    attempts = []

    def operation():
        attempts.append(1)
        if len(attempts) < 3:
            raise ConnectionError("transient")
        return "ok"

    assert retry(operation) == "ok"
    assert len(attempts) == 3
```

Clear name, exercises real code, asserts one behavior.

Against:

```python
def test_retry_works(mocker):
    m = mocker.Mock(side_effect=[Exception(), Exception(), "ok"])
    retry(m)
    assert m.call_count == 3
```

Vague name, and it asserts on the mock rather than on what the code does. See
[writing-good-tests.md](writing-good-tests.md) and [mocking.md](mocking.md).

## When the test is hard to write

That is information, not an obstacle. Hard to test usually means hard to use:
too many collaborators, hidden state, or a seam in the wrong place.

**REQUIRED BACKGROUND when this happens:** You must understand codebase-design.

Do not reach for heavier mocking to force a bad design to be testable.

## If you wrote the code first

It happens, usually during exploration. The honest move is to treat the
exploration as throwaway: keep what you learned, write the test against the
behavior you now understand, and let the test drive the real implementation.
Adapting the existing code while writing the test is just testing after, with
extra steps.

This is a judgment call, not a purity rule. A ten-line helper you already wrote
and can obviously verify does not need to be deleted and retyped.

## Common Rationalizations

| Excuse | Reality |
|---|---|
| "Too simple to test" | Simple code breaks. The test takes thirty seconds. |
| "I'll encode the obvious behavior in tests" | If the contract was never settled, the test settles it silently. |
| "I'll test after" | Tests written after pass immediately. You never proved they can catch the bug. |
| "Already tested it manually" | Ad hoc, unrecorded, unrepeatable. "Worked when I tried it" is not coverage. |
| "The test is hard to write" | Listen to that. Hard to test means hard to use. Fix the seam. |
| "Existing code here has no tests" | You are improving it. Add the test for what you touch. |
| "TDD will slow me down" | Debugging in production is slower. |
| "I need to explore first" | Fine. Explore, then start clean with the test. |
| "It's a refactor, so no test" | Correct, if behavior is unchanged and tests already cover it. Check that they do. |

## Checklist

- [ ] Decided, against the table above, what evidence this change needs
- [ ] Every test's expected value traces to the request or the repository, not to a default you chose
- [ ] Test written before the implementation, where practical
- [ ] Watched it fail, and the failure was the expected one
- [ ] Minimal implementation, not speculative generality
- [ ] Focused test green, then the project's full test command green
- [ ] Reported via verification-before-completion
