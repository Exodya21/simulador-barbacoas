// Cocción por caras, low-poly de color plano.
// Cada zona del alimento mezcla los colores de la paleta según su grado de
// cocción: 0 crudo · 1 sellado · 2 dorado · 3 pasado · 4 quemado.
// Los valores llegan por instancia desde CoccionComponente (cada pieza tiene
// los suyos sin duplicar el material).
//
// - Arriba / abajo: el grado de esa cara.
// - Cantos: se doran desde la cara que toca la parrilla hacia el centro, y
//   además se van haciendo con el calor del interior (como una hamburguesa
//   real vista de lado: gris parda cuando está hecha por dentro).
// - Grano de carne picada y marcas de la parrilla en las caras selladas.
shader_type spatial;

uniform vec4 color_crudo : source_color = vec4(0.851, 0.333, 0.420, 1.0);    // Paleta.CARNE_CRUDA
uniform vec4 color_sellado : source_color = vec4(0.690, 0.376, 0.227, 1.0);  // Paleta.CARNE_SELLADA
uniform vec4 color_dorado : source_color = vec4(0.545, 0.290, 0.169, 1.0);   // Paleta.CARNE_HECHA
uniform vec4 color_pasado : source_color = vec4(0.330, 0.190, 0.120, 1.0);
uniform vec4 color_quemado : source_color = vec4(0.180, 0.118, 0.090, 1.0);  // Paleta.CARNE_QUEMADA
uniform vec4 color_suciedad : source_color = vec4(0.30, 0.27, 0.22, 1.0);
// Alto de la pieza (m) para saber a qué altura del canto está cada punto.
uniform float alto = 0.025;
// Separación (m) entre marcas de la parrilla.
uniform float separacion_marcas = 0.022;

instance uniform float grado_arriba = 0.0;
instance uniform float grado_abajo = 0.0;
instance uniform float grado_lados = 0.0;
// Grado equivalente del interior según su temperatura (0 crudo, 2 hecho).
instance uniform float grado_interior = 0.0;
// 0 limpia · 1 sucia (ha caído al suelo): motas de tierra y ceniza.
instance uniform float suciedad = 0.0;

varying vec3 normal_local;
varying vec3 posicion_local;

void vertex() {
	normal_local = NORMAL;
	posicion_local = VERTEX;
}

float azar(vec3 celda) {
	return fract(sin(dot(celda, vec3(12.9898, 78.233, 37.719))) * 43758.5453);
}

// Ruido suave (interpolado entre celdas) para el grano de la carne.
float ruido_suave(vec3 p) {
	vec3 i = floor(p);
	vec3 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	float a = mix(azar(i), azar(i + vec3(1, 0, 0)), f.x);
	float b = mix(azar(i + vec3(0, 1, 0)), azar(i + vec3(1, 1, 0)), f.x);
	float c = mix(azar(i + vec3(0, 0, 1)), azar(i + vec3(1, 0, 1)), f.x);
	float d = mix(azar(i + vec3(0, 1, 1)), azar(i + vec3(1, 1, 1)), f.x);
	return mix(mix(a, b, f.y), mix(c, d, f.y), f.z);
}

vec3 color_por_grado(float g) {
	g = clamp(g, 0.0, 4.0);
	if (g < 1.0) return mix(color_crudo.rgb, color_sellado.rgb, g);
	if (g < 2.0) return mix(color_sellado.rgb, color_dorado.rgb, g - 1.0);
	if (g < 3.0) return mix(color_dorado.rgb, color_pasado.rgb, g - 2.0);
	return mix(color_pasado.rgb, color_quemado.rgb, g - 3.0);
}

void fragment() {
	vec3 n = normalize(normal_local);
	float peso_arriba = smoothstep(0.35, 0.85, n.y);
	float peso_abajo = smoothstep(0.35, 0.85, -n.y);
	float peso_canto = clamp(1.0 - peso_arriba - peso_abajo, 0.0, 1.0);

	// Canto: dorado que sube desde la cara de abajo y baja desde la de arriba,
	// y nunca menos hecho que el interior.
	float altura = clamp(posicion_local.y / alto + 0.5, 0.0, 1.0);
	float desde_abajo = grado_abajo * smoothstep(0.65, 0.0, altura);
	float desde_arriba = grado_arriba * smoothstep(0.35, 1.0, altura);
	float g_canto = max(max(grado_lados, grado_interior), max(desde_abajo, desde_arriba));

	vec3 color = color_por_grado(grado_arriba) * peso_arriba
		+ color_por_grado(grado_abajo) * peso_abajo
		+ color_por_grado(g_canto) * peso_canto;

	// Marcas de la parrilla en las caras ya selladas.
	float g_cara = grado_arriba * peso_arriba + grado_abajo * peso_abajo;
	float raya = 1.0 - smoothstep(0.08, 0.16, abs(fract(posicion_local.z / separacion_marcas) - 0.5));
	color *= 1.0 - raya * 0.45 * clamp(g_cara - 0.8, 0.0, 1.0) * (1.0 - peso_canto);

	// Grano de carne picada: variación suave de tono a dos escalas.
	float grano = ruido_suave(posicion_local * 220.0) * 0.6 + ruido_suave(posicion_local * 70.0) * 0.4;
	color *= mix(0.92, 1.05, grano);

	// Motas de suciedad: ruido por celdas de 1 cm sobre la pieza.
	float mota = step(0.55, azar(floor(posicion_local * 100.0) + 7.0)) * suciedad;
	color = mix(color, color_suciedad.rgb, mota * 0.85);
	color = mix(color, color * vec3(0.75, 0.72, 0.68), suciedad * 0.5);

	ALBEDO = color;
	ROUGHNESS = mix(0.7, 0.95, clamp(max(g_cara, g_canto) / 4.0, 0.0, 1.0));
}
