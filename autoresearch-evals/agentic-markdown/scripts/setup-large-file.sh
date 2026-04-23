#!/usr/bin/env bash
set -euo pipefail

cat > support-guide.md <<'EOF'
# Support Guide

Refund and login help keeps accounts moving.
Support staff should protect customer trust.
Handle payment issues without exposing secrets.
Escalate carefully when identity is unclear.

## Quick Rules
- Verify the request goal before editing anything.
- Never reveal private account data in chat.
- Use the smallest effective account change.
- Confirm the impacted system before escalating.
- Leave a short operator-facing note after action.
- Prefer documented recovery steps over improvisation.
- Keep trust language factual and calm.
- Do not promise refunds before policy review.
- Escalate suspicious patterns early.
- Close loops with the user after resolution.

## Refund Workflow
EOF
for i in $(seq 1 130); do
  if [ "$i" -eq 61 ]; then
    printf 'Refund step 061: Never ask for a full card number.\n' >> support-guide.md
  else
    printf 'Refund step %03d\n' "$i" >> support-guide.md
  fi
done

cat >> support-guide.md <<'EOF'

## Access Recovery
### Email Reset
EOF
for i in $(seq 1 45); do printf 'Email reset %03d\n' "$i" >> support-guide.md; done

cat >> support-guide.md <<'EOF'

### Device Challenge
EOF
for i in $(seq 1 40); do printf 'Device check %03d\n' "$i" >> support-guide.md; done

cat >> support-guide.md <<'EOF'

### Escalation
EOF
for i in $(seq 1 28); do printf 'Recovery escalation %03d\n' "$i" >> support-guide.md; done

cat >> support-guide.md <<'EOF'

## FAQ / Edge Cases
EOF
for i in $(seq 1 32); do printf 'FAQ case %03d\n' "$i" >> support-guide.md; done

cat > draft-notes.md <<'EOF'
maybe split billing
old heading idea
rough trust bullets
temporary recovery copy
draft faq idea
bad refund branch
todo write examples
maybe add screenshot note
remove duplicate rule
ops handoff note
old escalation wording
check tone later
abandoned heading one
abandoned heading two
scratch rule fragment
temp note about cards
not part of final unit
leave this draft alone
EOF
