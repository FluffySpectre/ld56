class_name Player extends CharacterBody3D

static var instance: Player = null

var input_disabled: bool = false
var controlled_by_playthrough: bool = false

const SPEED = 8.0
const STOPPING_SPEED = 1.0
const JUMP_VELOCITY = 4.5

func _ready() -> void:
	instance = self
	
	add_to_group("player")

func can_be_controlled(enable: bool):
	input_disabled = !enable

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if !controlled_by_playthrough:
		if !input_disabled:
			if Input.is_action_just_pressed("ui_accept") and is_on_floor():
				velocity.y = JUMP_VELOCITY

			var input := Input.get_axis("MoveLeft", "MoveRight")
			var direction := (transform.basis * Vector3(0, 0, input)).normalized()
			if direction:
				velocity.z = direction.z * SPEED
			else:
				velocity.z = move_toward(velocity.z, 0, STOPPING_SPEED)
		else:
			velocity.z = move_toward(velocity.z, 0, 0.5)

	move_and_slide()
