extends Node
class_name Gun
enum FIRE_MODES {
	FULL_AUTO = 0,
	SEMI_FULL_AUTO = 1,
	SEMI_AUTO = 2
}
@export var MAX_AMMO_CAP: int = 100
@export var MAX_MAG_SIZE: int = 60
@export var BULLET_COUNT_PER_SHOT: int = 1
@export var BULLET_SCENE: PackedScene
@export var LOADS_WHOLE_MAG: bool = true
@export var LOADS_PER_RELOAD: int = 1
@export var RELOAD_TIME: float = 1
@export var AMMO_COST_PER_SHOT: int = 1
@export var RANDOM_SPREAD_ANGLE: int = 0
@export var FIRE_COOLDOWN: float = 1
@export var FIRE_MODE: FIRE_MODES = FIRE_MODES.SEMI_AUTO
@export var MODEL: Mesh
@export var WEAPON_SLOT: int = 1
var reload_timer: Timer
var fire_cooldown_timer: Timer
var current_ammo_reserve: int = MAX_AMMO_CAP
var current_ammo_mag: int = MAX_MAG_SIZE

func _ready() -> void:
	reload_timer = Timer.new()
	reload_timer.one_shot = true
	reload_timer.wait_time = RELOAD_TIME
	reload_timer.timeout.connect(reloaded)
	add_child(reload_timer)

	fire_cooldown_timer = Timer.new()
	fire_cooldown_timer.one_shot = true
	fire_cooldown_timer.wait_time = FIRE_COOLDOWN
	add_child(fire_cooldown_timer)

func shoot(orgin: Vector3, direction: Vector3) -> void:
	if current_ammo_mag > 0 and BULLET_SCENE:
		var bullet = BULLET_SCENE.instantiate()
		bullet.position = orgin
		bullet.set_direction(direction)
		current_ammo_mag -= AMMO_COST_PER_SHOT
		add_child(bullet)

func reload():
	pass

func interupt_reload():
	pass

func reloaded():
	var empty_part_of_mag: int = MAX_MAG_SIZE - current_ammo_mag
	var bullets_we_can_load: int = min(current_ammo_reserve, empty_part_of_mag)
	if LOADS_WHOLE_MAG:
		current_ammo_mag += bullets_we_can_load
	else:
		bullets_we_can_load = min(bullets_we_can_load, LOADS_PER_RELOAD)
	current_ammo_reserve -= bullets_we_can_load

func is_cooldown_complete():
	return fire_cooldown_timer.is_stopped()
