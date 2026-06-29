extends Area3D

signal triggered
signal wave_complete

@export var wave_to_spawn: Array

var enemies_in_action: Array[Node3D] = []
var was_triggered: bool = false

func _on_body_entered(body: Node3D) -> void:
	if body is Player and !triggered:
		was_triggered = true
		emit_signal("triggered")
