# Writing the copy

The strings in an interface are almost never designed. They are typed once
while the feature is being wired up, by someone thinking about the wiring, and
then they are inherited forever. A visual pass that reflows those strings,
re-weights them and leaves the words exactly as they were has polished the
frame around the loudest element on the screen and left the element alone.

Text is presentation. It is inside the seam, and it gets the same treatment as
spacing and colour: not one rewrite, but a set of candidates and a reason for
the one that ships.

## What counts as a text element

Page and section headings · subheads and standfirsts · button and menu-item
labels · field labels, placeholders and helper text · empty states · error and
validation messages · loading and progress text · confirmation and success
messages · tooltips and titles · table column headers · nav and tab labels ·
document title and tab title · status and badge text · units, counts and
pluralisation · anything read aloud by a screen reader but never shown

Every one of those is an element. A pass that covers headings and buttons and
skips the twelve strings buried in error branches has covered the easy half.

## 1. Recover the intent before writing a candidate

Three questions per element, answered from the code and the screen rather than
from taste:

- **What is actually true here?** What has the software done, or what will it
  do, at the moment this string renders. This is the delivery intent, and it is
  the hard boundary on every candidate.
- **What job was this string doing?** Orienting, labelling, warning, teaching,
  confirming, inviting. This is the plan intent, and a candidate that drops the
  job is not a better string, it is a different one.
- **What must it never claim?** Capability the product does not have, a
  guarantee the system does not enforce, a state that has not been reached.

## 2. Generate a solution space, not a rewrite

At least three new candidates per element that matters, each from a different
register, and the original stays in the space as a candidate. The first rewrite
anyone produces is a synonym of the original; the value is in the comparison,
and candidates are cheap.

| Register | Sounds like |
|---|---|
| Plain | says the thing, no ornament — the baseline everything else must beat |
| Action-led | leads with the verb the user is here to perform |
| Outcome-led | names what the user gets, not what the system does |
| Intriguing | a specific, concrete hook that the screen pays off immediately |
| Voice-of-the-user | the words the user would use describing this to a colleague |
| Quiet-confident | short, declarative, no persuasion — earns trust by not trying |

Two constraints on the space: one candidate must be the shortest wording that
still does the job, and one must genuinely reach for intrigue rather than being
the plain one with a longer sentence.

## 3. Score against gates, then tie-break on pull

Truth and intent are **gates**. A candidate either passes or leaves the space.

- **True** — the product does this, now, in this state
- **Intent** — still does the job the original was doing
- **Clear at a glance** — understood without re-reading, without jargon the
  user has not met yet on this surface

The survivors are then ranked:

- **Fits** — at the longest plausible value, at the narrowest viewport, and
  with room for translation swell; a string that wraps to three lines has lost
  whatever it gained
- **Voice** — consistent with its neighbours; one surface written in two voices
  reads as two products
- **Pull** — does it make the user want to act, read on, or show someone

**Pull only breaks ties among candidates that already passed the gates.** Copy
that overstates what the software does is not a bolder headline, it is a
behavioral claim smuggled in as presentation — the same seam violation this
skill exists to prevent, written in prose instead of code.

## What intrigue actually is

It is specificity. A concrete noun, a real number, a named consequence, a
question the screen answers in the next half-second, a promise the next click
keeps. "Four agents, one disagreement left" earns attention because it is
information.

It is not mystery, not withholding what the user needs to act, not exclamation
marks, and not *unleash*, *supercharge*, *effortless*, *seamless*, *magical*.
Those read as noise to the user and as filler to anyone they show it to.

The test that matters: **screenshotted alone and sent to a colleague, does this
string still make sense, and does it make the product look considered?** That
is the thing that actually travels. Copy that only works with the rest of the
page around it will never leave the page.

## Where intrigue does not belong

Error messages say what happened and what to do next. Destructive
confirmations are plain and specific about what is about to be lost. Field
labels name the field. Legal, consent and security text says exactly what it
says. Anything a user reads while anxious, lost, or in a hurry gets the plain
register and nothing else.

Voice belongs in the empty state, the first-run moment, the heading that frames
a screen, the completed or celebratory state, and anywhere the user has slack
to enjoy it.

## Strings that are not a polish decision

Leave these alone, or raise them as separate work:

- Legal, consent, licensing, regulated and security-warning text
- Destructive-action confirmations whose precision is the safety mechanism
- Strings used as identifiers: translation keys, telemetry event names, values
  other code matches on
- Accessible names that automated checks or assistive-technology users depend
  on being stable, where changing the visible label changes the name too

## Check the couplings before changing a string

Search the repository for the literal string before editing it. A hit outside
the component means it has a second consumer — a test asserting it, a snapshot,
a selector, a translation catalogue, a screenshot in the docs. That is not a
reason never to change it; it is a reason to change it deliberately and update
every consumer in the same change, or to leave it.

A copy change that turns a test red and gets "fixed" by loosening the assertion
has quietly removed a check. Update the expected string instead.

## Record the decision

One row per changed string: surface, element, original, chosen, and one clause
of why. A diff of changed strings with no intent behind it is unreviewable —
the reviewer cannot tell a considered choice from a stray edit.

| Surface | Element | Original | Chosen | Why |
|---|---|---|---|---|
| Stances | empty state | `No deliberation selected.` | `Pick a deliberation to see where the agents disagree.` | Same fact, but names what the view is for and what the user gets by acting |

The rejected candidates do not need to be recorded. They need to have existed.
