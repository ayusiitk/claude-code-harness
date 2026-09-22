# ai-code-workflow

A general-purpose Python library.

## What is in here right now

The library itself is not written yet. What exists is the development
environment: a set of engineering skills in `.claude/skills/` that make Claude
Code behave like a strong senior engineer by default, without turning you into a
workflow operator.

Clone the repo, open Claude Code, say "build X". The agent reads the relevant
code, sizes the task, uses the minimum process that makes the change safe, and
shows you evidence before claiming it is done. It proposes the change and waits
for your approval before editing anything; after that you are interrupted only
at decisions that genuinely require your judgment.

You never have to type `/brainstorming` or `/test-driven-development`. The
skills are implementation details of the agent's behavior, not a framework you
operate.

## How process scales

| Task | What happens |
|---|---|
| Typo | edit, verify, done |
| Small isolated change | understand, test, implement, verify |
| Feature or bug fix | + brief design, + review |
| New subsystem | + brainstorm, spec, plan, execute |
| Auth, payments, migrations, destructive ops | + blast radius, adversarial review, wider verification |

Risk is an overlay, not a size. A one-line change to an authorization check
stays small and still gets the risk treatment.

## Authorization: changes need your approval

Sessions start in plan mode, unless a higher-precedence settings file or a
`--permission-mode` flag says otherwise. The agent can read files, search, and
run the repository's verification commands, but a change to the repository
needs your approval unless the command is explicitly allow-listed for
assessment. It assesses and proposes; you approve; then it implements.

This is enforced by Claude Code's permission engine, not by the agent's good
manners. A refused command comes back as `This command requires approval` and
the turn carries on without the change. There is no tool the agent can call to
grant itself permission: approving is something you do in the client, so the
boundary cannot be argued around.

`.claude/settings.json` sets it:

```json
"permissions": {
  "defaultMode": "plan",
  "allow": ["Bash(uv run pytest -q)", "Bash(uv run mypy src)", "..."],
  "ask":   ["Bash(docker:*)", "Bash(docker-compose:*)"]
}
```

**Every allow entry is an exact command, with no trailing `:*`.** That detail is
the whole design, and getting it wrong the first time cost this repo its
boundary. A rule written `Bash(uv run pytest:*)` matches any command *starting*
with that prefix, and the flags reachable from those prefixes are not benign:

| Allowed prefix | What it also permits |
|---|---|
| `Bash(uv run pytest:*)` | `--basetemp=src` — pytest deletes the directory first, so this wipes `src/`, or `.claude/` |
| `Bash(node --check:*)` | `--import 'data:text/javascript,...'` — Node runs the import before it syntax-checks, so this is arbitrary code execution |
| `Bash(uv run ruff check:*)` | `--fix` — rewrites every source file |

All three were demonstrated against this repo's own earlier allow list. A prefix
rule cannot express "this command but not that flag", so the list names the
exact commands from `docs/agents/toolchain.md` and nothing else. Anything with
a flag on it — a single test, a different pytest invocation — prompts, which is
the correct answer rather than an inconvenience. Read-only shell commands such
as `ls`, `grep`, `find` and the read-only forms of `git` need no rule; Claude
Code already treats them as read-only.

One entry is the exception, and it is worth knowing rather than glossing. The
`node --test` rule names a JavaScript test path that exists on the
dialogue-agents line and not on this branch, so here it matches nothing and
grants nothing. It is carried verbatim so the two lines do not drift apart, and
it starts working the moment that code arrives.

The `ask` list is the other half. `deny` beats `ask` beats `allow`, and `ask`
applies whatever the mode is, so anything that starts a container prompts even
in a session that has left plan mode. That is deliberate for the browser smoke
check: it pulls images, starts containers and writes screenshots into the tree,
so it should never run unattended. The rule matches the binary rather than one
spelling of the command, because flags can be reordered and `--profile=browser`
and `--profile browser` are the same thing to Docker and different strings to a
prefix matcher.

Three things are worth knowing before you rely on this.

**Allow rules are ignored until you trust the workspace.** Run Claude Code
interactively here once and accept the trust dialog. Until you do, the rules are
skipped and every command prompts instead; Claude Code prints a warning to
stderr saying so, which is easy to miss.

**Plan mode is an authorization boundary, not a sandbox.** A command you have
allow-listed runs with your privileges, so `pytest` can write whatever a test
writes, and `pytest`, `mypy` and `uv run` itself all create or update their
caches and the project environment as they go. Nothing on the list is
guaranteed inert; what the exact-match list buys you is that the agent cannot
choose the flags, which is what turned these commands into arbitrary writes. If you want containment rather than authorization, that is sandboxing
and a separate decision.

**Approval lasts for the session, not for one change.** Approving a plan leaves
plan mode, and the session stays out of it. A second, unrelated request in that
same session is no longer gated. Start a new session, or switch the mode back,
when you want the boundary again.

To opt a single session out, start it with `--permission-mode default`.

## Commands

`docs/agents/toolchain.md` names every command this repo uses. Rows are marked
*provisional* until the tooling is actually wired up.

## Provenance

The skills are adapted from [`mattpocock/skills`](https://github.com/mattpocock/skills)
and [`obra/superpowers`](https://github.com/obra/superpowers), both MIT. See
`NOTICE` for the licenses and `.claude/skills/README.md` for per-skill
provenance and what was changed.
