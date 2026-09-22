# Working with the harness

> **This file is for the human, not the agent.** It is a user manual, and the
> example prompts in it are illustrations, never tasks. If you are an agent
> reading this for repository conventions, there are none here. Read
> `CLAUDE.md` and `docs/agents/toolchain.md` instead.

## The mental model

**Tell the harness what you want. It decides how much engineering process that
outcome needs.**

You are not meant to operate it. If you find yourself sequencing the workflow
by hand, the harness has failed at its job.

## What belongs in your prompt

The things that are genuinely yours to decide:

- the outcome you want
- constraints that matter
- behavior that must not change
- acceptance criteria, when you know them
- security, data or product semantics
- explicit exclusions
- external side effects you do or do not want

```
Add password reset.

Users receive an email with a one-time reset link. Links expire after 30
minutes. Existing sessions stay valid. Do not change the login flow.

Don't send real emails in development.
```

That is a good prompt. It says nothing about files, tests, or process.

## What does not belong in your prompt

Leave these alone unless you specifically want to constrain them:

| Don't specify | Why |
|---|---|
| Which files to edit | It reads the repo first |
| Whether to write a helper, use a regex, pick a data structure | Implementation is delegated |
| Whether this is SMALL or LARGE | Classification is its job |
| Whether it needs a plan, tests, or review | Process scales automatically |
| How to order the implementation steps | That is what a plan is for |

Saying "use TDD, then brainstorm, then plan, then review" defeats the point.
You have just become the workflow engine.

## Vague is allowed. Unspecified behavior is not.

These are different things, and the distinction is the core idea here.

**A large request can be vague and still be valid.** "Build a notification
system for this app" is a fine starting point. The harness should inspect the
repo, recognise it as LARGE, and open a design conversation. It should not
demand a specification before helping.

**A small request with unresolved observable behavior is not valid**, however
short it looks. `Add parse_version()` leaves accepted formats, normalization,
and invalid-input behavior undecided. The harness should surface those and ask
rather than invent them.

| | Behavior specified | Behavior unspecified |
|---|---|---|
| **Small** | implement | **ask** |
| **Large** | design, spec, plan, execute | discovery, then design |

Size determines how much process. Unresolved behavior determines whether it can
start at all.

## Prompts by kind

**Understand only**
```
How does session expiry work in this codebase?
```

**Trivial**
```
Fix the typo in README.md.
```

**Small bug**
```
Fix the bug where expired sessions are still accepted.
```

**Normal feature**
```
Add CSV export to the reports page. Keep the existing JSON API unchanged.
```

**Large and deliberately broad**
```
I want this application to support team invitations. Start by understanding
the current architecture and help me work out the design before implementing
anything.
```

**Security sensitive**
```
Allow admins to view other users' invoices. Only admins. Everyone else must
get the same 404 they get today for an invoice that isn't theirs.
```

**Debugging**
```
The auth tests pass alone and fail in the suite. Find out why.
```

**Refactoring**
```
Split the billing module. Behavior must not change.
```

**Review**
```
Review the changes on this branch.
```

**Plan only, no edits**
```
Work out how you'd add rate limiting. Don't write any code yet.
```

## What to expect back

| Your request | Expected shape |
|---|---|
| Typo | edit, verify, done |
| Bug fix | inspect, contract, test, fix, verify |
| Feature | inspect, contract, design, implement, review, verify |
| Subsystem | inspect, brainstorm, spec, plan, execute, review, verify |
| "Not sure what I want yet" | design conversation |
| Unspecified behavior | contract block showing UNRESOLVED, then a question |
| Security, data, migration | the above plus risk treatment |

A trivial change should look like:

```
TRIVIAL: documentation-only change.
Contract: no observable behavior changes.
```

and then just happen.

A new API should look like:

```
SMALL: isolated new behavior.

Contract
| Decision | Source |
|---|---|
| accepted inputs        | REQUEST    |
| invalid input behavior | UNRESOLVED |
```

and then stop and ask one question.

## Signs it is doing too much

This is the section worth rereading. Any of these means the harness is wrong,
not you:

- A typo produces a design discussion
- A small, fully specified change produces a planning document
- A large ambiguous request produces immediate code
- It asks permission for something it could have decided
- It names a skill in its output
- It emits a contract block for a change that alters no behavior
- It explains its methodology instead of doing the work

## Signs it is doing too little

- It invents externally observable behavior instead of asking
- It claims something passes without showing the command output
- It edits a one-line authorization check as ordinary work
- It writes tests for behavior nobody specified

## Using this in another repository

Working in *this* repo needs nothing: `.claude/` is already here.

To use the harness on real work, the skills have to be visible to that
project. Claude Code reads project skills from `.claude/skills/` and personal
skills from `~/.claude/skills/`.

**Project-local, pinned.** Copy `.claude/skills/`, `.claude/hooks/` and
`.claude/settings.json` into the target repo, plus `docs/agents/toolchain.md`
with that project's real commands. Reproducible for anyone who clones it, and
the version is pinned by that repo's history. Prefer this for real work.

**Global.** Copy the skill directories into `~/.claude/skills/`. Available
everywhere without per-repo setup, but invisible to collaborators and
unversioned, and the SessionStart hook is not installed, so orientation is
weaker.

There is no installer. Copying two directories does not yet justify one.
