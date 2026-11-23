"""Genera el cubo de basura low-poly y lo exporta a arte/modelos/basura.glb.

Uso: blender --background --python herramientas/blender/basura.py
  o: python herramientas/blender/basura.py   (con el módulo bpy de PyPI)

Cubo de pedal abierto (sin tapa, para poder tirar la comida desde arriba),
de 0,70 m de alto, un poco más ancho arriba que abajo. Colores de la paleta:
CARBON para el cubo, METAL para el aro y el pedal.
"""
import math
from pathlib import Path

import bpy

RAIZ = Path(__file__).resolve().parents[2]
SALIDA_GLB = RAIZ / "arte" / "modelos" / "basura.glb"
SALIDA_BLEND = RAIZ / "arte" / "modelos" / "basura.blend"

CARBON = (0x2B / 255, 0x2A / 255, 0x2E / 255, 1.0)
METAL = (0x5A / 255, 0x5F / 255, 0x66 / 255, 1.0)
ALTO = 0.70
RADIO_ABAJO = 0.20
RADIO_ARRIBA = 0.24
LADOS = 10


def lineal(c):
    """La paleta está en sRGB; Blender trabaja en espacio lineal."""
    return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4


def material(nombre, color, metalico, rugosidad):
    color = tuple(lineal(v) for v in color[:3]) + (color[3],)
    mat = bpy.data.materials.new(nombre)
    mat.use_nodes = True
    bsdf = mat.node_tree.nodes["Principled BSDF"]
    bsdf.inputs["Base Color"].default_value = color
    bsdf.inputs["Metallic"].default_value = metalico
    bsdf.inputs["Roughness"].default_value = rugosidad
    return mat


def main():
    bpy.ops.wm.read_factory_settings(use_empty=True)
    carbon = material("Carbon", CARBON, 0.1, 0.7)
    metal = material("Metal", METAL, 0.7, 0.45)

    # Cuerpo: cono truncado sin tapa arriba, con grosor.
    bpy.ops.mesh.primitive_cone_add(vertices=LADOS, radius1=RADIO_ABAJO, radius2=RADIO_ARRIBA,
                                    depth=ALTO, location=(0, 0, ALTO / 2), end_fill_type="NGON")
    cuerpo = bpy.context.active_object
    cuerpo.name = "Cuerpo"
    bpy.ops.object.mode_set(mode="EDIT")
    bpy.ops.mesh.select_all(action="DESELECT")
    bpy.ops.object.mode_set(mode="OBJECT")
    arriba = max(p.center.z for p in cuerpo.data.polygons)
    for p in cuerpo.data.polygons:
        p.select = p.center.z >= arriba - 1e-4 and abs(p.normal.z) > 0.9
    bpy.ops.object.mode_set(mode="EDIT")
    bpy.ops.mesh.delete(type="FACE")
    bpy.ops.object.mode_set(mode="OBJECT")
    mod = cuerpo.modifiers.new("Grosor", "SOLIDIFY")
    mod.thickness = 0.012
    bpy.ops.object.modifier_apply(modifier=mod.name)
    cuerpo.data.materials.append(carbon)

    # Aro de metal en el borde.
    bpy.ops.mesh.primitive_torus_add(major_segments=LADOS, minor_segments=4, major_radius=RADIO_ARRIBA,
                                     minor_radius=0.012, location=(0, 0, ALTO),
                                     rotation=(0, 0, math.pi / LADOS))
    aro = bpy.context.active_object
    aro.name = "Aro"
    aro.data.materials.append(metal)

    # Pedal delante.
    bpy.ops.mesh.primitive_cube_add(size=1, location=(0, -RADIO_ABAJO - 0.05, 0.03))
    pedal = bpy.context.active_object
    pedal.name = "Pedal"
    pedal.scale = (0.12, 0.08, 0.02)
    bpy.ops.object.transform_apply(scale=True)
    pedal.data.materials.append(metal)

    raiz = bpy.data.objects.new("Basura", None)
    bpy.context.collection.objects.link(raiz)
    for obj in (cuerpo, aro, pedal):
        obj.parent = raiz
        for poly in obj.data.polygons:
            poly.use_smooth = False
    SALIDA_GLB.parent.mkdir(parents=True, exist_ok=True)
    bpy.ops.wm.save_as_mainfile(filepath=str(SALIDA_BLEND))
    bpy.ops.export_scene.gltf(filepath=str(SALIDA_GLB), export_format="GLB", export_apply=True, export_yup=True)
    caras = sum(len(o.data.polygons) for o in (cuerpo, aro, pedal))
    print(f"Basura exportada: {SALIDA_GLB} ({caras} caras)")


if __name__ == "__main__":
    main()
