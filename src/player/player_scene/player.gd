extends CharacterBody3D

# Player Controller
@export var SPEED: float = 30
@onready var inventory: Inventory = $Inventory
@onready var bullet_orgin: Marker3D = $TheStranger/StrangerArmature/Skeleton3D/StrangerBoneHandIndexRoot_L/Pistol/Marker3D
@onready var aimmer: Node3D = $LaserPointer
@onready var model: Node3D = $TheStranger
var shoot_lag: bool = false
var dodging: bool = false
var dodge_immunity: bool = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if dodging:
		pass
	elif !shoot_lag:
		var direction: int = Input.get_axis("move_left", "move_right")
		if direction:
			velocity.z = direction * SPEED
		else:
			velocity.z = move_toward(velocity.z, 0, SPEED)
		if Input.is_action_just_pressed("jump"):
			if direction != 0:
				dodging = true
				dodge_immunity = true
				velocity.z = direction * SPEED * 2
				model.dodge()
		elif Input.is_action_just_pressed("fire"):
			if inventory.can_fire_weapon() and !shoot_lag:
				model.shoot(aimmer.get_direction())
				shoot_lag = true
			else:
				print(inventory.can_fire_weapon())
				print(shoot_lag)
	move_and_slide()

func shoot_bullet():
	shoot_lag = false
	inventory.fire_weapon(bullet_orgin.global_position, aimmer.get_direction())

func dodge_lag():
	velocity.z = velocity.z / 4
	dodge_immunity = false

func dodge_end():
	dodging = false
	velocity.z = 0
