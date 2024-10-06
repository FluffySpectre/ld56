class_name CameraController extends Camera3D

@export var target : Node
@export var lerp_speed = 3.0
@export var offset = Vector3.ZERO

func reset_view():
	var target_pos = target.global_transform.translated_local(offset)
	global_position = target_pos.origin

func _physics_process(delta):
	if !target:
		return
	var target_pos = target.global_transform.translated_local(offset)
	global_transform = target_pos
	look_at(target.global_position, Vector3.UP)
