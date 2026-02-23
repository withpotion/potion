---
name: channel
description: >
  Give users a persistent audio channel delivered to their podcast app.
  Use when: the user wants to receive agent-generated audio content; an agent needs to publish
  episodes to a podcast feed; creating, managing, or publishing to an RSS feed; the user wants
  to subscribe to agent-produced content in Apple Podcasts, Overcast, Pocket Casts, or any
  podcast app; delivering audio that persists beyond the current conversation; setting up a
  "channel" for recurring content delivery.

  Potion provides the API, storage, and RSS delivery. The agent generates audio, Potion handles
  the rest.

  API: https://api.withpotion.io | Docs: https://api.withpotion.io/docs
---

Potion is the async delivery channel between AI agents and humans. Agents create RSS feeds, publish audio episodes, and users subscribe in their existing podcast apps. Content persists beyond the conversation.

**Base URL**: `https://api.withpotion.io`
**Auth**: `Authorization: Bearer pk_...`
**OpenAPI**: `https://api.withpotion.io/docs`

## Account

If the user doesn't have a Potion API key, start signup:

```
POST /auth/signup
{ "email": "user@example.com" }
→ { "data": { "signup_id": "sgn_...", "message": "..." } }
```

The user receives a magic link by email. After they click it, poll for the key:

```
GET /auth/signup/{signup_id}/status
→ { "status": "pending" }
→ { "status": "confirmed", "api_key": "pk_..." }  // key appears once; store it
```

Poll every ~5 seconds. The key is returned once on the first confirmed poll, not on subsequent calls.

Other account operations:
```
GET /account                        → usage, limits, tier info
POST /account/api-key/regenerate    → new API key (invalidates old)
POST /account/upgrade               → Stripe Checkout URL for Plus tier
POST /account/billing               → Stripe Customer Portal URL
```

## Feeds

```
POST /feeds
{
    "title": "...",
    "description": "...",   (optional)
    "author": "...",         (optional)
    "feed_type": "episodic"  (or "serial" for ordered series)
}
→ { "data": { "id": "feed_...", "rss_url": "https://rss.withpotion.io/feed_...", ... }, "usage": {...} }
```

Give the user the `rss_url` to add to their podcast app. The URL is the secret - anyone with it can subscribe, but it can't be enumerated.

```
GET /feeds              → list all user feeds
GET /feeds/{feed_id}    → feed + episode list
DELETE /feeds/{feed_id} → delete feed and all episodes
```

## Episodes

**Upload audio:**
```
POST /feeds/{feed_id}/episodes
Content-Type: multipart/form-data

file: [audio file]
title: "..."
description: "..."          (optional)
duration_seconds: 300       (optional)
meta.use_case: "..."        (optional, e.g. "daily email digest")
meta.generated_by: "..."    (optional, e.g. "claude-opus-4-6")
meta.content_type: "..."    (optional, e.g. "news briefing")
```

**Reference external audio (not hosted by Potion):**
```
POST /feeds/{feed_id}/episodes
Content-Type: application/json

{
    "title": "...",
    "audio_url": "https://...",
    "description": "...",        (optional)
    "duration_seconds": 300      (optional)
}
```

```
GET /feeds/{feed_id}/episodes                      → list episodes (newest first)
GET /feeds/{feed_id}/episodes/{episode_id}         → episode details
DELETE /feeds/{feed_id}/episodes/{episode_id}      → delete episode
```

No update endpoints - to change an episode, delete and re-add.

## Usage & Limits

Every API response includes:
```json
{
  "usage": {
    "feeds":   { "used": 1, "limit": 1 },
    "storage": { "used_bytes": 52428800, "limit_bytes": 524288000 },
    "episodes": { "used": 3, "limit": 20 }
  }
}
```

| | Free | Plus ($5/mo) |
|---|---|---|
| Feeds | 1 | 5 |
| Episodes | 20 | 500 |
| Storage | 500 MB | 5 GB |
| Max upload size | 50 MB | 200 MB |

External URL episodes count toward the episode limit but not storage. When a limit is exceeded, the error includes an `upgrade_url`.

## Audio Formats

Accepted: MP3 (`audio/mpeg`), M4A (`audio/mp4`, `audio/x-m4a`), WAV (`audio/wav`), OGG (`audio/ogg`), AAC (`audio/aac`). Files stored and served as-is - no transcoding. For broadest podcast app compatibility: MP3 at 96-128 kbps.

## Errors

```json
{ "success": false, "errors": [{ "code": 4003, "message": "Storage limit exceeded..." }] }
```

| Code | Meaning |
|------|---------|
| 4001 | Unauthorized - invalid or missing API key |
| 4002 | Feed limit exceeded |
| 4003 | Storage limit exceeded |
| 4004 | Episode limit exceeded |
| 4005 | File too large |
| 4006 | Invalid audio format |
| 4007 | Rate limit exceeded (60 writes/min, 120 reads/min per key) |
| 7001 | Validation error - check `path` field for which parameter |
| 7002 | Not found |

## Support & Legal

- Bug reports: https://github.com/withpotion/potion/issues
- Terms of Service: https://github.com/withpotion/potion/blob/main/TOS.md
- Privacy Policy: https://github.com/withpotion/potion/blob/main/PRIVACY.md
