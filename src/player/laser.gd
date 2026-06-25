extends RayCast3D

@onready var beam_mesh: MeshInstance3D = $MeshInstance3D

func _process(delta: float) -> void:
	force_raycast_update()
	if is_colliding():
		var cast_point: Vector3 = to_local(get_collision_point())
		beam_mesh.mesh.height = cast_point.y
		beam_mesh.position.y = cast_point.y / 2
