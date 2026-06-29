extends Control

signal retry_pressed
signal quit_pressed


func _on_retry_pressed() -> void:
	emit_signal("retry_pressed")

func _on_quit_pressed() -> void:
	emit_signal("quit_pressed")
