#!/bin/bash
# Claude Code statusline - shows quota usage, version updates, and service status.
# Configure in ~/.claude/settings.json:
#   "statusLine": { "command": "bash ~/.claude/statusline.sh" }
#
# Features:
#   - 5h/7d subscription quota with burn-rate projections and reset countdowns
#   - Version update indicator (current vs latest from npm)
#   - Service status from status.claude.com (only shown during incidents)
#
# Helper scripts (run lazily in background):
#   - check-claude-quota.sh   (refreshed every 1 min)
#   - check-claude-version.sh (refreshed every 1 hour)
#   - check-claude-status.sh  (refreshed every 5 min)

input=$(cat)

# --- Version ---
ver=$(echo "$input" | jq -r '.version // empty')
latest=""
latest_cache="$HOME/.claude/.latest-version"
[ -f "$latest_cache" ] && latest=$(cat "$latest_cache")

# Lazy refresh (>1h)
if [ ! -f "$latest_cache" ] || { [ "$(uname)" = "Darwin" ] && [ $(( $(date +%s) - $(stat -f %m "$latest_cache" 2>/dev/null || echo 0) )) -gt 3600 ]; } || { [ "$(uname)" != "Darwin" ] && [ $(( $(date +%s) - $(stat -c %Y "$latest_cache" 2>/dev/null || echo 0) )) -gt 3600 ]; }; then
    "$(dirname "$0")/check-claude-version.sh" &>/dev/null &
fi

ver_str=""
if [ -n "$ver" ]; then
    if [ -n "$latest" ] && [ "$ver" != "$latest" ] && \
       [ "$(printf '%s\n%s' "$ver" "$latest" | sort -V | tail -1)" = "$latest" ]; then
        ver_str=$'\e[38;5;220m'"v${ver}"$'\e[38;5;240m→\e[38;5;114m'"${latest}"$'\e[0m'
    else
        ver_str=$'\e[38;5;240m'"v${ver}"$'\e[0m'
    fi
fi

# --- Quota ---
quota_str=""
quota_cache="$HOME/.claude/.quota-cache"
if [ -f "$quota_cache" ]; then
    five_hour=$(sed -n '1p' "$quota_cache" | cut -d. -f1)
    seven_day=$(sed -n '2p' "$quota_cache" | cut -d. -f1)
    five_proj=$(sed -n '3p' "$quota_cache")
    seven_proj=$(sed -n '4p' "$quota_cache")
    five_reset_epoch=$(sed -n '5p' "$quota_cache")
    seven_reset_epoch=$(sed -n '6p' "$quota_cache")

    format_remaining() {
        local reset_epoch=$1
        [ -z "$reset_epoch" ] && { echo ""; return; }
        local remaining=$(( reset_epoch - $(date +%s) ))
        [ "$remaining" -lt 0 ] && remaining=0
        local mins=$(( remaining / 60 ))
        if [ "$mins" -lt 60 ]; then
            echo "${mins}m"
        elif [ "$remaining" -lt 86400 ]; then
            printf '%.1fh' "$(echo "scale=1; $remaining / 3600" | bc)"
        else
            printf '%.1fd' "$(echo "scale=1; $remaining / 86400" | bc)"
        fi
    }

    format_quota() {
        local label=$1 current=$2 projected=$3 reset_epoch=$4
        local clr arrow="" reset_str=""
        local effective=$current
        [ -n "$projected" ] && [ "$projected" -gt 0 ] && effective=$projected

        if [ "$current" -ge 80 ] || [ "$effective" -ge 90 ]; then
            clr=$'\e[38;5;196m'
        elif [ "$effective" -ge 70 ]; then
            clr=$'\e[38;5;220m'
        else
            clr=$'\e[38;5;240m'
        fi

        [ -n "$projected" ] && [ "$projected" -ge 70 ] && arrow="→${projected}%"

        local ttl
        ttl=$(format_remaining "$reset_epoch")
        [ -n "$ttl" ] && reset_str=$'\e[38;5;240m'"↻${ttl}"$'\e[0m'

        printf '%s%s:%s%%%s\e[0m %s' "$clr" "$label" "$current" "$arrow" "$reset_str"
    }

    if [ -n "$five_hour" ] && [ -n "$seven_day" ]; then
        q5=$(format_quota "5h" "$five_hour" "$five_proj" "$five_reset_epoch")
        q7=$(format_quota "7d" "$seven_day" "$seven_proj" "$seven_reset_epoch")
        quota_str="${q5} ${q7}"
    fi
fi

# Lazy refresh quota (>1min)
if [ ! -f "$quota_cache" ] || { [ "$(uname)" = "Darwin" ] && [ $(( $(date +%s) - $(stat -f %m "$quota_cache" 2>/dev/null || echo 0) )) -gt 60 ]; } || { [ "$(uname)" != "Darwin" ] && [ $(( $(date +%s) - $(stat -c %Y "$quota_cache" 2>/dev/null || echo 0) )) -gt 60 ]; }; then
    "$(dirname "$0")/check-claude-quota.sh" &>/dev/null &
fi

# --- Service Status (only shown when degraded) ---
status_str=""
status_cache="$HOME/.claude/.status-cache"
if [ -f "$status_cache" ] && [ -s "$status_cache" ]; then
    while IFS=: read -r comp sev; do
        case "$comp" in
            *"Claude Code"*) short="CC" ;;
            *"API"*) short="API" ;;
            *"claude.ai"*) short="Web" ;;
            *"Government"*) short="Gov" ;;
            *"platform"*|*"console"*) short="Console" ;;
            *) short="$comp" ;;
        esac
        case "$sev" in
            major_outage) clr=$'\e[38;5;196m' ;;
            partial_outage) clr=$'\e[38;5;208m' ;;
            degraded_performance) clr=$'\e[38;5;220m' ;;
            under_maintenance) clr=$'\e[38;5;75m' ;;
            *) clr=$'\e[38;5;220m' ;;
        esac
        status_str="${status_str:+$status_str }${clr}${short}"$'\e[0m'
    done < "$status_cache"
    [ -n "$status_str" ] && status_str=$'\e[38;5;196m'"!"$'\e[0m '"${status_str}"
fi

# Lazy refresh status (>5min)
if [ ! -f "$status_cache" ] || { [ "$(uname)" = "Darwin" ] && [ $(( $(date +%s) - $(stat -f %m "$status_cache" 2>/dev/null || echo 0) )) -gt 300 ]; } || { [ "$(uname)" != "Darwin" ] && [ $(( $(date +%s) - $(stat -c %Y "$status_cache" 2>/dev/null || echo 0) )) -gt 300 ]; }; then
    "$(dirname "$0")/check-claude-status.sh" &>/dev/null &
fi

# --- Output ---
sep=$'\e[38;5;240m│\e[0m'
parts=()
[ -n "$ver_str" ] && parts+=("$ver_str")
[ -n "$quota_str" ] && parts+=("$quota_str")
[ -n "$status_str" ] && parts+=("$status_str")

output=""
for i in "${!parts[@]}"; do
    [ "$i" -gt 0 ] && output+=" ${sep} "
    output+="${parts[$i]}"
done

printf '%s' "$output"
