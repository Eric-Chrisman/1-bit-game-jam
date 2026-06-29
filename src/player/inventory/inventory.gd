extends Node
class_name Inventory

var all_guns_data: Dictionary

var gun_slots: Array[Gun]
var current_gun: Gun

func _ready() -> void:
	for child in get_children():
		all_guns_data[child.name] = child
	for i in range(5):
		gun_slots.append(null)
	gun_slots[0] = all_guns_data["SixShooter"]
	current_gun = gun_slots[0]

func weapon_switch_by_number(slot_id: int):
	if gun_slots[slot_id]:
		current_gun = gun_slots[slot_id]

func fire_weapon(orgin: Vector3, direction: Vector3) -> void:
	if current_gun:
		current_gun.shoot(orgin, direction)

func reload_weapon() -> void:
	if current_gun:
		current_gun.reload_one_bullet()

func can_fire_weapon() -> bool:
	return current_gun.is_cooldown_complete() and current_gun.current_ammo_mag

func bullets_left_in_reserve() -> int:
	return current_gun.current_ammo_reserve

func is_mag_full() -> bool:
	return current_gun.current_ammo_mag == current_gun.MAX_MAG_SIZE
