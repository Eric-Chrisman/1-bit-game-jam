extends Node3D
class_name Aimming

enum AIM_TYPES {
	FORE_LAYER = 0,
	BACK_LAYER = 1
}

@onready var laser: Node3D = $AimLaser
@onready var dot: Node3D = $MeshInstance3D

func _process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 100000
	var camera = get_tree().root.get_camera_3d()
	if !camera:
		return
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	var result = space.intersect_ray(ray_query)
	
	if result:
		var target_point: Vector3 = result["position"]
		dot.position = target_point
		laser.look_at(target_point, Vector3.UP, false)
		laser.rotation.x -= PI / 2

func get_direction() -> Vector3:
	return (dot.global_position - global_position).normalized()
