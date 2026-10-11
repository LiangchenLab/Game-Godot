"""生成岭行用的像素图。改完画面后在仓库根目录运行：python3 tools/make_art.py"""
from pathlib import Path
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "assets"
STORE = ROOT / "store"
OUT.mkdir(exist_ok=True)
STORE.mkdir(exist_ok=True)

SKY = (126, 196, 232, 255)
HILL = (90, 158, 96, 255)
DIRT = (110, 74, 48, 255)
GRASS = (61, 140, 74, 255)
GRASS_DK = (42, 110, 56, 255)
SKIN = (240, 201, 160, 255)
HAIR = (90, 56, 38, 255)
SHIRT = (224, 122, 61, 255)
PANTS = (58, 74, 120, 255)
SHOE = (62, 42, 32, 255)
GOLD = (242, 193, 78, 255)
GOLD_DK = (196, 132, 42, 255)
SPIKE = (196, 69, 54, 255)
WHITE = (244, 241, 234, 255)
RED = (196, 58, 58, 255)
CLEAR = (0, 0, 0, 0)


def new(w, h):
    return Image.new("RGBA", (w, h), CLEAR)


def px(img, x, y, c):
    if 0 <= x < img.width and 0 <= y < img.height:
        img.putpixel((x, y), c)


def rect(img, x, y, w, h, c):
    for yy in range(y, y + h):
        for xx in range(x, x + w):
            px(img, xx, yy, c)


def draw_player(frame):
    img = new(32, 32)
    # 脚底靠近 y=30，方便和碰撞对齐
    bob = 0 if frame != 2 else 1
    y = 6 + bob
    rect(img, 12, y, 8, 6, HAIR)
    rect(img, 12, y + 5, 8, 5, SKIN)
    px(img, 14, y + 7, (40, 40, 50, 255))
    px(img, 17, y + 7, (40, 40, 50, 255))
    rect(img, 11, y + 10, 10, 8, SHIRT)
    rect(img, 12, y + 18, 8, 6, PANTS)
    if frame in (0, 5):
        rect(img, 12, y + 24, 3, 3, SHOE)
        rect(img, 17, y + 24, 3, 3, SHOE)
    elif frame == 1:
        rect(img, 10, y + 24, 4, 3, SHOE)
        rect(img, 18, y + 23, 4, 3, SHOE)
    elif frame == 2:
        rect(img, 11, y + 23, 4, 3, SHOE)
        rect(img, 17, y + 24, 4, 3, SHOE)
    elif frame == 3:
        rect(img, 9, y + 24, 4, 3, SHOE)
        rect(img, 18, y + 24, 4, 3, SHOE)
    else:
        rect(img, 11, y + 22, 4, 3, SHOE)
        rect(img, 17, y + 22, 4, 3, SHOE)
    if frame == 5:
        rect(img, 8, y + 12, 3, 5, SHIRT)
        rect(img, 21, y + 12, 3, 5, SHIRT)
    return img


def tile_grass():
    img = new(32, 32)
    rect(img, 0, 0, 32, 8, GRASS)
    rect(img, 0, 8, 32, 24, DIRT)
    for x in range(0, 32, 4):
        px(img, x, 6, GRASS_DK)
        px(img, x + 1, 7, GRASS_DK)
    return img


def tile_dirt():
    img = new(32, 32)
    rect(img, 0, 0, 32, 32, DIRT)
    px(img, 6, 10, (90, 60, 38, 255))
    px(img, 20, 18, (90, 60, 38, 255))
    return img


def coin(frame):
    img = new(16, 16)
    inset = frame % 2
    rect(img, 4 + inset, 2, 8 - inset * 2, 12, GOLD)
    rect(img, 6, 4, 4, 8, GOLD_DK)
    return img


def spike():
    img = new(32, 32)
    for i, x in enumerate((2, 12, 22)):
        for dy in range(14):
            w = dy // 2
            rect(img, x + 6 - w, 30 - dy, w * 2 + 2, 1, SPIKE)
    return img


def flag():
    img = new(32, 48)
    rect(img, 6, 4, 3, 42, WHITE)
    rect(img, 9, 6, 16, 10, RED)
    return img


def checkpoint():
    img = new(32, 48)
    rect(img, 6, 4, 3, 42, WHITE)
    rect(img, 9, 6, 16, 10, (70, 140, 210, 255))
    return img


def slime(frame):
    img = new(32, 24)
    squish = 2 if frame else 0
    rect(img, 4, 8 + squish, 24, 14 - squish, (70, 170, 90, 255))
    rect(img, 8, 12 + squish, 4, 4, WHITE)
    rect(img, 18, 12 + squish, 4, 4, WHITE)
    return img


def cloud():
    img = new(64, 32)
    d = ImageDraw.Draw(img)
    d.ellipse((4, 12, 36, 30), fill=(255, 255, 255, 230))
    d.ellipse((20, 6, 58, 28), fill=(255, 255, 255, 230))
    return img


def button(label):
    img = new(96, 96)
    d = ImageDraw.Draw(img)
    d.ellipse((4, 4, 92, 92), fill=(20, 28, 36, 170))
    d.ellipse((10, 10, 86, 86), outline=(244, 241, 234, 220), width=3)
    return img


def sheet(frames, fw, fh):
    img = new(fw * len(frames), fh)
    for i, frame in enumerate(frames):
        img.paste(frame, (i * fw, 0), frame)
    return img


def save(img, name):
    img.save(OUT / name)


def app_icon():
    icon = new(1024, 1024)
    d = ImageDraw.Draw(icon)
    d.rounded_rectangle((0, 0, 1024, 1024), 180, fill=SKY)
    d.rectangle((0, 620, 1024, 1024), fill=HILL)
    d.rounded_rectangle((80, 700, 944, 820), 20, fill=GRASS)
    hero = draw_player(1).resize((360, 360), Image.Resampling.NEAREST)
    icon.paste(hero, (332, 300), hero)
    icon.save(STORE / "icon-1024.png")
    icon.resize((128, 128), Image.Resampling.NEAREST).save(OUT / "icon.png")


def main():
    save(sheet([draw_player(i) for i in range(6)], 32, 32), "player_sheet.png")
    save(tile_grass(), "tile_grass.png")
    save(tile_dirt(), "tile_dirt.png")
    save(sheet([coin(0), coin(1)], 16, 16), "coin_sheet.png")
    save(spike(), "spike.png")
    save(flag(), "flag.png")
    save(checkpoint(), "checkpoint.png")
    save(sheet([slime(0), slime(1)], 32, 24), "slime_sheet.png")
    save(cloud(), "cloud.png")
    save(button(""), "touch_button.png")
    app_icon()


if __name__ == "__main__":
    main()
