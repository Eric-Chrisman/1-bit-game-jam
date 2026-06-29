extends Node3D

@onready var animation_node: AnimationPlayer = $AnimationPlayer
@onready var muzzle_flash: Node3D = $StrangerArmature/Skeleton3D/StrangerBoneHandIndexRoot_L/Pistol/MuzzleFlare
@export var muzzle_flash_timeout: float = 0.1

var muzzle_flash_timer: Timer
var chara: CharacterBody3D


func _ready() -> void:
	chara = get_parent()
	animation_node.play("Idle1")
	
	muzzle_flash.visible = false
	muzzle_flash_timer = Timer.new()
	add_child(muzzle_flash_timer)
	muzzle_flash_timer.one_shot = true
	muzzle_flash_timer.wait_time = muzzle_flash_timeout
	muzzle_flash_timer.timeout.connect(muzzle_flash_end)
	

func _process(_delta: float) -> void:
	match chara.state:
		chara.State.SHOOTING, chara.State.DODGE_AIR, chara.State.DODGE_LAG, chara.State.RELOADING:
			return
	
	var moving: bool = abs(chara.velocity.z) > 0.1
	var current: StringName = animation_node.current_animation
	
	if moving and current != "RunCycle":
		animation_node.play("RunCycle")
	elif not moving and (current == "RunCycle" or current == ""):
		animation_node.play("Idle1")
	
	if chara.velocity.z < 0:
		rotation.y = PI
	elif chara.velocity.z > 0:
		rotation.y = 0

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Idle1":
		if randi_range(1, 5) == 1:
			if randi_range(0, 1) == 1:
				animation_node.play("Idle2")
			else:
				animation_node.play("Idle3")
		else:
			animation_node.play("Idle1")
	elif anim_name == "Idle2" or anim_name == "Idle3":
		animation_node.play("Idle1")
		
func shoot(direction: Vector3) -> void:
	animation_node.stop()
	rotation.y = atan2(direction.x, direction.z)
	muzzle_flash.visible = true
	muzzle_flash_timer.start()
	animation_node.play("Shoot")

func muzzle_flash_end() -> void:
	print("Muzzle timer end")
	muzzle_flash.visible = false

func reload() -> void:
	animation_node.stop()
	animation_node.play("Reload")

func dodge() -> void:
	animation_node.play("Dive", -1, 1.5)
