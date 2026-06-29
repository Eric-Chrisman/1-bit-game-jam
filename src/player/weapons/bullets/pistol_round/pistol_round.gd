extends CharacterBody3D
class_name Bullet

@export var bullet_speed: float = 20

@onready var hitbox: Area3D = $Area3D
@onready var trail_start_timer: Timer
@onready var bullet_trail: Node3D = $BulletTrail

func _ready() -> void:
	bullet_trail.visible = false
	trail_start_timer = Timer.new()
	add_child(trail_start_timer)
	trail_start_timer.one_shot = true
	trail_start_timer.wait_time = 0.15
	trail_start_timer.timeout.connect(_on_trail_start)
	trail_start_timer.start()

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _on_area_3d_area_entered(_area: Area3D) -> void:
	#print("hit area: ", area.get_parent())
	kill_bullet()

func _on_area_3d_body_entered(_body: Node3D) -> void:
	#print("hit body: ", body)
	kill_bullet()

func kill_bullet() -> void:
	queue_free()

func set_direction(direction: Vector3) -> void:
	velocity = direction.normalized() * bullet_speed
	look_at(global_position + velocity, Vector3.UP)
	#print("Parent: ", get_parent().get_class())
	#print("Direction: ", direction)
	#print("Forward:", -global_basis.z)

func set_team(is_player: bool) -> void:
	if is_player:
		hitbox.set_collision_layer_value(3, true)
		hitbox.set_collision_mask_value(3, true)
	else:
		hitbox.set_collision_layer_value(5, true)
		hitbox.set_collision_mask_value(5, true)

func _on_timer_timeout() -> void:
	#print("bullet died of time out")
	kill_bullet()

func _on_trail_start() -> void:
	if bullet_trail:
		bullet_trail.visible = true
