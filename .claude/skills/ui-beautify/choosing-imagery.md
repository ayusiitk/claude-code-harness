# Choosing imagery

Reference for `ui-beautify` step 8. Read when a surface is getting an icon, an
illustration, a background image or a video — or when deciding it should not.

The rule that governs all of it: imagery is added where it does a job words do
worse, and left out where it would decorate a surface people are trying to work
in. What follows is what makes an asset shippable once that decision is made.

scan repeatedly, an empty state where an illustration turns a dead end into an
invitation, a first-run or landing moment that has to set a tone, a diagram that
shows a structure prose would take a paragraph to describe.

**Icons.** One family, one optical weight, one grid. Icons take their colour
from the ink and status tokens rather than carrying their own. An icon without a
label is a guess, unless the pairing is already a convention inside this product
— and an icon that is the only carrier of meaning needs an accessible name.

**Background and hero imagery.** Text over an image needs a scrim, a container
or a crop that guarantees the contrast floor against the lightest and darkest
part of the image, not against its average. Never bake text into an image: it
cannot be zoomed, selected, translated, or read aloud.

**Video and animated media.** Autoplay only when it is muted, short, and
silenced by a reduced-motion preference; anything longer gets controls the user
reaches first. A poster frame has to stand alone, because it is what most people
will see. Speech needs captions or a transcript. Media is never the only way a
piece of information is available.

**Every asset is an accessibility decision.** Decorative images are hidden from
assistive technology and carry empty alt text; meaningful ones carry alt text
that says the information, not the filename. Getting this backwards is how a
screen reader ends up narrating twelve identical icon names.

**Weight is part of the design.** Declared dimensions so nothing shifts as
assets land, a modern format, sizes appropriate to the width being served, and
lazy loading below the fold. An asset that delays the first paint has made the
interface worse, however good it looks once it arrives.

**Themes and provenance.** An asset needs a dark-theme variant or needs to be
theme-agnostic; a transparent asset drawn for a light background will show its
halo on a dark one. Record where each new asset came from and under what licence
— an asset with no provenance is a liability the reviewer cannot check.
