#!/usr/bin/env bash
# Optimize the raw demo GIFs into docs/assets/ and emit poster PNGs.
#
# Pipeline per GIF:
#   1. gifsicle lossy optimization (color reduction + lossy LZW within reason)
#   2. write the optimized GIF to docs/assets/
#   3. extract a representative poster PNG (a mid/late frame) for fallback/social
#
# Readability is never sacrificed for size; budgets are documented in README.md.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$HERE/../.." && pwd)"
WORK="${README_DEMO_WORK:-/tmp/blazecrawl-readme-demo}"
OUT_RAW="$WORK/raw"
ASSETS="$REPO_ROOT/docs/assets"
mkdir -p "$ASSETS"

GIFSICLE="${GIFSICLE:-$(command -v gifsicle || true)}"
FFMPEG="${FFMPEG:-$(command -v ffmpeg || true)}"
[ -n "$GIFSICLE" ] || { echo "missing gifsicle" >&2; exit 1; }
[ -n "$FFMPEG" ] || { echo "missing ffmpeg" >&2; exit 1; }

# name -> gifsicle lossy level (tuned per asset; higher = smaller + lower quality)
optimize() {
  local name="$1" lossy="$2"
  local src="$OUT_RAW/$name.gif"
  local dst="$ASSETS/blazecrawl-$name.gif"
  [ -f "$src" ] || { echo "missing raw gif: $src" >&2; return 1; }

  # Optimize: 256 colors, lossy LZW at the given level, drop duplicate frames.
  "$GIFSICLE" -O3 --colors 256 --lossy="$lossy" --optimize=3 \
    "$src" -o "$dst"

  # Poster PNG: the final frame (the summary card) for fallback/social.
  local n
  n=$("$GIFSICLE" --info "$dst" 2>/dev/null | grep -c 'image #')
  n=${n:-1}
  "$FFMPEG" -y -i "$dst" -vf "select=eq(n\,$((n > 1 ? n - 1 : 0)))" -vsync 0 \
    -vframes 1 "$ASSETS/blazecrawl-$name.png" >/dev/null 2>&1 || true

  report "$name" "$dst"
}

report() {
  local name="$1" dst="$2"
  local size dims dur
  size=$(stat -c%s "$dst")
  dims=$("$FFMPEG" -i "$dst" 2>&1 | grep -oE '[0-9]+x[0-9]+' | head -1 || echo "?")
  dur=$("$FFMPEG" -i "$dst" 2>&1 | grep -oE 'Duration: [0-9:.]+' | head -1 | awk '{print $2}' || echo "?")
  printf '  %-12s %8s  %10s  %s bytes\n' "$name" "${dims:-?}" "${dur:-?}" "$size"
}

echo ">> optimizing into $ASSETS"
optimize hero 60
optimize map-crawl 60
optimize security 60
optimize mcp 60
echo ">> done"
