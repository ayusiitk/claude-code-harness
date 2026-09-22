# Red flags

Reference for `ui-beautify`. The rationalizations that precede each of this
skill's failure modes, and what is actually true. Read when a shortcut is
starting to sound reasonable.

## Red Flags

| Thought | Reality |
|---|---|
| "The backend just needs one small field for this" | That is the seam. Stop and say so. |
| "I'll hardcode this colour, it's one component" | That is how the token system dies. |
| "It looks more modern with the animation" | Modern is not a reason. What does it tell the user? |
| "The focus ring is ugly, I'll remove it" | Then the keyboard user is lost. Restyle it. |
| "Contrast is close enough" | It is a threshold, not a preference. |
| "I only changed CSS" | Then the diff against the base proves it. Run it. |
| "The empty state is obvious" | It is the best teaching moment the screen has. |
| "I'll polish it now and check states later" | Later is where unfinished interfaces come from. |
| "This design system is limiting" | It is the reason the product looks like one product. |
| "The token change covers every page" | Only the pages that already used the token. Walk the list. |
| "I did the main screens, the rest are the same" | You have not read them. That belief is the defect. |
| "That subpage isn't in the nav" | Users still reach it, and it looks abandoned. |
| "The existing copy is fine" | Then say so per string, after generating alternatives. Not before. |
| "I'll tighten the wording as I go" | One pass of synonyms is not a solution space. |
| "This headline is punchier" | Is it still true, and does it still do the original job? |
| "Users will click it, that's what matters" | A promise the next screen does not keep is a behavior claim, and it breaks. |
| "Copy is content, not my scope" | It is rendered, it is presentation, and nobody else is coming. |
| "An icon here would look nicer" | Nicer is not a job. What does it identify, indicate or replace? |
| "Everyone knows what this icon means" | Outside a handful of conventions, nobody does. Label it. |
| "I'll drop in a stock photo to warm it up" | Unlicensed, unattributed, and it says nothing. Both are disqualifying. |
| "The image is decorative, alt text doesn't matter" | Then say so explicitly, so it is skipped rather than announced. |
| "It's a big hero, but it looks incredible" | Not once it arrives after the text. Weight is part of the design. |
| "It's responsive, it has breakpoints" | Breakpoints answer width. They do not answer touch, reach, or a keyboard eating the viewport. |
| "It stacks fine on mobile" | Stacking is reflow. What is the reading order, and is the primary action still reachable? |
| "We can hide that on small screens" | That is removing a capability. It stops at the seam. |
| "I checked it by narrowing the browser" | Then hover still worked and the keyboard never opened. That is not the phone. |
| "The design system's breakpoints are tablet and desktop" | Users arrive at every width in between, including half a window. |
