shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back, unshaded, depth_test_disabled;
uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color,filter_linear_mipmap,repeat_enable;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

uniform float lod = 0.0;

void vertex() {
	UV=UV*uv1_scale.xy+uv1_offset.xy;
	vec3 dir = CAMERA_POSITION_WORLD - NODE_POSITION_WORLD;
	dir.y = 0.;
	dir = normalize(dir);
	mat3 bt = mat3(cross(vec3(0.,1.,0.),dir), vec3(0.,1.,0.), dir);
	VERTEX = bt * VERTEX;
	NORMAL = dir;
}

void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = textureLod(texture_albedo,base_uv,lod);
	albedo_tex *= COLOR;
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	ALPHA *= albedo.a * albedo_tex.a;
}
