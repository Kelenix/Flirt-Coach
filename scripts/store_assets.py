"""Génère les visuels de la fiche Google Play à partir des écrans de l'app.

Entrées : docs/store/visuels/ecrans/*.png (captures 1080 × 2400 de l'émulateur, conversations
fictives), assets/icon/app_icon.png, logo et polices du kit de marque (le logo n'est pas
modifié). Sorties dans docs/store/visuels/ : icône 512 × 512, bannière 1024 × 500 et
captures 1080 × 1920 avec leur accroche (textes : docs/store/fiche-store.md, section 5).

Usage : python scripts/store_assets.py
"""
import pathlib

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = pathlib.Path(__file__).resolve().parent.parent
OUT = ROOT / "docs" / "store" / "visuels"
SCREENS = OUT / "ecrans"
FONTS = ROOT / "assets" / "fonts"
IMAGES = ROOT / "assets" / "images"

NIGHT, DUSK, PINK, VIOLET = (26, 16, 51), (58, 28, 92), (255, 77, 121), (155, 92, 255)
CAPTIONS = [
    ("1-accueil", "Gagne en confiance"),
    ("2-resultats", "Trouve les bons mots"),
    ("3-generer", "7 situations, 7 styles"),
    ("4-capture", "Réponds à partir d'une capture"),
    ("5-respect", "Flirte avec respect"),
    ("6-analyse", "Sache où vous en êtes"),
    ("7-banque", "Des idées, même hors connexion"),
]
# Zone utile des captures : sans barre d'état, barre de navigation ni liseré de l'émulateur.
CROP = (6, 130, 1074, 2262)


def font(name: str, size: int) -> ImageFont.FreeTypeFont:
    return ImageFont.truetype(str(FONTS / name), size)


def background(size: tuple[int, int]) -> Image.Image:
    """Dégradé nuit → violet du kit, avec deux halos doux (rose et violet)."""
    w, h = size
    img = Image.new("RGB", size, NIGHT)
    draw = ImageDraw.Draw(img)
    for y in range(h):
        t = y / max(h - 1, 1)
        draw.line([(0, y), (w, y)], fill=tuple(round(a + (b - a) * t) for a, b in zip(NIGHT, DUSK)))
    glow = Image.new("RGB", size, (0, 0, 0))
    g = ImageDraw.Draw(glow)
    g.ellipse([-w * 0.3, h * 0.55, w * 0.7, h * 1.15], fill=PINK)
    g.ellipse([w * 0.45, -h * 0.25, w * 1.3, h * 0.35], fill=VIOLET)
    glow = glow.filter(ImageFilter.GaussianBlur(min(w, h) * 0.18))
    return Image.blend(img, Image.composite(glow, img, glow.convert("L")), 0.28)


def rounded(img: Image.Image, radius: int) -> Image.Image:
    mask = Image.new("L", img.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, img.width - 1, img.height - 1], radius, fill=255)
    out = img.convert("RGBA")
    out.putalpha(mask)
    return out


def wrap(draw: ImageDraw.ImageDraw, text: str, fnt: ImageFont.FreeTypeFont, width: int) -> list:
    """Coupe le texte en lignes d'au plus `width` pixels."""
    lines, line = [], ""
    for word in text.split():
        trial = f"{line} {word}".strip()
        if draw.textlength(trial, font=fnt) <= width or not line:
            line = trial
        else:
            lines.append(line)
            line = word
    return lines + [line]


def screenshot(name: str, caption: str) -> None:
    canvas = background((1080, 1920)).convert("RGBA")
    draw = ImageDraw.Draw(canvas)
    brand = font("Poppins-SemiBold.ttf", 36)
    draw.text((540, 118), "Flirt Coach Pro", font=brand, fill=PINK, anchor="mm")
    title = font("Poppins-Bold.ttf", 76)
    lines = wrap(draw, caption, title, 940)
    for i, line in enumerate(lines):
        draw.text((540, 215 + i * 92), line, font=title, fill="white", anchor="mm")

    # Écran réduit pour tenir sous l'accroche, dans un cadre de téléphone ombré.
    screen = Image.open(SCREENS / f"{name}.png").convert("RGB").crop(CROP)
    top = 215 + len(lines) * 92 + 10
    scale = (1920 - top - 40 - 32) / screen.height
    size = (round(screen.width * scale), round(screen.height * scale))
    screen = screen.resize(size, Image.LANCZOS)
    bw, bh = screen.width + 32, screen.height + 32
    x = (1080 - bw) // 2

    shadow = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle(
        [x + 10, top + 24, x + bw + 10, top + bh + 24], 64, fill=(0, 0, 0, 150)
    )
    canvas.alpha_composite(shadow.filter(ImageFilter.GaussianBlur(26)))
    frame = Image.new("RGBA", (bw, bh), (0, 0, 0, 0))
    ImageDraw.Draw(frame).rounded_rectangle(
        [0, 0, bw - 1, bh - 1], 64, fill=(13, 8, 30), outline=(*PINK, 140), width=3
    )
    canvas.alpha_composite(frame, (x, top))
    canvas.alpha_composite(rounded(screen, 48), (x + 16, top + 16))
    canvas.convert("RGB").save(OUT / f"capture-{name}.png", optimize=True)


def feature_graphic() -> None:
    """Bannière : symbole et logotype du kit (non modifiés), puis la promesse de l'app."""
    canvas = background((1024, 500)).convert("RGBA")
    symbol = Image.open(IMAGES / "logo_symbol.png").convert("RGBA")
    canvas.alpha_composite(symbol.resize((300, 300), Image.LANCZOS), (70, 100))
    wordmark = Image.open(IMAGES / "logo_wordmark_dark.png").convert("RGBA")
    size = (540, round(wordmark.height * 540 / wordmark.width))
    canvas.alpha_composite(wordmark.resize(size, Image.LANCZOS), (410, 105))
    draw = ImageDraw.Draw(canvas)
    tagline, promise = font("Poppins-SemiBold.ttf", 38), font("Inter-Variable.ttf", 30)
    draw.text((414, 300), "Coach de drague et messages", font=tagline, fill="white")
    draw.text((414, 356), "Les bons mots, avec respect.", font=promise, fill=(255, 214, 230))
    canvas.convert("RGB").save(OUT / "banniere-1024x500.png", optimize=True)


def icon() -> None:
    img = Image.open(ROOT / "assets" / "icon" / "app_icon.png").convert("RGBA")
    img.resize((512, 512), Image.LANCZOS).save(OUT / "icone-512.png", optimize=True)


def main() -> None:
    icon()
    feature_graphic()
    for name, caption in CAPTIONS:
        screenshot(name, caption)
    print(f"{len(CAPTIONS) + 2} visuels écrits dans {OUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
