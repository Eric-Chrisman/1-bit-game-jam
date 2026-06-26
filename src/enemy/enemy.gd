extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

func _on_area_3d_area_entered(area: Area3D) -> void:
	visible = false
	$Timer.start()


func _on_timer_timeout() -> void:
	visible = true
