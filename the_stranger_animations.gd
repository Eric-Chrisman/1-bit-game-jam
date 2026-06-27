extends Node3D

@onready var animation_node: AnimationPlayer = $AnimationPlayer
var char_body_data: CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	char_body_data = get_parent()
	animation_node.play("Idle1")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !char_body_data:
		return
	var velocity: Vector3 = char_body_data.velocity
	if velocity.z == 0:
		animation_node.play("Idle1")
	else:
		animation_node.play("RunCycle")
		if velocity.z > 0.1:
			rotation.y = 0
		elif velocity.z < - 0.1:
			rotation.y = PI
