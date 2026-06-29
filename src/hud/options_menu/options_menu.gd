extends Control

signal cancel_pressed
signal apply_pressed


func _on_cancel_button_pressed() -> void:
	emit_signal("cancel_pressed")

func _on_apply_button_pressed() -> void:
	emit_signal("apply_pressed")
