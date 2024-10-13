class_name Main extends Node3D

@export var initial_stutter_playthrough: InitialStutterPlaythrough
@export var defectParticles: GPUParticles3D
@export var lampFlicker: Flicker
@export var lampLight: Light3D
@export var intro_trigger_area: Area3D
@export var lamp_hint_trigger_area: Area3D
@export var endingTriggerArea: Ending
@export var lamp_ultrashine: Sprite3D

@onready var theSphereRight: TheSphere = $TheSphere1
@onready var theSphereLeft: TheSphere = $TheSphere2

static var instance: Main

var lampLightDefaultIntensity
var end_sequence_trigger_active = false
var runs_in_webbrowser = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self
	
	if !OS.has_feature("editor"):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	runs_in_webbrowser = OS.has_feature("web")
	
	# setup
	theSphereRight.on_powered.connect(on_sphere_powered)
	theSphereRight.on_power_lost.connect(on_sphere_power_lost)
	theSphereLeft.on_powered.connect(on_sphere_powered)
	theSphereLeft.on_power_lost.connect(on_sphere_power_lost)
	
	toggle_ending_trigger(false)
	toggle_intro_trigger(false)
	toggle_lamp_hint_trigger(false)
	
	initial_stutter_playthrough.playthrough_complete.connect(on_playthrough_complete)
	initial_stutter_playthrough.start()
	
	#fade_in.start()

func on_playthrough_complete():
	finish_init()
	ScreenFade.instance.fade_in()

func splash_complete():
	toggle_intro_trigger(true)
	toggle_lamp_hint_trigger(true)
	
	# reset all fireflies
	var fireflies = get_tree().get_nodes_in_group("fireflies")
	for f in fireflies:
		f.reset_to_initial_position()
	
	var main_cam: Camera3D = $Camera3D
	main_cam.current = true
	
	$Splash.queue_free()
	
	ScreenFade.instance.fade_in()

func finish_init():
	defectParticles.amount = 2
	defectParticles.emitting = false
	
	lampFlicker.enable_flicker = false
	lampFlicker.sprite_tex = null
	
	lampLightDefaultIntensity = lampLight.light_energy
	lamp_ultrashine.visible = false
	
	var main_cam: Camera3D = $Camera3D
	main_cam.current = false
	
	$Splash.process_mode = Node.PROCESS_MODE_INHERIT
	$Splash.visible = true
	var splash_cam: Camera3D = $Splash/Camera3D
	splash_cam.current = true

func toggle_lamp_hint_trigger(state: bool):
	if state:
		lamp_hint_trigger_area.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		lamp_hint_trigger_area.process_mode = Node.PROCESS_MODE_DISABLED

func toggle_intro_trigger(state: bool):
	if state:
		intro_trigger_area.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		intro_trigger_area.process_mode = Node.PROCESS_MODE_DISABLED

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
	if !runs_in_webbrowser && Input.is_action_just_pressed("Escape"):
		get_tree().quit()
