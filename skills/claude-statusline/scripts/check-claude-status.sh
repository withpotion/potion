#!/bin/bash
# Fetch Claude service status from Statuspage API and cache it.
# Cache: ~/.claude/.status-cache (refreshed every 5 minutes)
# Output: one "component_name:status" per line for non-operational components.
# Empty file = all systems operational.

CACHE_FILE="$HOME/.claude/.status-cache"

json=$(curl -sf --max-time 5 "https://status.claude.com/api/v2/components.json" 2>/dev/null)
[ -z "$json" ] && exit 1

echo "$json" | jq -r '.components[] | select(.status != "operational") | "\(.name):\(.status)"' > "$CACHE_FILE"
