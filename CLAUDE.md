## Most Important: Environment and important rules

If the session runs on a local machine, these rules should always be adhered to.

WSL is the default space to run any commands, whether git, or any other.
Docker access is provided in wsl.
Docker may already have downloaded images of some environments. If any technical tooling
is required, we should inspect if the relevant image already exists in existing docker container
and reuse it.
We never by default install in local system and always ensure a containerized
space for our experiments and tests.

Whenever this claude.md file is being edited, it should always ask for my approval.

## Tool calls
Whenever the message mentions, "use skills", workflow should visit Start from `using-skills`
 `.claude/skills/`, and then follow relevant path.


# claude-code-harness

A reusable Claude Code engineering harness: skills, a session-start hook and
permission settings, meant to be cloned or installed into any project rather
than developed against one of its own.

This repo carries the harness and nothing else — there is no application
code here, and that is deliberate. Skills get exercised for real inside
whatever project installs this harness; anything that holds up gets promoted
back here. An empty `src/` is not a missing checkout.

## Install in another project

    ./install.sh <path-to-target-repo>

Run from inside the target repo with no argument to install into `.`. See
`install.sh` for exactly what it copies, what it merges instead of
overwriting, and what it leaves alone.

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
