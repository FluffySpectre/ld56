class_name TheSphere extends Area3D

@export var fireflies_to_activate: int = 5
@export var cable_mesh: MeshInstance3D

signal on_powered
signal on_power_lost

@onready var light_glow_sprite: Sprite3D = $Sprite3D

var num_fireflies: int = 0
var is_powered: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", on_body_entered)
	connect("body_exited", on_body_exited)

func on_body_entered(body: Node3D):
	if !body.is_in_group("fireflies"):
		return
	num_fireflies += 1
	
	# HACK: reduce jitter to keep the firefly from leaving the light area
	body.jitter_intensity = 4.0
	
	#print("New firefly! Count: " + str(num_fireflies))

func on_body_exited(body: Node3D):
	if !body.is_in_group("fireflies"):
		return
	
	# HACK: reset the jitter again
	body.jitter_intensity = 8.0
	
	num_fireflies -= 1
	if (num_fireflies < 0):
		num_fireflies = 0
	
	#dprint("Firefly gone! Count: " + str(num_fireflies))

func update_light_state():
	var activation_perc = float(num_fireflies) / fireflies_to_activate
	if activation_perc > 1.0:
		activation_perc = 1.0
	light_glow_sprite.modulate.a = lerpf(0.2, 0.8, float(num_fireflies) / fireflies_to_activate)
	
	if activation_perc > 0.99 && !is_powered:
		cable_mesh.visible = true
		is_powered = true
		on_powered.emit()
	elif activation_perc < 0.99 && is_powered:
		cable_mesh.visible = false
		is_powered = false
		on_power_lost.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_light_state()
