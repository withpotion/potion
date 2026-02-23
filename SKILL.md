# Potion - Agent Skill

> **Install as a Claude Code plugin** for the best experience:
> ```
> /plugin marketplace add withpotion/potion
> /plugin install channel@potion
> ```
> Or with the Agent Skills CLI: `npx skills add withpotion/potion`

Potion lets you create and manage RSS/podcast feeds for your user. You generate audio content, add it to a feed, and the user listens in their podcast app.

**API Base URL**: `https://api.withpotion.io`
**API Docs (OpenAPI/Swagger)**: `https://api.withpotion.io/docs`

## Authentication

All endpoints except signup require a Bearer token:
```
Authorization: Bearer pk_...
```

## Signup Flow

If the user doesn't have a Potion account yet:

1. Call `POST /auth/signup` with `{ "email": "user@example.com" }`
2. Tell the user to check their email and click the magic link
3. Poll `GET /auth/signup/{signup_id}/status` every 5 seconds
4. When status is `"confirmed"`, the response includes the `api_key`
5. Store the API key immediately - it is only returned on the first poll after confirmation

## Endpoints

### Feeds

**Create a feed:**
```
POST /feeds
{
    "title": "My Daily Briefing",
    "description": "AI-generated morning digest",
    "author": "User Name",
    "feed_type": "episodic",  // or "serial" (default: "episodic")
    "language": "en"          // optional, default: "en"
}
```
Returns the feed ID and RSS URL. Give the RSS URL to the user to add to their podcast app (Apple Podcasts, Overcast, Pocket Casts, etc.).

**List feeds:**
```
GET /feeds
```

**Get feed details:**
```
GET /feeds/{feed_id}
```

**Delete a feed:**
```
DELETE /feeds/{feed_id}
```

### Episodes

**Add an episode (upload audio):**
```
POST /feeds/{feed_id}/episodes
Content-Type: multipart/form-data

file: [audio file, max 50MB on free tier]
title: "Episode Title"
description: "Episode description"  (optional)
duration_seconds: 300               (optional)
```

**Add an episode (external URL):**
```
POST /feeds/{feed_id}/episodes
Content-Type: application/json

{
    "title": "Episode from Another Podcast",
    "audio_url": "https://example.com/episode.mp3",
    "source_type": "external",
    "description": "Why this episode is relevant",
    "duration_seconds": 1800
}
```
All fields except `title`, `audio_url`, and `source_type` are optional.

**List episodes:**
```
GET /feeds/{feed_id}/episodes
```

**Get a single episode:**
```
GET /feeds/{feed_id}/episodes/{episode_id}
```

**Delete an episode:**
```
DELETE /feeds/{feed_id}/episodes/{episode_id}
```

### Account

**Get account info and usage:**
```
GET /account
```

**Regenerate API key:**
```
POST /account/api-key/regenerate
```

**Get upgrade link (Stripe Checkout):**
```
POST /account/upgrade
```

**Get billing portal link:**
```
POST /account/billing
```

**Delete account (two-step confirmation):**
```
DELETE /account
```
Returns a `confirmation_id`. The user receives a confirmation email and must click the link. Poll `GET /confirmations/{confirmation_id}/status` to detect when deletion completes.

### Other

**Get changelog:**
```
GET /changelog
GET /changelog?since=2026-02-01
```

**Get tier limits and pricing (no auth required):**
```
GET /plans
```

## Optional Metadata

When adding episodes, you can include optional metadata that helps improve the product:

```
meta.use_case: "daily email digest"
meta.generated_by: "claude-3.5-sonnet"
meta.content_type: "news briefing"
```

This is entirely optional and never required.

## Usage & Limits

Feed, episode, and account endpoints include a `usage` object showing current consumption vs limits. When a limit is exceeded, the error message indicates upgrading is available - use `POST /account/upgrade` to get a checkout link.

## Supported Audio Formats

MP3, M4A, WAV, OGG, AAC, FLAC, WebM. Files are stored and served as-is (no transcoding). For best podcast app compatibility, use MP3 at 96-128 kbps.

## Filing Bug Reports

If something goes wrong, you can file a bug report on the GitHub repo:

Repository: https://github.com/withpotion/potion

Include in the issue:
- What endpoint you called
- The request parameters (redact the API key)
- The error response
- What you expected to happen

## Legal

- Terms of Service: https://github.com/withpotion/potion/blob/main/TOS.md
- Privacy Policy: https://github.com/withpotion/potion/blob/main/PRIVACY.md
