#!/usr/bin/env bash
set -euo pipefail

mkdir -p ops-guide

cat > ops-guide.md <<'EOF'
# Operations Guide

This unit covers billing and incident operations.
It should keep one explicit starting file.

## Billing
Short billing overview.
Source: ./billing.md

## Incident Response
EOF
for i in $(seq 1 18); do printf 'Inline incident %03d\n' "$i" >> ops-guide.md; done
cat >> ops-guide.md <<'EOF'

Source: [Incident Response](./incident.md)

## FAQ
Short answers for operators.
Source: [FAQ](./faq.md)

## Missing Topic
Placeholder reference for a topic that is absent.
Source: [Missing Topic](./missing-topic.md)

## Dependencies

| Doc | Why |
|---|---|
| [Glossary](./ops-glossary.md) | Defines terms |

## Related

| Document | Purpose |
|---|---|
| [External Playbook](https://example.com/playbook) | External URL should not validate |
EOF

for i in $(seq 1 20); do printf 'Alternate entrypoint line %02d\n' "$i"; done > ops-guide/index.md

cat > billing.md <<'EOF'
# Billing

Billing actions and notes.
EOF
for i in $(seq 1 70); do printf 'Billing note %03d\n' "$i" >> billing.md; done
printf 'Source: [Shared Notes](./common.md)\n' >> billing.md

cat > incident.md <<'EOF'
---
title: Incident Response
tags: [incident]
---

# Incident Response

Incident response steps.
EOF
for i in $(seq 1 75); do printf 'Incident step %03d\n' "$i" >> incident.md; done

cat > faq.md <<'EOF'
# FAQ

Frequently asked questions.
EOF
for i in $(seq 1 30); do printf 'FAQ line %03d\n' "$i" >> faq.md; done
printf 'Source: [Shared Notes](./common.md)\n' >> faq.md

cat > common.md <<'EOF'
---
title: Shared Notes
tags: [shared]
---

# Shared Notes

Shared notes that incorrectly create a cycle.
EOF
for i in $(seq 1 18); do printf 'Common line %03d\n' "$i" >> common.md; done
printf 'Source: [Billing](./billing.md)\n' >> common.md

cat > refund-exceptions.md <<'EOF'
# Refund Exceptions

Refund exception content that belongs to the unit but is not explicitly linked.
EOF
for i in $(seq 1 40); do printf 'Refund exception %03d\n' "$i" >> refund-exceptions.md; done

cat > ops-glossary.md <<'EOF'
---
title: Operations Glossary
tags: [glossary]
---

# Operations Glossary

Definitions for operations terms.
EOF
