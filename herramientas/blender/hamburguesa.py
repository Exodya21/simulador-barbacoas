"""Genera la carne de hamburguesa low-poly y la exporta a arte/modelos/hamburguesa.obj.

Uso: blender --background --python herramientas/blender/hamburguesa.py
  o: python herramientas/blender/hamburguesa.py   (con el módulo bpy de PyPI)

Se exporta como .obj (Godot lo importa como una malla suelta) porque el color
lo pone el shader de cocción (shaders/coccion.gdshader) a partir de la
posición y la normal de cada punto: no hace falta material ni UV.
Filete de 12 cm de diámetro y 2,2 cm de alto, centrado en el origen:
borde irregular, cantos biselados y la cara de arriba un poco abombada.
"""
import math
import random
from pathlib import Path

import bpy
import bmesh  # noqa: E402  (con el bpy de PyPI hay que importarlo después de bpy)

RAIZ = Path(__file__).resolve().parents[2]
SALIDA_OBJ = RAIZ / "arte" / "modelos" / "hamburguesa.obj"
RADIO = 0.06
ALTO = 0.022
LADOS = 16
SEMILLA = 3


def main():
    rnd = random.Random(SEMILLA)
    bpy.ops.wm.read_factory_settings(use_empty=True)
    bpy.ops.mesh.primitive_cylinder_add(vertices=LADOS, radius=RADIO, depth=ALTO, end_fill_type="TRIFAN")
    obj = bpy.context.active_object
    obj.name = "Hamburguesa"
    malla = bmesh.new()
    malla.from_mesh(obj.data)
    # Borde irregular: cada columna de vértices se mete o se saca un poco.
    radios = [RADIO * rnd.uniform(0.93, 1.03) for _ in range(LADOS)]
    for v in malla.verts:
        r = math.hypot(v.co.x, v.co.y)
        if r > RADIO * 0.5:
            angulo = math.atan2(v.co.y, v.co.x)
            i = round(angulo / (2 * math.pi / LADOS)) % LADOS
            k = radios[i] / r
            v.co.x *= k
            v.co.y *= k
        elif v.co.z > 0:
            v.co.z += 0.003  # centro de arriba abombado
    malla.to_mesh(obj.data)
    malla.free()
    # Cantos biselados (dos segmentos) para que no parezca un disco.
    bisel = obj.modifiers.new("Bisel", "BEVEL")
    bisel.width = 0.005
    bisel.segments = 2
    bisel.limit_method = "ANGLE"
    bpy.ops.object.modifier_apply(modifier=bisel.name)
    for poly in obj.data.polygons:
        poly.use_smooth = False
    SALIDA_OBJ.parent.mkdir(parents=True, exist_ok=True)
    bpy.ops.wm.obj_export(filepath=str(SALIDA_OBJ), export_selected_objects=True, export_materials=False,
                          export_uv=False, forward_axis="NEGATIVE_Z", up_axis="Y")
    print(f"Hamburguesa exportada: {SALIDA_OBJ} ({len(obj.data.polygons)} caras)")


if __name__ == "__main__":
    main()
