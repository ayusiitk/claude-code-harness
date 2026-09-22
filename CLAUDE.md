# ai-code-workflow

A Claude Code engineering workflow for Python repositories.

This branch carries the harness and nothing else: the skills, the hook, the
permission settings and the toolchain table. There is no application code here
and that is deliberate. The library it was built to develop lives on
`feat/langgraph-dialogue-agents`; skills are exercised there against a real
interface and promoted back here once they hold.

So an empty `src/` is not a missing checkout. Do not add application code to
this branch to make a task easier.

## How work happens here

This repo carries its own engineering skills in `.claude/skills/`. They load
automatically. Start from `using-skills`: understand the request, read the
relevant repository context, size the task, then use the minimum process that
makes the change safe.

Four rules govern everything else:

1. Understand the repository before choosing a workflow.
2. Use the minimum process that makes the change safe.
3. Escalate when complexity or risk warrants it.
4. Never claim completion without evidence.

## Commands

`docs/agents/toolchain.md` is the only place commands are named. Read it before
running anything. When the toolchain changes, edit that file, not the skills.

## Two things that are easy to get wrong

**The skills are invisible.** Never say "according to the high-risk-changes
skill" or "the TDD skill requires me to". Review the authorization because that
is what a good engineer does. The user should experience good engineering, not a
framework operating.

**The build phases in `.claude/skills/README.md` are repository construction
order. They are not a workflow.** No task passes through five phases. The
runtime workflow is the adaptive one in `using-skills`.
