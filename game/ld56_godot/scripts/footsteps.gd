class_name Footsteps extends Node3D

@export var footstep_sounds: Array[AudioStream] = []

@export_group("Footstep Settings")
@export var base_step_interval: float = 0.9
@export var min_velocity_threshold: float = 0.1
@export var max_velocity_multiplier: float = 2.0
@export var max_velocity_for_multiplier: float = 10.0

@export_group("Audio Settings")
@export var volume_db: float = 0.0
@export var pitch_variance: float = 0.1
@export var spatial_range: float = 10.0

var character_body: CharacterBody3D
var audio_player: AudioStreamPlayer3D
var step_timer: float = 0.0
var last_velocity: Vector3 = Vector3.ZERO
var is_moving: bool = false
var _last_footstep_stream: AudioStream

func _ready():
  character_body = get_parent() as CharacterBody3D
  
  audio_player = AudioStreamPlayer3D.new()
  add_child(audio_player)
  audio_player.volume_db = volume_db
  audio_player.max_distance = spatial_range
  audio_player.attenuation_model = AudioStreamPlayer3D.ATTENUATION_INVERSE_DISTANCE

func _physics_process(delta):
  if !character_body || footstep_sounds.is_empty():
    return
  
  var current_velocity = character_body.velocity
  var horizontal_velocity = Vector2(current_velocity.x, current_velocity.z)
  var speed = horizontal_velocity.length()
  
  # Check if character is moving
  var was_moving = is_moving
  is_moving = speed > min_velocity_threshold && character_body.is_on_floor()
  
  # Reset timer when starting to move and play a single footstep
  if is_moving && !was_moving:
    step_timer = 0.0
    play_footstep()
  
  # Update step timer and play footsteps
  if is_moving:
    step_timer += delta
    
    # Calculate dynamic step interval based on speed
    var speed_factor = clamp(speed / max_velocity_for_multiplier, 0.0, 1.0)
    var interval_multiplier = lerp(1.0, 1.0 / max_velocity_multiplier, speed_factor)
    var current_interval = base_step_interval * interval_multiplier
    
    if step_timer >= current_interval:
      play_footstep()
      step_timer = 0.0
  
  last_velocity = current_velocity

func play_footstep():
  if footstep_sounds.is_empty():
    return
  
  var footstep_stream: AudioStream = footstep_sounds.pick_random()
  while footstep_stream == _last_footstep_stream:
    footstep_stream = footstep_sounds.pick_random()
  
  if footstep_stream:
    audio_player.stream = footstep_stream
    
    # Apply pitch variation
    if pitch_variance > 0.0:
      var pitch_offset = randf_range(-pitch_variance, pitch_variance)
      audio_player.pitch_scale = 1.0 + pitch_offset
    else:
      audio_player.pitch_scale = 1.0
    
    audio_player.play()
    
    _last_footstep_stream = footstep_stream
