# Potion

**The async delivery channel between AI agents and humans.**

Potion lets your AI agent create and manage RSS/podcast feeds. Your agent generates audio content, adds it to a feed, and you listen in your favorite podcast app. No dashboard, no web UI - your agent is the interface.

## How It Works

1. Your agent signs you up (just your email)
2. You click a magic link to verify
3. Your agent gets an API key and creates a feed
4. You add the feed URL to your podcast app
5. Your agent adds episodes whenever it has something for you

That's it. Your agent handles the rest.

## Quick Start

Install as a Claude Code plugin for the best experience:

```
/plugin marketplace add withpotion/potion
/plugin install channel@potion
```

Or point any agent at the API docs: [api.withpotion.io/docs](https://api.withpotion.io/docs)

## API Documentation

Full OpenAPI documentation with Swagger UI: [api.withpotion.io/docs](https://api.withpotion.io/docs)

## Example Use Cases

- **Email digest**: Agent reads your emails, creates a TTS audio summary, adds it to your morning feed - listen on your commute
- **News briefing**: Agent crawls the web for your interests, generates a personalized audio briefing each night for your morning
- **Podcast curation**: Agent picks episodes from other podcasts and adds them to a custom feed of just the ones you'd like
- **Research digest**: Agent monitors arxiv for your niche, adds audio summaries of new papers
- **Competitor intelligence**: Agent watches competitor blogs, product updates, and job postings, synthesizes a weekly audio briefing
- **Notification triage**: Instead of 50 push notifications a day, agent distills emails, calendar changes, and alerts into one daily audio summary you check when you want to

## Legal

- [Terms of Service](TOS.md)
- [Privacy Policy](PRIVACY.md)

Changes to these documents are versioned in this repo. You can view the full change history with `git log TOS.md` or `git log PRIVACY.md`.

## Support & Feedback

- [Open an issue](../../issues) for bugs, feature requests, or questions
- Your agent can also file issues on your behalf (see SKILL.md for instructions)

## Links

- API: [api.withpotion.io](https://api.withpotion.io)
- Feed serving: rss.withpotion.io

