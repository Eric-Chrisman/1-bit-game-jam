extends RayCast3D

@onready var beam_mesh: MeshInstance3D = $MeshInstance3D

func _process(delta: float) -> void:
	force_raycast_update()
	var cast_point: Vector3
	if is_colliding():
		cast_point = to_local(get_collision_point())
	else:
		cast_point = Vector3(0, -target_position.length(), 0)
	beam_mesh.mesh.height = abs(cast_point.y)
	beam_mesh.position.y = cast_point.y / 2
