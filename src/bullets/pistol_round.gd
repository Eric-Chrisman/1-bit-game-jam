extends CharacterBody3D

@export var bullet_speed: float = 100

func _physics_process(delta: float) -> void:
	move_and_slide()

func _on_life_time_timeout() -> void:
	kill_bullet()

func _on_area_3d_area_entered(area: Area3D) -> void:
	kill_bullet()

func _on_area_3d_body_entered(body: Node3D) -> void:
	kill_bullet()

func kill_bullet() -> void:
	queue_free()
