extends Node

var color_light: Color
var color_dark: Color
var shader: MeshInstance3D

func _ready():
	shader = get_tree().get_first_node_in_group("shader")
	color_light = Color.WHITE
	color_dark = Color.BLACK

func _physics_process(delta: float) -> void:
	update_all()

func change_light_color(new_color: Color):
	color_light = new_color
	update_all()

func change_dark_color(new_color: Color):
	color_dark = new_color
	update_all()

func update_shader():
	if !shader:
		shader = get_tree().get_first_node_in_group("shader")
	if !shader:
		return
	var mat: ShaderMaterial = shader.get_active_material(0) as ShaderMaterial
	color_light = mat.get_shader_parameter("color_b")
	color_dark = mat.get_shader_parameter("color_a")

func update_modulates():
	for thing in get_tree().get_nodes_in_group("modulates"):
		# print(get_tree().get_nodes_in_group("modulates"))
		thing.modulate = color_light
func update_all():
	update_modulates()
	update_shader()
