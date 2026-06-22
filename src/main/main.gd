extends Node

func _on_options_pressed() -> void:
	$Options_Layer.visible = true

func _on_start_pressed() -> void:
	$Title_Layer.visible = false

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	place_circle()

func place_circle():
	var circle = $Game_World/Entities/Area2D
	var viewport_rect = get_viewport().get_visible_rect().size - Vector2(100, 100)
	circle.position = Vector2(
		randi_range(100, viewport_rect.x),
		randi_range(100, viewport_rect.y)
	)
