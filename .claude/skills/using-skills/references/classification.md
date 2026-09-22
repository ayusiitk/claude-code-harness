# Classification: edge cases and examples

Reference for `using-skills` step 2. The spine's table decides ordinary cases.
Read this when a task does not obviously fit one, or when size and risk seem to
disagree.

## Size

Size is about how much of the system the change touches and how much can be
learned from the repository, not about line count.

| Class | Test |
|---|---|
| TRIVIAL | Cannot alter behavior. Typo, comment, docs, mechanical rename. |
| SMALL | Changes behavior in code that already exists here, in one place. |
| NORMAL | A feature or a bug fix. Several files, one coherent change. |
| LARGE | Creates a subsystem, crosses boundaries, or changes an interface others depend on. |

**Read the repo before sizing.** A task that sounds architectural is often SMALL
once you find the existing abstraction. "Add a plugin system" is LARGE in an
empty repo and SMALL in one that already has a registry.

**When uncertain, start heavier.** Classification can move in either direction,
but reducing process needs justification from repository evidence. "There is
already a registry, so this is an implementation, not an architecture" is a
reason. "This is taking a while" is not.

## Risk is orthogonal to size

Risk does not change the class. A one-line change to an authorization check is
SMALL and RISKY. It gets SMALL's process plus the overlay. It does not become
LARGE.

| Change | Class |
|---|---|
| Internal helper, private function, refactor | SMALL |
| API response shape, an error message a caller parses | NORMAL |
| Authorization or authentication check | SMALL + RISKY |
| Anything reading or writing personal data | + RISKY |
| Schema migration, backfill, deletion | + RISKY |
| Secret handling, token issuance, session lifetime | + RISKY |
| Payment, billing, quota, rate limit | + RISKY |
| Retry, timeout or idempotency around a side effect | + RISKY |

The test for RISKY: does this alter **user-, security-, data-, or
externally-observable behavior**? Not "will this eventually run in production" —
by that reading everything is risky and the overlay means nothing.

When unsure, treat it as risky. The overlay is cheap; the failure is not.

## What each class actually runs

- **TRIVIAL** — make the change, verify it, done. No design, no classification
  ceremony beyond the one line, no test unless the change is testable behavior.
- **SMALL** — establish the contract, write the test, implement, verify.
- **NORMAL** — the above plus a short design stated in chat before implementing,
  and a review afterwards.
- **LARGE** — the above plus a written spec and an implementation plan.
  **REQUIRED SUB-SKILL:** Use brainstorming
