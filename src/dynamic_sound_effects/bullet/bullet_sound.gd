extends Node3D
class_name global_sounds

@export var possible_sounds: Array[AudioStream] = []
@export var pitch_min: float = 0.9
@export var pitch_max: float = 1.1
@export var volume_db: float = 0.0

func play() -> void:
	if possible_sounds.is_empty():
		return
	var new_audio: AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	new_audio.stream = possible_sounds[randi_range(0, possible_sounds.size() - 1)]
	new_audio.pitch_scale = randf_range(pitch_min, pitch_max)
	new_audio.volume_db = volume_db
	new_audio.finished.connect(new_audio.queue_free, CONNECT_ONE_SHOT)
	get_tree().root.add_child(new_audio)
	new_audio.global_position = global_position
	new_audio.play()
