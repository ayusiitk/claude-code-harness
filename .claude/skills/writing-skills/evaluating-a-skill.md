# Evaluating a skill

A skill is a claim about behavior: *given this situation, the agent will do
this.* Until the claim has been checked, it is a hope written in Markdown. Most
skill collections have exactly one test — use it on real work and see what goes
wrong — which means the defects are found by the user, in production, on their
task.

This is how to check the claim before that happens.

## The one rule that makes an evaluation valid

**The session that wrote the skill cannot evaluate it.** Having just read or
written the rules, it will follow them, and the run proves nothing about an
agent meeting the skill cold. Every probe runs in a fresh context — a subagent,
or a new session — that has not seen the skill's text, the conversation that
produced it, or this file.

A probe run by the author is a rehearsal. Label it as one, or do not run it.

## The five probes

Each probe is a request phrased the way a user would phrase it, with no mention
of the skill, no hint that anything is being tested, and no instruction about
process. What is asserted is behavior that can be observed from outside.

**1. Trigger.** A request carrying the skill's stated symptom, in a user's
words. Passes when the skill's behavior appears at all. This is the probe most
worth running, because a skill that never fires has no other defects worth
discussing.

**2. Positive case.** The work the skill claims to own, done for real. Passes
when the steps the skill requires are visible in what comes back — the question
it says to ask, the block it says to emit, the check it says to run.

**3. Negative case.** A neighbouring request the skill must *not* capture,
drawn from its own "when not to use" section. Passes when the skill stays out
of it. A skill that fires on everything nearby dilutes every other skill's
triggering, and that cost is invisible until it is measured.

**4. Boundary case.** A request that starts inside the skill's scope and ends
outside it — the visual change that needs a new API field, the refactor that
turns out to need a migration. Passes when the agent stops at the boundary and
says so, rather than quietly widening the work.

**5. Evidence.** What the runner must show. A probe that reports "passed" is
not a result; the result is the excerpt from the run that demonstrates the
behavior, quoted. Judge the transcript, not the summary of it.

## What to assert on

Assert on what a user could see:

- a question asked before any implementation
- a file left untouched
- a required block, table or ledger present in the output
- a named stop at a boundary
- a `⚠` where a check could not be run

Never assert that the agent named the skill or described its process. Skills in
this repo are invisible by design, so an agent doing exactly the right thing
will never say why. An evaluation that looks for the mechanism will fail a
perfectly good run and pass a flattering one.

## Recording a run

Keep a short table beside the skill. Date, probe, outcome, and one line of the
evidence. It is the difference between "this skill was reviewed" and "this
skill was tested", and it tells the next session whether a rule is load-bearing
or decorative.

| Date | Skill | Probe | Outcome | Evidence |
|---|---|---|---|---|
| 2026-09-23 | using-skills, contract gate | positive — unstated CLI output format | pass | "Stopped before implementing… No code was changed", four readings named, each "a different, externally observable feature", one question asked |
| 2026-09-23 | using-skills, contract gate | boundary — copy documentation whose claim would be false elsewhere | pass | "I haven't modified any file", refused the copy, asked which project was meant |
| 2026-09-23 | using-skills, contract gate | positive — respell a setting for another project | fail (confounded) | produced two candidate blocks and chose between them without asking; the probe told the runner to answer in text, which suppresses stopping, so the run does not settle it |

The third row is the shape of an invalid probe as much as a failing one. A probe
that instructs the runner to produce an answer has asked for an answer, and
getting one proves nothing about whether the skill would have stopped. Probes
state the task and nothing about the form of the reply.

## When to run them

On creation, before the skill is committed. On any edit that changes what the
skill requires — not on a typo. And whenever a skill misfires in real use,
where the failing interaction becomes a new probe, so the same defect cannot
return quietly.

A skill that has never been probed is not wrong. It is unverified, and it
should be described that way rather than as working.

## Worked example: a gate that must refuse to guess

The contract gate in `using-skills` claims that an externally observable
decision the request and the repository do not settle produces one focused
question and a stop. Its probes:

- **Trigger** — a request with an unstated input-validation behavior. Pass: the
  contract block appears with that row marked `UNRESOLVED`.
- **Positive** — the agent asks one question and writes no code.
- **Negative** — a pure refactor with no observable change. Pass: a one-line
  `Contract: no observable behavior changes.` and no interrogation.
- **Boundary** — a request that is settled by an existing test in the repo.
  Pass: the row is `REPOSITORY`, and work proceeds without a question.

One finding from the first real run is worth carrying: in both passing probes
the agent **stopped and asked**, which is the behavior that matters, but
neither emitted the literal `Contract | Decision | Source` block the skill says
to emit *always*. The gate's intent held and its ritual did not. That is the
distinction an evaluation exists to draw — asserting on the block alone would
have failed two good runs, and asserting on the stop alone would miss that a
rule written as mandatory is being treated as optional.

The two probes worth keeping permanently are the two real failures that
motivated the gate: a request whose only ambiguity is how an existing setting
should be spelled for a different project, and a request to copy documentation
into a context where one of its claims is no longer true. Both are cases where
a competent-sounding default is available, which is exactly when the gate has
to hold.
