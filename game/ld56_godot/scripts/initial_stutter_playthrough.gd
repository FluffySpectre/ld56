class_name InitialStutterPlaythrough extends Node3D

@export var player_speed: float = 60.0
@export var player_spawn: Node3D

signal playthrough_complete

var running: bool = false
var countdown_timer: float = 3.0
var firefly_collisions_disabled: bool = false

func start():
	running = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !running:
		return
	
	countdown_timer -= delta
	
	if !firefly_collisions_disabled:
		firefly_collisions_disabled = true
		var fireflies = get_tree().get_nodes_in_group("fireflies")
		for f in fireflies:
			f.ignore_area_collisions = true
	
	Player.instance.can_be_controlled(false)
	Player.instance.controlled_by_playthrough = true
	
	var flash_light: FlashLight = Player.instance.get_node("FlashLight")
	flash_light.toggle_flashlight(true)
	flash_light.global_rotation_degrees = Vector3(225.0, 0, 0)
	#flash_light.process_mode = Node.PROCESS_MODE_DISABLED

func _physics_process(delta: float) -> void:
	if !running:
		return
	
	if countdown_timer < 0:
		Player.instance.global_position = player_spawn.global_position
		#Player.instance.get_node("FlashLight").process_mode = Node.PROCESS_MODE_INHERIT
		Player.instance.get_node("FlashLight").toggle_flashlight(false)
		Player.instance.velocity.z = 0.0
		Player.instance.controlled_by_playthrough = false
		Player.instance.can_be_controlled(true)
		
		# reset all fireflies
		var fireflies = get_tree().get_nodes_in_group("fireflies")
		for f in fireflies:
			f.ignore_area_collisions = false
			f.reset_to_initial_position()
		
		playthrough_complete.emit()
		process_mode = ProcessMode.PROCESS_MODE_DISABLED
		return
	
	var direction := (transform.basis * Vector3(0, 0, -1)).normalized()
	if direction:
		Player.instance.velocity.z = direction.z * player_speed
	else:
		Player.instance.velocity.z = move_toward(Player.instance.velocity.z, 0, 10.0)
