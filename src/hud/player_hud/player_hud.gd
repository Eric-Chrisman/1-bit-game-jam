extends Control
class_name PlayerHUD

func on_health_update(health: int) -> void:
	print("HEALTH: ", health)
	match health:
		3:
			$HBoxContainer/TextureRect.visible = true
			$HBoxContainer/TextureRect2.visible = true
			$HBoxContainer/TextureRect3.visible = true
		2:
			$HBoxContainer/TextureRect.visible = true
			$HBoxContainer/TextureRect2.visible = true
			$HBoxContainer/TextureRect3.visible = false
		1:
			$HBoxContainer/TextureRect.visible = true
			$HBoxContainer/TextureRect2.visible = false
			$HBoxContainer/TextureRect3.visible = false
			
func update_ammo(ammo_count: int) -> void:
	$Label.text = ammo_count
