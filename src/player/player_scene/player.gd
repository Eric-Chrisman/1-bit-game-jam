extends CharacterBody3D

enum State {
	FREE,
	SHOOTING,
	DODGE_AIR, 
	DODGE_LAG,
	RELOADING
	}

@export var SPEED: float = 30
@onready var inventory: Inventory = $Inventory
@onready var bullet_origin: Marker3D = $TheStranger/StrangerArmature/Skeleton3D/StrangerBoneHandIndexRoot_L/Pistol/Marker3D
@onready var aimer: Node3D = $LaserPointer
@onready var model: Node3D = $TheStranger

var state: State = State.FREE
var dodge_dir: int = 0
var queued_shot: bool = false

func _physics_process(delta: float) -> void:
	print(State.find_key(state))
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match state:
		State.FREE:
			_handle_free(delta)
		State.SHOOTING:
			_handle_shooting_input()
		State.DODGE_AIR, State.DODGE_LAG:
			pass
	
	move_and_slide()

func _handle_free(_delta: float) -> void:
	var direction: int = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.z = direction * SPEED
	else:
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	if Input.is_action_just_pressed("jump") and direction != 0:
		_enter_dodge(direction)
	elif Input.is_action_just_pressed("fire"):
		if inventory.can_fire_weapon():
			_enter_shooting()

func _handle_shooting_input() -> void:
	velocity.z = move_toward(velocity.z, 0, SPEED)
	if Input.is_action_just_pressed("fire") and inventory.can_fire_weapon():
		queued_shot = true

func _enter_shooting() -> void:
	state = State.SHOOTING
	queued_shot = false
	model.shoot(aimer.get_direction())

func _enter_dodge(direction: int) -> void:
	dodge_dir = direction
	state = State.DODGE_AIR
	velocity.z = direction * SPEED * 2
	model.dodge()

func shoot_bullet() -> void:
	inventory.fire_weapon(bullet_origin.global_position, aimer.get_direction())

func shoot_done() -> void:
	if queued_shot and inventory.can_fire_weapon():
		queued_shot = false
		model.shoot(aimer.get_direction())
	else:
		queued_shot = false
		state = State.FREE

func dodge_lag() -> void:
	state = State.DODGE_LAG
	velocity.z = velocity.z / 4

func dodge_end() -> void:
	state = State.FREE
	velocity.z = 0

func is_dodge_immune() -> bool:
	return state == State.DODGE_AIR
