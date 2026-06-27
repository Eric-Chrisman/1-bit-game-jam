extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var inventory: Inventory = $Inventory
@onready var bullet_orgin: Marker3D = $Marker3D
@onready var aimmer: Node3D = $LaserPointer
@onready var model: Node3D = $TheStranger

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
	if velocity.z < -0.1:
		model.rotation.y = PI
	elif velocity.z > 0.1:
		model.rotation.y = 0
		
	move_and_slide()
	
	if Input.is_action_just_pressed("fire"):
		inventory.fire_weapon(bullet_orgin.global_position, aimmer.get_direction())
