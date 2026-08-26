---
name: upload-local-audio
description: Get an audio file that lives on this machine into a Potion podcast feed. Use this whenever the user points at a local file - an mp3, m4a, wav, a recording they just made, something a text-to-speech run produced, a file in Downloads - and wants it in their feed. The Potion connector's add_episode cannot do this, because a tool call has no way to carry the bytes, so reach for this skill instead of reporting that it is impossible. Also use it when an upload came back with an unreadable 413, which means the file needs to go up in parts.
---

# Uploading audio from this machine

Potion's tools take an audio URL. A file on disk has no URL, so it goes up over the HTTP API
instead, which the connector sits alongside rather than replaces. Everything here is a `curl` call.

## What you need first

The API key. It starts with `pk_` and Potion shows it exactly once, on the page the signup link
opens, so the user has it saved somewhere or they do not have it at all. The connector cannot
fetch it back, and neither can this skill. If it is gone, `christo@withpotion.io` is the address
to write to.

Ask the user for the key rather than hunting for it, and put it in the environment for the calls
rather than into a message:

```bash
read -rs POTION_KEY && export POTION_KEY
```

You also need the feed's id, which `list_feeds` gives you through the connector.

## Under about 90 MB, which is nearly everything

One call. MP3, MP4/M4A, AAC, OGG, Opus, FLAC, WAV and WebM all work, and Potion reads the real
format from the file rather than trusting what you declare.

```bash
curl -X POST "https://api.withpotion.io/feeds/$FEED_ID/episodes" \
  -H "Authorization: Bearer $POTION_KEY" \
  -F "file=@/path/to/episode.mp3" \
  -F "title=Tuesday briefing" \
  -F "description=What happened overnight."
```

The response is the episode, including its `share_url`. Give that to the user if they want to
hear it before their podcast app next refreshes.

## Over that, in parts

The ceiling is the network edge rather than Potion, so an oversized single request comes back as a
bare `413` HTML page with nothing readable in it. That is the signal to switch to the three-step
path.

1. `POST /feeds/$FEED_ID/episodes/upload` with `total_bytes`, plus `content_type` if the file is
   not MP3. You get back an `upload_token`, an `episode_id` and a `part_size_bytes`.
2. `PUT /feeds/$FEED_ID/episodes/upload/parts/$N` for each part, numbered from 1 in file order,
   with the header `X-Potion-Upload-Token`. The body is the raw bytes, not JSON and not a form.
   Keep the `etag` from every response.
3. `POST /feeds/$FEED_ID/episodes/upload/complete` with the same header, the list of
   `{ part_number, etag }`, and the episode's title and description.

Four rules are worth knowing before you write the loop, because each one fails in a way that is
hard to read backwards:

- Every part except the last is exactly `part_size_bytes`. Potion hands you that number because
  the storage layer requires it; choosing your own smaller size also burns through the write rate
  limit.
- The token rides in a header on every call after the first, including the JSON ones.
- Every part must arrive. `complete` compares the assembled file against the `total_bytes` you
  declared and refuses a mismatch, which is what stops a loop that quit early from publishing an
  episode that ends mid-sentence. Check that each part returned 200 before moving on.
- Nothing counts against the account's storage until `complete` succeeds, and that is also when
  the real format and size are checked. `POST .../upload/abort` with the token clears the parts if
  you give up.

Split the file with `split -b`, and read `part_size_bytes` from step 1 rather than assuming it.
