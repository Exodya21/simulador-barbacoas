shader_type spatial;
// Pasto de la estancia (MultiMesh): el color viene de cada mata, la punta
// es más clara que la base y se mece con el viento según su altura.
render_mode cull_disabled;

uniform float viento = 0.10;
uniform float velocidad = 1.4;

void vertex() {
	float h = max(VERTEX.y, 0.0);
	vec3 mundo = (MODEL_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).xyz;
	float fase = TIME * velocidad + mundo.x * 0.35 + mundo.z * 0.22;
	VERTEX.x += sin(fase) * viento * h;
	VERTEX.z += cos(fase * 0.8) * viento * 0.6 * h;
	// Normal hacia arriba: el pasto se ilumina como el suelo y no parpadea.
	NORMAL = vec3(0.0, 1.0, 0.0);
}

void fragment() {
	ALBEDO = COLOR.rgb * mix(0.55, 1.05, UV.y);
	ROUGHNESS = 0.95;
	SPECULAR = 0.1;
}
