# Toolchain

**This file is the single source of truth for what commands to run in this repo.**

Skills never hardcode commands. They say "run the project's test command as
recorded in `docs/agents/toolchain.md`" and read this table. When the toolchain
changes, edit this file. Do not edit skills.

| Purpose | Command | Status |
|---|---|---|
| All tests | `pytest` | provisional |
| One test | `pytest <path>::<name> -v` | provisional |
| Tests, quiet | `pytest -q` | provisional |
| Lint | `ruff check .` | provisional |
| Format | `ruff format .` | provisional |
| Type check | `mypy src` | provisional |
| Install deps | not yet chosen | provisional |

## Status meanings

- **provisional** — the conventional default for a Python library, but nothing
  in this repo installs or configures it yet. Before relying on a provisional
  row, check that the tool is actually available; if it is not, say so in the
  verification report with a `⚠` line rather than claiming it passed.
- **authoritative** — chosen, installed, and configured for this repo. Trust it.

## When you change this file

Flip a row to **authoritative** the moment the tool is actually wired up
(dependency declared, config present, command verified to run). That is the
signal to every future session that the command can be trusted.
