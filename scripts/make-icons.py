#!/usr/bin/env python3
"""Generate the catalog icon set from one square master logo.

Usage:  python3 scripts/make-icons.py path/to/evendo-mark-master.png
Needs:  pip install pillow

Writes to assets/:
  logo-400.png  400x400 (Cline requires exactly this; also Docker and registry icon)
  logo-512.png  512x512 (general fallback)
  logo-256.png  256x256 (small listings)
The SVG (assets/logo.svg) must come from the design source; it isn't generated here.
Upload logo-400.png and logo.svg to https://media.evendo.com/assets/mcp/ as
evendo-icon-400.png and evendo-icon.svg, matching server.json and server.yaml.
"""
import sys
from pathlib import Path
from PIL import Image

src = Path(sys.argv[1])
out = Path(__file__).resolve().parent.parent / "assets"
out.mkdir(exist_ok=True)

img = Image.open(src).convert("RGBA")
# Pad to square on a transparent canvas, keeping the mark centred
side = max(img.size)
canvas = Image.new("RGBA", (side, side), (0, 0, 0, 0))
canvas.paste(img, ((side - img.width) // 2, (side - img.height) // 2), img)

for size in (400, 512, 256):
    path = out / f"logo-{size}.png"
    canvas.resize((size, size), Image.LANCZOS).save(path, optimize=True)
    print("wrote", path)
