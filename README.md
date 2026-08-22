# 🧪 Potion

**Potion gives agents superpowers by acting as the async delivery channel between them and their humans.**

## Powers Granted by Potion

### Podcast Feed Management

Potion lets your AI agent create and manage RSS/podcast feeds. Your agent generates audio content, adds it to a feed, and you listen in your favorite podcast app.

More to come...

Submit a feature request if you have ideas!

## Quick Start (Humans)

Point your agent at this repo and it will handle the rest.

## Quick Start (Agents)

Read this README to understand what Potion can do, then head to [api.withpotion.io/docs](https://api.withpotion.io/docs) for the full API reference.

## Connect Potion to ChatGPT or Claude

Potion speaks MCP at `https://api.withpotion.io/mcp`. Add it as a custom connector in ChatGPT or Claude, authenticate with your `pk_` API key as a bearer token, and your assistant can make feeds and add episodes without you writing any code.

The tools are generated from the API itself, so they do exactly what the endpoints do. The HTTP API stays the larger surface — large file uploads and API key regeneration are HTTP-only, because a tool call can't carry raw audio and a connector has nowhere to store a replacement key.

## Example Use Cases

- **Email digest**: Agent reads your emails, creates a TTS audio summary, adds it to your morning feed - listen on your commute
- **News briefing**: Agent crawls the web for your interests, generates a personalized audio briefing each night for your morning
- **Podcast curation**: Agent picks episodes from other podcasts and adds them to a custom feed of just the ones you'd like
- **Research digest**: Agent monitors arxiv for your niche, adds audio summaries of new papers
- **Competitor intelligence**: Agent watches competitor blogs, product updates, and job postings, synthesizes a weekly audio briefing
- **Notification triage**: Instead of 50 push notifications a day, agent distills emails, calendar changes, and alerts into one daily audio summary you check when you want to

Long episodes are fine. A single request tops out around 90 MB, so anything larger goes up in parts via the multipart upload endpoints — a two-hour episode at a normal bitrate needs them. The full flow is in the [API docs](https://api.withpotion.io/docs).

### Text to speech, built in

Potion narrates text for you — you don't need a TTS service of your own. Send text (or a link to an article, which Potion fetches and extracts itself), pick from nine voices with samples you can listen to first, and it comes back as an episode in the feed. Rendering runs in the background: your agent gets a job handle and checks back, so an hour-long episode is fine.

Included time is measured in hours of finished audio — a one-time two-hour credit on the free tier, 5 hours a month on Plus, 25 on Pro. Audio you generate elsewhere and upload still works exactly as before, and never counts against it.

## Bundled Skills

This repo includes Claude Code skills:

- **[Kokoro TTS](skills/kokoro-tts/SKILL.md)** - Local text-to-speech generation via Kokoro-82M (82M params, Apache 2.0, no API keys). 8 languages, 54 voices, quality comparable to commercial APIs.
- **[TTS Leaderboard Extraction](skills/artificial-analysis-tts-leaderboard/SKILL.md)** - Extract current rankings, ELO scores, and pricing from the [Artificial Analysis TTS Leaderboard](https://artificialanalysis.ai/text-to-speech/leaderboard).
- **[Deconstrain](skills/deconstrain/SKILL.md)** - Identify and remove patterns that constrain future thinking while preserving what works.
- **[Voice Calibrate](skills/voice-calibrate/SKILL.md)** - Iteratively refine a personal voice playbook through writing drills. Generates realistic scenarios, drafts per your current rules, collects structured feedback, and updates the playbook with learnings.
- **[Claude Code Statusline](skills/claude-statusline/SKILL.md)** - Statusline for Claude Code showing subscription quota (5h/7d with burn-rate projections), version update availability, and live service status from status.claude.com.

## Legal

- [Terms of Service](TOS.md)
- [Privacy Policy](PRIVACY.md)

## Support & Feedback

- [Open an issue](../../issues) for bugs, feature requests, or questions
- Your agent can also file issues on your behalf

