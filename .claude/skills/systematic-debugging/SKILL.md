---
name: systematic-debugging
description: Use when encountering a bug, a failing test, an error, or behavior that does not match expectations, before proposing or attempting any fix. Also use when a fix did not work, when a failure is intermittent, or when tests pass alone but fail together.
---

# Systematic Debugging

## Overview

**Core principle:** no fix without a root cause, and no root cause without a
command that reproduces the failure on demand.

The failure mode this prevents is plausible-fix churn: changing something that
might be it, re-running, seeing a different error, changing something else. That
loop can run for an hour and leave the original bug intact underneath a pile of
edits.

## Phase 0: get a red-capable command

**Before anything else, find a command that fails because of this bug and
succeeds when it is fixed.** Usually a focused test. Sometimes a script, a
request, a one-liner in a REPL.

> **No red-capable command, no Phase 1.**

This is the gate. If you cannot make the failure happen on demand, you are not
debugging, you are guessing. Getting to a reproduction is the work; everything
after it is comparatively easy.

When the failure is intermittent, the reproduction is a loop: run it fifty
times, or with the ordering seed that triggered it. An intermittent
reproduction is still a reproduction. "Cannot reproduce" is a finding to report,
not a reason to fix speculatively.

Commands come from `docs/agents/toolchain.md`.

## Phase 1: minimise

Shrink the reproduction until nothing can be removed without losing the failure.
Cut inputs, cut steps, cut layers. Each thing you remove that does not change
the failure is a thing that was never involved.

Completion criterion: you can state the failure in one sentence naming the input
and the wrong output.

## Phase 2: hypothesise

Write down what you believe is happening, specifically enough to be wrong:

> "`parse_window` treats the end bound as exclusive, so the last row is dropped
> when the range ends exactly on a boundary."

Not "something is wrong with the date handling."

Prefer the hypothesis that explains **all** the symptoms. A hypothesis that
explains only some of them is usually a second bug or a wrong guess.

## Phase 3: instrument

Prove or kill the hypothesis by observation, not by patching and hoping. Print
the value, add a temporary assert, step through, log at the boundary. Trace back
to where the wrong value was born rather than where it surfaced.

See [root-cause-tracing.md](root-cause-tracing.md) for working backwards from a
symptom to its origin, and
[finding-test-pollution.md](finding-test-pollution.md) when tests pass in
isolation but fail together.

Completion criterion: you can point at the line where the wrong value first
exists and explain why it is wrong.

## Phase 4: fix at the root

Fix the cause, not the symptom. If the wrong value is born in `parse_window`, do
not clamp it in the caller.

Then, before writing the fix: **write the regression test that fails for this
bug.** The red-capable command from Phase 0 usually becomes it.

**REQUIRED SUB-SKILL:** Use test-driven-development

Remove the instrumentation you added. Run the focused test, then the project's
full test command.

**REQUIRED SUB-SKILL:** Use verification-before-completion

## When the fix does not work

Go back to Phase 2, not to Phase 4 with a different edit. A failed fix falsified
the hypothesis, which is information. Say what it ruled out.

Two failed fixes in a row means the hypothesis was never tested properly at
Phase 3.

## Red Flags

| Thought | Reality |
|---|---|
| "I'll just try changing this" | That is guessing. Get the red command first. |
| "It's probably the cache" | Probably is a hypothesis. Go to Phase 3 and prove it. |
| "It's flaky, re-run it" | Flaky is a symptom with a cause, usually order or timing. |
| "I can't reproduce it, but I know the fix" | Then you cannot know the fix worked. |
| "Let me add error handling around it" | Swallowing the symptom leaves the cause. |
| "The test is wrong" | Sometimes true. Prove it before changing the test. |
| "This is taking too long, I'll patch the caller" | A symptom patch costs more later, in a worse place. |
| "Several things could cause this" | Then instrument until one of them is ruled in. |

## Checklist

- [ ] A command exists that fails on demand because of this bug
- [ ] Reproduction minimised; failure stated in one sentence
- [ ] Hypothesis written down, specific enough to be falsified
- [ ] Hypothesis proven by observation, not by a fix that seemed to help
- [ ] The line where the wrong value originates is identified
- [ ] Regression test written and seen failing before the fix
- [ ] Fix applied at the root, instrumentation removed
- [ ] Focused test and full suite green, reported with evidence
