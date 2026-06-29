extends CharacterBody3D
class_name Player

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
@onready var bullet_sounds: global_sounds = $BulletSound
@onready var walk_sounds: global_sounds = $WalkSound
@onready var reload_sounds: global_sounds = $Reload
@onready var dodge_sounds: global_sounds = $Dodge

@export var MAX_HEALTH: int = 3
@onready var health: int = MAX_HEALTH
var ui: PlayerHUD

var state: State = State.FREE
var dodge_dir: int = 0
var queued_shot: bool = false
var can_move: bool

signal on_gameover

func _ready() -> void:
	ui = get_tree().get_first_node_in_group("player_ui")

func _physics_process(delta: float) -> void:
	if !can_move:
		return
	$LaserPointer.visible = true
	#print(State.find_key(state))
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match state:
		State.FREE:
			_handle_free(delta)
		State.SHOOTING:
			_handle_shooting_input()
		State.RELOADING:
			_handle_reload_input()
		State.DODGE_AIR, State.DODGE_LAG:
			pass
	move_and_slide()

func _handle_free(_delta: float) -> void:
	var direction: float = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.z = direction * SPEED
	else:
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	if Input.is_action_just_pressed("jump") and direction != 0:
		_enter_dodge(direction)
	elif Input.is_action_just_pressed("fire"):
		if inventory.can_fire_weapon():
			_enter_shooting()
	elif Input.is_action_just_pressed("reload") and !inventory.is_mag_full():
			_enter_reload()
	

func _handle_reload_input() -> void:
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right") or Input.is_action_just_pressed("jump"):
		state = State.FREE
	elif Input.is_action_just_pressed("fire"):
		state = State.FREE
		if inventory.can_fire_weapon():
			_enter_shooting()
	
func _enter_reload() -> void:
	velocity.z = move_toward(velocity.z, 0, SPEED)
	state = State.RELOADING
	model.reload()
	reload_sounds.play()

func continue_reload() -> void:
	inventory.reload_weapon()
	if inventory.current_gun.current_ammo_mag < inventory.current_gun.MAX_MAG_SIZE:
		model.reload()
		reload_sounds.play()
	else:
		state = State.FREE

func _handle_shooting_input() -> void:
	velocity.z = move_toward(velocity.z, 0, SPEED)
	if Input.is_action_just_pressed("fire") and inventory.can_fire_weapon():
		queued_shot = true

func _enter_shooting() -> void:
	if inventory.can_fire_weapon():
		state = State.SHOOTING
		queued_shot = false
		model.shoot(aimer.get_direction())

func _enter_dodge(direction: float) -> void:
	dodge_dir = int(direction)
	state = State.DODGE_AIR
	velocity.z = direction * SPEED * 2
	model.dodge()
	dodge_sounds.play()

func shoot_bullet() -> void:
	bullet_sounds.play()
	inventory.fire_weapon(bullet_origin.global_position, (aimer.get_target_position() - bullet_origin.global_position).normalized())

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

func get_target() -> Marker3D:
	return get_node("where_enemies_aim")

func _on_hitbox_area_entered(area: Area3D) -> void:
	
	health = clamp(health - 1, 0, MAX_HEALTH)
	if health <= 0:
		var main = get_tree().get_first_node_in_group("main")
		main.on_gameover()
	if ui:
		ui.on_health_update(health)
	

func play_walk_sound():
	walk_sounds.play()
