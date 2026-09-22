---
name: writing-skills
description: Use when creating a new skill, editing an existing skill, or deciding whether a new skill should exist at all. Also use when a skill is not triggering when it should, is triggering when it should not, or when two skills seem to cover the same moment.
---

# Writing Skills

## Overview

Skills in this repo exist to make the agent behave like a strong senior engineer
by default. They are not documentation and they are not a framework the user
operates.

**Core principle:** a skill earns its place by changing behavior at a decision
point nothing else owns.

## The invariant

> **No two skills own the same decision point.**

Skill count is not a target. Eleven is fine. Sixteen is fine if each one earns
it. What is not fine is two skills giving advice about the same moment, because
then the agent has to arbitrate between them mid-task and the user watches it
happen.

## Before adding a skill

Answer all four. The default answer is no.

1. Is this genuinely new behavior?
2. Does an existing skill already own this decision point?
3. Can the capability be folded into an existing skill instead?
4. Does it measurably reduce user friction or improve outcomes?

A new skill is justified by **a real task that demonstrated a recurring failure
the existing system did not handle**. It is not justified by the idea that it
might help. Resist the temptation to proliferate: a skill landfill is worse than
a small sharp set, because every skill dilutes the triggering of every other.

## Frontmatter

Exactly these fields. Nothing else.

| Field | Required | Rule |
|---|---|---|
| `name` | yes | equals the directory name; letters, digits, hyphens only |
| `description` | yes | see below |
| `argument-hint` | no | only if the skill takes an argument |

Whole frontmatter block must stay under 1024 characters.

`disable-model-invocation` is **not used by any skill in this repo**. Every skill
must be enterable by the model on its own, including the workflow transitions.
The user should never have to name a skill to get good engineering.

### Writing the description

The description is the only thing the model sees when deciding whether to load
the skill. It describes **when to use, never what the skill does**.

- Start with "Use when…"
- Name specific symptoms, situations, and triggers
- Keep it under 500 characters
- Never summarize the skill's process or workflow. If the description explains
  the method, the model thinks it already knows the method and skips the skill.

Good: `Use when encountering a bug, a failing test, or behavior that does not
match expectations, before proposing any fix.`

Bad: `A four-phase debugging process that reproduces, isolates, hypothesises and
verifies.` That is what it does, and it is a summary the model will substitute
for reading the skill.

## Structure

```
.claude/skills/
  skill-name/
    SKILL.md              # required
    supporting-file.md    # only when justified below
```

Flat namespace. No category directories.

**Split into a sibling file when:** the reference is over roughly 100 lines, or
it is a reusable template or prompt that gets handed to a subagent.

**Keep inline when:** it is a principle, a rule, or a code pattern under about
50 lines. Everything else stays inline.

Sibling files are reached by a relative Markdown link from `SKILL.md`, so they
load only when the agent actually needs them.

## Body shape

```markdown
---
name: skill-name
description: Use when [triggering conditions and symptoms]
---

# Skill Name

## Overview
What this is, and the core principle in one or two sentences.

## When to Use
Symptoms and situations. When NOT to use.

## [The actual content]
Rules, patterns, before/after comparisons.

## Red Flags
Two-column table: the rationalizing thought, and the reality.

## Checklist
- [ ] Checkable items, each with an explicit completion criterion.
```

Not every section is required. `## Overview` and the content are.

### Red Flags tables

Agents rationalize their way out of discipline. A two-column *Thought → Reality*
table catches that cheaply, because the model recognises its own excuse in the
left column. Use one wherever a skill has a rule the model will be tempted to
skip.

| Thought | Reality |
|---|---|
| "This is too simple to need the skill" | Simple things become complex. The check costs seconds. |

## Rules that keep the system coherent

### The skills are invisible

Never write an instruction that makes the agent narrate the skill system.

- Bad: `Announce at start: "I'm using the writing-plans skill."`
- Bad: `Tell the user you are invoking this skill.`
- Good: nothing. The agent just does the work.

The user should experience good engineering, not a framework operating. The one
exception is the terse size and risk line that `using-skills` requires, and that
names the classification, not the skill.

