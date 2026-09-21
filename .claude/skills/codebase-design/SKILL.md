---
name: codebase-design
description: Use when deciding where code should live, naming a module or function, designing an interface between components, or when a test is hard to write because a unit has too many collaborators. Also use when a change requires edits in many files at once.
---

# Codebase Design

## Overview

**Core principle:** prefer deep modules. A deep module has a small interface and
a lot of behavior behind it. A shallow module has a wide interface and barely
earns its own existence.

Depth is the ratio, not the size. A hundred-line function behind one clear name
is deep. A ten-line class with six configuration parameters is shallow.

## The vocabulary

**Interface** here means the surface a caller must understand: the names, the
parameters, the return shapes, the error cases, the ordering requirements, the
things you must know but that are not in the signature. It is not Python's
`Protocol` or an abstract base class, though those are ways to express one.

The cost of a module is its interface. The value is the behavior it hides. A
good module has a small cost and a large value.

**Seam** is a place where you can substitute one implementation for another
without editing the code around it. Seams are what make code testable, so a
codebase with no seams is a codebase that needs heavy mocking.

## Signals a module is too shallow

| Signal | What it means |
|---|---|
| Callers must call two functions in order | The ordering is part of the interface. Hide it behind one. |
| A parameter exists only to be passed through | The caller is doing the module's job. |
| Callers repeatedly do the same thing after calling | That work belongs inside. |
| Many boolean flags changing behavior | Two or three functions wearing a trenchcoat. |
| Renaming would require reading the body | The name does not describe the behavior. |
| The docstring is longer than the body | The interface costs more than it hides. |

## Signals a module is too deep

Rarer, and usually easier to fix:

- The name needs "and" to be accurate
- Two callers each use a disjoint half of it
- It changes for two unrelated reasons

## Pass the whole thing, or pass what you need

Take the narrowest thing that does the job. A function that needs a timezone
should not take a `User`.

```python
# Wide: needs the whole user to read one attribute, and cannot be tested
# without constructing one
def format_due(order, user): ...

# Narrow: obvious to call, trivial to test
def format_due(due_at: datetime, tz: ZoneInfo) -> str: ...
```

The exception is when the narrow version would take five parameters that always
travel together. Then the group is a concept; give it a name and a type.

## Seams in Python

Prefer, in order:

1. **A parameter with a sensible default.** `def charge(order, *, now=datetime.now)`
2. **A `Protocol`** when several implementations must be interchangeable and you
   want the type checker to agree.
3. **An abstract base class** when you also need shared behavior, not just a
   shape.
4. **Module-level patching.** A last resort, for code you do not own.

```python
class RateSource(Protocol):
    def latest(self, base: str) -> dict[str, float]: ...

def convert(amount: float, frm: str, to: str, *, rates: RateSource) -> float:
    return amount * rates.latest(frm)[to]
```

`Protocol` is structural: a class satisfies it by shape, with no inheritance and
no import. That keeps the dependency pointing the right way.

## Dependencies point inward

Domain logic should not import the web framework, the ORM, or the HTTP client.
Push those to the edges and let the core take plain values and protocols. This
is what makes the core testable without machinery, and it is usually the reason
a test needs three mocks.

## When a change touches many files

That is a design signal. Either a concept is missing (the same idea is spelled
out in eight places instead of named once), or a boundary is in the wrong place
(one idea is split across modules that must change together).

Prefer naming the missing concept over adding a parameter to eight functions.

## Do not generalize early

Two similar things are not a pattern. Wait for the third before extracting an
abstraction, because the wrong abstraction costs more than the duplication it
removed: it has to be un-abstracted before anything can move.

## Red Flags

| Thought | Reality |
|---|---|
| "I'll add a flag for this case" | Flags multiply. Consider a second function. |
| "The caller can handle that" | If every caller handles it, it belongs inside. |
| "I'll make it configurable" | Configuration is interface. Only if someone needs it. |
| "This needs three mocks to test" | The design is telling you something. Fix the seam. |
| "I'll extract a base class for these two" | Wait for the third. |
| "It's cleaner as a separate module" | Only if the interface is smaller than the behavior. |
| "I'll pass the request object down" | Take the two fields you need. |

## Checklist

- [ ] The interface is smaller than the behavior it hides
- [ ] The name describes what it does without reading the body
- [ ] Parameters are the narrowest things that do the job
- [ ] No required call ordering leaking to the caller
- [ ] Domain logic does not import edge concerns
- [ ] No abstraction extracted from fewer than three cases
