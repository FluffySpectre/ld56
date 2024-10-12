extends ColorRect

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	modulate.a -= delta * 2.0
	if modulate.a <= 0.0:
		process_mode = ProcessMode.PROCESS_MODE_DISABLED
