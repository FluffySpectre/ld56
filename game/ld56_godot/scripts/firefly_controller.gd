class_name FireflyController extends RigidBody3D

@export var target: Node3D
@export var light_sense_radius: float = 10.0

@onready var light_detector_area: Area3D = $LightDetectorArea

const SPEED = 1
const JITTER_INTENSITY = 8.0

var initial_target: Node3D
var is_attracted_to_player_light: bool = false
var new_parent: Node

func _ready() -> void:
	initial_target = target
	new_parent = get_parent()
	
	light_detector_area.area_entered.connect(on_light_area_entered)
	light_detector_area.area_exited.connect(on_light_area_exited)
	
	add_to_group("fireflies")

func on_light_area_entered(area: Area3D) -> void:
	if area.is_in_group("player_light"):
		is_attracted_to_player_light = true
		target = area.get_parent().get_node("FlockTarget")
		new_parent = area.get_parent()
	
	elif !is_attracted_to_player_light && area.is_in_group("light"):
		target = area.get_parent().get_node("FlockTarget")
		new_parent = area.get_parent()

func on_light_area_exited(area: Area3D) -> void:
	if area.is_in_group("player_light"):
		is_attracted_to_player_light = false
		target = initial_target
		new_parent = get_tree().root
	
	elif area.is_in_group("light") && !is_attracted_to_player_light:
		target = initial_target
		new_parent = get_tree().root

func _process(_delta: float) -> void:
	# do reparenting in normal process
	# godot doesnt like those kind of operations in physics process functions
	if new_parent != get_parent():
		reparent(new_parent)
		new_parent = get_parent()

func _physics_process(delta: float) -> void:
	var direction: Vector3 = Vector3.ZERO

	if target:
		direction = (target.global_position - global_position).normalized()

		var jitter = Vector3(
			0.0,
			randf_range(-JITTER_INTENSITY, JITTER_INTENSITY),
			randf_range(-JITTER_INTENSITY, JITTER_INTENSITY)
		)
		direction += jitter

		apply_central_force(direction * SPEED)
	
		# Keep the firefly upright
		global_rotation_degrees = Vector3(0, 0, 0)
