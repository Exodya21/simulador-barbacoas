shader_type spatial;
// Trozos de carbón bajo la rejilla (MultiMesh de RejillaCalor).
// Color de cada instancia: r = fuego (0 apagado, 1 al rojo), g = ceniza,
// b = fase del parpadeo. Low-poly de color plano: el detalle es el brillo.

uniform vec3 color_carbon : source_color = vec3(0.169, 0.165, 0.180); // Paleta: Carbón
uniform vec3 color_ceniza : source_color = vec3(0.604, 0.580, 0.549); // Paleta: Ceniza
uniform vec3 color_brasa : source_color = vec3(0.910, 0.467, 0.180);  // Paleta: Brasa
uniform vec3 color_llama : source_color = vec3(0.961, 0.753, 0.290);  // Paleta: Llama
uniform float energia = 0.9;

varying float v_fuego;
varying float v_ceniza;
varying float v_fase;

void vertex() {
	v_fuego = COLOR.r;
	v_ceniza = COLOR.g;
	v_fase = COLOR.b;
}

void fragment() {
	// Las caras de arriba se cubren antes de ceniza; las de abajo brillan más.
	float arriba = clamp(dot(NORMAL, (VIEW_MATRIX * vec4(0.0, 1.0, 0.0, 0.0)).xyz), 0.0, 1.0);
	float ceniza = clamp(v_ceniza + arriba * 0.35 * (1.0 - v_fuego * 0.5), 0.0, 1.0);
	ALBEDO = mix(color_carbon, color_ceniza, ceniza);
	ROUGHNESS = 0.95;
	float parpadeo = 0.85 + 0.15 * sin(TIME * (1.3 + v_fase) + v_fase * 6.2832);
	float brillo = v_fuego * v_fuego * parpadeo * (1.0 - ceniza * 0.7);
	EMISSION = mix(color_brasa, color_llama, clamp(v_fuego - 0.9, 0.0, 1.0) * 4.0) * brillo * energia;
}
