---
name: finishing-a-development-branch
description: Use when implementation is complete and tests pass, and the work needs to be integrated, merged, pushed, or turned into a pull request. Also use when deciding whether work is actually done.
---

# Finishing a Development Branch

## Overview

**Core principle:** integration is the one irreversible-ish step in the loop, so
it is the one place that takes no claims.

Everything before this can be amended cheaply. A merge into a shared branch is
seen by other people and by CI, and undoing it is a public event.

## The gate

<HARD-GATE>
Do not merge, push to a shared branch, or open a pull request until you have
actual verification evidence: commands run, in this state of the code, with
their results reported.

"Tests passed earlier" is not evidence. Run them on the final state of the
branch, after the last commit, including any review fixes.
</HARD-GATE>

**REQUIRED SUB-SKILL:** Use verification-before-completion

## Before integrating

1. **Re-run the full suite on the final commit.** Review fixes and merges change
   things. The run that matters is the last one.
2. **Check the diff as a whole.** Not the individual commits: read the branch's
   total change the way a reviewer will. Debug prints, commented-out code,
   temporary instrumentation from debugging, a file added by accident.
3. **Confirm the work matches what was asked.** Scope that grew is scope that
   was not reviewed.
4. **Get a review if the work is substantial or risky.**
   **REQUIRED SUB-SKILL:** Use requesting-code-review
5. **Bring the base branch in and resolve anything it conflicts with.**
   **REQUIRED SUB-SKILL when it conflicts:** Use resolving-merge-conflicts

## Pushing and pull requests

Pushing to a shared branch and opening a pull request are side effects outside
the working tree. Under the stop-rules in `using-skills`, they need the user's
go-ahead unless they already asked for them.

Committing locally does not. Commit freely; integrate deliberately.

When the user has asked for a pull request, describe what the change does and
why, from the diff. If the repo has a template, fill in its sections.

## Leaving work unfinished

Sometimes the right answer is that the branch is not done. Say so plainly, name
what is missing, and do not integrate. A branch honestly reported as incomplete
is worth more than one merged on an assumption.

If part of the scope is blocked, finish everything else in full and say exactly
what was left out and why. Scaling the work down is the user's call.

## Red Flags

| Thought | Reality |
|---|---|
| "Tests passed before the review fixes" | Then you have not tested this code. Re-run. |
| "It's a small change, I'll push it" | Small changes break builds. Same gate. |
| "I'll merge and fix forward if it breaks" | Fixing forward in public costs more. |
| "The individual commits were each fine" | Read the whole diff. Debris hides between commits. |
| "I'll open the PR, they can review it there" | Opening a PR is a side effect. Ask first. |
| "Close enough to done" | Then say what is missing. Do not integrate it. |
| "CI will catch anything I missed" | CI is not your verification. It is the backstop. |

## Checklist

- [ ] Full test suite run on the final commit, results reported
- [ ] Whole-branch diff read; no debug output, dead code or stray files
- [ ] Work matches what was asked; no unreviewed scope growth
- [ ] Review requested for substantial or risky work, findings triaged
- [ ] Base branch merged in, conflicts resolved, suite re-run after
- [ ] User's go-ahead obtained before any push, merge or pull request
- [ ] Anything incomplete stated plainly rather than integrated
