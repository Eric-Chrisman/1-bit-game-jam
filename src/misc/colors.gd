extends Node

var color_light: Color
var color_dark: Color
var shader: MeshInstance3D

func ready():
	shader = get_tree().get_first_node_in_group("shader")
	color_light = Color.WHITE
	color_dark = Color.BLACK
	
func change_light_color(new_color: Color):
	color_light = new_color
	update_all()

func change_dark_color(new_color: Color):
	color_dark = new_color
	update_all()

func _physics_process(delta: float):
	pass

func update_modulates():
	pass

func update_shader():
	pass

func update_all():
	update_modulates()
	update_shader()
