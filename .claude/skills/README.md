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
| `requesting-code-review` | superpowers `requesting-code-review` and `code-reviewer.md`, mattpocock `code-review` | mattpocock's two-axis split (Standards and Spec) on superpowers' file-based subagent dispatch. Added the rule to hand the reviewer the original requirement rather than a summary, and a risk-overlay pass. |
| `receiving-code-review` | superpowers `receiving-code-review` | Ported close to upstream. Added the optional-findings rule and explicit handoffs to systematic-debugging for bug claims and codebase-design for clustered findings. |
| `brainstorming` | superpowers `brainstorming`, mattpocock `grilling` and `grill-me` | Path classification removed: `using-skills` owns sizing, so this skill takes the size as given and does the design work it calls for. mattpocock's interview technique (one question at a time, frontier, facts versus decisions) supplies the method behind superpowers' gate. `domain-modeling` folded in. |
| `writing-plans` | superpowers `writing-plans`, mattpocock `to-tickets` | Template ported nearly verbatim, since upstream's was already pytest-flavoured. Added per-task blocking edges from mattpocock. The subagent-versus-native execution choice was dropped: it made the user manage the agent. |
| `executing-plans` | superpowers `executing-plans` and the rulings doctrine from `subagent-driven-development`, mattpocock `implement` | Kept "rulings, not stalls" and the four stop conditions. Added resume-from-ledger, per-task risk overlay, and the rule that a wrong task is fixed in place rather than re-planned. |
| `finishing-a-development-branch` | superpowers `finishing-a-development-branch` | Rewritten around the merge hard gate: no integration without evidence from the final commit. Push and pull-request creation treated as side effects needing the user's go-ahead. |
| `writing-skills` | superpowers `writing-skills`, mattpocock `writing-for-agents` and `SKILL-MECHANICS.md` | Added the four-question gate and the no-two-skills-own-the-same-decision invariant. Added the invisibility rule. Python examples only; Graphviz conventions dropped. |
| `ui-beautify` | new, not upstream | Not an upstream skill, and not vendored from either collection. Owns presentation-only change to an interface that already works: establishing the seam between presentation and behavior before editing, enumerating the whole surface — every subpage, modal and variant, not just what was on screen — before sizing the work, hierarchy before decoration, extending an existing token vocabulary rather than writing literal values into components, treating the rendered words as a design element with a generated solution space per text element rather than a single rewrite, designing the interaction, loading, empty and error states, contrast and visible-focus floors, deciding imagery — icons, illustrations, background and media — as a job to be done rather than decoration to be added, designing each surface for phone, tablet and laptop as three ergonomic problems rather than one reflow, and motion that has to justify itself. Colour guidance is directional and context-dependent rather than a fixed meaning per hue; copy is gated on truth and original intent before it is ranked on pull, so a more compelling string that overstates the product fails the same seam a backend edit would; and the seam, the surface ledger and the copy decisions are verified against the changed-file list rather than trusting the agent's account of what it touched. Imagery and per-device work carry their own seam rules: an upload path, a media field the API does not return, a third-party embed or a capability hidden at a breakpoint are behavior, not presentation. Method files: `ui-beautify/writing-the-copy.md` and `ui-beautify/designing-for-devices.md`. |

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
