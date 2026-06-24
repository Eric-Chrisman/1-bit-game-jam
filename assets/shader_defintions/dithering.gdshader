shader_type canvas_item;

// --- Functions --- //
void fragment() {
	COLOR.a = 100.0 * cos(2.0 * 50.0 * UV.x);
}