#!/usr/bin/env python3
"""Generate Disney castle app icons for iOS and tvOS."""

from PIL import Image, ImageDraw
import math, os

# ── colour palette ──────────────────────────────────────────────────────────
BG_TOP    = (10,  10,  40)
BG_BOT    = (46,  21,  97)
CASTLE    = (255, 255, 255)
CASTLE_SH = (200, 170, 255)   # soft lilac for depth
STAR_COL  = (255, 240, 180)
GLOW_COL  = (140, 80, 255)


def lerp_colour(c1, c2, t):
    return tuple(int(c1[i] + (c2[i] - c1[i]) * t) for i in range(3))


def draw_gradient_bg(draw, w, h):
    for y in range(h):
        t = y / h
        c = lerp_colour(BG_TOP, BG_BOT, t)
        draw.line([(0, y), (w, y)], fill=c)


def draw_glow(img, cx, cy, radius, colour, alpha=120):
    glow = Image.new("RGBA", img.size, (0, 0, 0, 0))
    d = ImageDraw.Draw(glow)
    for r in range(radius, 0, -1):
        a = int(alpha * (1 - r / radius) ** 1.5)
        d.ellipse([cx - r, cy - r, cx + r, cy + r],
                  fill=(*colour, a))
    img.alpha_composite(glow)


def draw_star(draw, cx, cy, r, colour, alpha=220):
    pts = []
    for i in range(8):
        angle = math.radians(i * 45 - 90)
        rr = r if i % 2 == 0 else r * 0.42
        pts.append((cx + math.cos(angle) * rr, cy + math.sin(angle) * rr))
    draw.polygon(pts, fill=(*colour, alpha))


def castle_silhouette(draw, cx, base_y, scale, colour=CASTLE):
    """Draw a simplified Disney-style castle centred on cx, bottom at base_y."""
    s = scale    # 1.0 → fits in ~340px wide for 1024 canvas

    def rect(x, y, w, h, fill=colour):
        draw.rectangle([cx + x * s, base_y + y * s,
                        cx + (x + w) * s, base_y + (y + h) * s], fill=fill)

    def tri(pts, fill=colour):
        scaled = [(cx + p[0] * s, base_y + p[1] * s) for p in pts]
        draw.polygon(scaled, fill=fill)

    def turret(tx, ty, r, h, fill=colour):
        """Cylinder-ish turret + crenellations."""
        rect(tx - r, ty - h, r * 2, h, fill)
        for i in range(3):
            rx = tx - r + i * (r * 2 / 3)
            rect(rx, ty - h - r * 0.6, r * 2 / 3 * 0.55, r * 0.6, fill)

    def spire(tx, ty, r, h, fill=colour):
        tri([(tx - r, ty), (tx + r, ty), (tx, ty - h)], fill)

    # ── main keep (centre tower) ─────────────────────────────────────────
    rect(-28, -310, 56, 310)
    # crenellations on main keep
    for i in range(5):
        rect(-28 + i * 14, -325, 8, 18)
    # main spire
    spire(0, -310, 22, 130)

    # ── arch / gate ──────────────────────────────────────────────────────
    rect(-20, -80, 40, 80)                      # gate body
    # arch cutout (draw darker)
    gate_col = lerp_colour(colour, BG_BOT, 0.75)
    tri([(-12, -80), (12, -80), (0, -110)], fill=gate_col)   # arch top
    rect(-12, -80, 24, 80, fill=gate_col)                     # gate opening

    # ── flanking towers (inner pair) ────────────────────────────────────
    for sx in (-1, 1):
        turret(sx * 52, -20, 16, 200)
        spire(sx * 52, -20 - 200, 13, 80)

    # ── outer towers ────────────────────────────────────────────────────
    for sx in (-1, 1):
        turret(sx * 98, 0, 13, 170)
        spire(sx * 98, -170, 11, 65)

    # ── curtain walls ───────────────────────────────────────────────────
    for sx in (-1, 1):
        rect(sx * 36, -60, sx * 16 * sx, 60)   # inner wall segment

    rect(-110, -30, 220, 30)   # base platform


def draw_stars_bg(img_rgba, w, h, seed=42):
    """Scatter small white dots as stars."""
    import random
    rng = random.Random(seed)
    overlay = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(overlay)
    for _ in range(60):
        x = rng.randint(0, w)
        y = rng.randint(0, int(h * 0.55))
        r = rng.uniform(0.5, 2.5)
        alpha = rng.randint(100, 240)
        d.ellipse([x - r, y - r, x + r, y + r], fill=(255, 255, 255, alpha))
    img_rgba.alpha_composite(overlay)


# ═══════════════════════════════════════════════════════════════════════════
# iOS  1024 × 1024
# ═══════════════════════════════════════════════════════════════════════════

