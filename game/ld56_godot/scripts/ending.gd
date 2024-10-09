extends Area3D

@export var camera_controller: CameraController
@export var ending_camera_target: Node3D
@export var camera_target: Node3D
@export var story: Story
@export var player: Player
@export var explosion_sprite: Sprite3D
@export var blackscreen_sprite: ColorRect

enum EndingState {
	NOT_STARTED,
	BEFORE_EXPLOSION,
	EXPLOSION,
	FIREFLIES_FLY_TO_LAMP,
	FIREFLIES_FLY_TO_SCREEN,
	ENDING_TEXTS,
	COMPLETE
}
var current_state: EndingState = EndingState.NOT_STARTED
var state_changed: bool = false
var state_timer: float = 0.0

var explosion_timer: float = 0.0

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
		
		explosion_timer += delta * 0.5
		explosion_sprite.scale = lerp(Vector3.ZERO, Vector3(500.0, 500.0, 500.0), explosion_timer)
		
		if explosion_timer > 1.0:
			explosion_sprite.visible = false
			blackscreen_sprite.visible = true
			
			current_state = EndingState.FIREFLIES_FLY_TO_LAMP
			state_changed = true

	elif current_state == EndingState.FIREFLIES_FLY_TO_LAMP:
		if state_changed:
			state_timer = 0.0
			state_changed = false
			
		# TODO: IMPLEMENT ME
		
		current_state = EndingState.FIREFLIES_FLY_TO_SCREEN
		state_changed = true

	elif current_state == EndingState.FIREFLIES_FLY_TO_SCREEN:
		if state_changed:
			state_timer = 0.0
			state_changed = false
		
		# TODO: IMPLEMENT ME
		
		current_state = EndingState.ENDING_TEXTS
		state_changed = true

	elif current_state == EndingState.ENDING_TEXTS:
		if state_changed:
			state_timer = 0.0
			state_changed = false

		if state_timer > 2.0:
			story.play_ending()
			
			current_state = EndingState.COMPLETE
			state_changed = true
