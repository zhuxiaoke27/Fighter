#!/usr/bin/env python3
"""
Generate pixel art sprites for Fighter game characters and enemies.
Outputs PNG sprites + Xcode asset catalog structure.
"""

import os
import json
from PIL import Image, ImageDraw

ASSETS_DIR = os.path.join(os.path.dirname(__file__), '..', 'Fighter', 'Assets.xcassets')
OUTLINE = (0, 0, 0, 255)

# ──────────────────────────── helpers ────────────────────────────

def new_canvas(w, h):
    img = Image.new('RGBA', (w, h), (0, 0, 0, 0))
    return img, ImageDraw.Draw(img)

def px(draw, x, y, color):
    draw.point((x, y), fill=color)

def rect(draw, x, y, w, h, color):
    for dy in range(h):
        for dx in range(w):
            px(draw, x+dx, y+dy, color)

def outline_rect(draw, x, y, w, h, color=OUTLINE):
    rect(draw, x, y, w, 1, color)
    rect(draw, x, y+h-1, w, 1, color)
    rect(draw, x, y, 1, h, color)
    rect(draw, x+w-1, y, 1, h, color)

def circle(draw, cx, cy, r, color):
    for y in range(-r, r+1):
        for x in range(-r, r+1):
            if x*x + y*y <= r*r:
                px(draw, cx+x, cy+y, color)

def circle_outline(draw, cx, cy, r, color=OUTLINE):
    for y in range(-r-1, r+2):
        for x in range(-r-1, r+2):
            d = x*x + y*y
            if d > r*r and d <= (r+1)*(r+1):
                px(draw, cx+x, cy+y, color)

def write_xcassets(folder_name, filenames):
    folder = os.path.join(ASSETS_DIR, folder_name)
    os.makedirs(folder, exist_ok=True)
    images = []
    for fn in filenames:
        images.append({"idiom": "universal", "filename": fn, "scale": "1x"})
    images.append({"idiom": "universal", "scale": "2x"})
    images.append({"idiom": "universal", "scale": "3x"})
    contents = {"images": images, "info": {"version": 1, "author": "xcode"}}
    with open(os.path.join(folder, 'Contents.json'), 'w') as f:
        json.dump(contents, f, indent=2)

def save(img, folder, filename):
    dir_path = os.path.join(ASSETS_DIR, folder)
    os.makedirs(dir_path, exist_ok=True)
    path = os.path.join(dir_path, filename)
    img.save(path, 'PNG')

# ──────────────────────────── WARRIOR ────────────────────────────

def draw_warrior(draw, frame=0):
    armor = (180, 60, 40)
    armor_hi = (220, 90, 60)
    armor_lo = (130, 40, 25)
    helm = (160, 160, 170)
    sword_blade = (200, 210, 220)
    shield_col = (140, 45, 35)
    shield_rim = (190, 70, 50)
    cape = (120, 30, 20)
    yoff = 0 if frame == 0 else 2

    rect(draw, 20, 16+yoff, 10, 24, cape)
    rect(draw, 16, 16+yoff, 18, 22, armor)
    rect(draw, 18, 16+yoff, 14, 2, armor_hi)
    rect(draw, 16, 16+yoff, 18, 1, OUTLINE)
    rect(draw, 16, 37+yoff, 18, 1, OUTLINE)
    rect(draw, 16, 16+yoff, 1, 22, OUTLINE)
    rect(draw, 33, 16+yoff, 1, 22, OUTLINE)
    rect(draw, 22, 20+yoff, 6, 1, armor_hi)
    rect(draw, 20, 26+yoff, 10, 1, armor_lo)
    rect(draw, 20, 30+yoff, 10, 1, armor_lo)

    circle(draw, 24, 12+yoff, 5, helm)
    circle_outline(draw, 24, 12+yoff, 5)
    rect(draw, 20, 12+yoff, 8, 2, (30, 30, 40))
    rect(draw, 23, 5+yoff, 3, 4, armor_hi)
    rect(draw, 24, 4+yoff, 1, 2, OUTLINE)

    rect(draw, 6, 20+yoff, 10, 14, shield_col)
    outline_rect(draw, 6, 20+yoff, 10, 14)
    rect(draw, 8, 22+yoff, 6, 2, shield_rim)
    rect(draw, 9, 27+yoff, 4, 2, shield_rim)
    circle(draw, 11, 27+yoff, 2, shield_rim)

    rect(draw, 35, 8+yoff, 2, 14, sword_blade)
    rect(draw, 34, 22+yoff, 4, 2, (160, 130, 60))
    rect(draw, 35, 24+yoff, 2, 5, (130, 100, 50))
    rect(draw, 35, 7+yoff, 2, 1, OUTLINE)
    rect(draw, 34, 8+yoff, 1, 1, OUTLINE)
    rect(draw, 37, 8+yoff, 1, 1, OUTLINE)

    rect(draw, 18, 38+yoff, 5, 7, armor_lo)
    rect(draw, 27, 38+yoff, 5, 7, armor_lo)
    rect(draw, 17, 43+yoff, 6, 3, (90, 35, 25))
    rect(draw, 26, 43+yoff, 6, 3, (90, 35, 25))
    outline_rect(draw, 17, 43+yoff, 6, 3)
    outline_rect(draw, 26, 43+yoff, 6, 3)

