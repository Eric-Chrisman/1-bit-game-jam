extends Node

@onready var title_layer: CanvasLayer = $Title_Layer
#@onready var options_layer: CanvasLayer = $Options_Layer
@onready var gameover_layer: CanvasLayer = $GameoverLayer


func _ready() -> void:
	get_tree().paused = true
	$Map/Entity_Layer/Player.can_move = false
	title_layer.get_child(0).start_pressed.connect(on_start_pressed)
	#title_layer.get_child(0).options_pressed.connect(on_options_pressed)
	title_layer.get_child(0).quit_pressed.connect(on_quit_pressed)
	
	#options_layer.get_child(0).cancel_pressed.connect(on_back_pressed)
	#options_layer.get_child(0).apply_pressed.connect(on_apply_pressed)
	
	gameover_layer.get_child(0).retry_pressed.connect(on_retry_pressed)
	gameover_layer.get_child(0).quit_pressed.connect(on_quit_pressed)

# Title Screen Buttons
func on_start_pressed() -> void:
	title_layer.visible = false
	$Map/Entity_Layer/Player.can_move = true
	get_tree().paused = false
	
#func on_options_pressed() -> void:
	#title_layer.visible = false
	#options_layer.visible = true
	
func on_quit_pressed() -> void:
	get_tree().quit()

## Options Menu Buttons
#func on_back_pressed() -> void:
	#options_layer.visible = false
	#title_layer.visible = true

#func on_apply_pressed() -> void:
	#options_layer.visible = false
	#title_layer.visible = true


# GameOver Buttons
func on_retry_pressed() -> void:
	gameover_layer.visible = false
	get_tree().reload_current_scene()

func on_gameover() -> void:
	get_tree().paused = true
	gameover_layer.visible = true


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	place_circle()

func place_circle():
	var circle = $Game_World/Entities/Area2D
	var viewport_rect = get_viewport().get_visible_rect().size - Vector2(100, 100)
	circle.position = Vector2(
		randi_range(100, viewport_rect.x),
		randi_range(100, viewport_rect.y)
	)
