extends Control

signal start_pressed
signal options_pressed
signal quit_pressed


func _on_start_pressed() -> void:
	emit_signal("start_pressed")

func _on_options_pressed() -> void:
	emit_signal("options_pressed")

func _on_quit_pressed() -> void:
	emit_signal("quit_pressed")
