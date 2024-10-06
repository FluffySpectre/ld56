class_name FlyingEnemyController extends RigidBody3D

@export var target: Node3D

const SPEED = 1

func _physics_process(delta: float) -> void:
	# Calculate the direction towards the target
	var direction: Vector3 = Vector3.ZERO
	
	if target:
		direction = (target.global_position - global_position).normalized()
	
		apply_central_force(direction * SPEED)
