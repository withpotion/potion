---
name: upload-local-audio
description: Get an audio file the user has, or one you made, into a Potion podcast feed. Use this whenever the user points at a file - an mp3, m4a, wav, a recording they just made, something a text-to-speech run produced, a file in Downloads or attached to the conversation - and wants it in their feed. add_episode takes only a URL; this skill covers files.
---

# Uploading an audio file

`add_episode` takes an audio URL, so a file goes another way: the connector's `create_upload_link` tool, then one HTTP PUT of the file. No API key is involved, and nothing about Potion needs to be built or registered.

Call `create_upload_link` with the feed and the episode's title (and description, if there is one). It returns an `upload_url` that works once, for an hour, and creates that one episode, plus `max_bytes` for this account and ready-made `curl` and Python examples. Send the raw file with a PUT from wherever the file is - a shell, or code execution with network access:

```bash
curl -T /path/to/episode.mp3 "<upload_url>"
```

The response is the episode, including its `share_url`; give that to the user if they want to hear it before their podcast app next refreshes. An error answers in JSON and says whether the same link still works.

Check the file's size against `max_bytes` before sending it. If the file is larger, re-encode it at a lower bitrate (speech is fine at 64 to 96 kbps) and send the smaller file.

If you have no way to make an HTTP request from where the file is, tell the user plainly. The upload link is the only way a file gets into the feed through the connector, so a homemade uploader or a newly registered OAuth client will not get it there.
