# Test Brief: Restructure Agent Onboarding Notes

> Simulated input for testing the markdown-progressive-disclosure skill.
> The executor agent treats this as what a real user would provide.

## Scenario

Restructure a messy Markdown context file for an internal support-agent onboarding guide. The goal is progressive disclosure: keep the top-level node scannable, split only where useful, and use explicit `Source:` references for extracted content.

## Source Materials

Create this starting file in your isolated workspace:

```text
support-agent.md
```

```md
# Purpose
This node helps new support agents answer billing, account access, and escalation questions consistently.

# Tone
Be direct, brief, and factual. Do not promise refunds. When policy is unclear, escalate.

# Billing Workflow
Agents should first confirm the customer identity using the account email and last invoice date.
If the invoice was issued within 24 hours, tell the customer payment systems may still be syncing.
If the invoice is older than 24 hours, check the billing dashboard for payment status, refund eligibility, and failed payment attempts.
If the customer requests a refund, check whether the subscription renewed in the last 14 days.
Refunds are allowed for accidental renewals only when the customer has not used paid features after renewal.
If usage exists, escalate to a billing lead.
If a card was charged twice, collect both transaction IDs and escalate immediately.
If the customer reports tax/VAT issues, ask for billing country and company tax ID.
Never ask for a full card number.

# Account Access
Password resets go through the self-service reset flow.
If the customer cannot access email, ask for two account verification signals and escalate to Trust.
SSO users must contact their workspace admin first.

# Escalations
Escalate security reports to Trust.
Escalate chargebacks to Billing Ops.
Escalate enterprise contract disputes to the account team.

# Examples
Refund request: "I can check whether this renewal is eligible under the 14-day accidental-renewal policy."
Double charge: "Send the two transaction IDs and I will route this to Billing Ops."
```

The skill may create sibling files/folders next to `support-agent.md`.

## Simulated User Behavior

- When asked to confirm: confirm.
- When asked to fill gaps: skip unless required to proceed.
- When asked to choose between reasonable structures: choose the shallowest valid structure that keeps the entrypoint scannable.
- If the skill requires lint fixes: apply them.

## Expected Output

- `support-agent.md` remains the only top-level entrypoint for the support-agent node.
- At least the long billing workflow is extracted to an explicitly referenced file.
- Short sections may remain inline when that is clearer than extracting tiny files.
- All public extracted files are referenced from the entrypoint.
- No duplicate entrypoint such as both `support-agent.md` and `support-agent/index.md`.
- No broken `Source:` references.
- No mixed truth where an entry has both substantial inline content and a `Source:` for the same topic.
- The final response includes files created/changed and a lint-style check summary.

## Edge Cases Included

- Long section among several short sections: correct handling is splitting only the long section unless another split has clear benefit.
- Sensitive-data rule in billing workflow: content must be preserved exactly enough to retain the "Never ask for a full card number" constraint.
- Multiple escalation categories: may stay inline unless the executor can justify splitting.
- Existing node starts as `support-agent.md`: correct handling avoids creating `support-agent/index.md` at the same time.
