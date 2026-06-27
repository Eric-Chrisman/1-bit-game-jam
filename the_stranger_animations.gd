extends Node3D

@onready var animation_node: AnimationPlayer = $AnimationPlayer
var char_body_data: CharacterBody3D
var is_moving: bool = false

func _ready() -> void:
	char_body_data = get_parent()
	animation_node.play("Idle1")

func _process(delta: float) -> void:
	if !char_body_data:
		return
	var velocity: Vector3 = char_body_data.velocity
	var moving: bool = abs(velocity.z) > 0.1

	if moving and !is_moving:
		is_moving = true
		animation_node.play("RunCycle")
	elif !moving and is_moving:
		is_moving = false
		animation_node.play("Idle1")

	if is_moving:
		rotation.y = PI if velocity.z < 0 else 0

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Idle1":
		if randi_range(1, 5) == 1:
			animation_node.play("Idle2" if randi_range(0, 1) else "Idle3")
		else:
			animation_node.play("Idle1")
	elif anim_name == "Idle2" or anim_name == "Idle3":
		animation_node.play("Idle1")
