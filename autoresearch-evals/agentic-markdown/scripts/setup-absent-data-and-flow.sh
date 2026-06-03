#!/usr/bin/env bash
set -euo pipefail
# Materializes a legacy single-file service doc for the absent-data-and-flow brief.
cat > service.md <<'EOF'
# Pricing Service

The pricing service computes quotes. A request hits the API gateway, then the
quote builder, then the discount resolver, which calls the Rate Service for the
current rate table.

# Caching

We cache rates for 5 minutes. There is a big comparison of the three caching
strategies we considered (no cache, 5-minute TTL, write-through) with p50/p95
latency and cost numbers for each. It really wants to be a side-by-side table
with those numbers, but the actual figures are not recorded here.

# Discounts

Discounts come in three kinds: volume, loyalty, and promo. Volume discounts use
the rate table; loyalty is looked up per customer; promo discounts expire.

# Operations

To deploy: build, push, run migrations, flip the flag. To roll back: flip the
flag back. On call, check the Rate Service health first; it is the usual culprit.
EOF
