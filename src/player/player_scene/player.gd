extends CharacterBody3D

@export var SPEED: float = 30

@onready var inventory: Inventory = $Inventory
@onready var bullet_orgin: Marker3D = $Marker3D
@onready var aimmer: Node3D = $LaserPointer
@onready var model: Node3D = $TheStranger

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	var direction: int = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.z = direction * SPEED
	else:
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	move_and_slide()
	
	if Input.is_action_just_pressed("fire"):
		if inventory.can_fire_weapon():
			pass
		#inventory.fire_weapon(bullet_orgin.global_position, aimmer.get_direction())
