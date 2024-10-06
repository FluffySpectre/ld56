class_name FlashLight extends Node3D

@export var camera: Camera3D
@export var debugSphere: Node3D

const RAY_LENGTH = 1000

func _physics_process(_delta):
    var space_state = get_world_3d().direct_space_state
    var cam = camera
    var mousepos = get_viewport().get_mouse_position()

    var origin = cam.project_ray_origin(mousepos)
    var end = origin + cam.project_ray_normal(mousepos) * RAY_LENGTH
    var query = PhysicsRayQueryParameters3D.create(origin, end)
    query.collide_with_areas = true

    var result = space_state.intersect_ray(query)
    if result:
        if (debugSphere):
            debugSphere.global_transform.origin = result.position

        # Let flashlight point into the direction of the hit point
        var direction = result.position - global_transform.origin
        direction *= -1
        global_transform.basis = Basis.looking_at(direction, Vector3.LEFT)
