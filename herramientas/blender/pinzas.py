"""Genera las pinzas de barbacoa low-poly y las exporta a arte/modelos/pinzas.glb.

Uso (Blender instalado):
    blender --background --python herramientas/blender/pinzas.py
o con el módulo bpy de PyPI:
    python herramientas/blender/pinzas.py

Ejes (Blender): las pinzas apuntan hacia +Y (en Godot, hacia delante: -Z).
Cada brazo es un objeto aparte con el origen en la bisagra, para poder
abrirlos y cerrarlos girándolos sobre el eje X.
Colores de la paleta del juego (scripts/paleta.gd): METAL y MADERA.
"""
import math
from pathlib import Path

import bpy

RAIZ = Path(__file__).resolve().parents[2]
SALIDA_GLB = RAIZ / "arte" / "modelos" / "pinzas.glb"
SALIDA_BLEND = RAIZ / "arte" / "modelos" / "pinzas.blend"

METAL = (0x5A / 255, 0x5F / 255, 0x66 / 255, 1.0)
MADERA = (0x8A / 255, 0x5A / 255, 0x3B / 255, 1.0)

LARGO_MANGO = 0.13     # tramo con el mango de madera
LARGO_METAL = 0.20     # tramo de metal hasta la punta
LARGO_PUNTA = 0.045    # pala de la punta
ANCHO = 0.020
GROSOR = 0.003
SEPARACION = 0.012     # separación de cada brazo respecto al centro en la bisagra
APERTURA = math.radians(7)  # ángulo de cada brazo con las pinzas abiertas


def limpiar_escena():
    bpy.ops.wm.read_factory_settings(use_empty=True)


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


def caja(nombre, centro, tamano, mat, padre):
    bpy.ops.mesh.primitive_cube_add(size=1, location=centro)
    obj = bpy.context.active_object
    obj.name = nombre
    obj.scale = tamano
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    obj.data.materials.append(mat)
    obj.parent = padre
    return obj


def brazo(nombre, lado, mat_metal, mat_madera):
    """lado = +1 brazo de arriba, -1 brazo de abajo."""
    pivote = bpy.data.objects.new(nombre, None)
    bpy.context.collection.objects.link(pivote)
    z = lado * SEPARACION
    y_metal = LARGO_MANGO + LARGO_METAL / 2
    y_punta = LARGO_MANGO + LARGO_METAL + LARGO_PUNTA / 2
    piezas = [
        # Fleje de metal a todo lo largo.
        caja(f"{nombre}_fleje", (0, (LARGO_MANGO + LARGO_METAL) / 2, z),
             (ANCHO, LARGO_MANGO + LARGO_METAL, GROSOR), mat_metal, None),
        # Mango de madera, más grueso, por fuera del fleje.
        caja(f"{nombre}_mango", (0, LARGO_MANGO / 2 + 0.01, z + lado * 0.005),
             (ANCHO + 0.004, LARGO_MANGO - 0.02, 0.010), mat_madera, None),
        # Pala de la punta: más ancha y doblada hacia dentro.
        caja(f"{nombre}_punta", (0, y_punta - 0.002, z),
             (ANCHO * 1.7, LARGO_PUNTA + 0.004, GROSOR), mat_metal, None),
        # Cuello que ensancha el fleje hacia la pala.
        caja(f"{nombre}_cuello", (0, LARGO_MANGO + LARGO_METAL - 0.006, z),
             (ANCHO * 1.35, 0.014, GROSOR), mat_metal, None),
    ]
    # Dientes de la punta (tres) mirando hacia el otro brazo.
    for i, x in enumerate((-0.012, 0.0, 0.012)):
        piezas.append(caja(f"{nombre}_diente{i}", (x, LARGO_MANGO + LARGO_METAL + LARGO_PUNTA - 0.005, z - lado * 0.004),
                           (0.006, 0.006, 0.005), mat_metal, None))
    # Juntar las piezas en una malla por brazo.
    bpy.ops.object.select_all(action="DESELECT")
    for p in piezas:
        p.select_set(True)
    bpy.context.view_layer.objects.active = piezas[0]
    bpy.ops.object.join()
    malla = bpy.context.active_object
    malla.name = f"{nombre}_malla"
    malla.parent = pivote
    pivote.rotation_euler = (lado * APERTURA, 0, 0)
    return pivote


def bisagra(mat_metal):
    """Aro del muelle que une los dos brazos por detrás."""
    bpy.ops.mesh.primitive_torus_add(major_radius=SEPARACION, minor_radius=0.003,
                                     major_segments=10, minor_segments=4,
                                     location=(0, -0.004, 0), rotation=(0, math.radians(90), 0))
    aro = bpy.context.active_object
    aro.name = "Bisagra"
    aro.data.materials.append(mat_metal)
    return aro


def main():
    limpiar_escena()
    mat_metal = material("Metal", METAL, 0.7, 0.45)
    mat_madera = material("Madera", MADERA, 0.0, 0.8)
    raiz = bpy.data.objects.new("Pinzas", None)
    bpy.context.collection.objects.link(raiz)
    for obj in (bisagra(mat_metal), brazo("BrazoArriba", 1, mat_metal, mat_madera),
                brazo("BrazoAbajo", -1, mat_metal, mat_madera)):
        obj.parent = raiz
    for obj in bpy.data.objects:
        if obj.type == "MESH":
            for poly in obj.data.polygons:
                poly.use_smooth = False  # low-poly: caras planas
    SALIDA_GLB.parent.mkdir(parents=True, exist_ok=True)
    bpy.ops.wm.save_as_mainfile(filepath=str(SALIDA_BLEND))
    bpy.ops.export_scene.gltf(filepath=str(SALIDA_GLB), export_format="GLB",
                              export_apply=True, export_yup=True)
    tris = sum(len(o.data.polygons) for o in bpy.data.objects if o.type == "MESH")
    print(f"Pinzas exportadas: {SALIDA_GLB} ({tris} caras)")


if __name__ == "__main__":
    main()
