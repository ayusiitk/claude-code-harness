---
name: ui-beautify
description: Use when an existing interface needs visual work — weak hierarchy, cramped or inconsistent spacing, ad-hoc colours, missing hover, focus, loading, empty or error states, motion that explains nothing, no icons or imagery where a screen needs them, a layout that only works at one screen size, or placeholder wording — and its behavior must not change. Also use when asked to make a screen feel more finished, calmer, denser or more professional, or when only part of a surface has been polished.
---

# UI Beautify

## Overview

**Core principle:** the interface gets better; the product does not change.

Every decision here is about what the user perceives — hierarchy, rhythm,
colour, state, motion, and the words themselves. None of it is about what the
software does. Naming that boundary is the whole value of this work: it makes
the intended presentation-only scope explicit, so verification can concentrate
on the interface and confirm the behavioral seam was preserved.

Four things are easy to lose inside that principle, and all four are failures
of scope rather than of taste.

- **"The screen" is never one screen** — it is every page, subpage, panel and
  state the surface can reach, and a pass that improves the three that were open
  at the time has not been done.
- **The words are part of the interface** — the loudest element on most screens
  is a string somebody typed while wiring the feature up, and re-spacing it is
  not designing it.
- **Imagery is a decision, not an absence** — a screen with no icon, no
  illustration and no media got that way by default, and "no imagery" is only
  right when it was chosen.
- **A screen is not one design** — it is read on a phone, a tablet and a
  laptop, and the versions differ by more than width.

## When to use

An interface already exists and works, and the complaint is about how it looks
or feels: flat hierarchy, noise, inconsistent spacing, colours invented per
component, states that were never designed, transitions that distract, copy that
reads like a placeholder because it is one.

**When not to use.** The screen is missing a capability, the data is wrong, the
layout question is really an information-architecture question, or there is no
interface yet. Those are ordinary feature or design work and belong in the
normal workflow.

## 1. Find the seam before touching anything

Establish which paths hold presentation and which hold behavior. In most
projects the split is a directory; in some it is a file type; in a few, markup
is generated inside application code and the seam runs through a single file.
Find out which, and write it down, because everything below depends on it.

**Yours:** markup that exists only to be rendered, style and theme files,
design tokens, component templates, visual assets, visual or snapshot tests,
the accessibility attributes that make an existing control perceivable and
operable, and the words rendered in the interface — headings, labels, button
text, placeholders, helper text, empty states and error copy. The icons,
illustrations, background imagery and media the interface renders are yours too,
as are the breakpoints and everything the layout does differently at each width.

**Not yours:** domain logic, API contracts and payload shapes, schemas and
migrations, persistence, authentication and authorization, data fetching, and
anything that adds a capability the screen did not have. Strings are on this
side of the seam too when they are contracts rather than presentation: legal and
consent text, security warnings, destructive-action confirmations, and any
string another system matches on. Media crosses the seam the same way: an upload
path, a media field the API does not return, a CDN or asset pipeline, a
third-party embed that calls another origin, and an asset whose licence you
cannot establish are all behavior, not decoration. So is a breakpoint that
removes a capability — hiding a feature on small screens is a product decision,
not a layout rule.

When the visual outcome you have been asked for genuinely requires a change on
the other side of that seam — a field the API does not return, a state the
backend never emits — **stop at the seam and say so.** Deliver the visual work
that does not depend on it and name the part that does. Do not quietly widen
the change to make the picture come out right; a backend edit smuggled in under
a visual task is the one failure this skill exists to prevent.

## 2. Inventory the whole surface before you size the work

Before reading any single screen, enumerate every one of them. Write the list
down. It is the scope of the work, and without it the pass silently becomes
"whatever was on screen while I was looking".

Build the inventory from the code, not from the running app:

- the route table, router config, view registry or page directory
- everything reachable from nav, and everything **not** reachable from nav —
  subpages opened from a row, a link inside an empty state, a redirect after an
  error, a deep link
- panels, tabs, drawers, modals, sheets, toasts and popovers, including the ones
  mounted far from the screen that opens them
- the variants a single route renders: per role, per feature flag, per theme,
  per locale, and per device class — phone, tablet and laptop widths, in both
  orientations wherever the device turns
- surfaces that are not pages at all — the document title, print styles,
  share and social previews, emails or exports the same product sends

Then keep a ledger, one row per surface, each row ending in **done**, **no
change needed** (with the reason), or **deferred** (with the reason), and each
carrying the widths it was actually checked at. The ledger
is what makes the work reviewable and what makes the last two rows visible
instead of forgotten.

