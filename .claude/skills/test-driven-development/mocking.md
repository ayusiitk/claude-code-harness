# Mocking

Reference for `test-driven-development`. Read before introducing a mock, or when
a test needs more than one.

## The default is not to mock

A mock replaces real behavior with an assumption. Every mock is a place where
the test can pass while production breaks, because the assumption drifted.

Reach for these first, in order:

1. **The real thing.** Pure functions, in-memory structures, `tmp_path` for
   files. Fast and honest.
2. **A real lightweight substitute.** SQLite instead of Postgres, an in-memory
   queue, a local HTTP server.
3. **A fake you wrote.** A small class implementing the same protocol with real
   behavior. Reusable across tests and it catches interface drift.
4. **A stub.** Returns canned values, asserts nothing.
5. **A mock.** Only when the real thing is impossible, slow, or has side effects
   you must not cause.

## Mock at the boundary you own

Mock your own abstraction, not someone else's library internals.

```python
# Fragile: couples the test to requests' internals
mocker.patch("requests.Session.request", return_value=...)

# Durable: your own seam
class FakeRates:
    def latest(self, base): return {"EUR": 0.9}

def test_converts_with_current_rate():
    assert convert(100, "USD", "EUR", rates=FakeRates()) == 90
```

If there is no seam to mock at, that is the finding. Add the seam.

## Never assert on the mock

```python
# Asserts the test's own setup
assert mock_sender.send.call_count == 1

# Asserts the behavior a user would notice
assert outbox.messages == [Message(to="a@example.com", subject="Reset")]
```

Call counts are a claim about how the code is written. Effects are a claim about
what it does. Only the second survives a refactor.

The exception is when the call *is* the behavior: "does not charge the card
twice" is legitimately a statement about call count. Say so in the test name.

## Prefer injection over patching

```python
# Patching: couples the test to the import path
mocker.patch("myapp.billing.clock.now", return_value=FIXED)

# Injection: the dependency is visible in the signature
def charge(order, *, now=datetime.now): ...

def test_charges_use_request_time():
    charge(order, now=lambda: FIXED)
```

`monkeypatch` is the right tool for environment variables, `sys.path`, and
module-level config you do not own. It is the wrong tool for your own
collaborators.

## Time, randomness, IDs

Do not patch them. Inject them.

```python
def test_token_expires_after_an_hour():
    issued = datetime(2026, 1, 1, tzinfo=timezone.utc)
    token = issue(user, now=lambda: issued)
    assert not token.valid_at(issued + timedelta(hours=1, seconds=1))
```

The same applies to `uuid4` and `random`: take a factory argument with a real
default.

## Async

Use `unittest.mock.AsyncMock` for coroutines, never a plain `Mock` — a plain
`Mock` returns a non-awaitable and fails in a way that does not name the cause.
Better still, write a small async fake with real behavior.

Never use `sleep` to wait for something. Wait for the condition: poll with a
deadline, or await the event the code exposes. A sleep-based test is either slow
or flaky, usually both, and it hides the race it was meant to catch.

## Too many mocks means fix the design

Three or more mocks to construct one test is a design signal, not a test
problem. The unit has too many collaborators.

**REQUIRED BACKGROUND:** You must understand codebase-design.

## Red Flags

| Thought | Reality |
|---|---|
| "I'll just mock it for now" | The assumption outlives the "for now". |
| "Mocking is faster than a real object" | Usually true and usually irrelevant at this scale. |
| "I need to patch the import path" | You need a parameter. |
| "Assert it was called correctly" | Assert what the call produced. |
| "The real dependency is too complex to set up" | Then the seam is in the wrong place. |
| "A sleep will make this reliable" | A sleep makes it slow and still flaky. |
