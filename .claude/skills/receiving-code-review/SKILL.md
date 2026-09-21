---
name: receiving-code-review
description: Use when review feedback arrives from a human, a bot, or a review subagent, before implementing any of it. Also use when a finding seems wrong, when several findings conflict, or when a reviewer asks for a change you disagree with.
---

# Receiving Code Review

## Overview

**Core principle:** a finding is a claim, not an instruction. Verify it, then
act on what survives.

Two failure modes, and they are mirror images. **Performative agreement**: "good
catch, fixed" applied to everything, including the findings that were wrong,
which introduces bugs a reviewer merely suggested. **Reflexive defense**:
explaining why each finding does not apply, which wastes the review.

Neither is rigor. Rigor is checking.

## The loop, per finding

1. **Understand the claim.** What specifically is alleged to be wrong? If a
   finding has no concrete failure scenario, it is a preference. Treat it as
   one.
2. **Check it against the code.** Read the actual lines. Can you construct the
   input that produces the failure they describe?
3. **Decide:**
   - **Correct** → fix it, at the root rather than at the symptom.
   - **Correct but the fix is wrong** → fix the real problem, and say why the
     suggested fix would not have worked.
   - **Incorrect** → say so, with the evidence. A test that demonstrates the
     current behavior is the strongest reply.
   - **A preference** → adopt it if the repo has no opinion and it is plainly
     better; otherwise say the code stays as is and why.
4. **Verify the fix.** A fix applied to satisfy a reviewer still needs a test
   and a run.

**REQUIRED SUB-SKILL:** Use verification-before-completion

## When a finding is about a bug

Do not patch the line the reviewer pointed at until you know why it is wrong.
The reviewer saw a symptom; the cause may be elsewhere.

**REQUIRED SUB-SKILL:** Use systematic-debugging

## Several findings in the same area

Repeated findings around one piece of code usually mean the design is the
problem, not the three lines. Fix the cause rather than each instance.

**REQUIRED BACKGROUND:** You must understand codebase-design.

## Disagreeing well

Disagreement is a legitimate outcome and should be specific:

> "`parse_window` cannot receive `None` here: the caller validates at
> `api.py:44` and `test_window_rejects_null` covers it. Leaving as is."

Not "I don't think that's an issue."

If the reviewer is a human and the question is about intent or product
behavior rather than code, ask them rather than deciding.

## Bots and subagents

Findings from an automated reviewer get the same treatment: verified, not
obeyed and not dismissed. They have no context about intent, so they produce
both real bugs and confident nonsense, and the only way to tell is to check.

Where a reviewer marks a finding optional or non-blocking, it stays optional.
Do not start a round of changes for it; fold the plainly correct ones into the
next change that touches those files anyway.

## Red Flags

| Thought | Reality |
|---|---|
| "Good catch, fixing" (before checking) | You may be introducing the bug they imagined. |
| "The reviewer is more senior, so they're right" | Seniority is not evidence. The code is. |
| "I'll just make the change to move on" | An unverified change is an unreviewed change. |
| "This finding is obviously wrong" | Then it is cheap to show why. Show it. |
| "I'll fix the line they pointed at" | They saw a symptom. Find the cause. |
| "Three findings, three small patches" | Three findings in one area is a design signal. |
| "It's just a nit, I'll do it" | Fine, if it is genuinely better. Not if it is churn. |
| "I'll explain why each one doesn't apply" | That wastes the review. Check first. |

## Checklist

- [ ] Every finding read as a claim, not an instruction
- [ ] Each checked against the actual code before acting
- [ ] Findings without a concrete failure scenario treated as preferences
- [ ] Fixes applied at the root, not at the line pointed to
- [ ] Disagreements stated with specific evidence
- [ ] Clustered findings examined for a design cause
- [ ] Every fix verified and reported