**Editing shared tokens is not coverage.** A change to the palette or the
stylesheet touches every surface that already uses those roles and does nothing
for the one that hardcoded its own values, and nothing at all for the surface
whose problem is a missing empty state or an unwritten heading. A token edit is
the beginning of the pass, never the evidence that it happened.

If the inventory turns out to be larger than the effort available, say so with
the list in hand and propose an order — highest-traffic surfaces first, then the
states users hit when something goes wrong. A named deferral is work; a silent
one is the defect.

## 3. Read each screen before changing it

Answer these before editing, per surface in the inventory. They take minutes and
they decide everything else.

- What is the user here to do, and what is the one action that serves it?
- What is genuinely secondary, and is it currently competing with the primary?
- What does the information hierarchy claim, and does the visual hierarchy agree?
- What is this screen's intent — calm, dense and professional, exploratory,
  urgent?
- What visual language already exists, and what are its conventions?

A screen whose visual weight disagrees with its information hierarchy is the
most common defect, and no amount of polish fixes it. Fix that first.

Across surfaces there is one more question: do these screens look like they
came from the same product? Answers that differ per page — a heading scale here,
another there, two spellings of the same label — are consistency defects, and
they are invisible until the surfaces are read together.

## 4. Work the token system, not the components

Inventory the existing design tokens before inventing anything. Most codebases
that have any visual discipline already name their roles — surfaces, ink,
borders, semantic status, focus — and every component reads those names.

Extend that vocabulary; do not bypass it. A literal colour, spacing value or
shadow written directly into a component is a token that escaped, and it will
drift from every other instance within a release.

Prefer a role that says what a thing is over a value that says what it looks
like. `--border-strong` survives a theme change; `#cccccc` does not. Add a role
only when an existing one genuinely cannot carry the meaning — a palette that
grows a colour per component has stopped being a system.

## 5. Spend effort in this order

1. **Clarity** — can the user tell what this is and what to do?
2. **Hierarchy** — does visual weight match importance?
3. **Consistency** — do the same things look the same everywhere?
4. **Delight** — and only now, the finish.

Reversing this order produces a screen that is decorated and still confusing.
Gradients, shadows and animation are the last four percent, not the work.

The words belong to the first three rungs, not the fourth. A heading that names
what a screen is for does more for clarity than any amount of type scale, and
the same label spelled two ways on two pages is a consistency defect exactly as
much as two shades of the same grey.

## 6. The words are a design element

Every text element on every surface in the inventory gets the same treatment as
a spacing value: recover what it has to say, generate a set of candidates, and
choose one for a stated reason. One rewrite is not a design decision — it is a
synonym.

The short version of the method:

1. **Inventory the text elements** on the surface — headings, labels, buttons,
   placeholders, helper text, empty states, errors, tooltips, counts, the
   document title. The strings inside error branches count, and they are the
   ones that get skipped.
2. **Recover the intent.** What is actually true at the moment this string
   renders, what job the string was doing, and what it must never claim.
3. **Generate the solution space** — at least three candidates in different
   registers, plus the original, including one that is the shortest thing that
   works and one that genuinely reaches for intrigue.
4. **Gate, then rank.** Truth and original intent are pass-or-fail. Fit, voice
   and pull rank whatever survives.
5. **Record the choice** — surface, element, original, chosen, one clause of why.

Balance is the whole point, and it only goes one way: **a candidate that is more
compelling than it is true is not a candidate.** Copy that promises capability
the product does not have is a behavioral claim wearing presentation's clothes,
and it fails the seam in step 1 as surely as an edit to the API would. Intrigue
is earned with specificity — a concrete number, a named consequence, a question
the screen answers immediately — never with mystery, withheld information or
superlatives.

Some strings are not a polish decision at all: legal and consent text, security
warnings, destructive confirmations, and strings other code matches on. And
before changing any string, search the repository for it — a test, a snapshot, a
selector or a translation catalogue holding the same literal means it has a
second consumer to update in the same change.

For the registers, the scoring rubric, what intrigue is and is not, where voice
does not belong, and a worked example: [writing-the-copy.md](writing-the-copy.md)

## 7. Colour is contextual

Do not reason from fixed meanings. "Blue means trustworthy" and "red means
urgent" are not findings you can apply; the evidence is about colour in
context, against neighbours, in a culture, for a purpose.

