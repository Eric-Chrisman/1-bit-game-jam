extends Node3D

enum AIM_TYPES {
	FORE_LAYER = 0,
	BACK_LAYER = 1
}

@onready var y_pivot: Node3D = $y_pivot
@onready var ray_cast_laser_pointer: RayCast3D = $y_pivot/AimLaser

func _process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 1000
	var camera = get_tree().root.get_camera_3d()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	var result = space.intersect_ray(ray_query)
	
	if result:
		var target_point: Vector3 = result["position"]
		y_pivot.look_at(target_point, Vector3.UP)
		y_pivot.rotation.x -= PI / 2
