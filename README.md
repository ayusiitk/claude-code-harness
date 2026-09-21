# ai-code-workflow

A general-purpose Python library.

## What is in here right now

The library itself is not written yet. What exists is the development
environment: a set of engineering skills in `.claude/skills/` that make Claude
Code behave like a strong senior engineer by default, without turning you into a
workflow operator.

Clone the repo, open Claude Code, say "build X". The agent reads the relevant
code, sizes the task, uses the minimum process that makes the change safe, and
shows you evidence before claiming it is done. You are interrupted only at
decisions that genuinely require your judgment.

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

## Commands

`docs/agents/toolchain.md` names every command this repo uses. Rows are marked
*provisional* until the tooling is actually wired up.

## Provenance

The skills are adapted from [`mattpocock/skills`](https://github.com/mattpocock/skills)
and [`obra/superpowers`](https://github.com/obra/superpowers), both MIT. See
`NOTICE` for the licenses and `.claude/skills/README.md` for per-skill
provenance and what was changed.
