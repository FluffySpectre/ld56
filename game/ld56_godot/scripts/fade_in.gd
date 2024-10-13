class_name FadeIn extends ColorRect

@export var autostart: bool = false

var running: bool = false

func start():
	running = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if autostart && !running:
		running = true
	
	if !running:
		return
	
	modulate.a -= delta * 2.0
	if modulate.a <= 0.0:
		process_mode = ProcessMode.PROCESS_MODE_DISABLED
