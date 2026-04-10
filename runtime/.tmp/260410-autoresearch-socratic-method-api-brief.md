# Test Brief: Wants to Understand APIs but Feels Lost

> Simulated input for testing the `socratic-method` skill.
> The executor agent treats this as what a real user would provide.

## Scenario
The user says they want to understand APIs, but the real issue is still unclear: they may be confused about terminology, practical use, fear of jargon, or where to start. This brief is designed to stress the simplified skill's merged answer-handling rules by including a vague term, a short answer, an `I don't know`, and a broad answer before the user later asks what to do.

## Source Materials
Initial user message:

`I keep hearing about APIs and I want to understand them, but every explanation loses me.`

Follow-up user answers, in order if the skill asks one question at a time:

1. `A useful outcome would be understanding what part I actually don't get yet.`
2. `By understand I mean I want to stop feeling like the word is magic jargon.`
3. `I don't know.`
4. `I guess I assume I need to understand servers, code, networking, and a lot of other technical stuff before APIs will make sense.`
5. `The evidence is mostly that explanations online seem written for people who already know the basics.`
6. `A constraint is that I get overwhelmed fast when too many new terms show up at once.`
7. `If that keeps happening, I stop reading and avoid the topic for weeks.`
8. `Another perspective is that maybe I only need a simple mental model first, not the whole stack.`
9. `Can you summarize where I am so far?`
10. `Yes, that's closer. What do you think I should do next?`

## Simulated User Behavior
- When asked to confirm: confirm briefly and continue
- When asked to fill gaps: use the next unanswered item from the ordered answers above
- When asked to choose: prefer the option that reduces confusion about terminology or learning constraints
- When asked more than one question at once: answer only the first part and note that the question felt bundled

## Expected Output
The executor should judge the skill successful if it would guide a conversation that:
- aligns on the desired outcome before explaining APIs
- clarifies what the user means by `understand`
- handles `I don't know` without breaking the one-question flow
- surfaces assumptions, evidence, constraints, consequences, and alternative perspectives
- summarizes cleanly when asked
- exits Socratic mode when the user asks what to do next

## Edge Cases Included
- The user appears to want an explanation immediately: the skill should still clarify first
- `understand` is vague: the skill should ask what that means instead of assuming mastery, memorization, or coding ability
- The user says `I don't know`: the skill should narrow or offer limited options only after agreement
- The user gets overwhelmed by jargon: the skill should surface this as a real constraint
