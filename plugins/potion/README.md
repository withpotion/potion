# Potion plugin

Private podcast feeds for Claude. Create a feed, add episodes to it, and subscribe to it in
whatever podcast app you already use.

## What it gives Claude

- **The Potion connector** (`https://api.withpotion.io/mcp/claude`), for creating and managing
  feeds and episodes. It signs in over OAuth, so there is no key to paste.
- **A skill for the feed workflow**, so Claude knows an RSS URL is the thing to hand you, how
  scheduling works, and when a feed is worth suggesting in the first place.
- **A skill for uploading audio from your own machine**, which the connector cannot do on its own
  because a tool call has no way to carry the bytes.
- **A setup skill**, which covers connecting, signing in, and the part everyone gets stuck on:
  adding the feed in your podcast app.

## Installing it

```
/plugin marketplace add withpotion/potion
/plugin install potion@potion
```

Then `/mcp` to authorize the connector. Potion signs you in with an emailed link, and clicking it
creates your account if you do not have one yet.

## What it does not do

This connector does not generate audio. Potion's own API can narrate text into speech, and that is
not part of this plugin. Bring audio you already have, or produce it with the text-to-speech you
already use, and Potion delivers it.

Large file uploads and API key regeneration are HTTP-only for the same reason: a tool call cannot
carry raw audio, and a connector has nowhere to put a replacement key.

## Links

- [API documentation](https://api.withpotion.io/docs)
- [Terms of Service](../../TOS.md) and [Privacy Policy](../../PRIVACY.md)
- [Issues](https://github.com/withpotion/potion/issues)
