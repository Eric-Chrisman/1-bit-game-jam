extends RayCast3D

enum AIM_TYPES {
	FORE_LAYER = 0,
	BACK_LAYER = 1
}

@onready var beam_mesh: MeshInstance3D = $MeshInstance3D

func _process(delta: float) -> void:
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var mouse_position: Vector2 = get_viewport().get_mouse_position()
	var camera: Camera3D = get_tree().root.get_camera_3d()
	var ray_origin: Vector3 = camera.project_ray_origin(mouse_position)
	var ray_end: Vector3 = ray_origin + camera.project_ray_normal(mouse_position) * 2000
	var result = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(ray_origin, ray_end))
	
	var target_point: Vector3
	if result:
		target_point = result.position
	else:
		return
	
