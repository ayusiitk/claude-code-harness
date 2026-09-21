---
name: verification-before-completion
description: Use when about to say work is done, fixed, passing, working, or ready, and before committing, opening a pull request, or merging. Also use when reporting what a change accomplished.
---

# Verification Before Completion

## Overview

**Core principle:** evidence before assertion. Never claim something is done,
fixed, or passing without having actually run the check.

This is the strongest rule in this repo. Everything else scales with the task.
This does not.

## The evidence contract

One line per check:

```
✓ pytest tests/test_slug.py -q — 4 passed
✓ pytest -q — 214 passed
✓ ruff check . — clean
⚠ full e2e — not run; external email service is not configured
```

Format: `✓ <command> — <concise result>` for what ran, `⚠ <what> — not run; <reason>`
for what did not.

**The command must have actually been run.** This is about execution, not
formatting. Writing a `✓` line for a command you did not execute is worse than
saying nothing, because it launders a guess into a report.

### Keep it concise

Raw output goes in the response **only when it contains something
decision-relevant**: a failure, a surprising count, a warning that changes what
to do next. Thirty lines of green pytest output in every response is noise, and
transcript verbosity is not part of correctness.

A failure is always decision-relevant. Paste it.

## What counts as appropriate evidence

A test is usually the right evidence, but not always. Do not write a fake test
to satisfy a rule. Choose the strongest concrete check the change admits:

| Change | Appropriate evidence |
|---|---|
| Behavior in code | focused test, then the project's full test command |
| Bug fix | the regression test, failing before and passing after |
| Refactor | existing tests still green, no new test needed |
| Performance work | before and after measurement, same conditions |
| Migration | schema or static validation, plus rollback reasoning |
| Configuration | the config loaded and exercised, or validated by its own tool |
| Generated artifacts | regenerated and diffed, not hand-edited |
| Docs describing behavior | the described commands actually run |

Commands come from `docs/agents/toolchain.md`. If a row there is marked
*provisional* and the tool is not actually installed, that is a `⚠` line naming
it, not a silent omission and never a `✓`.

## Scope of the run

**"Tests pass" means the project's suite, not just your file.** A green run of
the test you wrote is not a green suite. Before calling a change done, run the
project's full test command even when your task named one file.

A scope statement bounds the deliverable, not the verification.

**Report every failure you saw, by name, including ones you did not cause.** A
red test that scrolled past unmentioned is a report falsified by omission.

## When risk is on the task

The risk overlay widens this. Beyond the focused tests, run whatever else
touches that boundary or that data, and verify the negative cases: denied,
expired, replayed, concurrent. Say which ones you exercised.

## Red Flags

| Thought | Reality |
|---|---|
| "This should work" | Then you have not checked. Run it. |
| "The change is obviously correct" | Obvious changes break suites constantly. Cheap to prove. |
| "Tests probably still pass" | "Probably" is the word that makes this a guess. |
| "I only changed one file, I'll run one test" | The suite is how you learn what else depended on it. |
| "That failure was already there" | Then say so by name. Do not omit it. |
| "That failure is unrelated to my change" | Possibly. Name it anyway and say why you think so. |
| "It's just a docs change" | If it documents a command, run the command. |
| "The linter isn't installed, so that's fine" | It is a `⚠` line, not an absence. |
| "I'll paste the full output to be thorough" | Thoroughness is running it, not pasting it. |

## Checklist

- [ ] Every check reported was actually executed
- [ ] The project's full test command was run, not just the focused test
- [ ] Every failure seen is named, including pre-existing ones
- [ ] Anything not run has a `⚠` line with a reason
- [ ] Raw output included only where decision-relevant
- [ ] Risk overlay: negative cases exercised and named
