#!/bin/bash
# Fetch Claude Code subscription quota from Anthropic OAuth API and cache it.
# Includes burn-rate projections for 5h and 7d windows.
# Cache: ~/.claude/.quota-cache (refreshed every 1 minute, or when a reset window passes)
#
# Cache format (one value per line):
#   1: 5h current%
#   2: 7d current%
#   3: 5h projected% (empty if insufficient data)
#   4: 7d projected% (empty if insufficient data)
#   5: 5h reset epoch
#   6: 7d reset epoch
#
# Requires: macOS Keychain with "Claude Code-credentials" entry (auto-created by Claude Code)

CACHE_FILE="$HOME/.claude/.quota-cache"
LOCK_FILE="$HOME/.claude/.quota-cache.lock"
CACHE_MAX_AGE=60  # 1 minute

if [ -f "$CACHE_FILE" ]; then
    if [ "$(uname)" = "Darwin" ]; then
        age=$(( $(date +%s) - $(stat -f %m "$CACHE_FILE") ))
    else
        age=$(( $(date +%s) - $(stat -c %Y "$CACHE_FILE") ))
    fi
    now_epoch=$(date +%s)
    five_reset_cached=$(sed -n '5p' "$CACHE_FILE")
    seven_reset_cached=$(sed -n '6p' "$CACHE_FILE")
    reset_passed=0
    [ -n "$five_reset_cached" ] && [ "$now_epoch" -gt "$five_reset_cached" ] && reset_passed=1
    [ -n "$seven_reset_cached" ] && [ "$now_epoch" -gt "$seven_reset_cached" ] && reset_passed=1
    if [ "$age" -lt "$CACHE_MAX_AGE" ] && [ "$reset_passed" -eq 0 ]; then
        exit 0
    fi
fi

# Lockfile: only one process hits the API at a time (prevents stampede from multiple sessions)
if [ -d "$LOCK_FILE" ]; then
    if [ "$(uname)" = "Darwin" ]; then
        lock_age=$(( $(date +%s) - $(stat -f %m "$LOCK_FILE") ))
    else
        lock_age=$(( $(date +%s) - $(stat -c %Y "$LOCK_FILE") ))
    fi
    [ "$lock_age" -lt 15 ] && exit 0
    rmdir "$LOCK_FILE" 2>/dev/null
fi
mkdir "$LOCK_FILE" 2>/dev/null || exit 0
trap 'rmdir "$LOCK_FILE" 2>/dev/null' EXIT

# Get OAuth token from macOS Keychain
RAW_CRED=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null)
[ -z "$RAW_CRED" ] && exit 1

# Try plain JSON first, then hex-decode fallback
TOKEN=$(echo "$RAW_CRED" | jq -r '.claudeAiOauth.accessToken' 2>/dev/null)
if [ -z "$TOKEN" ] || [ "$TOKEN" = "null" ]; then
    TOKEN=$(echo "$RAW_CRED" | python3 -c "
import sys, re
hexdata = sys.stdin.read().strip()
try:
    decoded = bytes.fromhex(hexdata).decode('utf-8', errors='ignore')
    m = re.search(r'\"accessToken\":\"(sk-ant-oat01-[^\"]+)\"', decoded)
    if m: print(m.group(1))
except: pass
" 2>/dev/null)
fi

[ -z "$TOKEN" ] || [ "$TOKEN" = "null" ] && exit 1

USAGE=$(curl -s --max-time 5 \
    -H "Authorization: Bearer $TOKEN" \
    -H "anthropic-beta: oauth-2025-04-20" \
    "https://api.anthropic.com/api/oauth/usage" 2>/dev/null)

[ -z "$USAGE" ] || ! echo "$USAGE" | jq -e '.five_hour' &>/dev/null && exit 1

now=$(date +%s)

five_hour=$(echo "$USAGE" | jq -r '.five_hour.utilization // 0')
seven_day=$(echo "$USAGE" | jq -r '.seven_day.utilization // 0')
five_reset=$(echo "$USAGE" | jq -r '.five_hour.resets_at // empty')
seven_reset=$(echo "$USAGE" | jq -r '.seven_day.resets_at // empty')

calc_projected() {
    local util=$1 reset_iso=$2 window_secs=$3 min_elapsed=$4
    [ -z "$reset_iso" ] || [ "$reset_iso" = "null" ] && { echo ""; return; }

    local reset_epoch
    if [ "$(uname)" = "Darwin" ]; then
        reset_epoch=$(date -juf "%Y-%m-%d %H:%M:%S" "$(echo "$reset_iso" | cut -d. -f1 | sed 's/T/ /')" +%s 2>/dev/null)
    else
        reset_epoch=$(date -d "$reset_iso" +%s 2>/dev/null)
    fi
    [ -z "$reset_epoch" ] && { echo ""; return; }

    local remaining=$(( reset_epoch - now ))
    [ "$remaining" -lt 0 ] && remaining=0
    local elapsed=$(( window_secs - remaining ))
    [ "$elapsed" -lt "$min_elapsed" ] && { echo ""; return; }

    local util_int=${util%.*}
    [ -z "$util_int" ] || [ "$util_int" = "0" ] && { echo "0"; return; }

    local projected=$(( util_int * window_secs / elapsed ))
    [ "$projected" -gt 200 ] && projected=200
    echo "$projected"
}

five_proj=$(calc_projected "$five_hour" "$five_reset" 18000 600)
seven_proj=$(calc_projected "$seven_day" "$seven_reset" 604800 7200)

parse_reset_epoch() {
    local iso=$1
    [ -z "$iso" ] || [ "$iso" = "null" ] && { echo ""; return; }
    if [ "$(uname)" = "Darwin" ]; then
        date -juf "%Y-%m-%d %H:%M:%S" "$(echo "$iso" | cut -d. -f1 | sed 's/T/ /')" +%s 2>/dev/null
    else
        date -d "$iso" +%s 2>/dev/null
    fi
}

five_reset_epoch=$(parse_reset_epoch "$five_reset")
seven_reset_epoch=$(parse_reset_epoch "$seven_reset")

printf '%s\n%s\n%s\n%s\n%s\n%s\n' "$five_hour" "$seven_day" "$five_proj" "$seven_proj" "$five_reset_epoch" "$seven_reset_epoch" > "$CACHE_FILE"
