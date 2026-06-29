extends CharacterBody3D

enum ENEMY_STATES {
	STARTING = 1,
	FIRE = 2,
	HURT = 3,
	DEAD = 4
}

@export var MAX_HEALTH: int = 1
@export var SHOOT_FREQUENCY: float = 2
@export var BULLET_BURST: int = 1
@export var BULLET_SCENE: PackedScene
@export var HURT_DURATION: float = 0.15  # How long to show the hurt frame

@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D
@onready var reload_timer: Timer = $reload_timer
@onready var bullet_origin_1: Marker3D = $Marker3D
@onready var bullet_origin_2: Marker3D = $Marker3D2
var current_gun_to_shoot: Marker3D

var patrol_point: Marker3D
var current_state: ENEMY_STATES = ENEMY_STATES.STARTING
var current_health: int
var target: Marker3D

@onready var muzzle_flash: Node3D = $MuzzleFlare
@export var muzzle_flash_timeout: float = 0.1
var muzzle_flash_timer: Timer

# Internal timer so we don't need an extra Timer node for hurt flash
var _hurt_timer: float = 0.0

func _ready() -> void:
	current_gun_to_shoot = bullet_origin_1
	current_health = MAX_HEALTH
	sprite.play("Walk", randf_range(0.8, 1.2))
	reload_timer.wait_time = SHOOT_FREQUENCY
	get_player_node()
	
	muzzle_flash.visible = false
	muzzle_flash_timer = Timer.new()
	add_child(muzzle_flash_timer)
	muzzle_flash_timer.one_shot = true
	muzzle_flash_timer.wait_time = muzzle_flash_timeout
	muzzle_flash_timer.timeout.connect(muzzle_flash_end)

func get_player_node() -> void:
	var result = get_tree().get_nodes_in_group("player")
	if result.size() > 0:
		target = result[0].get_target()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	match current_state:
		ENEMY_STATES.STARTING:
			current_state = ENEMY_STATES.FIRE

		ENEMY_STATES.FIRE:
			if reload_timer.is_stopped():
				if target:
					shoot()
					reload_timer.start(SHOOT_FREQUENCY * randf_range(0.8, 1.2))
				else:
					get_player_node()

		ENEMY_STATES.HURT:
			# Count down and return to FIRE once the hurt frame has shown long enough
			_hurt_timer -= delta
			if _hurt_timer <= 0.0:
				current_state = ENEMY_STATES.FIRE
				sprite.play("Walk")

		ENEMY_STATES.DEAD:
			pass

	move_and_slide()

func shoot() -> void:
	if not BULLET_SCENE:
		return
	var new_bullet = BULLET_SCENE.instantiate()
	get_parent().add_child(new_bullet)
	new_bullet.global_position = current_gun_to_shoot.global_position
	new_bullet.set_direction((target.global_position - current_gun_to_shoot.global_position).normalized())
	new_bullet.set_team(false)
	if bullet_origin_2 and bullet_origin_1 == current_gun_to_shoot:
		current_gun_to_shoot = bullet_origin_2
	else:
		current_gun_to_shoot = bullet_origin_1
	if muzzle_flash:
		muzzle_flash.visible = true
		muzzle_flash_timer.start()
	

func take_damage(amount: int = 1) -> void:
	if current_state == ENEMY_STATES.DEAD:
		return
	current_health -= amount
	if current_health <= 0:
		die()
	else:
		current_state = ENEMY_STATES.HURT
		sprite.play("Hurt")
		_hurt_timer = HURT_DURATION  # Start the hurt display countdown

func die() -> void:
	current_state = ENEMY_STATES.DEAD
	sprite.play("Dying")

func _on_area_3d_area_entered(area: Area3D) -> void:
	take_damage(1)

func _on_animated_sprite_3d_animation_finished() -> void:
	match current_state:
		ENEMY_STATES.DEAD:
			queue_free()

func muzzle_flush_end() -> void:
	muzzle_flash.visible = false
