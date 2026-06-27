shader_type spatial;
render_mode cull_disabled, depth_draw_opaque;

uniform vec4 line_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform float line_count = 20.0;
uniform float line_width = 0.1;
uniform float speed = 2.0;

void fragment() {
    float v = UV.y;
    float t = TIME * speed;
    float pattern = fract(v * line_count + t);
    float line = smoothstep(line_width, line_width, pattern);
    line = 1.0 - line;
    ALBEDO = line_color.rgb;
    ALPHA = line * line_color.a;
}