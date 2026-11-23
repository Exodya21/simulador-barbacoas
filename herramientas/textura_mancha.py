"""Genera arte/texturas/mancha_grasa.png: mancha de grasa y aceite con bordes
irregulares, semitransparente. Uso: python herramientas/textura_mancha.py (necesita Pillow)."""
import math
import random
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

TAM = 256
SALIDA = Path(__file__).resolve().parents[1] / "arte" / "texturas" / "mancha_grasa.png"


def main(semilla=7):
    rnd = random.Random(semilla)
    alfa = Image.new("L", (TAM, TAM), 0)
    d = ImageDraw.Draw(alfa)
    c = TAM / 2
    # Mancha principal: polígono de borde irregular.
    puntos = []
    for i in range(28):
        a = 2 * math.pi * i / 28
        r = TAM * 0.30 * (0.75 + 0.35 * rnd.random())
        puntos.append((c + r * math.cos(a), c + r * math.sin(a)))
    d.polygon(puntos, fill=210)
    # Salpicaduras alrededor.
    for _ in range(14):
        a = rnd.uniform(0, 2 * math.pi)
        r = rnd.uniform(TAM * 0.30, TAM * 0.45)
        t = rnd.uniform(4, 14)
        x, y = c + r * math.cos(a), c + r * math.sin(a)
        d.ellipse([x - t, y - t, x + t, y + t], fill=rnd.randint(140, 200))
    alfa = alfa.filter(ImageFilter.GaussianBlur(3))
    # Color: aceite marrón amarillento, más oscuro en el centro.
    color = Image.new("RGB", (TAM, TAM))
    px = color.load()
    for y in range(TAM):
        for x in range(TAM):
            k = min(1.0, math.hypot(x - c, y - c) / (TAM * 0.45))
            px[x, y] = (int(95 + 60 * k), int(70 + 45 * k), int(25 + 15 * k))
    imagen = color.convert("RGBA")
    imagen.putalpha(alfa)
    SALIDA.parent.mkdir(parents=True, exist_ok=True)
    imagen.save(SALIDA, optimize=True)
    print(f"Mancha generada: {SALIDA}")


if __name__ == "__main__":
    main()
