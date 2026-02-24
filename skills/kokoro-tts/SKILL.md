---
name: kokoro-tts
description: >
  Generate speech audio locally using Kokoro TTS (82M params, Apache 2.0).
  Use when: user asks to generate audio/speech from text, convert text to speech,
  create TTS output, make audio from a script, or needs local/offline voice synthesis.
  Also use when building workflows that produce audio files (podcasts, briefings,
  narration, notifications). Runs entirely on-device, no API keys needed.
---

# Kokoro TTS

Local text-to-speech via Kokoro-82M. 82M parameters, ~350MB model, Apache 2.0 license. Quality comparable to commercial TTS APIs. 8 languages, 54 voices.

## Prerequisites

espeak-ng must be installed for phonemization:

```bash
# macOS
brew install espeak-ng

# Linux
sudo apt install espeak-ng
```

Model downloads automatically on first run (~350MB from HuggingFace).

## Generate Audio

Run the bundled script via uv (handles all Python dependencies):

```bash
# Text to MP3
uv run scripts/generate.py "Your text here" -o output.mp3

# Text to WAV (default)
uv run scripts/generate.py "Your text here" -o output.wav

# From file
uv run scripts/generate.py -f input.txt -o output.mp3

# Different voice and speed
uv run scripts/generate.py "Hello" -o output.mp3 --voice am_adam --speed 1.1

# List all available voices
uv run scripts/generate.py --list-voices
```

Script path: `skills/kokoro-tts/scripts/generate.py` (relative to repo root)

Supported output formats: `.wav`, `.mp3`, `.flac`, `.ogg`/`.opus` (last two require ffmpeg).

## Voice Selection

Voice IDs follow `{lang}{gender}_{name}`. The first letter sets the language automatically.

- `a` = American English, `b` = British English, `j` = Japanese, `z` = Mandarin, `e` = Spanish, `f` = French, `h` = Hindi, `i` = Italian, `p` = Brazilian Portuguese
- `f` after lang = female, `m` = male

Good defaults: `af_heart` (female), `am_adam` (male). Run `--list-voices` for the full set.

## Inline Usage

When the script doesn't fit the situation, use kokoro directly in Python:

```python
import numpy as np
import soundfile as sf
from kokoro import KPipeline

pipeline = KPipeline(lang_code='a')
chunks = [audio for _, _, audio in pipeline("Text here", voice='af_heart', speed=1.0)]
sf.write('output.wav', np.concatenate(chunks), 24000)
```

Sample rate is always 24000 Hz. The generator yields chunks at sentence boundaries, so arbitrarily long text works without manual splitting.

## Known Gotchas

- **MPS (Apple Silicon GPU)**: Set `PYTORCH_ENABLE_MPS_FALLBACK=1` env var or some operations fail silently.
- **First run is slow**: Model download + warmup. Subsequent runs are fast.
- **MP3 needs ffmpeg or pydub**: The script uses pydub (bundled via PEP 723 deps). If pydub can't find ffmpeg for edge cases, install it: `brew install ffmpeg`.
- **510-token internal limit**: Per-chunk limit handled transparently by KPipeline's auto-splitting. Not a user concern unless debugging empty output on very short inputs.
- **First run downloads spaCy model**: Kokoro uses pip internally to install `en_core_web_sm` (~13MB) on first run. The script includes `pip` in its PEP 723 deps to handle this.
- **Warnings on stderr are normal**: Deprecation warnings from PyTorch (weight_norm, LSTM dropout) and pydub (regex escapes) are harmless noise.
