# Writing Good Tests

Reference for `test-driven-development`. Read when a test is hard to write, when
a test keeps breaking for the wrong reasons, or when deciding what to assert.

## What a good test is

A good test states a behavior someone cares about, in a name you could read in a
failure report and know what broke.

```python
def test_expired_token_is_rejected():
    ...
```

Not `test_auth`, not `test_token_2`, not `test_works`.

## Test the behavior, not the implementation

The test should survive a rewrite of the code it covers. If you can refactor
without changing behavior and the test breaks, the test was coupled to the
implementation.

```python
# Coupled: asserts on internals
def test_cache():
    c = Cache()
    c.get("k")
    assert c._misses == 1

# Behavioral: asserts on what a caller observes
def test_cache_recomputes_after_eviction():
    calls = []
    cache = Cache(maxsize=1, loader=lambda k: calls.append(k) or k.upper())
    cache.get("a")
    cache.get("b")      # evicts "a"
    cache.get("a")
    assert calls == ["a", "b", "a"]
```

## Vertical slices, not horizontal layers

Prefer one test that exercises a real path through the code over three tests
that each check one layer in isolation. A slice through parser, validator and
store catches the integration bugs that three isolated tests each miss.

Split into layers only when the slice becomes too slow or too noisy to localize
failures.

## One behavior per test

Multiple asserts are fine when they describe one behavior from different angles.
They are not fine when the test is really three tests sharing a body: the first
failure hides the rest.

## Anti-patterns

| Pattern | Why it hurts | Instead |
|---|---|---|
| Tautological test | Asserts the code does what the code does, usually by reimplementing it in the test | Assert a concrete expected value |
| Implementation-coupled | Reaches into private attributes or asserts call counts on internals | Assert on observable output |
| Mock-asserting | `assert mock.call_count == 3` is a claim about the mock, not the code | Assert the effect the calls produce |
| Horizontal slicing | Every layer tested alone, integration untested | One vertical slice through the real path |
| Shared mutable fixture | Tests pass alone, fail together, or depend on order | Fresh state per test |
| Conditional assertions | `if x: assert ...` silently skips when the branch is not taken | Two tests, or parametrize |

## Fixtures

Use fixtures for setup that is genuinely shared and genuinely inert. Prefer
function scope; a `scope="module"` fixture holding mutable state is how order
dependence gets in.

```python
@pytest.fixture
def store(tmp_path):
    return FileStore(tmp_path / "data.json")
```

`tmp_path` and `monkeypatch` are the two built-ins worth reaching for first:
they give real behavior with automatic cleanup, which beats a mock.

## Parametrize instead of looping

```python
@pytest.mark.parametrize(
    "raw,expected",
    [("Hello World", "hello-world"), ("  a  b ", "a-b"), ("Ünïcode", "unicode")],
)
def test_slugify(raw, expected):
    assert slugify(raw) == expected
```

Each case reports as its own test, so a failure names the input.

## Asserting on errors

```python
def test_rejects_negative_quantity():
    with pytest.raises(ValueError, match="quantity must be positive"):
        Order(quantity=-1)
```

Match the message. `pytest.raises(ValueError)` alone passes on any `ValueError`,
including one from a typo on an unrelated line.

## Testing the negative cases

Especially under the risk overlay. For anything guarded, the happy path is the
least interesting test:

- denied: wrong user, wrong role, no credential
- expired: stale token, lapsed session
- replayed: same request twice, idempotency
- concurrent: two writers, lost update
- malformed: absent field, wrong type, oversized input

## When the test is hard to write

Read the difficulty as a design signal:

| Symptom | Likely design problem |
|---|---|
| Needs many mocks to construct | Too many collaborators; the seam is too wide |
| Needs monkeypatching module globals | Hidden dependency; inject it instead |
| Needs sleeps to be reliable | Time or concurrency is implicit; make it explicit |
| Needs the whole app to boot | Logic is entangled with wiring |
| Assertion is awkward to phrase | The behavior itself is not clearly defined |

Fix the design rather than escalating the test machinery.
