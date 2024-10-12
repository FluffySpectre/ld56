extends Node3D

@export var pulse_speed: float = 1.0
@export var min_alpha: float = 0.2
@export var max_alpha: float = 1.0
@export var random_pulse_start: bool = true

@onready var mesh_material: StandardMaterial3D = $GlowSphere.material_override

var pulse_timer: float = 0.0
var mesh_material_copy: StandardMaterial3D

func _ready() -> void:
	mesh_material_copy = mesh_material.duplicate()
	$GlowSphere.material_override = mesh_material_copy
	
	if random_pulse_start:
		pulse_timer = randf() * 10.0

func _process(delta: float) -> void:
	pulse_timer += delta * pulse_speed
	
	var pulse_value = (sin(pulse_timer) + 1.0) / 2.0
	var alpha = lerp(min_alpha, max_alpha, pulse_value)

	mesh_material_copy.albedo_color.a = alpha
