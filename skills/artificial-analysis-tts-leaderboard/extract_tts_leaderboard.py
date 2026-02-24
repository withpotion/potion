#!/usr/bin/env python3
"""Extract TTS leaderboard data from Artificial Analysis.

The page embeds data in React Server Component (RSC) payloads via
self.__next_f.push() calls. Model data appears in multiple pushes,
one per leaderboard view (Global, US accent, UK accent, categories).

Key insight: The "formatted" object has display strings but uses RSC
references ($L...) for prices after rank ~9. The "values" object always
has raw numeric data, so we extract from there.

Usage:
    # Pretty table output
    python3 extract_tts_leaderboard.py

    # JSON output
    python3 extract_tts_leaderboard.py --json

    # Save HTML and reuse (skip fetch)
    curl -s https://artificialanalysis.ai/text-to-speech/leaderboard > /tmp/tts.html
    python3 extract_tts_leaderboard.py --html /tmp/tts.html
"""
import sys
import re
import json
import subprocess
from pathlib import Path


def fetch_html(cache_path: str | None = None) -> str:
    """Fetch leaderboard HTML, optionally from a cached file."""
    if cache_path and Path(cache_path).exists():
        return Path(cache_path).read_text()

    result = subprocess.run(
        ["curl", "-s", "https://artificialanalysis.ai/text-to-speech/leaderboard"],
        capture_output=True, text=True, timeout=30
    )
    html = result.stdout
    if cache_path:
        Path(cache_path).write_text(html)
    return html


def extract_rsc_pushes(html: str) -> list[str]:
    """Extract RSC payload strings from the HTML."""
    return re.findall(
        r'self\.__next_f\.push\(\[1,"(.*?)"\]\)</script>', html, re.DOTALL
    )


def find_leaderboard_pushes(pushes: list[str]) -> list[str]:
    """Identify pushes that contain leaderboard model data."""
    results = []
    for push in pushes:
        if 'apiPricing' in push and 'formatted' in push and 'pricePer1MCharacters' in push:
            results.append(push)
    return results


def extract_models_from_push(push: str) -> list[dict]:
    """Extract all model entries from an RSC push payload.

    Uses the 'values' object for raw data since 'formatted' uses RSC
    references for some fields (prices, release dates) after rank ~9.
    """
    # Unescape RSC string encoding
    clean = push.replace('\\"', '"')

    models = []

    # Extract using values fields which always have raw data
    # Pattern matches the full formatted+values structure
    # Note: pricePer1MCharacters can be null for models without listed pricing
    pattern = (
        r'"formatted":\{"rank":(\d+),'  # display rank
        r'[^}]+\}'  # skip rest of formatted
        r',"values":\{'
        r'"id":"([^"]+)",'
        r'"name":"([^"]+)",'
        r'"url":"([^"]+)",'
        r'"rank":(\d+),'
        r'"elo":([0-9.]+),'
        r'"ci":"([^"]+)",'
        r'"appearances":(\d+),'
        r'"creator":\{"id":"[^"]+","name":"([^"]+)","logoUrl":"[^"]*","color":"[^"]*"\},'
        r'"released":("(?:[^"]*)"|null),'
        r'"openWeightsUrl":([^,]+),'
        r'"winRate":([0-9.]+),'
        r'"pricePer1MCharacters":(null|[0-9.]+)'
    )

    for match in re.finditer(pattern, clean):
        groups = match.groups()
        display_rank = int(groups[0])
        id_ = groups[1]
        name = groups[2]
        url = groups[3]
        _rank_idx = int(groups[4])
        elo = float(groups[5])
        ci = groups[6]
        appearances = int(groups[7])
        creator = groups[8]
        released_raw = groups[9]
        released = released_raw.strip('"') if released_raw != "null" else ""
        open_weights_url = groups[10]
        win_rate = float(groups[11])
        price_raw = groups[12]
        price = float(price_raw) if price_raw != "null" else None

        has_open_weights = open_weights_url not in ('null', 'false', '""')

        models.append({
            "rank": display_rank,
            "name": name,
            "creator": creator,
            "elo": round(elo, 2),
            "ci": ci,
            "win_rate_pct": round(win_rate * 100, 1),
            "appearances": appearances,
            "price_per_1m_chars": price,
            "released": released,
            "open_weights": has_open_weights,
            "url": f"https://artificialanalysis.ai{url}",
            "id": id_,
        })

    return models


