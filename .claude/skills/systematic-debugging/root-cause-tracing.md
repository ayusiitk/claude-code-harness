# Root Cause Tracing

Reference for `systematic-debugging`, Phase 3. Read when you can see a wrong
value but not where it came from.

## The technique

Work backwards from where the symptom appears to where the wrong value was born.
The bug is almost never at the crash site; the crash site is where the wrong
value finally met code that could not tolerate it.

1. At the symptom, name the wrong value precisely: what it is, what it should be.
2. Find where that value entered this scope: a parameter, a return, an attribute.
3. Move one frame back and repeat.
4. Stop when you reach the point where a correct input produced an incorrect
   output. That is the root.

The temptation at every step is to fix it where you are standing. Note the
candidate and keep walking.

## Making the walk cheap

**Bisect the pipeline.** For a chain of transforms, assert the invariant halfway
through. Correct there means the bug is downstream; wrong means upstream. Repeat.

```python
data = load(path)
assert all(r.ts.tzinfo for r in data), "tz lost before normalise"
data = normalise(data)
```

**Fail at birth, not at use.** A temporary assert or exception where the value
is created gives you a traceback from the real origin:

```python
def set_window(self, end):
    if end is None:
        raise AssertionError("window end set to None")   # temporary
    self._end = end
```

**Bisect history.** If it used to work, `git bisect run <command>` with the
Phase 0 red-capable command finds the commit mechanically. This is often faster
than reading code, and it names the change rather than your guess about it.

**Bisect the diff.** If the failure appeared in uncommitted work, revert half
the hunks and re-run.

## Reading a Python traceback

The deepest frame is where it broke, not where it went wrong. Read from the top
down: the first frame in your own code is usually the closest to the cause.

`raise ... from e` and the `__cause__` chain matter. "During handling of the
above exception, another exception occurred" means the second exception is
probably masking the first. The first one is the interesting one.

## Values that arrive wrong from far away

| Symptom | Where the value is usually born |
|---|---|
| `None` where an object was expected | An early return, a `dict.get` with no default, an unassigned branch |
| Naive datetime among aware ones | A parse or a literal missing `tzinfo`, often at an I/O boundary |
| Mutated shared state | A default argument (`def f(x=[])`), a class attribute, a cached instance |
| Off-by-one at a boundary | Inclusive versus exclusive disagreement between two functions |
| Correct value, wrong type | A serialization round trip that stringified it |
| Stale value | A cache with no invalidation, or a bound method captured early |

## Stop conditions

You have the root cause when you can say: **given this input, this function
produces this wrong output, because of this line.** If your explanation contains
"somehow" or "it seems to", you are not there yet.

You have gone too far when you are explaining why a correct upstream value is
correct. Come back one frame.
