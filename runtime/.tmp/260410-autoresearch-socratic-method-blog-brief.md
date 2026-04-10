# Test Brief: Starting a Blog Without a Clear Direction

> Simulated input for testing the `socratic-method` skill.
> The executor agent treats this as what a real user would provide.

## Scenario
The user says they want to create a blog, but they have not clarified whether the real issue is topic selection, consistency, identity, business goals, or technical setup. The skill should keep the conversation in clarification mode, ask one neutral question at a time, summarize when asked, and stop Socratic behavior if the user explicitly shifts to asking what to do.

## Source Materials
Initial user message:

`I want to create a blog, but I keep getting stuck and not starting.`

Follow-up user answers, in order if the skill asks one question at a time:

1. `A useful outcome would be understanding what is actually blocking me from starting.`
2. `By blog I mean a personal site where I publish essays about technology, work, and things I am learning.`
3. `I assume I need a narrow niche before I publish anything.`
4. `The evidence is mostly what I see online. People say broad blogs fail.`
5. `A real constraint is that I only have about three hours a week for this.`
6. `If I over-plan it, I will probably keep delaying and publish nothing.`
7. `Another perspective is that the first version could just be a place to practice in public.`
8. `Can you summarize where I am so far?`
9. `Yes, that sounds right. So what do you think I should do next?`

## Simulated User Behavior
- When asked to confirm: confirm briefly and continue
- When asked to fill gaps: use the next unanswered item from the ordered answers above
- When asked to choose: prefer the option that reduces ambiguity about intent or constraints
- When asked more than one question at once: answer only the first question and note that the rest felt bundled together

## Expected Output
The executor should judge the skill successful if it would guide a conversation that:
- starts by aligning on the desired outcome
- clarifies what the user means by `blog`
- surfaces assumptions, evidence, constraints, consequences, and alternative perspectives
- avoids suggesting platforms, content plans, or marketing tactics while still in Socratic mode
- provides a concise summary when asked
- treats `what do you think I should do next?` as an exit trigger from Socratic mode

## Edge Cases Included
- The user appears action-oriented from the first message: the skill should still align on outcome before giving direction
- `blog` can mean many things: the skill should clarify the term instead of assuming a business, newsletter, or hobby site
- The user has a limited weekly time budget: the skill should surface this as a constraint rather than ignore it
- The user asks for solutions after a summary: the skill should stop Socratic questioning cleanly