Translate the screen's intent into a direction instead, and hold it:

- **Calm, focused** — restrained chroma, generous neutral surface, few accents
- **Dense, professional** — tight rhythm, strong alignment, predictable states,
  information density without crowding
- **Exploratory** — more expressive accent range over a stable structure
- **Status-heavy** — semantic states carry the salience; the workflow around
  them stays visually quiet

The exception is convention already established in the product. If the codebase
has used one role for destructive actions everywhere, that meaning is real
within this product and changing it costs the user more than it gains.

## 8. Imagery earns its place

Every icon, illustration, background image and video is a claim on attention and
on bytes, and the default state of most working screens is that nobody ever made
the claim deliberately. Add imagery where it does a job words do worse:
identifying a repeated thing at a glance, indicating state, showing what is hard
to describe, carrying tone at an entry point, or being the content itself. Leave
it out where it would decorate a surface people are trying to work in.

The places it usually earns its keep: an icon beside a label in a list people

What makes an asset shippable rather than merely present — icon families and
labelling, contrast against an image's extremes, video and autoplay, alt text
and decorative status, weight and declared dimensions, dark-theme variants, and
recording a licence: [choosing-imagery.md](choosing-imagery.md)

**The seam applies to assets.** An upload path, a media field the API does not
return, an asset pipeline, a third-party embed calling another origin, or an
asset whose licence you cannot establish is behavior, not decoration. It stops
at step 1.
## 9. Every device is a different design

The same surface on a phone, a tablet and a laptop is a different ergonomic
problem each time: a different pointer, a different reach, a different amount of
attention, a different viewport — often halved by an on-screen keyboard. Reflow
answers the width and none of the rest.

Design against three widths at a minimum — the narrowest supported, the awkward
middle where a two-column layout has to decide, and the widest — and let the
content say where the breakpoints go. A layout breaks at a width because a line
got unreadable or a column got too narrow, not because a framework named a
device.

What changes is more than size: the navigation pattern, whether a table becomes
cards, whether a modal becomes a sheet, the reading order a collapsed grid
imposes, hit targets and the spacing between them, where a primary action sits
relative to a thumb, how much density a screen can carry, and how an image is
cropped rather than merely scaled. Anything revealed by hover needs a form that
exists without a pointer.

What does not change is the capability. **Dropping a feature at a breakpoint
because the layout is hard is a product decision, and it stops at the seam in
step 1.**

For the per-device differences, the list of what to change beyond reflow, and
how to verify each width: [designing-for-devices.md](designing-for-devices.md)

## 10. Design the states, not just the screen

The default state is the one that already got attention. The others are where
interfaces feel unfinished:

hover · active · focus · disabled · loading · empty · partial · error · too
much content · too little content · longest plausible string

Empty and error states are content, not accidents. An empty state that says
nothing wastes the one moment the user is most receptive to being told what to
do next.

Which means these states are copy work before they are layout work. Every empty,
error, loading and partial state on every surface in the inventory goes through
step 6 — those strings are usually the ones that were never written, and they
are where a pass that only touched stylesheets shows.

## 11. Accessibility is a constraint, not a pass at the end

Non-negotiable, and cheaper to hold than to retrofit:

- Text contrast at least 4.5:1; large text at least 3:1
- Never colour alone to carry meaning — pair it with text, shape, or icon
- Keyboard focus stays visible, and stays legible against its background
- Do not trade focus visibility for tidiness; a removed outline needs a
  replacement, not a deletion
- Hit targets stay comfortable, and text stays readable as the viewport narrows
- Changing a visible label changes the accessible name with it: keep the name
  a control announces matching the words a user would say to ask for it

If a visual direction cannot meet contrast, the direction is wrong. Adjust the
palette, not the standard.

## 12. Motion has to say something

Use it for continuity between states, for emphasis that decays, for feedback on
an action the user took, and for the spatial relationship between what was
there and what is there now.

Do not use it because a screen feels static. Honour a reduced-motion preference
for anything non-essential, and never make motion the only way a state change
is perceivable — a user who does not see the animation must still see the
result.

## 13. Prove the behavior did not change, and the work actually landed

Six claims need evidence, and none of them is satisfied by saying it.

**The behavior still works.** Run the repository's verification commands as
recorded in `docs/agents/toolchain.md` — including the frontend and
browser-level checks, which are the ones that actually exercise this work. A
changed string can turn a test red; that is the coupling check doing its job, and
the fix is the expected value, never a loosened assertion.

