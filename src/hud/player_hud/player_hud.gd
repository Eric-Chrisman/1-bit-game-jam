extends Control
class_name PlayerHUD

func on_health_update(health: int) -> void:
	match health:
		3:
			$HBOXContainer/SPrite2D3.visible = true
			$HBOXContainer/SPrite2D2.visible = true
			$HBOXContainer/SPrite2D1.visible = true
		2:
			$HBOXContainer/SPrite2D3.visible = false
			$HBOXContainer/SPrite2D2.visible = true
			$HBOXContainer/SPrite2D1.visible = true
		1:
			$HBOXContainer/SPrite2D3.visible = false
			$HBOXContainer/SPrite2D2.visible = false
			$HBOXContainer/SPrite2D1.visible = true

func update_ammo(ammo_count: int) -> void:
	$Label.text = ammo_count
