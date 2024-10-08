extends Area3D

@export var camera_controller: CameraController
@export var ending_camera_target: Node3D
@export var camera_target: Node3D
@export var story: Story
@export var player: Player
@export var explosion_sprite: Sprite3D
@export var blackscreen_sprite: ColorRect

var is_play_ending = false
var explosion_timer = 0.0
var wait_timer = 0.0
var timeout_before_explosion = 3.0
var time_after_explosion_timer = 0.0
var ending_story_played = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_body_entered)
	story.ending_stopped.connect(on_ending_stopped)
	
	blackscreen_sprite.visible = false

func on_body_entered(body: Node3D):
	if !body.is_in_group("player") || is_play_ending:
		return

	play_ending()

func on_ending_stopped():
	get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_play_ending:
		return
	
	# OMG, no words
	var target_pos = ending_camera_target.global_transform.origin
	camera_target.global_position = camera_target.global_position.lerp(target_pos, 2.0 * delta)

	wait_timer += delta
	if wait_timer < timeout_before_explosion:
		return

	# play explosion
	if explosion_timer > 1.0:
		explosion_sprite.visible = false
		blackscreen_sprite.visible = true
		
		time_after_explosion_timer += delta
		if time_after_explosion_timer > 2.0:
			if !ending_story_played:
				ending_story_played = true
				story.play_ending()
	else:
		explosion_sprite.visible = true
		explosion_timer += delta * 0.5
		explosion_sprite.scale = lerp(Vector3.ZERO, Vector3(500.0, 500.0, 500.0), explosion_timer)

func play_ending():
	is_play_ending = true
	player.input_disabled = true
	player.stop_movement()
