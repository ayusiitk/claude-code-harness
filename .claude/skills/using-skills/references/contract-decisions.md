# Contract decisions

Reference for `using-skills` step 3. Read when deciding whether a decision is
yours or the user's.

## What counts as externally observable behavior

- which input forms are accepted, and which are rejected
- return-value semantics
- error and exception behavior
- normalization or transformation rules
- compatibility behavior
- user-visible output
- persistence and data interpretation

Each becomes one row in the Contract block, labelled REQUEST, REPOSITORY or
UNRESOLVED. Only the first two permit you to proceed.

The block is emitted whether or not anything is unresolved. That is deliberate:
if it were emitted only when something looked doubtful, deciding whether to
emit it would become the judgment call it exists to replace, and a contract
that feels obvious would never produce one.

**REQUEST** — the user stated it. Not implied it, not made it likely: stated
it.

**REPOSITORY** — an existing caller, test, spec or documented convention
settles it. A sibling function doing something similar is REPOSITORY only if
consistency with it is actually required; otherwise it is a precedent you are
choosing to follow, which is UNRESOLVED.

**UNRESOLVED** — everything else. This includes every case where you can
produce a defensible answer yourself. Being able to answer is what makes it
UNRESOLVED rather than settled.

**You may not create a behavioral contract by declaring your own default, even
if you state it out loud.** Announcing a choice is not authorization for it. "I
will treat this as the standard convention, raising on anything else" is the
invention this gate exists to prevent, said politely.

Defaults remain yours for implementation: module location, regex versus a hand
parser, internal data structures, helper naming, encoding where a repository
convention establishes it. They are never yours for accepted input forms,
return semantics, error behavior, normalization rules or compatibility.

## Yours or theirs

| Decision | Proceed? |
|---|---|
| Module location, file names, `src/` layout | yes |
| Dev dependencies, test framework | yes |
| Internal implementation: regex, algorithm, data structure | yes |
| Text encoding, path handling, where conventions settle it | yes |
| Which input forms are accepted, and which are rejected | ask |
| Whether malformed input raises, returns a sentinel, or is skipped | ask |
| Whether input is normalized before use, and how | ask |
| Whether a partial match is an error or a best-effort result | ask |
| Whether ordering, grouping or key casing is preserved or canonicalized | ask |

**Structure is yours. Semantics are theirs.**

Take a default without asking **only** when the decision is genuinely
implementation-level, or when an established repository convention already
implies the behavior.

## The two traps

Both of these defeated earlier versions of this gate in practice.

**Reversibility is not the test.** A new function's contract is trivially
reversible, because nothing calls it yet. That makes it cheap to change, not
yours to choose. Cost of change and ownership are different questions, and
"easy to change later" will let every semantic decision through.

**A plausible name is not a specification.** A descriptive name suggests a
conventional implementation, and you can usually produce one. It does not say
which inputs that implementation accepts, which it rejects, how it normalizes
what it takes, what it does at the boundaries, or what happens when input does
not fit. Every one of those is a decision the name left open.

Inferring a contract from a name is inventing it. That a conventional
interpretation exists is not evidence the user wanted that one, and the
strength of your intuition about what the function "obviously" does is not
evidence either. The clearer the name feels, the more decisions it is hiding.

## Size does not settle the contract

A SMALL task can be underspecified. Small implementation size is not evidence
that the behavior is decided. The gate applies at every size, including
TRIVIAL if the change somehow alters observable behavior.

## Tests come after the contract, not instead of it

A test asserts an expected value, so writing one decides the contract. If the
contract was never settled, the test settles it silently, and a suite of them
makes the decision look authoritative afterwards.

Fifteen tests against an invented contract is not thorough. It is fifteen
assertions the user never agreed to.
