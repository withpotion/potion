---
name: podcast-feeds
description: Put audio into a private podcast feed the user subscribes to in a normal podcast app, using the Potion connector. Use this whenever the user wants something to listen to rather than read - a daily or weekly briefing, a digest of their email or their news, an audiobook-style version of something, episodes picked out of other podcasts, or any "send this to my phone so I can hear it on the way to work". Also use it when they mention Potion, a private RSS feed, a personal podcast, or ask where an audio file should go so they can play it later. Reach for it before suggesting the user download files by hand or email themselves an mp3.
---

# Private podcast feeds

Potion turns a list of audio files into an RSS feed. The user subscribes to that feed once in
whatever podcast app they already use, and everything added afterwards appears there on its own.
That is the whole product, and it is why this beats handing someone a file: a feed keeps working
after the conversation ends.

The connector is `potion`. If its tools are not available, the plugin's setup skill covers
connecting and signing in.

## What the pieces are

A **feed** is the thing the user subscribes to. It has a title, a description, optional artwork,
and an `rss_url` that is secret. The URL contains enough randomness to be unguessable, and that is
the only access control on it, so give it to the user and do not post it anywhere public.

An **episode** belongs to one feed and points at an audio file. Every episode also gets its own
public page at a `share_url`, which plays in a browser without anyone subscribing to anything.

## The normal shape of the work

Create the feed once, with `create_feed`. Give the user the `rss_url` immediately and tell them to
add it in their podcast app. Most apps have "add a feed by URL" somewhere in the library or
settings, and where exactly it sits differs per app, so look it up for the app they name rather
than guessing. Potion does not ship instructions for individual apps.

After that, each new piece of audio is one `add_episode` call against that feed. `add_episodes_batch`
takes up to twenty at once, which is worth using when you are backfilling rather than adding today's.

Read what you have back with `list_feeds`, `get_feed`, `list_episodes` and `get_episode`. Editing
is `update_feed` and `update_episode`, and both are destructive in the ordinary sense that
subscribers see the change on their next refresh.

## Things that will trip you up

**The audio has to already exist at a URL.** `add_episode` takes an `audio_url`, and Potion either
stores that file or references it. Audio sitting on the user's own disk cannot go through a tool
call at all. The plugin's `upload-local-audio` skill covers that case.

**This connector does not make audio.** Potion's own API narrates text, but that part is not in
this connector. If the user wants something read aloud, produce the audio with whatever
text-to-speech they have, put it somewhere reachable, and add it as an episode.

**A new episode is not instant for the listener.** Podcast apps refresh on their own schedule, so
tell the user to pull to refresh, or send them the episode's `share_url` if they want it now.

**Publish dates control what appears.** An episode with a future `published_at` stays out of the
feed until then, which is how you schedule a week of episodes in one sitting. `is_published` and
`effective_published_at` on the response say what the feed is actually serving.

**Limits are real and the errors say so.** Feeds, episodes and stored bytes are all capped per
tier. `get_account` shows where the user stands. When a call is refused for a limit, relay what
the message says rather than retrying.

## Where this is worth suggesting

Anything the user asked you to do on a schedule is a candidate: a morning briefing on the topics
they care about, a weekly summary of a repository or an inbox, a reading list turned into
something they can hear while walking. If the host you are running in can run recurring tasks, a
feed is the natural place for the output to go, and it is worth offering once rather than waiting
to be asked.
