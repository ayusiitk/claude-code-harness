# Finding Test Pollution

Reference for `systematic-debugging`. Read when tests pass alone but fail
together, when a failure moves as tests are added or removed, or when a failure
depends on ordering.

## What pollution is

One test leaves state behind and another test reads it. The failing test is the
victim, not the culprit. Debugging the victim is wasted effort, which is why
this gets its own procedure.

## Confirm it is pollution

```
pytest tests/test_victim.py::test_name -q     # passes alone
pytest -q                                      # fails in the suite
```

That difference is the finding. Adjust command names to match
`docs/agents/toolchain.md`.

## Find the culprit by bisection

Run the suite up to and including the victim, then halve the set of tests that
run before it.

```
pytest tests/ -q -x --co -q          # list collected tests in order
pytest tests/a tests/b tests/test_victim.py -q
```

Keep halving the prefix until one test, removed, makes the victim pass. That is
the culprit.

`pytest-randomly` or `pytest -p no:randomly` is worth knowing about here: if the
suite randomizes order, the seed is printed and re-running with the same seed
reproduces the ordering. Fixing the seed turns an intermittent failure into a
deterministic one, which satisfies the Phase 0 gate.

## Common culprits

| Leak | How it happens | Fix |
|---|---|---|
| Module-level mutable | A list or dict at module scope accumulates | Function-scoped fixture, or reset explicitly |
| Class attribute | Mutated on the class rather than the instance | Instance attribute, or reset in teardown |
| Default argument | `def f(acc=[])` shares one list forever | `None` sentinel |
| Environment variable | `os.environ[...] = ...` without cleanup | `monkeypatch.setenv`, which reverts |
| Working directory | `os.chdir` with no restore | `monkeypatch.chdir`, or `tmp_path` |
| Cached singleton | `functools.lru_cache`, a module-level client | `cache_clear()` in a fixture |
| Registered handler | Signal handler, `atexit`, warning filter, logging config | Register and remove in a fixture |
| Database or file state | Rows or files left behind | Transaction rollback, or `tmp_path` |
| Patched global | `mock.patch` started but not stopped | Context manager or `monkeypatch` |
| Frozen or shifted time | A clock patched globally | Inject the clock instead |

The pattern: anything that outlives a test function can pollute. `monkeypatch`
and `tmp_path` are safe because they revert automatically.

## Fix the culprit, not the victim

Adding cleanup to the victim makes the symptom go away and leaves the leak for
the next test to find. Fix where the state is created.

If the culprit legitimately needs global state, it owns the teardown:

```python
@pytest.fixture(autouse=True)
def reset_registry():
    yield
    registry.clear()
```

## Prove it

After the fix, run the full suite, then run it again with a different ordering
seed. Pollution that only appears under one ordering is still pollution.

Report both runs.
