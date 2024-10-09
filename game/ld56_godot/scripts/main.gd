extends Node3D

@export var defectParticles: GPUParticles3D
@export var lampFlicker: Flicker
@export var lampLight: Light3D
@export var endingTriggerArea: Ending
@export var story: Story
@export var lamp_ultrashine: Sprite3D

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
	lampFlicker.sprite_tex = null
	
	lampLightDefaultIntensity = lampLight.light_energy
	lamp_ultrashine.visible = false
	
	toggle_ending_trigger(false)
	
	# kickoff the intro
	story.play_intro()

func toggle_ending_trigger(state: bool):
	if state == false && endingTriggerArea.has_started():
		return
	
	end_sequence_trigger_active = state
	if state:
		endingTriggerArea.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		endingTriggerArea.process_mode = Node.PROCESS_MODE_DISABLED

func on_sphere_powered():
	print("Sphere powered!")
	
	if theSphereRight.is_powered && theSphereLeft.is_powered:
		# kick off the little ending sequence
		toggle_ending_trigger(true)
		
		defectParticles.amount = 15
		defectParticles.emitting = true
		
		lampFlicker.flicker_speed = 10
		lampFlicker.sprite_tex = lamp_ultrashine
		lamp_ultrashine.visible = true
		
		lampLight.light_energy = 5
		
	elif theSphereRight.is_powered || theSphereLeft.is_powered:
		toggle_ending_trigger(false)
		defectParticles.amount = 5
		defectParticles.emitting = true
		lampFlicker.enable_flicker = true
		lampFlicker.flicker_speed = 5
		lampFlicker.sprite_tex = lamp_ultrashine
		lampLight.light_energy = 1.5
		lamp_ultrashine.visible = true

func on_sphere_power_lost():
	print("Sphere lost power!")
	
	if theSphereRight.is_powered || theSphereLeft.is_powered:
		toggle_ending_trigger(false)
		defectParticles.amount = 5
		defectParticles.emitting = true
		lampFlicker.enable_flicker = true
		lampFlicker.flicker_speed = 5
		lampFlicker.sprite_tex = lamp_ultrashine
		lampLight.light_energy = 1.5
		lamp_ultrashine.visible = true
	else:
		toggle_ending_trigger(false)
		defectParticles.emitting = false
		lampFlicker.enable_flicker = false
		lampFlicker.sprite_tex = null
		lampLight.light_energy = lampLightDefaultIntensity
		lamp_ultrashine.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
