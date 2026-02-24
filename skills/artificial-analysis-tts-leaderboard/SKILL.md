---
name: TTS Leaderboard Extraction
description: Extract data from Artificial Analysis TTS Leaderboard (https://artificialanalysis.ai/text-to-speech/leaderboard). Use when user asks to check TTS model rankings, compare TTS providers, or get current ELO scores for text-to-speech models.
version: 1.0.0
last-verified: 2026-01-26
dependencies: python3, curl
---

# TTS Leaderboard Data Extraction

## Purpose

Programmatically extract structured data from the [Artificial Analysis TTS Leaderboard](https://artificialanalysis.ai/text-to-speech/leaderboard) - the primary objective benchmark for comparing text-to-speech models.

## When to Use

- User asks to check current TTS rankings or ELO scores
- Comparing TTS providers by quality, price, or value
- Updating project docs with current leaderboard data
- Analyzing price/quality tradeoffs across TTS models

## Script

`skills/artificial-analysis-tts-leaderboard/extract_tts_leaderboard.py` (relative to repo root)

```bash
# Table output (global leaderboard)
python3 skills/artificial-analysis-tts-leaderboard/extract_tts_leaderboard.py

# JSON for programmatic use
python3 skills/artificial-analysis-tts-leaderboard/extract_tts_leaderboard.py --json

# All leaderboard variants (accent x category combos)
python3 skills/artificial-analysis-tts-leaderboard/extract_tts_leaderboard.py --all

# Cache HTML to avoid re-fetching
python3 skills/artificial-analysis-tts-leaderboard/extract_tts_leaderboard.py --html /tmp/tts.html
```

## Extracted Fields

| Field | Type | Description |
|-------|------|-------------|
| `rank` | int | Position in leaderboard |
| `name` | str | Model name (e.g., "Inworld TTS 1 Max") |
| `creator` | str | Provider name |
| `elo` | float | ELO score from blind A/B comparisons |
| `ci` | str | Confidence interval (e.g., "-14/14") |
| `win_rate_pct` | float | Win rate percentage |
| `appearances` | int | Number of comparisons |
| `price_per_1m_chars` | float/null | Cost per 1M characters (null if unlisted) |
| `released` | str | Release date (empty if unknown) |
| `open_weights` | bool | Whether model weights are public |
| `url` | str | Full URL to model page |
| `id` | str | UUID identifier |

## Leaderboard Variants

The page contains ~15 leaderboard variants: combinations of accent (Global, US, UK) and category (Entertainment, Knowledge Sharing, Assistants, Customer Service). The first is always the main "Global" leaderboard. Use `--all` to extract all variants.

## How It Works (Technical Details)

The page is a Next.js app that embeds all data in React Server Component (RSC) payloads via `self.__next_f.push()` script tags in the HTML. No separate API endpoint exists.

**Key implementation details:**

1. **RSC payload parsing**: Model data lives in `self.__next_f.push([1,"..."])` script blocks. The strings use `\"` escaping which gets cleaned to standard JSON.

2. **"formatted" vs "values" objects**: Each model has both. The `formatted` object has display strings but uses RSC lazy references (`$L1b`, `$L2a`) for prices and dates after ~rank 9. The `values` object always has raw numeric data. **Extract from `values`.**

3. **Null handling**: `pricePer1MCharacters` is `null` for models without public API pricing (Step TTS 2, GPT-4o mini TTS, NVIDIA models, etc.). `released` can be `null` (not empty string) for unreleased models.

4. **Multiple leaderboards per push**: RSC pushes concatenate multiple leaderboard datasets. Split on rank resets (when rank drops back to 1-2).

5. **Regex pattern**: Matches the `values` object structure:
   ```
   "formatted":{"rank":N,...},"values":{"id":"...","name":"...","url":"...",...}
   ```

## Gotchas

- **Page structure may change**: If Artificial Analysis updates their Next.js app, the RSC payload format could change. If extraction breaks, inspect the HTML for new patterns.
- **Some models lack pricing**: `price_per_1m_chars` is null for ~13/60 models in the global leaderboard.
- **Variant labeling**: Only the first leaderboard ("global") is definitively identified. Others are labeled `variant_1` through `variant_14`. Compare #1 model ELO against the website to identify specific accent/category combos if needed.
- **No API**: This is HTML scraping, not an official API. Rate-limit appropriately.