### Cross-references are prose, not links

Reference another skill by name with an explicit requirement marker:

- Good: `**REQUIRED SUB-SKILL:** Use test-driven-development`
- Good: `**REQUIRED BACKGROUND:** You must understand systematic-debugging`
- Bad: `See .claude/skills/test-driven-development/SKILL.md` — unclear whether required
- Bad: `@.claude/skills/test-driven-development/SKILL.md` — force-loads the file
  immediately and burns context before it is needed

Never link into another skill's directory with a relative path either. Relative
links are for a skill's *own* sibling files only.

### No process recursion

A skill may invoke another skill **only when that skill owns the next decision
point**. Never restart the workflow from the beginning.

Once a workflow stage is complete, do not re-enter it unless new information
invalidates its output, and when that happens, say what the new information was.

### Tooling stays out of skills

No skill hardcodes a command. Write "run the project's test command as recorded
in `docs/agents/toolchain.md`". That file is the single source of truth, so a
toolchain change edits one file instead of fifteen.

### Examples are Python

This is a Python repo. Every code example is Python, tests are pytest. No
TypeScript, no npm, no Graphviz `dot` blocks (they cost context and render as
nothing in a terminal — use a numbered list instead).

Keep *triggers* technology-agnostic though: describe the problem (race
condition, inconsistent state) rather than a language-specific symptom.

## Test the skill before trusting it

A skill is a claim about behavior, and an untested claim is a hope. Probe it
with a request phrased the way a user would phrase it, in a context that has
not read the skill — a subagent or a fresh session — and judge what comes back,
not what the skill says should come back.

**The session that wrote the skill cannot evaluate it.** It has just read the
rules and will follow them, which proves nothing about an agent meeting the
skill cold. Author-run probes are rehearsals and get labelled as such.

Five probes: does it fire at all, does it do the work it claims, does it stay
out of the neighbouring request it should not take, does it stop at its own
boundary, and what excerpt proves each of those. Assert on behavior a user
could see — a question asked, a file untouched, a required block present. Never
assert that the agent named the skill: the invisibility rule means a perfect
run never will.

The procedure, what to assert on, how to record a run, and a worked example:
[evaluating-a-skill.md](evaluating-a-skill.md)

A skill nobody has probed is not wrong. It is unverified, and saying it works
is the same overclaim as reporting a test suite that never ran.

## Red Flags

| Thought | Reality |
|---|---|
| "This deserves its own skill" | Answer the four questions first. Default is no. |
| "I'll add a skill for this edge case" | Edge cases fold into the skill that owns the decision. |
| "The description should explain the method" | Then the model skips the skill, believing it already knows. |
| "I'll link the other skill's file so it's handy" | That force-loads it. Name the skill in prose. |
| "More skills means more capability" | More skills means worse triggering for all of them. |
| "I read it back and it looks right" | You wrote it. Probe it from a context that did not. |
| "It worked when I used it just now" | That run was primed. An author-run probe is a rehearsal. |
| "The agent said it followed the skill" | Skills are invisible. Assert on behavior, never on self-report. |
| "I'll have it announce which skill it's using" | That is workflow theater. The user wants the work, not the mechanism. |

## Checklist

When adding or editing a skill:

- [ ] All four gate questions answered, and the answer was yes
- [ ] No existing skill owns this decision point
- [ ] `name` matches the directory name exactly
- [ ] `description` starts with "Use when", is under 500 characters, and names
      triggers rather than method
- [ ] Frontmatter under 1024 characters, no `disable-model-invocation`
- [ ] No instruction to announce the skill
- [ ] Cross-references are prose with a requirement marker, no `@` or paths
- [ ] Commands deferred to `docs/agents/toolchain.md`
- [ ] Examples are Python and pytest
- [ ] Reference over ~100 lines moved to a sibling file
- [ ] Probed from an unprimed context: fires, does the work, stays out of the
      neighbouring request, stops at its own boundary
- [ ] Probe evidence recorded, or the skill described as unverified rather than working
- [ ] Row added to `.claude/skills/README.md` with provenance