def split_leaderboards(models: list[dict]) -> list[list[dict]]:
    """Split a flat list of models into separate leaderboards.

    Multiple leaderboard datasets are concatenated in a single RSC push.
    We detect boundaries by rank resets (rank drops back to a lower value).
    """
    if not models:
        return []

    leaderboards = []
    current = [models[0]]

    for m in models[1:]:
        if m["rank"] <= current[-1]["rank"] and m["rank"] <= 2:
            # Rank reset - new leaderboard starts
            leaderboards.append(current)
            current = [m]
        else:
            current.append(m)

    if current:
        leaderboards.append(current)

    return leaderboards


def extract_all_leaderboards(html: str) -> dict[str, list[dict]]:
    """Extract all leaderboards from the page HTML."""
    pushes = extract_rsc_pushes(html)
    lb_pushes = find_leaderboard_pushes(pushes)

    # Extract all models from all pushes, then split on rank resets
    all_models = []
    for push in lb_pushes:
        all_models.extend(extract_models_from_push(push))

    leaderboard_lists = split_leaderboards(all_models)

    # The first leaderboard is always Global (all categories, all accents).
    # Subsequent ones are combinations of:
    #   Categories: Entertainment, Knowledge Sharing, Assistants, Customer Service
    #   Accents: Global, US, UK
    # Exact order may change if the page is updated. Use the first (#1 model
    # and ELO) to identify specific leaderboards if needed.
    results = {}
    for i, lb in enumerate(leaderboard_lists):
        if i == 0:
            label = "global"
        else:
            label = f"variant_{i}"
        results[label] = lb

    return results


def print_leaderboard(name: str, models: list[dict]):
    """Print a formatted leaderboard table."""
    print(f"\n{'=' * 130}")
    print(f"  {name.upper().replace('_', ' ')} ({len(models)} models)")
    print(f"{'=' * 130}")
    header = (
        f"{'#':<4} {'Model':<35} {'Creator':<15} {'ELO':<8} {'CI':<10} "
        f"{'Win%':<7} {'$/1M':<10} {'OW':<4} {'Released':<12} {'Appearances'}"
    )
    print(header)
    print("-" * 130)
    for m in models:
        ow = "Y" if m["open_weights"] else ""
        price = f"${m['price_per_1m_chars']:.1f}" if m['price_per_1m_chars'] is not None else "N/A"
        print(
            f"{m['rank']:<4} {m['name']:<35} {m['creator']:<15} "
            f"{m['elo']:<8.1f} {m['ci']:<10} {m['win_rate_pct']:<7.1f} "
            f"{price:<10} {ow:<4} {m['released']:<12} "
            f"{m['appearances']}"
        )


def main():
    import argparse
    parser = argparse.ArgumentParser(description="Extract TTS leaderboard data")
    parser.add_argument("--json", action="store_true", help="Output as JSON")
    parser.add_argument("--html", help="Path to cached HTML file")
    parser.add_argument("--leaderboard", "-l", default="global",
                        help="Which leaderboard to show (global, us_accent, uk_accent, etc.)")
    parser.add_argument("--all", "-a", action="store_true",
                        help="Show all leaderboards")
    args = parser.parse_args()

    html = fetch_html(args.html)
    leaderboards = extract_all_leaderboards(html)

    if args.json:
        if args.all:
            print(json.dumps(leaderboards, indent=2))
        else:
            data = leaderboards.get(args.leaderboard, [])
            print(json.dumps(data, indent=2))
    else:
        if args.all:
            for name, models in leaderboards.items():
                print_leaderboard(name, models)
        else:
            data = leaderboards.get(args.leaderboard)
            if data:
                print_leaderboard(args.leaderboard, data)
            else:
                print(f"Leaderboard '{args.leaderboard}' not found.")
                print(f"Available: {', '.join(leaderboards.keys())}")

        # Summary
        print(f"\n{'=' * 130}")
        print("SUMMARY")
        for name, models in leaderboards.items():
            marker = " <--" if name == args.leaderboard and not args.all else ""
            print(f"  {name}: {len(models)} models{marker}")


if __name__ == "__main__":
    main()
