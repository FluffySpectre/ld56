class_name FlashLight extends Node3D

@export var camera: Camera3D
@export var debugSphere: Node3D
@export var toggle_sfx: AudioStream

const RAY_LENGTH = 1000

@export var push_force: float = 10.0
@onready var area: Area3D = $EnemyRepeller

var bodies_in_light_cone: Array
var flashlight_on = false

func _ready() -> void:
	area.body_entered.connect(on_body_entered)
	area.body_exited.connect(on_body_exited)
	
	area.get_child(0).disabled = !area.get_child(0).disabled
	$cone2.visible = !$cone2.visible
	$SpotLight3D.visible = !$SpotLight3D.visible

func on_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		bodies_in_light_cone.append(body)

func on_body_exited(body: Node3D) -> void:
	if body is RigidBody3D:
		var body_index = bodies_in_light_cone.find(body)
		if body_index > -1:
			bodies_in_light_cone.remove_at(body_index)

func toggle_flashlight(toggle: bool):
	area.get_child(0).disabled = !toggle
	$cone2.visible = toggle
	$SpotLight3D.visible = toggle
	flashlight_on = toggle

func check_activation():
	if Input.is_action_just_pressed("ToggleLight"):
		toggle_flashlight(!flashlight_on)
		AudioManagerInstance.stream = toggle_sfx
		AudioManagerInstance.play()

func rotate_flashlight():
	var space_state = get_world_3d().direct_space_state
	var cam = camera
	var mousepos = get_viewport().get_mouse_position()

	var origin = cam.project_ray_origin(mousepos)
	var end = origin + cam.project_ray_normal(mousepos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	query.collision_mask = 0b0010

	var result = space_state.intersect_ray(query)
	if result:
		if (debugSphere):
			debugSphere.global_transform.origin = result.position
		
		var direction = result.position - global_transform.origin
		direction *= -1
		global_transform.basis = Basis.looking_at(direction, Vector3.LEFT)

func repell_bodies():
	var push_direction = global_transform.basis.z.normalized()
	for b in bodies_in_light_cone:
		b.apply_central_force(push_direction * push_force)

func _physics_process(_delta):
	check_activation()
	rotate_flashlight()
	#repell_bodies()
