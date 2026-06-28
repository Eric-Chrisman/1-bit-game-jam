shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, unshaded;

uniform float t = 0.0;
uniform vec3 albedo_and_emissive_color : source_color = vec3(1.0);
// Godot automatically binds the current animation frame to this uniform
// DO NOT assign this manually in the Inspector — Godot handles it
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap, repeat_disable;
uniform sampler2D noise_tex;
uniform float noise_scale = 1.0;

void fragment() {
	vec4 sprite = texture(texture_albedo, UV);

	// Discard transparent pixels from the sprite
	if (sprite.a < 0.1) { discard; }

	float noise = texture(noise_tex, UV * noise_scale).r;
	float mask = step(t, noise);

	// Discard pixels dissolved by the noise mask
	if (mask < 1.0) { discard; }

	ALBEDO   = sprite.rgb * albedo_and_emissive_color;
	EMISSION = sprite.rgb * albedo_and_emissive_color;
	ALPHA    = sprite.a;
}
