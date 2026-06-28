extends Node3D

@onready var animation_node: AnimationPlayer = $AnimationPlayer

var char: CharacterBody3D

func _ready() -> void:
	char = get_parent()
	animation_node.play("Idle1")

func _process(_delta: float) -> void:
	match char.state:
		char.State.SHOOTING, char.State.DODGE_AIR, char.State.DODGE_LAG:
			return
	
	var moving: bool = abs(char.velocity.z) > 0.1
	var current: StringName = animation_node.current_animation
	
	if moving and current != "RunCycle":
		animation_node.play("RunCycle")
	elif not moving and (current == "RunCycle" or current == ""):
		animation_node.play("Idle1")
	
	if char.velocity.z < 0:
		rotation.y = PI
	elif char.velocity.z > 0:
		rotation.y = 0

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Idle1":
		if randi_range(1, 5) == 1:
			if randi_range(0, 1) == 1:
				animation_node.play("Idle2")
			else:
				animation_node.play("Idle3")
		else:
			animation_node.play("Idle1")
	elif anim_name == "Idle2" or anim_name == "Idle3":
		animation_node.play("Idle1")

func shoot(direction: Vector3) -> void:
	animation_node.stop()
	rotation.y = atan2(direction.x, direction.z)
	animation_node.play("Shoot")

func dodge() -> void:
	animation_node.play("Dive", -1, 1.5)