# ──────────────────────────── ASSASSIN ────────────────────────────

def draw_assassin(draw, frame=0):
    cloak = (60, 120, 60)
    cloak_hi = (80, 150, 80)
    cloak_dk = (40, 80, 40)
    hood = (50, 45, 80)
    hood_dk = (35, 30, 60)
    blade = (200, 210, 220)
    eye = (180, 50, 50)
    yoff = 0 if frame == 0 else 1
    xshift = 0 if frame == 0 else 1

    for y in range(18, 40):
        w = min(4 + (y - 18) // 3, 8)
        rect(draw, 20+xshift-w//2, y+yoff, w, 1, cloak)

    rect(draw, 15+xshift, 18+yoff, 14, 4, cloak)
    rect(draw, 16+xshift, 18+yoff, 5, 2, cloak_hi)

    circle(draw, 22+xshift, 14+yoff, 5, hood)
    circle_outline(draw, 22+xshift, 14+yoff, 5)
    px(draw, 22+xshift, 6+yoff, hood_dk)
    px(draw, 21+xshift, 7+yoff, hood_dk)
    px(draw, 23+xshift, 7+yoff, hood_dk)
    px(draw, 20+xshift, 14+yoff, eye)
    px(draw, 24+xshift, 14+yoff, eye)

    rect(draw, 7+xshift, 16+yoff, 1, 10, blade)
    rect(draw, 6+xshift, 16+yoff, 1, 1, OUTLINE)
    px(draw, 7+xshift, 15+yoff, OUTLINE)
    rect(draw, 6+xshift, 26+yoff, 3, 2, (100, 80, 50))

    rect(draw, 37+xshift, 18+yoff, 1, 10, blade)
    px(draw, 37+xshift, 17+yoff, OUTLINE)
    rect(draw, 36+xshift, 28+yoff, 3, 2, (100, 80, 50))

    rect(draw, 19+xshift, 38+yoff, 3, 6, cloak_dk)
    rect(draw, 24+xshift, 38+yoff, 3, 6, cloak_dk)
    rect(draw, 18+xshift, 43+yoff, 4, 3, (30, 60, 30))
    rect(draw, 23+xshift, 43+yoff, 4, 3, (30, 60, 30))

# ──────────────────────────── MAGE ────────────────────────────

def draw_mage(draw, frame=0):
    robe = (50, 70, 160)
    robe_hi = (70, 100, 200)
    robe_dk = (35, 50, 120)
    skin = (220, 190, 155)
    staff = (140, 110, 70)
    orb = (140, 180, 255) if frame == 0 else (200, 220, 255)
    orb_glow = (100, 150, 255) if frame == 0 else (180, 210, 255)
    hat = (40, 55, 130)
    hat_dk = (25, 35, 80)
    yoff = 0 if frame == 0 else 1

    for y in range(22, 42):
        w = min(6 + (y - 22) // 2, 14)
        start_x = 24 - w // 2
        rect(draw, start_x, y+yoff, w, 1, robe if y < 36 else robe_dk)

    rect(draw, 18, 22+yoff, 12, 2, robe_hi)

    circle(draw, 24, 18+yoff, 4, skin)
    circle_outline(draw, 24, 18+yoff, 4)
    px(draw, 22, 18+yoff, (40, 40, 60))
    px(draw, 26, 18+yoff, (40, 40, 60))
    rect(draw, 22, 22+yoff, 4, 3, (180, 180, 190))
    px(draw, 23, 25+yoff, (170, 170, 180))

    for dy in range(10):
        w = max(1, int(14 * dy / 10))
        rect(draw, 24 - w//2, 4+dy+yoff, w, 1, hat)
    rect(draw, 17, 14+yoff, 14, 2, hat_dk)
    rect(draw, 24, 4+yoff, 1, 1, OUTLINE)

    rect(draw, 36, 6+yoff, 2, 36, staff)
    rect(draw, 35, 6+yoff, 1, 1, OUTLINE)
    rect(draw, 38, 6+yoff, 1, 1, OUTLINE)

    circle(draw, 37, 5+yoff, 3, orb)
    circle_outline(draw, 37, 5+yoff, 3)
    if frame == 1:
        circle(draw, 37, 5+yoff, 4, (*orb_glow[:3], 80))
    px(draw, 36, 4+yoff, orb_glow)

    rect(draw, 14, 24+yoff, 5, 3, robe)
    rect(draw, 32, 24+yoff, 5, 3, robe)

    rect(draw, 19, 43+yoff, 4, 3, (30, 40, 90))
    rect(draw, 26, 43+yoff, 4, 3, (30, 40, 90))

# ──────────────────────────── ENEMIES ────────────────────────────

def draw_cultist(draw):
    robe = (120, 40, 30); robe_dk = (80, 25, 18); hood = (90, 30, 25)
    blade = (190, 200, 210); eye = (220, 60, 40)

    for y in range(22, 44):
        w = min(6 + (y - 22) // 2, 14)
        rect(draw, 24 - w//2, y, w, 1, robe if y < 38 else robe_dk)
    outline_rect(draw, 17, 22, 14, 22)

    circle(draw, 24, 16, 6, hood)
    circle_outline(draw, 24, 16, 6)
    px(draw, 24, 8, (70, 20, 15))
    px(draw, 21, 16, eye); px(draw, 27, 16, eye)

    rect(draw, 35, 22, 1, 8, blade)
    px(draw, 35, 21, OUTLINE)
    rect(draw, 34, 30, 3, 2, (100, 70, 40))

def draw_jaw_worm(draw):
    body = (160, 110, 50); body_dk = (120, 80, 35); belly = (180, 140, 70)
    jaw = (200, 60, 30); tooth = (240, 240, 220)

    circle(draw, 24, 30, 8, body)
    circle(draw, 24, 38, 6, body_dk)
    circle(draw, 22, 44, 4, body_dk)
    circle(draw, 24, 22, 6, body)
    circle_outline(draw, 24, 22, 6)
    circle(draw, 24, 32, 4, belly)

    px(draw, 21, 20, (20, 20, 20)); px(draw, 27, 20, (20, 20, 20))

    rect(draw, 16, 18, 5, 4, jaw); rect(draw, 27, 18, 5, 4, jaw)
    for i in range(4):
        px(draw, 17+i, 22, tooth); px(draw, 28+i, 22, tooth)
    px(draw, 17, 17, tooth); px(draw, 30, 17, tooth)

def draw_slime_base(draw, color, highlight):
    dk = tuple(max(0, c - 40) for c in color)
    for y in range(-10, 11):
        w = int((100 - y*y) ** 0.5) if y*y < 100 else 0
        w = int(w * 0.9)
        rect(draw, 24 - w, 28 + y, w * 2, 1, color)
    circle_outline(draw, 24, 28, 10, OUTLINE)
    rect(draw, 14, 37, 20, 1, OUTLINE)
    circle(draw, 21, 25, 3, highlight)
    px(draw, 21, 28, (255, 255, 255)); px(draw, 27, 28, (255, 255, 255))
    px(draw, 22, 28, (20, 20, 20)); px(draw, 28, 28, (20, 20, 20))
    px(draw, 24, 31, dk)

def draw_slime(draw):
    draw_slime_base(draw, (80, 180, 80), (120, 220, 120))

def draw_blue_slime(draw):
    draw_slime_base(draw, (60, 120, 200), (100, 170, 240))

def draw_fungus_beast(draw):
    cap = (140, 80, 160); cap_hi = (180, 120, 200); stem = (200, 180, 140)
    spots = (220, 100, 80); body = (80, 140, 60)

    rect(draw, 19, 30, 10, 12, body)
    outline_rect(draw, 19, 30, 10, 12)
    rect(draw, 19, 40, 4, 5, (60, 110, 45)); rect(draw, 27, 40, 4, 5, (60, 110, 45))

    rect(draw, 21, 20, 6, 12, stem)
    outline_rect(draw, 21, 20, 6, 12)

    for y in range(-8, 2):
        w = int((64 - y*y) ** 0.5) if y*y < 64 else 0
        rect(draw, 24 - w, 18 + y, w * 2, 1, cap)
    circle_outline(draw, 24, 18, 8)
    rect(draw, 16, 18, 16, 1, OUTLINE)

    circle(draw, 20, 14, 2, spots); circle(draw, 28, 12, 1, spots)
    circle(draw, 24, 16, 1, spots)
    px(draw, 22, 25, (20, 20, 20)); px(draw, 26, 25, (20, 20, 20))

def draw_gremlin_nob(draw):
    skin = (180, 130, 60); skin_hi = (210, 160, 80); tooth = (240, 240, 220)

    rect(draw, 17, 18, 14, 16, skin)
    outline_rect(draw, 17, 18, 14, 16)
    rect(draw, 19, 20, 4, 2, skin_hi); rect(draw, 25, 20, 4, 2, skin_hi)

    rect(draw, 10, 14, 8, 4, skin); rect(draw, 30, 14, 8, 4, skin)
    outline_rect(draw, 10, 14, 8, 4); outline_rect(draw, 30, 14, 8, 4)
    circle(draw, 10, 16, 2, skin); circle(draw, 38, 16, 2, skin)

    circle(draw, 24, 12, 5, skin); circle_outline(draw, 24, 12, 5)
    px(draw, 18, 10, skin); px(draw, 17, 9, skin)
    px(draw, 30, 10, skin); px(draw, 31, 9, skin)
    rect(draw, 21, 11, 3, 1, (200, 50, 30)); rect(draw, 25, 11, 3, 1, (200, 50, 30))
    rect(draw, 21, 14, 6, 1, (100, 40, 25)); px(draw, 23, 15, tooth)

    rect(draw, 19, 34, 4, 8, skin); rect(draw, 25, 34, 4, 8, skin)
    rect(draw, 19, 40, 4, 2, (80, 55, 25)); rect(draw, 25, 40, 4, 2, (80, 55, 25))

def draw_gremlin_leader(draw):
    skin = (170, 115, 45); skin_hi = (200, 145, 70)
    banner = (180, 50, 30); banner_hi = (220, 80, 50)

    rect(draw, 18, 20, 12, 14, skin)
    outline_rect(draw, 18, 20, 12, 14)
    rect(draw, 20, 22, 4, 2, skin_hi)

    circle(draw, 24, 15, 5, skin); circle_outline(draw, 24, 15, 5)
    px(draw, 18, 13, skin); px(draw, 30, 13, skin)
    rect(draw, 20, 9, 8, 2, (180, 160, 50))
    px(draw, 20, 8, (180, 160, 50)); px(draw, 24, 8, (180, 160, 50)); px(draw, 27, 8, (180, 160, 50))
    rect(draw, 22, 14, 2, 1, (180, 40, 30)); rect(draw, 26, 14, 2, 1, (180, 40, 30))

    rect(draw, 36, 6, 2, 32, (120, 90, 50))
    rect(draw, 33, 6, 8, 10, banner)
    outline_rect(draw, 33, 6, 8, 10)
    rect(draw, 35, 8, 4, 2, banner_hi)

    rect(draw, 20, 34, 4, 6, skin); rect(draw, 26, 34, 4, 6, skin)

def draw_slime_boss(draw, size=64):
    body = (50, 140, 60); hi = (80, 190, 90); dk = (30, 100, 40)
    cx, cy = 32, 36

    for y in range(-16, 17):
        w = int((256 - y*y) ** 0.5) if y*y < 256 else 0
        w = int(w * 0.85)
        rect(draw, cx - w, cy + y, w * 2, 1, body)
    circle_outline(draw, cx, cy, 16)
    rect(draw, cx - 14, cy + 15, 28, 1, OUTLINE)

    circle(draw, cx - 6, cy - 8, 4, hi)
    rect(draw, cx - 5, cy - 18, 10, 3, (220, 190, 50))
    px(draw, cx - 5, cy - 19, (220, 190, 50))
    px(draw, cx, cy - 19, (220, 190, 50))
    px(draw, cx + 4, cy - 19, (220, 190, 50))

    px(draw, cx - 6, cy - 2, (255, 255, 255)); px(draw, cx + 4, cy - 2, (255, 255, 255))
    px(draw, cx - 5, cy - 2, (20, 20, 20)); px(draw, cx + 5, cy - 2, (20, 20, 20))
    rect(draw, cx - 5, cy + 4, 10, 2, dk)
    rect(draw, cx - 8, cy + 14, 2, 4, body); rect(draw, cx + 6, cy + 13, 2, 5, body)

def draw_spheric_guardian(draw):
    core = (140, 160, 200); core_hi = (180, 200, 240)
    plate = (180, 190, 210); plate_hi = (210, 220, 240); glow = (100, 140, 220)

    circle(draw, 24, 24, 8, core)
    circle_outline(draw, 24, 24, 8)
    circle(draw, 22, 22, 3, core_hi)
    circle(draw, 24, 24, 2, glow); px(draw, 24, 24, (200, 230, 255))

    rect(draw, 16, 12, 16, 4, plate); outline_rect(draw, 16, 12, 16, 4)
    rect(draw, 18, 13, 12, 1, plate_hi)
    rect(draw, 16, 32, 16, 4, plate); outline_rect(draw, 16, 32, 16, 4)
    rect(draw, 8, 20, 4, 8, plate); outline_rect(draw, 8, 20, 4, 8)
    rect(draw, 36, 20, 4, 8, plate); outline_rect(draw, 36, 20, 4, 8)

def draw_chosen(draw):
    body = (220, 200, 140); glow_col = (255, 240, 180); aura = (200, 180, 100)
    halo = (255, 220, 100)

    circle(draw, 24, 24, 14, (*aura, 40))
    rect(draw, 20, 20, 8, 16, body); outline_rect(draw, 20, 20, 8, 16, glow_col)
    circle(draw, 24, 16, 4, body); circle_outline(draw, 24, 16, 4, glow_col)
    rect(draw, 19, 10, 10, 2, halo)
    px(draw, 19, 9, halo); px(draw, 28, 9, halo)
    px(draw, 22, 16, (255, 255, 220)); px(draw, 26, 16, (255, 255, 220))
    rect(draw, 12, 22, 8, 2, body); rect(draw, 28, 22, 8, 2, body)
    rect(draw, 21, 36, 3, 6, body); rect(draw, 26, 36, 3, 6, body)
    px(draw, 10, 18, glow_col); px(draw, 38, 18, glow_col)
    px(draw, 14, 30, glow_col); px(draw, 34, 30, glow_col)

def draw_book_of_stabbing(draw):
    cover = (140, 90, 50); pages = (220, 210, 180); blade = (190, 200, 210)

    rect(draw, 14, 18, 14, 20, cover); rect(draw, 28, 18, 8, 20, cover)
    outline_rect(draw, 14, 18, 14, 20); outline_rect(draw, 28, 18, 8, 20)
    rect(draw, 16, 20, 10, 16, pages); rect(draw, 29, 20, 6, 16, pages)
    rect(draw, 28, 18, 1, 20, (100, 60, 30))

    rect(draw, 12, 10, 2, 10, blade); px(draw, 12, 9, OUTLINE)
    rect(draw, 22, 8, 2, 12, blade); px(draw, 22, 7, OUTLINE)
    rect(draw, 32, 12, 2, 8, blade); px(draw, 32, 11, OUTLINE)

    circle(draw, 21, 28, 2, (180, 40, 30)); px(draw, 21, 28, (40, 20, 20))

def draw_giant_worm(draw):
    seg1 = (130, 80, 40); seg2 = (110, 65, 30); seg3 = (90, 50, 25)

    circle(draw, 14, 20, 6, seg1); circle(draw, 24, 26, 7, seg1)
    circle(draw, 34, 22, 6, seg2); circle(draw, 30, 34, 5, seg3)
    circle(draw, 24, 28, 3, (160, 120, 70))

    circle_outline(draw, 14, 20, 6)
    rect(draw, 8, 18, 3, 4, (170, 50, 30))
    px(draw, 8, 18, (240, 240, 220)); px(draw, 8, 21, (240, 240, 220))
    px(draw, 14, 18, (200, 200, 180)); px(draw, 14, 18, (30, 30, 30))
    circle_outline(draw, 24, 26, 7); circle_outline(draw, 34, 22, 6)

def draw_darkling(draw):
    body = (40, 30, 60); body_hi = (60, 45, 80); eyes = (180, 50, 180)
    shadow = (25, 18, 40)

    rect(draw, 12, 40, 24, 4, shadow)
    rect(draw, 20, 26, 8, 14, body); outline_rect(draw, 20, 26, 8, 14, body_hi)
    circle(draw, 24, 22, 4, body); circle_outline(draw, 24, 22, 4, body_hi)
    px(draw, 22, 22, eyes); px(draw, 26, 22, eyes)
    px(draw, 18, 38, shadow); px(draw, 30, 36, shadow)
    px(draw, 16, 42, shadow); px(draw, 32, 42, shadow)

def draw_spire_growth(draw):
    crystal1 = (60, 180, 170); crystal2 = (80, 200, 190); crystal3 = (40, 140, 130)
    base = (50, 60, 70)

    rect(draw, 14, 36, 20, 6, base); outline_rect(draw, 14, 36, 20, 6)

    for y in range(20):
        w = max(1, 6 - y // 4)
        rect(draw, 24 - w//2, 36 - y, w, 1, crystal1 if y % 3 != 0 else crystal2)
    for y in range(14):
        w = max(1, 4 - y // 4)
        rect(draw, 18 - w//2, 36 - y, w, 1, crystal3)
    for y in range(16):
        w = max(1, 5 - y // 4)
        rect(draw, 30 - w//2, 36 - y, w, 1, crystal2 if y % 2 == 0 else crystal1)

    px(draw, 24, 16, crystal2); px(draw, 18, 22, crystal2); px(draw, 30, 20, crystal2)
    px(draw, 22, 34, crystal1); px(draw, 27, 33, crystal1)

def draw_transmogrifier(draw):
    col1 = (140, 80, 180); col2 = (180, 120, 200); col3 = (100, 50, 150)
    swirl = (200, 160, 220)

    circle(draw, 24, 26, 10, col1)
    circle(draw, 16, 22, 5, col2); circle(draw, 32, 28, 6, col3)
    circle(draw, 22, 34, 4, col2); circle(draw, 30, 18, 3, col1)
    circle_outline(draw, 24, 26, 10); circle_outline(draw, 16, 22, 5)
    circle_outline(draw, 32, 28, 6)

    px(draw, 24, 24, swirl); px(draw, 22, 26, swirl); px(draw, 26, 22, swirl)
    px(draw, 20, 28, swirl); px(draw, 28, 30, swirl)
    px(draw, 20, 24, (240, 240, 220)); px(draw, 28, 26, (240, 240, 220))
    px(draw, 24, 30, (240, 240, 220))
    px(draw, 20, 24, (40, 20, 60)); px(draw, 28, 26, (40, 20, 60))
    px(draw, 24, 30, (40, 20, 60))

def draw_giant_head(draw):
    skin = (200, 175, 150); skin_hi = (220, 200, 175); hair = (80, 70, 65)
    eye = (180, 160, 60)

    circle(draw, 24, 24, 12, skin); circle_outline(draw, 24, 24, 12)

    for y in range(-12, -4):
        w = int((144 - y*y) ** 0.5) if y*y < 144 else 0
        w = min(w, 12)
        rect(draw, 24 - w, 24 + y, w * 2, 1, hair)

    rect(draw, 18, 14, 12, 3, skin_hi)
    rect(draw, 18, 22, 4, 3, (240, 240, 230)); rect(draw, 26, 22, 4, 3, (240, 240, 230))
    px(draw, 20, 23, eye); px(draw, 28, 23, eye)
    rect(draw, 23, 25, 2, 4, skin_hi)
    rect(draw, 19, 31, 10, 2, (140, 80, 70))
    rect(draw, 21, 31, 6, 1, (230, 230, 220))
    rect(draw, 12, 22, 2, 4, skin); rect(draw, 34, 22, 2, 4, skin)
    rect(draw, 18, 40, 12, 2, (100, 90, 80, 60))

# ──────────────────────────── MAIN ────────────────────────────

ENEMIES = {
    'cultist': draw_cultist,
    'jaw_worm': draw_jaw_worm,
    'slime': draw_slime,
    'blue_slime': draw_blue_slime,
    'fungus_beast': draw_fungus_beast,
    'gremlin_nob': draw_gremlin_nob,
    'gremlin_leader': draw_gremlin_leader,
    'spheric_guardian': draw_spheric_guardian,
    'chosen': draw_chosen,
    'book_of_stabbing': draw_book_of_stabbing,
    'giant_worm': draw_giant_worm,
    'darkling': draw_darkling,
    'spire_growth': draw_spire_growth,
    'transmogrifier': draw_transmogrifier,
    'giant_head': draw_giant_head,
}

CHARACTERS = {
    'warrior': draw_warrior,
    'assassin': draw_assassin,
    'mage': draw_mage,
}

def main():
    os.makedirs(ASSETS_DIR, exist_ok=True)

    for char_name, draw_fn in CHARACTERS.items():
        folder = f'Sprites_{char_name.capitalize()}'
        filenames = []

        for frame in range(2):
            img, d = new_canvas(48, 48)
            draw_fn(d, frame=frame)
            fn = f'{char_name}_idle_{frame+1}.png'
            save(img, folder, fn)
            filenames.append(fn)

        img, d = new_canvas(48, 48)
        draw_fn(d, frame=0)
        fn = f'{char_name}_attack.png'
        save(img, folder, fn)
        filenames.append(fn)

        write_xcassets(folder, filenames)
        print(f'  Generated {folder}: {filenames}')

    folder = 'Sprites_slime_boss'
    img, d = new_canvas(64, 64)
    draw_slime_boss(d, size=64)
    save(img, folder, 'slime_boss.png')
    write_xcassets(folder, ['slime_boss.png'])
    print(f'  Generated {folder}')

    for enemy_id, draw_fn in ENEMIES.items():
        if enemy_id == 'slime_boss':
            continue
        folder = f'Sprites_{enemy_id}'
        img, d = new_canvas(48, 48)
        draw_fn(d)
        fn = f'{enemy_id}.png'
        save(img, folder, fn)
        write_xcassets(folder, [fn])
        print(f'  Generated {folder}')

    print('\nAll sprites generated successfully!')

if __name__ == '__main__':
    main()
