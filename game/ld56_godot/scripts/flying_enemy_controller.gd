class_name FlyingEnemyController extends RigidBody3D

@export var target: Node3D

const SPEED = 1
const JITTER_INTENSITY = 8.0

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
