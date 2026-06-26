extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var inventory: Node = $Inventory

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var direction: int = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.z = direction * SPEED
	else:
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