**Nothing outside the seam was touched.** Read the changed-file list for the
whole change, not for whatever happens to be uncommitted right now:

```
git diff --name-only $(git merge-base HEAD <the branch this started from>)..HEAD
git status --porcelain
```

Check every path against the partition from step 1. Do not rely on your own
account of what you edited; the list is the evidence and your memory is not.

Diffing the working tree alone is the trap, and it fails in the direction that
hides the problem: the moment the work is committed, `git diff --name-only`
returns nothing, so the check reports a clean seam exactly when the evidence
is being asked for. A check that passes because it cannot see anything is
worse than no check, because it is reported as a pass.

A path on the behavior side is a scope violation, and the remedy is to revert
it. It is not something to explain and keep: the whole claim this work makes is
that behavior was not touched, and a justified exception is indistinguishable
to a reviewer from the failure this exists to prevent. If the visual outcome
truly needs that change, it belongs to the ordinary workflow as separate work,
per step 1.

**Every surface was accounted for.** Report the ledger from step 2 — every row
marked done, no-change-needed, or deferred with its reason. The same changed-file
list is the cross-check: a surface marked done whose file appears nowhere in the
diff was not done, whatever the ledger says, unless the reason it needed no file
of its own is stated.

**The copy decisions are visible.** Report the table from step 6 for the strings
that changed. Strings that were examined and deliberately kept are a result too,
and worth a line.

**Every device class was actually looked at.** Report the widths behind each
ledger row. Browser-level evidence is the only kind that counts here, and the
repository's browser check is the command that produces it — which has side
effects beyond the working tree, so it is asked for and waited on, per
`docs/agents/toolchain.md`. Not run means reported as unverified, with the
reason. It never means reported as working because the stylesheet looks right.

**Every asset that was added is accounted for.** One line each: what it is, why
it is there, its weight and dimensions, its alt text or its explicit decorative
status, its dark-theme story, and where it came from with its licence. An asset
that arrived in the diff with none of that is indistinguishable from one that
was pasted in by accident.

**REQUIRED SUB-SKILL:** Use verification-before-completion

## Red Flags

The rationalization for every failure mode above, with what is actually true:
[red-flags.md](red-flags.md)
## Checklist

- [ ] Presentation/behavior seam established and written down before editing
- [ ] Full surface inventory built from routes and view registry, including
      subpages, modals, and variants not reachable from nav
- [ ] Every inventory row resolved: done, no change needed, or deferred with a reason
- [ ] Primary user task and primary action named, per surface
- [ ] Visual hierarchy checked against information hierarchy
- [ ] Surfaces read together for cross-page consistency, not only one at a time
- [ ] Existing tokens inventoried; new roles added only where none could carry it
- [ ] No literal colour, spacing or shadow values left in components
- [ ] Text elements inventoried per surface, error and loading strings included
- [ ] Candidates in multiple registers generated for each text element, original included
- [ ] Every shipped string passes the truth and original-intent gates before fit, voice and pull
- [ ] Contract strings left alone or raised as separate work; literals searched for other consumers
- [ ] Copy decisions recorded: surface, element, original, chosen, why
- [ ] Imagery decided rather than defaulted: each icon, illustration, background
      or video does a job words do worse, or is deliberately absent
- [ ] Icons from one family, taking colour from tokens, labelled or conventional
- [ ] Text over imagery meets contrast against the image's extremes; no text baked into an asset
- [ ] Every asset has alt text or an explicit decorative status, a dark-theme story,
      declared dimensions, an appropriate size per width, and a recorded licence
- [ ] Media never the only carrier of information; autoplay muted, short and reduced-motion aware
- [ ] Designed at the narrowest, the awkward middle and the widest, with breakpoints
      placed where the content breaks
- [ ] Per-device changes made beyond reflow: navigation, tables, overlays, reading
      order, hit targets, thumb reach, density
- [ ] No hover-only affordance without a pointer-free equivalent
- [ ] No capability removed at any breakpoint
- [ ] Interaction, loading, empty and error states all addressed
- [ ] Contrast thresholds met; meaning never carried by colour alone
- [ ] Keyboard focus visible and legible; accessible names still match visible labels
- [ ] Motion justified per use, reduced-motion honoured, never load-bearing
- [ ] Repository verification commands run, frontend checks included
- [ ] Changed-file list read against the base commit, not just the working tree, every path inside the seam, no exceptions carried
- [ ] Ledger and copy table reported as evidence, cross-checked against the changed-file list
