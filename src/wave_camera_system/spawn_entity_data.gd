extends Node3D
class_name SpawnEntry

enum SpawnTrigger {
	TIMED = 1,
	ON_DEATHS = 2,
}

@export var enemy_scene: PackedScene
@export var trigger: SpawnTrigger = SpawnTrigger.TIMED
@export var delay: float = 1.0
@export var deaths_required: int = 1

var where_to_move: Marker3D

func _ready():
	for child in get_children():
		if child is Marker3D:
			where_to_move = child
