class_name Ending extends Area3D

@export var camera_controller: CameraController
@export var ending_camera_target: Node3D
@export var camera_target: Node3D
@export var story: Story
@export var player: Player
@export var explosion_sprite: Sprite3D
@export var blackscreen_sprite: ColorRect
@export var lamp_target: Node3D
@export var screen_target: Node3D
@export var lamp: Node3D
@export var flashlight: FlashLight

enum EndingState {
	NOT_STARTED,
	BEFORE_EXPLOSION,
	EXPLOSION,
	TELEPORT_FIREFLIES,
	FIREFLIES_FLY_TO_LAMP,
	FIREFLIES_FLY_TO_SCREEN,
	ENDING_TEXTS,
	COMPLETE
}
var current_state: EndingState = EndingState.NOT_STARTED
var state_changed: bool = false
var state_timer: float = 0.0

var explosion_timer: float = 0.0
var explosion_complete: bool = false

func has_started():
	return current_state != EndingState.NOT_STARTED

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_body_entered)
	story.ending_stopped.connect(on_ending_stopped)
	
	blackscreen_sprite.visible = false

func on_body_entered(body: Node3D):
	if !body.is_in_group("player") || current_state != EndingState.NOT_STARTED:
		return

	play_ending()

func on_ending_stopped():
	get_tree().quit()

func play_ending():
	current_state = EndingState.BEFORE_EXPLOSION
	player.input_disabled = true
	player.stop_movement()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# NOT STARTED
	if current_state == EndingState.NOT_STARTED:
		return
	
	state_timer += delta
	
	# BEFORE EXPLOSION
	if current_state == EndingState.BEFORE_EXPLOSION:
		if state_changed:
			state_timer = 0.0
			state_changed = false
		
		# OMG, no words
		var target_pos = ending_camera_target.global_transform.origin
		camera_target.global_position = camera_target.global_position.lerp(target_pos, 2.0 * delta)
		
		if state_timer > 3.0:
			current_state = EndingState.EXPLOSION
			state_changed = true
	
	# EXPLOSION
	elif current_state == EndingState.EXPLOSION:
		if state_changed:
			state_timer = 0.0
			state_changed = false
			
			explosion_timer = 0.0
			explosion_sprite.visible = true
			explosion_complete = false
		
		explosion_timer += delta * 0.5
		
		if !explosion_complete:
			explosion_sprite.scale = lerp(Vector3.ZERO, Vector3(500.0, 500.0, 500.0), explosion_timer)
		else:
			explosion_sprite.modulate.a = lerp(1.0, 0.0, explosion_timer)
		
		if explosion_complete && explosion_timer > 1.0:
			explosion_sprite.visible = false
			
			current_state = EndingState.TELEPORT_FIREFLIES
			state_changed = true
		
		if !explosion_complete && explosion_timer > 1.0:
			explosion_complete = true
			explosion_timer = 0.0
			
			# disable all lights
			var lights = get_tree().get_nodes_in_group("light")
			for l in lights:
				l.get_child(0).disabled = true
			
			lamp.visible = false
			
			flashlight.toggle_flashlight(false)

	elif current_state == EndingState.TELEPORT_FIREFLIES:
		if state_changed:
			state_timer = 0.0
			state_changed = false
			
			# first, get all fireflies in the scene
			var fireflies = get_tree().get_nodes_in_group("fireflies")
			
			# now check for each firefly, if it is left or right outside the screen
			for f in fireflies:
				if f.global_position.z > 15.0:
					# firefly is far off on the right of the screen
					f.global_position.z = 15.0
					
				elif f.global_position.z < -15.0:
					# firefly is far off on the left of the screen
					f.global_position.z = -15.0
			
			current_state = EndingState.FIREFLIES_FLY_TO_LAMP
			state_changed = true
					
	elif current_state == EndingState.FIREFLIES_FLY_TO_LAMP:
		if state_changed:
			state_timer = 0.0
			state_changed = false
				
			# tell fireflies to fly towards the destroyed lamp
			var fireflies = get_tree().get_nodes_in_group("fireflies")
			for f in fireflies:
				f.target = lamp_target
		
		if state_timer > 6.0:
			current_state = EndingState.FIREFLIES_FLY_TO_SCREEN
			state_changed = true

	elif current_state == EndingState.FIREFLIES_FLY_TO_SCREEN:
		if state_changed:
			state_timer = 0.0
			state_changed = false
			
			# tell fireflies to fly towards the screen
			var fireflies = get_tree().get_nodes_in_group("fireflies")
			for f in fireflies:
				f.target = screen_target
				f.axis_lock_linear_x = false
		
		if state_timer > 8.0:
			current_state = EndingState.ENDING_TEXTS
			state_changed = true

	elif current_state == EndingState.ENDING_TEXTS:
		if state_changed:
			state_timer = 0.0
			state_changed = false
			
			blackscreen_sprite.visible = true

		if state_timer > 2.0:
			story.play_ending()
			
			current_state = EndingState.COMPLETE
			state_changed = true
