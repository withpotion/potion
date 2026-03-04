---
name: claude-statusline
description: >
  Set up a Claude Code statusline showing subscription quota usage (5h/7d windows with
  burn-rate projections), version update availability, and live service status from
  status.claude.com. Use when user asks to: set up a statusline, add quota monitoring,
  show service status, configure Claude Code status bar, or monitor their subscription usage.
---

# Claude Code Statusline

Install a statusline for Claude Code that shows three things:

1. **Quota** - 5h and 7d subscription windows with burn-rate projections and reset countdowns
2. **Version** - current vs latest from npm, with upgrade indicator
3. **Service status** - live incidents from status.claude.com (hidden when all operational)

## Prerequisites

- Claude Code with active subscription
- `jq`, `curl`, `npm`, `bc` in PATH
- **macOS**: Quota feature uses Keychain to read the OAuth token (auto-created by Claude Code)
- **Linux**: Version and service status work out of the box. Quota requires extracting the OAuth token manually - see `check-claude-quota.sh` for the token retrieval section to adapt

## Installation

1. Copy scripts to `~/.claude/`:

```bash
SKILL_DIR="skills/claude-statusline/scripts"  # adjust if skill is elsewhere
cp "$SKILL_DIR/statusline.sh" ~/.claude/statusline.sh
cp "$SKILL_DIR/check-claude-version.sh" ~/.claude/check-claude-version.sh
cp "$SKILL_DIR/check-claude-quota.sh" ~/.claude/check-claude-quota.sh
cp "$SKILL_DIR/check-claude-status.sh" ~/.claude/check-claude-status.sh
chmod +x ~/.claude/statusline.sh ~/.claude/check-claude-*.sh
```

2. Add to `~/.claude/settings.json`:

```json
{
  "statusLine": {
    "command": "bash ~/.claude/statusline.sh"
  }
}
```

3. Restart Claude Code. Caches populate on first render.

## Display Examples

Normal: `v2.2.0 | 5h:25% ↻3.1h 7d:55% ↻1.7d`

Update available: `v2.2.0→2.3.0 | 5h:25% ↻3.1h 7d:55% ↻1.7d`

Quota warning: `v2.2.0 | 5h:42%→82% ↻2.4h 7d:58%→76% ↻1.6d`

Service incident: `v2.2.0 | 5h:25% ↻3.1h 7d:55% ↻1.7d | ! CC API`

## Color Coding

- **Quota**: gray (normal), yellow (projected >= 70%), red (current >= 80% or projected >= 90%)
- **Version**: gray (current), yellow→green (update available)
- **Status**: red `!` prefix, per-component: red (major outage), orange (partial), yellow (degraded), blue (maintenance)

## Cache Refresh Intervals

| Cache | File | Interval |
|-------|------|----------|
| Quota | `~/.claude/.quota-cache` | 1 min |
| Version | `~/.claude/.latest-version` | 1 hour |
| Status | `~/.claude/.status-cache` | 5 min |

## Extending

The statusline receives JSON on stdin from Claude Code:

```json
{
  "workspace": { "current_dir": "/path" },
  "model": { "display_name": "Opus 4.6" },
  "version": "2.2.0",
  "session_id": "uuid",
  "context_window": { "used_percentage": 25 }
}
```

Add modules by reading these fields and appending to the output.
