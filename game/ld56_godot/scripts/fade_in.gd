class_name ScreenFade extends ColorRect

@export var fade_speed: float = 1.0

static var instance: ScreenFade

var running: bool = false
var fade_dir: int = 1

func fade_in():
	fade_dir = -1
	running = true

func fade_out():
	fade_dir = 1
	running = true

func _ready() -> void:
	instance = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !running:
		return
	
	modulate.a += delta * fade_speed * fade_dir
	if (fade_dir == -1 && modulate.a <= 0.0) || (fade_dir == 1 && modulate.a >= 1.0):
		running = false
