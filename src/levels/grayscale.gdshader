shader_type canvas_item;
uniform vec3 filter_coff = vec3(1.0,1.0,1.0);

float lerp(float a, float b, float t) {
    return a + (b - a) * t;
}

void fragment() {
    vec4 texColor = texture(TEXTURE, UV);
    float gray = dot(texColor.rgb, vec3(0.299, 0.587, 0.114));
	
	float r =  texColor.r;
	r = lerp(r, gray, filter_coff.x);
	float g =  texColor.g;
	g = lerp(g, gray, filter_coff.y);
	float b =  texColor.b;
	b = lerp(b, gray, filter_coff.z);
	COLOR = vec4(r, g, b, texColor.a);
}