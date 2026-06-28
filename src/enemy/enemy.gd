extends CharacterBody3D

enum ENEMY_STATES {
	STARTING = 1,
	FIRE = 2,
	HURT = 3,
	DEAD = 4
}

@export var MAX_HEALTH: int = 1
@export var SHOOT_FREQUENCY: float = 2
@export var BULLET_BURST: int
@export var BULLET_SCENE: PackedScene

@onready var sprite: AnimatedSprite3D = $AnimatedSprite3D
@onready var reload_timer: Timer = $reload_timer
@onready var bullet_origin: Marker3D = $Marker3D

var patrol_point: Marker3D
var current_state: ENEMY_STATES = ENEMY_STATES.STARTING
var current_health: int
var target: Marker3D

func _ready() -> void:
	current_health = MAX_HEALTH  # Fix: was using MAX_HEALTH before _ready, always 0 default
	sprite.play("Walk", randf_range(0.8, 1.2))
	reload_timer.wait_time = SHOOT_FREQUENCY
	get_player_node()

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
		ENEMY_STATES.DEAD:
			pass

	move_and_slide()

func shoot() -> void:
	if not BULLET_SCENE:
		return
	print("BANG")
	var new_bullet = BULLET_SCENE.instantiate()
	get_parent().add_child(new_bullet)
	new_bullet.global_position = bullet_origin.global_position
	new_bullet.set_direction((target.global_position - bullet_origin.global_position).normalized())
	new_bullet.set_team(false)

func take_damage(amount: int = 1) -> void:
	if current_state == ENEMY_STATES.DEAD:
		return
	current_health -= amount
	if current_health <= 0:
		die()
	else:
		current_state = ENEMY_STATES.HURT
		sprite.play("Hurt")

func die() -> void:
	current_state = ENEMY_STATES.DEAD
	sprite.play("Dying")

func _on_area_3d_area_entered(area: Area3D) -> void:
	take_damage(1)

func _on_animated_sprite_3d_animation_finished() -> void:
	match current_state:
		ENEMY_STATES.HURT:
			current_state = ENEMY_STATES.FIRE
			sprite.play("Walk")
		ENEMY_STATES.DEAD:
			pass
