#!/usr/bin/env python3
# /// script
# requires-python = ">=3.10"
# dependencies = [
#   "kokoro>=0.9.4",
#   "soundfile",
#   "pydub",
#   "numpy",
#   "pip",
# ]
# ///
"""
Generate speech audio from text using Kokoro TTS (82M, local, Apache 2.0).

Usage:
    uv run generate.py "Hello world" -o output.mp3
    uv run generate.py "Hello world" -o output.wav --voice af_heart
    uv run generate.py -f input.txt -o output.mp3 --voice am_adam --speed 1.2
    uv run generate.py "Bonjour le monde" -o output.mp3 --lang f --voice ff_siwis

First run downloads the model (~350MB) from HuggingFace.
Requires espeak-ng: brew install espeak-ng (macOS) or apt install espeak-ng (Linux).
"""

import argparse
import sys
import shutil
import subprocess
from pathlib import Path


def check_espeak():
    """Verify espeak-ng is installed."""
    if not shutil.which("espeak-ng") and not shutil.which("espeak"):
        print("ERROR: espeak-ng not found.", file=sys.stderr)
        print("Install it:", file=sys.stderr)
        print("  macOS:  brew install espeak-ng", file=sys.stderr)
        print("  Linux:  sudo apt install espeak-ng", file=sys.stderr)
        sys.exit(1)


def detect_lang(voice: str) -> str:
    """Infer lang_code from voice prefix."""
    if not voice or len(voice) < 2:
        return "a"
    return voice[0]


def generate(text: str, voice: str, speed: float, output: Path):
    import numpy as np
    import soundfile as sf
    from kokoro import KPipeline

    lang = detect_lang(voice)
    pipeline = KPipeline(lang_code=lang)

    chunks = []
    for _, _, audio in pipeline(text, voice=voice, speed=speed):
        chunks.append(audio)

    if not chunks:
        print("ERROR: No audio generated.", file=sys.stderr)
        sys.exit(1)

    full_audio = np.concatenate(chunks)
    sample_rate = 24000

    suffix = output.suffix.lower()
    if suffix in (".wav", ".flac"):
        fmt = "FLAC" if suffix == ".flac" else "WAV"
        sf.write(str(output), full_audio, sample_rate, format=fmt)
    elif suffix == ".mp3":
        from pydub import AudioSegment

        audio_int16 = (full_audio * 32767).clip(-32768, 32767).astype(np.int16)
        segment = AudioSegment(
            audio_int16.tobytes(),
            frame_rate=sample_rate,
            sample_width=2,
            channels=1,
        )
        segment.export(str(output), format="mp3")
    elif suffix in (".ogg", ".opus"):
        # Write wav to temp, convert with ffmpeg
        import tempfile

        if not shutil.which("ffmpeg"):
            print("ERROR: ffmpeg required for .ogg/.opus output.", file=sys.stderr)
            sys.exit(1)
        with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as tmp:
            sf.write(tmp.name, full_audio, sample_rate)
            subprocess.run(
                ["ffmpeg", "-y", "-i", tmp.name, str(output)],
                capture_output=True,
                check=True,
            )
            Path(tmp.name).unlink(missing_ok=True)
    else:
        # Default: write as wav
        sf.write(str(output), full_audio, sample_rate)

    duration = len(full_audio) / sample_rate
    size_kb = output.stat().st_size / 1024
    print(f"Wrote {output} ({duration:.1f}s, {size_kb:.0f}KB)")


def list_voices():
    """List available voice IDs."""
    voices = {
        "American English (lang_code='a')": [
            "af_heart", "af_bella", "af_sarah", "af_nicole", "af_sky",
            "af_alloy", "af_aoede", "af_jessica", "af_kore", "af_nova", "af_river",
            "am_adam", "am_echo", "am_eric", "am_fenrir", "am_liam",
            "am_michael", "am_onyx", "am_puck", "am_santa",
        ],
        "British English (lang_code='b')": [
            "bf_alice", "bf_emma", "bf_isabella", "bf_lily",
            "bm_daniel", "bm_fable", "bm_george", "bm_lewis",
        ],
        "Japanese (lang_code='j')": [
            "jf_alpha", "jf_gongitsune", "jf_nezuko", "jf_tebukuro", "jm_kumo",
        ],
        "Mandarin Chinese (lang_code='z')": [
            "zf_xiaobei", "zf_xiaoni", "zf_xiaoxiao", "zf_xiaoyi",
            "zm_yunjian", "zm_yunxi", "zm_yunxia", "zm_yunyang",
        ],
        "Spanish (lang_code='e')": ["ef_dalia", "em_alex", "em_santa"],
        "French (lang_code='f')": ["ff_siwis"],
        "Hindi (lang_code='h')": ["hf_alpha", "hf_beta", "hm_omega", "hm_psi"],
        "Italian (lang_code='i')": ["if_sara", "im_nicola"],
        "Brazilian Portuguese (lang_code='p')": ["pf_dora", "pm_alex", "pm_santa"],
    }
    for group, ids in voices.items():
        print(f"\n{group}:")
        for v in ids:
            print(f"  {v}")


def main():
    parser = argparse.ArgumentParser(
        description="Generate speech from text using Kokoro TTS (local, 82M params)"
    )
    parser.add_argument("text", nargs="?", help="Text to speak")
    parser.add_argument("-f", "--file", help="Read text from file instead")
    parser.add_argument("-o", "--output", default="output.wav", help="Output file path (.wav, .mp3, .flac, .ogg)")
    parser.add_argument("--voice", default="af_heart", help="Voice ID (default: af_heart)")
    parser.add_argument("--speed", type=float, default=1.0, help="Speed multiplier (default: 1.0)")
    parser.add_argument("--list-voices", action="store_true", help="List available voices and exit")
    args = parser.parse_args()

    if args.list_voices:
        list_voices()
        return

    if args.file:
        text = Path(args.file).read_text()
    elif args.text:
        text = args.text
    else:
        parser.error("Provide text as argument or via -f/--file")

    check_espeak()
    generate(text, args.voice, args.speed, Path(args.output))


if __name__ == "__main__":
    main()
