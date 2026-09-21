---
name: high-risk-changes
description: Use when a change touches authentication, authorization, secrets, payments, personal data, database migrations, deletion or destructive operations, public API contracts, or anything else a user or external system can observe. Applies at any task size, including one-line changes.
---

# High-Risk Changes

## Overview

**Core principle:** risk is orthogonal to size. A one-line change to an
authorization check is a small change that can lose an account.

This is an overlay. It does not replace the process the task's size already
earned; it adds four things on top. A small risky change stays small and still
gets all four.

## What makes a change risky

The change alters **user-, security-, data-, or externally-observable
behavior**. Not "code that will eventually run in production" — by that reading
everything is risky and the distinction buys nothing.

| Change | Risky? |
|---|---|
| Internal helper, refactor, private function | No |
| API response shape, error message a caller parses | Yes, externally observable |
| Authorization or authentication check | Yes |
| Anything reading or writing personal data | Yes |
| Schema migration, backfill, data deletion | Yes |
| Secret handling, token issuance, session lifetime | Yes |
| Payment, billing, quota, rate limit | Yes |
| Retry, timeout, or idempotency around a side effect | Yes |

When unsure, treat it as risky. The overlay is cheap; the failure is not.

## The four additions

### 1. Name the blast radius and the rollback path, before implementing

Write down, in a few lines:

- **Who or what is affected** if this is wrong: which users, which callers,
  which rows.
- **How it fails**: silently wrong, loudly broken, or slowly corrupting. Silent
  and slow are the dangerous ones.
- **How to undo it**: revert the deploy, run the down migration, restore from
  backup, or — the answer that should stop you — you cannot.

For a migration this is a hard gate: state the rollback path and the data-loss
implications before writing it. "Drop column" has no undo once it runs.

### 2. Review authorization explicitly

Not incidentally, as part of reading the diff. Ask directly:

- Who is allowed to do this, and where is that enforced?
- Is the check on the **object** as well as the action? "Can edit profiles" is
  not "can edit *this* profile".
- Can the identifier be substituted for someone else's?
- Is the check before the side effect, or after it?
- Does an error path skip it?

If the change adds a new way to reach existing behavior, the new path needs the
same check the old one had. That is where authorization bugs actually come from.

### 3. Test the negative cases

The happy path is the least interesting test here.

Consider each class below, **say which ones apply to this change**, and test
those. Not every class is meaningful for every change: a schema migration has no
expired-token case, and a payment timeout may have no malformed-input case.
Naming the ones you ruled out is part of the work, because that is where the
missed case hides.

- **denied**: wrong user, wrong role, missing credential
- **expired**: stale token, lapsed session, past deadline
- **replayed**: the same request twice; does it double-charge, double-send
- **concurrent**: two writers, lost update, check-then-act races
- **malformed**: absent field, wrong type, oversized input, injection shapes
- **partial failure**: it died halfway; what is left behind, and is it recoverable
- **boundary inputs**: empty, zero, maximum, just past maximum, unicode

**REQUIRED SUB-SKILL:** Use test-driven-development

### 4. Adversarial pass, then widen verification

Read your own diff as someone trying to break it. What input makes this do the
wrong thing? What ordering? What partial failure halfway through?

Then verify beyond the focused tests: run whatever else touches that boundary or
that data.

**REQUIRED SUB-SKILL:** Use verification-before-completion

For anything substantial, also get a second read.

**REQUIRED SUB-SKILL:** Use requesting-code-review

## Choose the safer fix

When two fixes work and one is safer, take the safer one, even if it is duller.
Fail closed rather than open. Deny by default. Prefer an additive migration over
a destructive one, and a two-step deploy over a simultaneous one.

## Red Flags

| Thought | Reality |
|---|---|
| "It's only one line" | Authorization is usually one line. |
| "It's an internal endpoint" | Internal is a deployment fact, not a security boundary. |
| "The caller already checks" | Then this is the second place it can be wrong. Check here. |
| "The migration is straightforward" | State the rollback anyway. That is the gate. |
| "I'll add the negative tests after" | The negative cases are the reason this is risky. |
| "It's the same as the existing pattern" | Then confirm the existing pattern is right. |
| "This is just a refactor" | A refactor that moves an auth check is not just a refactor. |
| "We can revert if it's wrong" | Data does not revert. Say so before, not after. |

## Checklist

- [ ] Blast radius written down: who is affected, how it fails
- [ ] Rollback path stated, or its absence stated
- [ ] Authorization reviewed explicitly, object-level as well as action-level
- [ ] Applicable negative-case classes named, including the ones ruled out, and the applicable ones tested
- [ ] Own diff read adversarially
- [ ] Verification widened past the focused tests
- [ ] The safer of the available fixes chosen
