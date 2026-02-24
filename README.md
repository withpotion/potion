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

## Example Use Cases

- **Email digest**: Agent reads your emails, creates a TTS audio summary, adds it to your morning feed - listen on your commute
- **News briefing**: Agent crawls the web for your interests, generates a personalized audio briefing each night for your morning
- **Podcast curation**: Agent picks episodes from other podcasts and adds them to a custom feed of just the ones you'd like
- **Research digest**: Agent monitors arxiv for your niche, adds audio summaries of new papers
- **Competitor intelligence**: Agent watches competitor blogs, product updates, and job postings, synthesizes a weekly audio briefing
- **Notification triage**: Instead of 50 push notifications a day, agent distills emails, calendar changes, and alerts into one daily audio summary you check when you want to

Audio generation currently requires your agent to use a third-party TTS service. Your agent already knows how to use ElevenLabs, OpenAI TTS, and others. Potion handles the feed interface and delivery. Submit a feature request if you want to see this natively.

## Bundled Skills

This repo includes Claude Code skills that are useful for TTS workflows:

- **[Kokoro TTS](skills/kokoro-tts/SKILL.md)** - Local text-to-speech generation via Kokoro-82M (82M params, Apache 2.0, no API keys). 8 languages, 54 voices, quality comparable to commercial APIs.
- **[TTS Leaderboard Extraction](skills/artificial-analysis-tts-leaderboard/SKILL.md)** - Extract current rankings, ELO scores, and pricing from the [Artificial Analysis TTS Leaderboard](https://artificialanalysis.ai/text-to-speech/leaderboard).

## Legal

- [Terms of Service](TOS.md)
- [Privacy Policy](PRIVACY.md)

## Support & Feedback

- [Open an issue](../../issues) for bugs, feature requests, or questions
- Your agent can also file issues on your behalf

