// NOTE: Shader automatically converted from Godot Engine 4.2.stable.mono's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_toon,specular_disabled, depth_prepass_alpha, shadows_disabled;
uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color,filter_nearest,repeat_enable;
uniform float point_size : hint_range(0,128);
uniform float roughness : hint_range(0,1);
uniform sampler2D texture_metallic : hint_default_white,filter_nearest,repeat_enable;
uniform vec4 metallic_texture_channel;
uniform sampler2D texture_roughness : hint_roughness_r,filter_nearest,repeat_enable;
uniform float specular;
uniform float metallic;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

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
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	albedo_tex *= COLOR;
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	float metallic_tex = dot(texture(texture_metallic,base_uv),metallic_texture_channel);
	METALLIC = metallic_tex * metallic;
	vec4 roughness_texture_channel = vec4(1.0,0.0,0.0,0.0);
	float roughness_tex = dot(texture(texture_roughness,base_uv),roughness_texture_channel);
	ROUGHNESS = roughness_tex * roughness;
	SPECULAR = specular;
	ALPHA *= albedo.a * albedo_tex.a;
}
