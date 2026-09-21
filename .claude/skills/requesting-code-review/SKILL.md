---
name: requesting-code-review
description: Use when a feature or bug fix is complete and tests pass, before committing substantial work or opening a pull request. Also use after a risky change, and when asked to review a branch, a diff, or work in progress.
---

# Requesting Code Review

## Overview

**Core principle:** a reviewer who shares your context shares your blind spots.
The value of a review comes from a reader who has not spent the last hour
convincing themselves this design is right.

So the review runs in a fresh subagent with no session history, given the diff
and the requirements as files rather than as a summary you wrote.

## When to review

- A feature or bug fix that is more than a few lines
- Anything carrying the risk overlay, always
- Before opening a pull request
- When the user asks

Not for a typo, a comment, or a mechanical rename.

## Two axes, reviewed separately

A single "review this" prompt produces style notes. Two focused reviews produce
findings, because each has one question to answer.

**Standards.** Does the code follow this repo's conventions and hold up as
code? Naming, structure, error handling, test quality, the design rules in
`codebase-design`, whatever `CLAUDE.md` and `docs/agents/` require.

**Spec.** Does the code do what was actually asked? Missing requirements,
misread requirements, scope that grew beyond the request, edge cases the
requirement implies but no test covers.

Run both. They find different things: Standards catches code that is wrong on
its own terms, Spec catches code that is fine but solves a different problem.

## How to run it

1. Establish the base: the commit, branch, tag or merge-base the diff is
   measured from. Say which.
2. Write the diff and the requirements to files. Do not paste them into the
   prompt.
3. Dispatch two subagents in parallel, each pointed at
   [code-reviewer-prompt.md](code-reviewer-prompt.md) with its axis and the file
   paths.
4. Report the two results side by side.

**Hand artifacts over as files.** Anything pasted into a dispatch prompt, and
anything a subagent prints back, stays in your context for the rest of the
session and is re-read every turn. A path costs a line.

**Give the reviewer the requirement, not your summary of it.** A summary you
wrote carries the same misreading the code might carry, so the Spec axis becomes
a check that the code matches your belief about the requirement. Point at the
original: the issue, the spec file, or the user's own words.

## Under the risk overlay

Add a third pass, or fold it into Standards explicitly: authorization at the
object level, the negative cases, what happens on partial failure. Say in the
prompt that this change touches a security or data boundary, so the reviewer
weights it accordingly.

## Then triage the findings

Findings are claims, not orders. Verify each one before acting.

**REQUIRED SUB-SKILL:** Use receiving-code-review

## Red Flags

| Thought | Reality |
|---|---|
| "I wrote it, so I'll review it" | You will read what you meant, not what you wrote. |
| "I'll summarize the change for the reviewer" | Give them the diff. Your summary hides the bug. |
| "One review prompt is enough" | One prompt gets style notes. Two axes get findings. |
| "I'll paste the diff into the prompt" | It stays in context all session. Write a file. |
| "Tests pass, so review is a formality" | Tests check what you thought to check. |
| "It's a small change" | Small and risky is exactly the case for a second reader. |
| "I'll skip review and fix it in follow-up" | Follow-up costs more, in a worse place. |

## Checklist

- [ ] Base commit for the diff established and stated
- [ ] Diff and original requirements written to files, not pasted
- [ ] Standards and Spec reviews dispatched separately, fresh context each
- [ ] Risk boundary flagged in the prompt where applicable
- [ ] Both results reported side by side
- [ ] Findings triaged, not implemented blindly
