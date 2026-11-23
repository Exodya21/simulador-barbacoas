"""Genera el trapo viejo, sucio y roto para limpiar y lo exporta a arte/modelos/trapo.glb.

Uso: blender --background --python herramientas/blender/trapo.py
  o: python herramientas/blender/trapo.py   (con el módulo bpy de PyPI)

Paño de unos 25 x 22 cm: malla con arrugas al azar, bordes deshilachados
y algunos agujeros. Dos colores: tela gris parda y manchas de grasa.
"""
import random
from pathlib import Path

import bpy
import bmesh  # noqa: E402  (con el bpy de PyPI hay que importarlo después de bpy)

RAIZ = Path(__file__).resolve().parents[2]
SALIDA_GLB = RAIZ / "arte" / "modelos" / "trapo.glb"
SALIDA_BLEND = RAIZ / "arte" / "modelos" / "trapo.blend"

TELA = (0x8C / 255, 0x82 / 255, 0x70 / 255, 1.0)    # gris pardo, desteñido
GRASA = (0x5E / 255, 0x47 / 255, 0x24 / 255, 1.0)   # tono de la mancha de grasa
ANCHO, FONDO = 0.25, 0.22
CORTES = 7
SEMILLA = 11


def lineal(c):
    """La paleta está en sRGB; Blender trabaja en espacio lineal."""
    return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4


def material(nombre, color):
    color = tuple(lineal(v) for v in color[:3]) + (color[3],)
    mat = bpy.data.materials.new(nombre)
    mat.use_nodes = True
    bsdf = mat.node_tree.nodes["Principled BSDF"]
    bsdf.inputs["Base Color"].default_value = color
    bsdf.inputs["Roughness"].default_value = 0.95
    return mat


def main():
    rnd = random.Random(SEMILLA)
    bpy.ops.wm.read_factory_settings(use_empty=True)
    bpy.ops.mesh.primitive_grid_add(x_subdivisions=CORTES, y_subdivisions=CORTES, size=1)
    trapo = bpy.context.active_object
    trapo.name = "Trapo"
    trapo.scale = (ANCHO, FONDO, 1)
    bpy.ops.object.transform_apply(scale=True)
    trapo.data.materials.append(material("Tela", TELA))
    trapo.data.materials.append(material("Grasa", GRASA))

    malla = bmesh.new()
    malla.from_mesh(trapo.data)
    # Arrugas: cada vértice sube o baja un poco; bordes deshilachados.
    for v in malla.verts:
        v.co.z += rnd.uniform(-0.008, 0.012)
        borde = abs(v.co.x) > ANCHO * 0.45 or abs(v.co.y) > FONDO * 0.45
        if borde:
            v.co.x += rnd.uniform(-0.012, 0.012)
            v.co.y += rnd.uniform(-0.012, 0.012)
    # Agujeros: quitar unas caras sueltas; manchas: otras caras con grasa.
    caras = list(malla.faces)
    rnd.shuffle(caras)
    for cara in caras[:4]:
        malla.faces.remove(cara)
    # Dos manchones de grasa con borde irregular.
    centros = [(rnd.uniform(-0.08, 0.08), rnd.uniform(-0.07, 0.07)) for _ in range(2)]
    for cara in malla.faces:
        c = cara.calc_center_median()
        for cx, cy in centros:
            if ((c.x - cx) ** 2 + (c.y - cy) ** 2) ** 0.5 < rnd.uniform(0.03, 0.07):
                cara.material_index = 1
    # Una esquina doblada, como un trapo tirado.
    for v in malla.verts:
        if v.co.x > ANCHO * 0.3 and v.co.y > FONDO * 0.3:
            v.co.z += 0.02
    malla.to_mesh(trapo.data)
    malla.free()
    mod = trapo.modifiers.new("Grosor", "SOLIDIFY")
    mod.thickness = 0.003
    bpy.ops.object.modifier_apply(modifier=mod.name)
    for poly in trapo.data.polygons:
        poly.use_smooth = False

    SALIDA_GLB.parent.mkdir(parents=True, exist_ok=True)
    bpy.ops.wm.save_as_mainfile(filepath=str(SALIDA_BLEND))
    bpy.ops.export_scene.gltf(filepath=str(SALIDA_GLB), export_format="GLB", export_apply=True, export_yup=True)
    print(f"Trapo exportado: {SALIDA_GLB} ({len(trapo.data.polygons)} caras)")


if __name__ == "__main__":
    main()
