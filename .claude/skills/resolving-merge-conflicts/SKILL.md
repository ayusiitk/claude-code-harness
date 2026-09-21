---
name: resolving-merge-conflicts
description: Use when a merge, rebase, cherry-pick or stash pop stops with conflicts, when a pull request reports conflicts with its base branch, or when conflict markers appear in a file.
---

# Resolving Merge Conflicts

## Overview

**Core principle:** resolve by intent, hunk by hunk. Each side of a conflict is
somebody's change that worked. The resolution has to preserve both intents, not
pick a winner by looking at which text seems newer.

## Never abort by reflex

`git merge --abort` and `git rebase --abort` throw away the resolution work and
leave the conflict to be met again unchanged. Abort only when you have decided
the merge itself was wrong, and say so.

The same goes for `--ours` and `--theirs` applied to a whole file: they are the
"pick a winner" button, and they silently drop one side's intent.

## Before touching anything

Know what you are merging. Get oriented first:

```bash
git status                       # which files, which operation
git log --oneline HEAD..MERGE_HEAD   # what is coming in
git log --oneline MERGE_HEAD..HEAD   # what is already here
```

For each conflicted file, find out **why** each side changed it:

```bash
git log -p --merge -- path/to/file
```

That shows only the commits that touched the conflicting region from both sides.
It is the fastest way to recover intent.

## Resolve hunk by hunk

For each conflict marker, answer three questions:

1. **What was each side trying to accomplish?** Not what the text says, what the
   change was for.
2. **Are the two intents compatible?** Usually yes, and the resolution contains
   both.
3. **If they are not, which is correct now?** This is the only case that needs a
   decision, and often it needs a human.

Then write the resolution. It is frequently neither side's text verbatim: two
compatible intents often merge into a third form that expresses both.

```python
# ours: added retry
# theirs: added timeout
# resolution: both, not either
response = request(url, timeout=30, retries=3)
```

## Generated files are regenerated, never merged

Lockfiles, migrations with sequence numbers, compiled assets, API clients. Take
either side to clear the conflict, then regenerate with the project's own tool
and commit the result.

Hand-merging a lockfile produces a file that is internally inconsistent and
passes review.

## Never rewrite someone else's history

On a branch you did not create, resolve with a merge commit. No rebase, no
amend, no force-push: those invalidate every checkout anyone else has.

On a branch you created, follow whatever the repo's convention is.

## Verify the merge, not just the compile

A conflict resolution that compiles is not a resolution that is correct. Both
sides' behavior has to still work, and the tests that cover each side are the
proof.

**REQUIRED SUB-SKILL:** Use verification-before-completion

Run the project's full test command from `docs/agents/toolchain.md`. Semantic
conflicts do not produce markers: two sides can merge cleanly and still break,
when one renames what the other calls.

## When to stop and ask

> Both sides changed the same logic, and preserving either intent loses the
> other's behavior.

That is a real decision and it belongs to the humans who wrote the two changes.
Say what each side was doing and what is lost either way.

Everything else, resolve.

## Red Flags

| Thought | Reality |
|---|---|
| "I'll abort and try again" | It will conflict identically. Resolve it. |
| "I'll take theirs, it's newer" | Newer is not more correct. Read both intents. |
| "`--ours` on the whole file is faster" | It silently deletes one side's work. |
| "It compiles, so the merge is fine" | Semantic conflicts compile. Run the tests. |
| "I'll hand-edit the lockfile" | Regenerate it. Hand-merged lockfiles are broken quietly. |
| "I'll rebase to clean this up" | Not on a branch someone else has checked out. |
| "The markers are gone, so I'm done" | Markers gone means editable, not correct. |

## Checklist

- [ ] Understood what each side was trying to accomplish
- [ ] Each hunk resolved by intent, not by picking a side
- [ ] Generated files regenerated with the project's tooling, not merged
- [ ] No history rewritten on a branch you did not create
- [ ] No conflict markers left anywhere
- [ ] Full test suite run and reported, not just a compile
