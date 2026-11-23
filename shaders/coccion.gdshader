// Cocción por caras, low-poly de color plano.
// Cada cara (arriba, abajo, lados) mezcla los colores de la paleta según su
// grado de cocción: 0 crudo · 1 sellado · 2 dorado · 3 pasado · 4 quemado.
// Los grados llegan por instancia desde CoccionComponente, así cada pieza
// tiene los suyos sin duplicar el material.
shader_type spatial;

uniform vec4 color_crudo : source_color = vec4(0.851, 0.333, 0.420, 1.0);    // Paleta.CARNE_CRUDA
uniform vec4 color_sellado : source_color = vec4(0.690, 0.376, 0.227, 1.0);  // Paleta.CARNE_SELLADA
uniform vec4 color_dorado : source_color = vec4(0.545, 0.290, 0.169, 1.0);   // Paleta.CARNE_HECHA
uniform vec4 color_pasado : source_color = vec4(0.330, 0.190, 0.120, 1.0);
uniform vec4 color_quemado : source_color = vec4(0.180, 0.118, 0.090, 1.0);  // Paleta.CARNE_QUEMADA

instance uniform float grado_arriba = 0.0;
instance uniform float grado_abajo = 0.0;
instance uniform float grado_lados = 0.0;
// 0 limpia · 1 sucia (ha caído al suelo): motas de tierra y ceniza.
instance uniform float suciedad = 0.0;
uniform vec4 color_suciedad : source_color = vec4(0.30, 0.27, 0.22, 1.0);

varying vec3 normal_local;
varying vec3 posicion_local;

void vertex() {
	normal_local = NORMAL;
	posicion_local = VERTEX;
}

vec3 color_por_grado(float g) {
	g = clamp(g, 0.0, 4.0);
	if (g < 1.0) return mix(color_crudo.rgb, color_sellado.rgb, g);
	if (g < 2.0) return mix(color_sellado.rgb, color_dorado.rgb, g - 1.0);
	if (g < 3.0) return mix(color_dorado.rgb, color_pasado.rgb, g - 2.0);
	return mix(color_pasado.rgb, color_quemado.rgb, g - 3.0);
}

void fragment() {
	float g = grado_lados;
	if (normal_local.y > 0.5) {
		g = grado_arriba;
	} else if (normal_local.y < -0.5) {
		g = grado_abajo;
	}
	vec3 color = color_por_grado(g);
	// Motas de suciedad: ruido por celdas de 1 cm sobre la pieza.
	vec3 celda = floor(posicion_local * 100.0);
	float ruido = fract(sin(dot(celda, vec3(12.9898, 78.233, 37.719))) * 43758.5453);
	float mota = step(0.55, ruido) * suciedad;
	color = mix(color, color_suciedad.rgb, mota * 0.85);
	color = mix(color, color * vec3(0.75, 0.72, 0.68), suciedad * 0.5);
	ALBEDO = color;
	ROUGHNESS = mix(0.75, 0.95, clamp(g / 4.0, 0.0, 1.0));
}
