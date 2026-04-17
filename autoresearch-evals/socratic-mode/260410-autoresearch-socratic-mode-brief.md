# Test Brief: Ambiguous Career Decision Conversation

> Simulated input for testing the `socratic-mode` skill.
> The executor agent treats this as what a real user would provide.

## Scenario
The user arrives with a vague internal conflict about whether to leave a stable job for an independent project. The skill should clarify intent, motives, constraints, and assumptions through one-question dialogue, avoid offering solutions prematurely, summarize when asked, and stop Socratic behavior once the user explicitly asks what to do.

## Source Materials
Initial user message:

`I'm thinking about quitting my job to work on my own thing, but I'm not sure if that's smart.`

Follow-up user answers, in order if the skill asks one question at a time:

1. `A useful outcome would be understanding whether I'm actually confused about money, identity, or timing.`
2. `The hardest part to define is what "my own thing" even means, because it could be a consulting practice or a product.`
3. `I assume I need a single clear idea before I quit.`
4. `Evidence for that is weak. I mostly feel pressure to sound decisive.`
5. `A constraint is that I support my parents with about $1,200 a month.`
6. `If I quit too early, I'd risk becoming unreliable to them.`
7. `Another perspective is that I could test independence without resigning immediately.`
8. `Can you summarize where I am so far?`
9. `Yes, clarity feels better now. What do you think I should do?`

## Simulated User Behavior
- When asked to confirm: confirm briefly and continue
- When asked to fill gaps: use the next unanswered item from the ordered answers above
- When asked to choose: prefer the narrower framing that most reduces ambiguity
- When asked more than one question at once: answer only the first one and note that the rest were hard to track

## Expected Output
The executor should judge the skill successful if it would guide a conversation that:
- starts by aligning on the desired outcome
- asks one neutral question at a time
- surfaces motives, ambiguity, assumptions, evidence, constraints, and consequences
- provides a concise summary when asked
- recognizes that the explicit request `What do you think I should do?` triggers exit from Socratic mode
- does not keep probing after the exit trigger

## Edge Cases Included
- Ambiguous goal at the start: the skill should align on outcome before deep probing
- User asks for a summary mid-conversation: the skill should summarize without abandoning the broader workflow
- User asks for solutions after clarity: the skill should exit Socratic behavior instead of continuing to question
- The phrase `my own thing` is intentionally vague: the skill should clarify it rather than assume a business model
