#!/usr/bin/env python3
"""Auditoría de contraste WCAG para la paleta de Me Toca.

Lee los colores de app/lib/app/theme/app_colors.dart y calcula la relación
de contraste para los pares texto/fondo que se usan en las pantallas.
Umbral AA: 4.5 para texto normal, 3.0 para texto grande.
"""

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
COLORS_FILE = ROOT / "app" / "lib" / "app" / "theme" / "app_colors.dart"


def parse_colors(path: Path) -> dict[str, str]:
    colors = {}
    for line in path.read_text().splitlines():
        match = re.search(r"static const (\w+) = Color\((0x[0-9A-Fa-f]+)\);", line)
        if match:
            colors[match.group(1)] = match.group(2)
    return colors


def hex_to_rgb(value: str) -> tuple[int, int, int]:
    n = int(value, 16)
    return ((n >> 16) & 0xFF, (n >> 8) & 0xFF, n & 0xFF)


def relative_luminance(rgb: tuple[int, int, int]) -> float:
    def channel(c: int) -> float:
        s = c / 255
        return s / 12.92 if s <= 0.03928 else ((s + 0.055) / 1.055) ** 2.4

    r, g, b = rgb
    return 0.2126 * channel(r) + 0.7152 * channel(g) + 0.0722 * channel(b)


def contrast(fg: str, bg: str) -> float:
    l1 = relative_luminance(hex_to_rgb(fg))
    l2 = relative_luminance(hex_to_rgb(bg))
    lighter, darker = max(l1, l2), min(l1, l2)
    return (lighter + 0.05) / (darker + 0.05)


def main() -> None:
    colors = parse_colors(COLORS_FILE)
    if not colors:
        raise SystemExit("No se encontraron colores en " + str(COLORS_FILE))

    # Pares (primer plano, fondo) que se usan en las pantallas.
    pairs = [
        ("lightInk", "lightCanvas"),
        ("lightInkMuted", "lightCanvas"),
        ("lightPrimary", "lightCanvas"),
        ("lightAccent", "lightCanvas"),
        ("lightInk", "lightSurface"),
        ("lightInkMuted", "lightSurface"),
        ("lightPrimary", "lightPrimarySoft"),
        ("darkInk", "darkCanvas"),
        ("darkInkMuted", "darkCanvas"),
        ("darkPrimary", "darkCanvas"),
        ("darkAccent", "darkCanvas"),
        ("darkInk", "darkSurface"),
        ("darkInkMuted", "darkSurface"),
        ("darkPrimary", "darkPrimarySoft"),
    ]

    print("Auditoría de contraste — Me Toca")
    print("=" * 60)
    failures = 0
    for fg_name, bg_name in pairs:
        fg = colors[fg_name]
        bg = colors[bg_name]
        ratio = contrast(fg, bg)
        ok = "OK  " if ratio >= 4.5 else "FAIL"
        if ratio < 4.5:
            failures += 1
        print(f"{ok}  {fg_name:18} on {bg_name:18}  {ratio:5.2f}:1")

    print("=" * 60)
    print(f"Pares evaluados: {len(pairs)} | Fallos AA: {failures}")
    if failures:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
