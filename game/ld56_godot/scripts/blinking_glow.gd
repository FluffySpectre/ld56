extends Node3D

@export var pulse_speed: float = 1.0
@export var min_alpha: float = 0.2
@export var max_alpha: float = 1.0

@onready var mesh_material: StandardMaterial3D = $GlowSphere.material_override

var pulse_timer: float = randf() * 10.0
var mesh_material_copy: StandardMaterial3D

func _ready() -> void:
	mesh_material_copy = mesh_material.duplicate()
	$GlowSphere.material_override = mesh_material_copy

func _process(delta: float) -> void:
	pulse_timer += delta * pulse_speed
	
	var pulse_value = (sin(pulse_timer) + 1.0) / 2.0
	var alpha = lerp(min_alpha, max_alpha, pulse_value)

	mesh_material_copy.albedo_color.a = alpha
