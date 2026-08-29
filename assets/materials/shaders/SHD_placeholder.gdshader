shader_type spatial;

uniform sampler2D _MainTex : source_color, repeat_enable;
uniform bool UseImgRoughness;
uniform float UVscale : hint_range(1.0, 200.0, 1) = 50.0;
//uniform vec2 _UVscale = vec2(50.000000,50.000000000);
//
//void vertex() {
	//// Called for every vertex the material is visible on.
//}

void fragment() {
	// Called for every pixel the material is visible on.
	//	scale the uv before applying to the albedo
	vec2 scaledUV = UV * vec2(UVscale,UVscale);
	//vec2 scaledUV = UV * _UVscale / vec2(textureSize(_MainTex,0));
	vec3 albedo = texture(_MainTex, scaledUV).rgb;
	ALBEDO = albedo;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
