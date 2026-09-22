# Red flags

Reference for `using-skills`. These thoughts mean stop: you are rationalizing.

## About the contract

| Thought | Reality |
|---|---|
| "It's SMALL, so I can just build it" | Size picked the workflow. It did not settle the contract. |
| "The name tells me what it should do" | A plausible name is not a specification. |
| "There's an obvious convention for this" | A convention is not a decision the user made. |
| "Nothing calls it yet, so it's easy to change" | Cheap to change is not yours to choose. |
| "I'll cover the edge cases thoroughly" | Thorough coverage of invented cases entrenches the invention. |
| "I'll pick a sensible default and mention it" | Right for implementation choices. Wrong for the contract itself. |
| "They'll tell me if it's wrong" | They will tell you after you built it. Ask first. |

## About process

| Thought | Reality |
|---|---|
| "Let me explore the codebase first" | Yes, that is step 1. Then classify. |
| "I'll ask if they want me to proceed" | Only for unresolved contracts and consequential steps. |
| "This is complex, so it's LARGE" | Read the repo first. Existing abstractions shrink tasks. |
| "It's only one line, so it's safe" | One line in an auth check is SMALL + RISKY. |
| "It's an internal endpoint" | Internal is a deployment fact, not a security boundary. |
| "I'll summarize progress so far" | The commits are the record. |
| "I should tell them which skill I'm using" | No. Just do the work. |

## About evidence

| Thought | Reality |
|---|---|
| "Tests probably pass" | Then you have no evidence. Run them. |
| "This should work" | Then you have not checked. |
| "That failure was already there" | Then say so by name. Do not omit it. |
| "The change is obviously correct" | Obvious changes break suites constantly. |
| "It's just a docs change" | If it documents a command, run the command. |
