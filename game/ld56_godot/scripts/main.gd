extends Node3D

@export var defectParticles: GPUParticles3D
@export var lampFlicker: Flicker
@export var lampLight: Light3D
@export var endingTriggerArea: Area3D

@onready var theSphereRight: TheSphere = $TheSphere1
@onready var theSphereLeft: TheSphere = $TheSphere2

var lampLightDefaultIntensity
var end_sequence_trigger_active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !OS.has_feature("editor"):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	# setup
	theSphereRight.on_powered.connect(on_sphere_powered)
	theSphereRight.on_power_lost.connect(on_sphere_power_lost)
	theSphereLeft.on_powered.connect(on_sphere_powered)
	theSphereLeft.on_power_lost.connect(on_sphere_power_lost)
	
	defectParticles.amount = 2
	defectParticles.emitting = false
	
	lampFlicker.enable_flicker = false
	
	lampLightDefaultIntensity = lampLight.light_energy

func on_sphere_powered():
	print("Sphere powered!")
	
	if theSphereRight.is_powered && theSphereLeft.is_powered:
		# TODO: kick off the little ending sequence
		end_sequence_trigger_active = true
		
		defectParticles.amount = 8
		defectParticles.emitting = true
		
		lampFlicker.flicker_speed = 10
		
		lampLight.light_energy = 5
		
	elif theSphereRight.is_powered || theSphereLeft.is_powered:
		defectParticles.amount = 2
		defectParticles.emitting = true
		lampFlicker.enable_flicker = true
		lampFlicker.flicker_speed = 5
		lampLight.light_energy = 1.5

func on_sphere_power_lost():
	print("Sphere lost power!")
	
	if theSphereRight.is_powered || theSphereLeft.is_powered:
		defectParticles.amount = 2
		defectParticles.emitting = true
		lampFlicker.enable_flicker = true
		lampFlicker.flicker_speed = 5
		lampLight.light_energy = 1.5
	else:
		defectParticles.emitting = false
		lampFlicker.enable_flicker = false
		lampLight.light_energy = lampLightDefaultIntensity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