def make_ios_icon(path, size=1024):
    img = Image.new("RGBA", (size, size))
    flat = Image.new("RGB", (size, size))
    d_flat = ImageDraw.Draw(flat)
    draw_gradient_bg(d_flat, size, size)
    img.paste(flat.convert("RGBA"))

    draw_stars_bg(img, size, size)
    draw_glow(img, size // 2, int(size * 0.60), int(size * 0.45), GLOW_COL, 90)

    d = ImageDraw.Draw(img, "RGBA")

    # Shadow layer (offset castle)
    castle_silhouette(d, size // 2 + 6, int(size * 0.93) + 6,
                      size / 1024 * 2.85,
                      colour=(60, 20, 100))
    # Main castle
    castle_silhouette(d, size // 2, int(size * 0.93),
                      size / 1024 * 2.85)

    # Sparkle on top of main spire
    spire_tip_x = size // 2
    spire_tip_y = int(size * 0.93) - int(310 + 130) * int(size / 1024 * 2.85)
    spire_tip_y = int(size * 0.93 - 440 * size / 1024 * 2.85)
    draw_star(d, spire_tip_x, spire_tip_y + 12, int(size * 0.045), STAR_COL)
    draw_star(d, spire_tip_x - int(size * 0.12), int(size * 0.22),
              int(size * 0.022), STAR_COL, 160)
    draw_star(d, spire_tip_x + int(size * 0.18), int(size * 0.15),
              int(size * 0.016), STAR_COL, 140)

    os.makedirs(os.path.dirname(path), exist_ok=True)
    img.convert("RGB").save(path, "PNG")
    print(f"  iOS icon → {path}")


# ═══════════════════════════════════════════════════════════════════════════
# tvOS layers  (Back, Middle, Front)  at two sizes
# ═══════════════════════════════════════════════════════════════════════════

def make_tvos_layer_back(path, w, h):
    img = Image.new("RGBA", (w, h))
    flat = Image.new("RGB", (w, h))
    d = ImageDraw.Draw(flat)
    draw_gradient_bg(d, w, h)
    img.paste(flat.convert("RGBA"))
    draw_stars_bg(img, w, h)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    img.convert("RGB").save(path, "PNG")
    print(f"  tvOS Back  → {path}")


def make_tvos_layer_middle(path, w, h):
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    draw_glow(img, w // 2, int(h * 0.65), int(min(w, h) * 0.55), GLOW_COL, 80)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    img.save(path, "PNG")
    print(f"  tvOS Middle → {path}")


def make_tvos_layer_front(path, w, h):
    img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(img, "RGBA")
    scale = min(w, h) / 1024 * 2.85
    cx, base_y = w // 2, int(h * 0.96)
    castle_silhouette(d, cx + 4, base_y + 4, scale, colour=(60, 20, 100))
    castle_silhouette(d, cx, base_y, scale)
    # sparkle
    tip_y = int(base_y - 440 * scale)
    draw_star(d, cx, tip_y + int(scale * 12), int(min(w, h) * 0.045), STAR_COL)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    img.save(path, "PNG")
    print(f"  tvOS Front → {path}")


def make_tvos_top_shelf(path, w=1920, h=720):
    """Wide banner for top shelf."""
    img = Image.new("RGBA", (w, h))
    flat = Image.new("RGB", (w, h))
    d_f = ImageDraw.Draw(flat)
    draw_gradient_bg(d_f, w, h)
    img.paste(flat.convert("RGBA"))
    draw_stars_bg(img, w, h)
    draw_glow(img, w // 2, h // 2, int(h * 0.8), GLOW_COL, 80)

    d = ImageDraw.Draw(img, "RGBA")
    scale = h / 1024 * 2.85
    castle_silhouette(d, w // 2 + 5, int(h * 0.97) + 5, scale, colour=(60, 20, 100))
    castle_silhouette(d, w // 2, int(h * 0.97), scale)
    tip_y = int(h * 0.97 - 440 * scale)
    draw_star(d, w // 2, tip_y + int(scale * 12), int(h * 0.06), STAR_COL)

    os.makedirs(os.path.dirname(path), exist_ok=True)
    img.convert("RGB").save(path, "PNG")
    print(f"  tvOS Top Shelf → {path}")


# ── run ─────────────────────────────────────────────────────────────────────

BASE = "/home/user/TestClaude"

print("Generating iOS icon…")
make_ios_icon(
    f"{BASE}/DisneyWaitTimes/DisneyWaitTimes/Assets.xcassets/AppIcon.appiconset/AppIcon.png"
)

TV_BASE = f"{BASE}/DisneyWaitTimesTV/DisneyWaitTimesTV/Assets.xcassets/AppIcon.brandassets"

print("Generating tvOS App Icon (400×240)…")
for layer, fn in [("Back", make_tvos_layer_back),
                  ("Middle", make_tvos_layer_middle),
                  ("Front", make_tvos_layer_front)]:
    fn(f"{TV_BASE}/App Icon.imagestack/{layer}.imagestacklayer/Content.imageset/layer.png", 400, 240)

print("Generating tvOS App Icon App Store (1280×768)…")
for layer, fn in [("Back", make_tvos_layer_back),
                  ("Middle", make_tvos_layer_middle),
                  ("Front", make_tvos_layer_front)]:
    fn(f"{TV_BASE}/App Icon - App Store.imagestack/{layer}.imagestacklayer/Content.imageset/layer.png", 1280, 768)

print("Generating tvOS Top Shelf Image (1920×720)…")
make_tvos_top_shelf(
    f"{TV_BASE}/Top Shelf Image.imageset/top_shelf.png", 1920, 720
)

print("Done.")
