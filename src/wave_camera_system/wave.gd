extends Area3D

signal triggered
signal wave_complete

var enemies_in_action: Array[Node3D] = []
var was_triggered: bool = false

var _wave_to_spawn: Array[SpawnEntry] = []
var _spawn_index: int = 0
var _death_count: int = 0
var _deaths_at_last_spawn: int = 0
var _wait_timer: Timer

func _ready() -> void:
	_wait_timer = Timer.new()
	_wait_timer.one_shot = true
	_wait_timer.timeout.connect(_on_wait_timer_timeout)
	add_child(_wait_timer)

func _on_body_entered(body: Node3D) -> void:
	if body is Player and !was_triggered:
		was_triggered = true
		emit_signal("triggered")
		_begin_wave()

func _begin_wave() -> void:
	# Collect SpawnEntry children in scene-tree order
	_wave_to_spawn.clear()
	for child in get_children():
		if child is SpawnEntry:
			_wave_to_spawn.append(child)

	_spawn_index = 0
	_death_count = 0
	_deaths_at_last_spawn = 0
	enemies_in_action.clear()
	_process_next_entry()

func _process_next_entry() -> void:
	if _spawn_index >= _wave_to_spawn.size():
		_check_wave_complete()
		return

	var entry: SpawnEntry = _wave_to_spawn[_spawn_index]

	match entry.trigger:
		SpawnEntry.SpawnTrigger.TIMED:
			_wait_timer.start(entry.delay)

		SpawnEntry.SpawnTrigger.ON_DEATHS:
			var target: int = _deaths_at_last_spawn + entry.deaths_required
			if _death_count >= target:
				_spawn_current_and_advance()
			# else: wait — _on_enemy_died() will re-check

func _on_wait_timer_timeout() -> void:
	_spawn_current_and_advance()

func _spawn_current_and_advance() -> void:
	if _spawn_index >= _wave_to_spawn.size():
		return

	var entry: SpawnEntry = _wave_to_spawn[_spawn_index]
	_spawn_enemy(entry)
	_deaths_at_last_spawn = _death_count
	_spawn_index += 1
	_process_next_entry()

func _spawn_enemy(entry: SpawnEntry) -> void:
	if not entry.enemy_scene:
		push_warning("SpawnEntry at index %d has no enemy_scene set." % _spawn_index)
		return

	var enemy: Node3D = entry.enemy_scene.instantiate()
	get_parent().add_child(enemy)
	# Use the SpawnEntry Node3D's own world position as the spawn point
	enemy.global_position = entry.global_position

	enemies_in_action.append(enemy)
	enemy.tree_exited.connect(_on_enemy_died.bind(enemy))

func _on_enemy_died(enemy: Node3D) -> void:
	enemies_in_action.erase(enemy)
	_death_count += 1

	if _spawn_index < _wave_to_spawn.size():
		var entry: SpawnEntry = _wave_to_spawn[_spawn_index]
		if entry.trigger == SpawnEntry.SpawnTrigger.ON_DEATHS:
			var target: int = _deaths_at_last_spawn + entry.deaths_required
			if _death_count >= target:
				_spawn_current_and_advance()

	_check_wave_complete()

func _check_wave_complete() -> void:
	if _spawn_index >= _wave_to_spawn.size() and enemies_in_action.is_empty():
		emit_signal("wave_complete")
