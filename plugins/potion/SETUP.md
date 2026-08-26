---
name: potion-setup
description: Connect the Potion connector and sign the user in, and help them get their feed into a podcast app. Use this when Potion's tools are missing or refusing calls, when a Potion call says there is no account, when the user has just installed this plugin, or when they have a feed URL and do not know what to do with it.
---

# Setting Potion up

Two things have to happen once, and neither of them needs an API key.

## 1. Authorize the connector

The `potion` server is remote and signs in over OAuth. In Claude Code that is `/mcp`, then Potion,
then authenticate; a browser window opens and comes back authorized. If the tools are listed but
every call is refused, this is what is missing.

## 2. Make sure there is an account

Potion has no password. Signing in and signing up are the same act: the OAuth page asks for an
email address, sends a link to it, and clicking the link both creates the account (if it is new)
and completes the connection.

If a tool call comes back saying there is no account, `start_signup` is the other way in. It takes
an email address and returns a signup id, and then `check_signup` reports where things stand.
While it says `pending`, the user has to go and click the link in their email, and nothing moves
until they do, so tell them that rather than polling in silence. When it comes back `confirmed`,
the response carries an API key once and only once. Show it to the user and say plainly that
Potion cannot show it again. They will not need it for anything in this plugin except uploading
audio files from their own machine.

## 3. Get the feed into a podcast app

This is the step people get stuck on, and it is worth doing properly rather than handing over a
URL and moving on.

A Potion feed is an ordinary RSS podcast feed at a secret address. Every podcast app can add one
by URL, but they all hide it somewhere different, and some of the popular ones make it genuinely
hard to find. Ask the user which app they use, look up the current steps for that app, and walk
them through it. Potion deliberately ships no per-app instructions, because they go stale and
because you can find the real ones.

Tell the user the URL is the key to the feed. Anyone holding it can subscribe, so it should not be
posted anywhere public.

If they want to hear something immediately, an episode's `share_url` plays in a browser and does
not need any of this.
