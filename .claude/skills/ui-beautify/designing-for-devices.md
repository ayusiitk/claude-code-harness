# Designing for devices

A layout that reflows is not a design that adapts. The same screen on a phone,
a tablet and a laptop is read at a different distance, held in a different
number of hands, pointed at with a different instrument, and given a different
amount of attention. Reflow answers the width. It does not answer any of that.

The rule that keeps this honest: **the capability is identical on every
device.** Density changes, order changes, navigation changes, the shape of a
control changes. What the user can do does not. Dropping a feature on small
screens because the layout is awkward is a product decision wearing a
responsive-design costume — that is the seam, and it stops there.

## What actually differs

| | Phone | Tablet | Laptop and up |
|---|---|---|---|
| Pointer | finger, imprecise | finger, two-handed | mouse or trackpad, precise |
| Hover | does not exist | does not exist | available, and still not required |
| Reach | one thumb, bottom two-thirds | both thumbs at the edges | anywhere |
| Viewport | short, and halved by the keyboard | tall, often split-screen | wide, often not maximised |
| Attention | interrupted, seconds | lean-back, minutes | working session |
| Orientation | both, and landscape is cramped | both, and both are used | one |
| Chrome | notches, home indicators, safe areas | safe areas | none |

Split-screen and a resized window are why "tablet" is a width, not a device.
Design for the width; do not detect the hardware.

## Breakpoints come from the content

Add a breakpoint where the layout actually breaks — where a line gets too long
to read, a column gets too narrow to hold its content, a row of controls wraps
badly. Name it for what it fixes. Device-named breakpoints copied from a
framework fit devices that stopped shipping years ago.

Three widths are the minimum to design against, not to test at: the narrowest
supported, the awkward middle where a two-column layout has to decide, and the
widest where a single column starts to look abandoned in a field of whitespace.

## What changes beyond reflow

- **Navigation.** A sidebar that becomes a drawer is fine; a primary action
  that becomes a hamburger item is not. The one thing the user came to do stays
  visible at every width.
- **Tables.** At narrow widths a table becomes cards, or a prioritised subset of
  columns with the rest on demand. Horizontal scroll as the only answer is a
  table nobody reads.
- **Overlays.** A modal becomes a sheet. A tooltip becomes inline text, because
  there is no hover to reveal it. A right-click menu needs a visible equivalent.
- **Hover-only affordances.** Any control revealed by hover needs a state that
  exists without a pointer — always visible on touch, or reachable another way.
- **Order.** A multi-column layout collapsing to one column makes source order
  into reading order. That order is a decision: most important first, per
  surface, not whatever the grid happened to emit.
- **Hit targets.** Comfortable on touch — roughly a finger pad, with space
  between adjacent targets so the wrong one is not the easy one to hit.
- **Thumb reach.** Primary and destructive actions on a phone belong where the
  thumb lands, not tucked into the top corners, and they belong apart from each
  other.
- **Inputs.** The right keyboard type per field, and a layout that still works
  when the on-screen keyboard takes half the viewport with the submit button
  below it.
- **Density.** A laptop can afford more per screen. Shipping the phone layout
  stretched wastes it; shipping the desktop grid shrunk is how a screen ends up
  unusable in a hand.
- **Text.** Line length stays in a readable band at every width, type never
  shrinks below comfortable on the device it is read on, and the layout survives
  the user's own text-size setting and a 200% zoom.
- **Imagery.** Art direction, not just scaling: a hero cropped for a wide
  viewport loses its subject at narrow, and an asset sized for a desktop is
  wasted bytes on a phone.
- **Safe areas.** Content clears notches and home indicators, and nothing
  important sits under them.

## What does not change

Capability, data, the meaning of an action, and the wording of anything that is
a contract. If a device genuinely cannot carry a feature, that is a product
decision to raise, not a breakpoint to write.

## Verifying it

Check every surface in the ledger at the narrowest supported width, at the
awkward middle, and at the widest — plus a touch-pointer pass for the
hover-dependent parts, a 200% zoom pass, and landscape on a phone-sized
viewport wherever the screen has inputs.

Browser-level evidence is the only evidence that counts for this, and the
repository's browser check is the command that produces it — run it as recorded
in `docs/agents/toolchain.md`, and **only after asking**, because it has side
effects beyond the working tree. If it was not run, the device work is reported
as unverified. It is never reported as working because the CSS looks right.

Record the device classes each surface was checked at as a column on the ledger.
A ledger row that says "done" with no widths behind it is a claim about one
window size.
