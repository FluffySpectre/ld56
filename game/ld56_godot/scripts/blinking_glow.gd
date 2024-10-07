extends Node3D

@export var pulse_speed: float = 1.0
@export var min_alpha: float = 0.2
@export var max_alpha: float = 1.0

@onready var mesh_material: StandardMaterial3D = $GlowSphere.material_override

var pulse_timer: float = randf() * 10.0

func _process(delta: float) -> void:
	pulse_timer += delta * pulse_speed
	
	var pulse_value = (sin(pulse_timer) + 1.0) / 2.0
	var alpha = lerp(min_alpha, max_alpha, pulse_value)

	var new_material = mesh_material.duplicate()
	new_material.albedo_color.a = alpha
	$GlowSphere.material_override = new_material
