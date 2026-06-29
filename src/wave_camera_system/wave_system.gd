extends Node3D

@export var player: Player
@export var distance_till_move_cam: float = 6

var locked_to_wave: bool = false

func _ready() -> void:
	if !player:
		player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	print(player_position_relative_to_camera())
	if distance_till_move_cam < player_position_relative_to_camera():
		global_position.z = player.global_position.z - distance_till_move_cam

func player_position_relative_to_camera():
	return player.global_position.z - global_position.z
