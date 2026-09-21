# Skills

Adapted from two MIT-licensed upstream collections, vendored here with no
runtime dependency on either. See `NOTICE` for the licenses.

| Upstream | Vendored from commit |
|---|---|
| [`mattpocock/skills`](https://github.com/mattpocock/skills) | `c55ee46073ed923f86ce59a5eb3b6d895095d1b7` |
| [`obra/superpowers`](https://github.com/obra/superpowers) | `5bf4e78011075bcfc0dc295f0724994cd123ee71` |

Those SHAs are the only re-sync path. To see what upstream changed since, diff
against them. There is no automated sync and no dependency to update.

## The invariant

**No two skills own the same decision point.** Skill count is not a target.
Before adding one, read `writing-skills` and answer its four gate questions.
The default answer is no.

## Provenance

| Skill | From | What changed |
|---|---|---|
| `using-skills` | superpowers `using-superpowers`, mattpocock `ask-matt` | Rewritten around size and risk classification. Added context-inspection-first, the terse classification line, the consequential-decisions-only stop rule, and the no-process-recursion rule. Dropped the multi-harness platform section. |
| `verification-before-completion` | superpowers `verification-before-completion` | Evidence contract relaxed from pasted transcripts to `✓ command — result` lines, with raw output only where decision-relevant. Added the table of what counts as appropriate evidence when a test is not the right check. |
| `test-driven-development` | superpowers `test-driven-development` and `writing-good-tests.md`, mattpocock `tdd/tests.md` and `tdd/mocking.md` | Iron Law replaced with a per-task default table and "whenever practical" framing. All examples rewritten for pytest. Graphviz cycle diagram dropped. |
| `systematic-debugging` | superpowers `systematic-debugging` and `root-cause-tracing.md`, mattpocock `diagnosing-bugs` | mattpocock's feedback-loop gate added as Phase 0: no red-capable command, no Phase 1. Test-pollution shell script replaced with a pytest-aware reference covering ordering seeds. |
| `codebase-design` | mattpocock `codebase-design` | TypeScript snippets rewritten as Python. The "interface is not the TypeScript keyword" caveat reworded around `Protocol` and ABCs, with a preference ladder for seams in Python. |
| `high-risk-changes` | new, from the risk overlay | Not an upstream skill. Makes the overlay concrete: blast radius and rollback, explicit object-level authorization review, the five negative-case classes, adversarial pass and widened verification. |
| `resolving-merge-conflicts` | mattpocock `resolving-merge-conflicts` | Ported close to upstream. Added the generated-files rule, the never-rewrite-others-history rule, and semantic-conflict verification. |
| `writing-skills` | superpowers `writing-skills`, mattpocock `writing-for-agents` and `SKILL-MECHANICS.md` | Added the four-question gate and the no-two-skills-own-the-same-decision invariant. Added the invisibility rule. Python examples only; Graphviz conventions dropped. |

## Deliberately not vendored

| Skill | Why |
|---|---|
| `subagent-driven-development` | Asks the user to choose an execution strategy. That is making the user manage the agent. If parallel implementers are wanted later, the agent picks silently. |
| `domain-modeling` | Folds into `brainstorming` rather than being a separate invocation. |
| `handoff`, `using-git-worktrees`, `dispatching-parallel-agents` | Ceremony without outcome improvement for a single-maintainer Python library. |
| `triage`, `to-spec`, `wayfinder`, `improve-codebase-architecture`, `teach`, `to-questionnaire`, `wait-what`, `wizard`, `prototype`, `research`, `setup-matt-pocock-skills` | Issue-tracker-coupled or outside the core loop. |
| `migrate-to-shoehorn`, `setup-pre-commit`, `scaffold-exercises`, `setup-ts-deep-modules` | TypeScript and npm specific. |
| `diagnosing-superpowers` | An upstream bug-report tool. Not applicable to a fork. |

## Build order is not a workflow

These skills were built in five phases. **That is repository construction order.
It is not how work is done here.** No task passes through five phases. The
runtime workflow is the adaptive one in `using-skills`: read context, size the
task, use the minimum process that makes the change safe.

| Phase | Skills |
|---|---|
| 1 Foundation and spine | `writing-skills`, `using-skills`, the SessionStart hook |
| 2 Universal rules | `verification-before-completion`, `test-driven-development` |
| 3 Situational engineering | `systematic-debugging`, `codebase-design`, `high-risk-changes`, `resolving-merge-conflicts` |
| 4 Review | `requesting-code-review`, `receiving-code-review` |
| 5 Large-work pipeline | `brainstorming`, `writing-plans`, `executing-plans`, `finishing-a-development-branch` |
