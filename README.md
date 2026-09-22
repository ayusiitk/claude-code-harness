# ai-code-workflow

A Claude Code engineering workflow for Python repositories.

## What is in here right now

**This branch is the harness on its own, and deliberately so.** It carries the
engineering skills in `.claude/skills/`, the hook, the permission settings and
the toolchain table — and no application code. The library this workflow was
built to develop lives on `feat/langgraph-dialogue-agents`, where the skills
are exercised against something real and then promoted back here.

What that buys you is a branch you can read, copy into another project, or
clone without inheriting a LangGraph application you did not ask for.

A set of engineering skills in `.claude/skills/` that make Claude Code behave
like a strong senior engineer by default, without turning you into a workflow
operator.

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

## The contract idea

Before writing tests or implementation, the agent emits a small block naming
each externally observable decision and where it came from:

```
Contract
| Decision | Source |
|---|---|
| accepted inputs        | REQUEST    |
| invalid input behavior | UNRESOLVED |
```

`REQUEST` means you said so. `REPOSITORY` means existing code settles it.
`UNRESOLVED` means neither, and the agent stops and asks rather than inventing
an answer.

A function name is not a source. Neither is a common convention, nor a
sensible default the agent chose and announced. This exists because an agent
asked for `parse_version()` will otherwise decide for itself which formats are
valid and what invalid input does, then encode all of it in tests, and you will
not find out until you read them.

## Authorization: changes need your approval

Sessions start in plan mode, unless a higher-precedence settings file or a
`--permission-mode` flag says otherwise. The agent can read files, search, and
run the commands the allow list names — the whole suite, the lint check and the
type check — but a change to the repository needs your approval, and so does
every other row in `docs/agents/toolchain.md`, including the single-test form
that carries a flag. It assesses and proposes; you approve; then it implements.

**The mode decides whether any of that applies.** The allow list is consulted
by the modes that gate tool use; a session started outside plan mode is not
being held by this list, because nothing is asking. What does survive the mode
is the `ask` list, which is why the container rules are written there rather
than left to plan mode to catch.

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

## Using it in this repo

```
git clone https://github.com/ayusiitk/ai-code-workflow
cd ai-code-workflow
claude
```

`.claude/` is already here. Give it work in plain language.

## Using it on real work

The skills have to be visible to that project. Claude Code reads project skills
from `.claude/skills/` and personal skills from `~/.claude/skills/`.

- **Project-local (preferred):** copy `.claude/skills/`, `.claude/hooks/` and
  `.claude/settings.json` into the target repo, plus `docs/agents/toolchain.md`
  with that project's real commands. Versioned, reproducible, shared with
  collaborators.
- **Global:** copy the skill directories into `~/.claude/skills/`. Works
  everywhere, but unversioned, invisible to collaborators, and without the
  SessionStart hook.

There is no installer.

## Read this before your first real task

**[docs/agents/working-with-the-harness.md](docs/agents/working-with-the-harness.md)**
— what to put in a prompt, what to leave out, what each kind of request should
look like coming back, and how to tell when the harness is doing too much or
too little.

## Commands

`docs/agents/toolchain.md` names every command this repo uses. Rows are marked
*provisional* until the tooling is actually wired up.

## Provenance

The skills are adapted from [`mattpocock/skills`](https://github.com/mattpocock/skills)
and [`obra/superpowers`](https://github.com/obra/superpowers), both MIT. See
`NOTICE` for the licenses and `.claude/skills/README.md` for per-skill
provenance and what was changed.
