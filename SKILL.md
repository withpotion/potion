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
5. Store the API key for future use

## Endpoints

### Feeds

**Create a feed:**
```
POST /feeds
{
    "title": "My Daily Briefing",
    "description": "AI-generated morning digest",
    "author": "User Name",
    "feed_type": "episodic"  // or "serial"
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
description: "Episode description"
duration_seconds: 300  (optional)
```

**Add an episode (external URL):**
```
POST /feeds/{feed_id}/episodes
Content-Type: application/json

{
    "title": "Episode from Another Podcast",
    "audio_url": "https://example.com/episode.mp3",
    "source_type": "external",
    "description": "Why this episode is relevant"
}
```

**List episodes:**
```
GET /feeds/{feed_id}/episodes
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

## Optional Metadata

When adding episodes, you can include optional metadata that helps improve the product:

```
meta.use_case: "daily email digest"
meta.generated_by: "claude-3.5-sonnet"
meta.content_type: "news briefing"
```

This is entirely optional and never required.

## Usage & Limits

Every API response includes a `usage` object showing current consumption vs limits. When a limit is exceeded, the error response includes an upgrade URL.

**Free tier**: 1 feed, 20 episodes, 500 MB storage, 50 MB per upload.
**Plus ($5/mo)**: 5 feeds, 500 episodes, 5 GB storage, 200 MB per upload.

## Supported Audio Formats

MP3, M4A, WAV, OGG, AAC. Files are stored and served as-is (no transcoding). For best podcast app compatibility, use MP3 at 96-128 kbps.

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
