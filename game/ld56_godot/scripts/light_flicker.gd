extends Light3D

@export var pulse_speed: float = 5.0
@export var min: float = 2.0
@export var max: float = 13.5

var pulse_timer: float = 0.0

func _process(delta: float) -> void:
	pulse_timer += delta * pulse_speed
	
	var pulse_value = (sin(pulse_timer) + 1.0) / 2.0
	var val = lerp(min, max, pulse_value)

	light_energy = val 
