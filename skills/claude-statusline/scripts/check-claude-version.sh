#!/bin/bash
# Fetch latest Claude Code version from npm registry and cache it.
# Cache: ~/.claude/.latest-version (refreshed every 1 hour)

CACHE_FILE="$HOME/.claude/.latest-version"
CACHE_MAX_AGE=3600

if [ -f "$CACHE_FILE" ]; then
    if [ "$(uname)" = "Darwin" ]; then
        age=$(( $(date +%s) - $(stat -f %m "$CACHE_FILE") ))
    else
        age=$(( $(date +%s) - $(stat -c %Y "$CACHE_FILE") ))
    fi
    [ "$age" -lt "$CACHE_MAX_AGE" ] && exit 0
fi

touch "$CACHE_FILE"

latest=$(npm show @anthropic-ai/claude-code version 2>/dev/null)
[ -n "$latest" ] && echo "$latest" > "$CACHE_FILE"
