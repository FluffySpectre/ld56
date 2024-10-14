class_name Spawner extends Area3D

@export var spawn_list: Array[PackedScene]
@export var autostart: bool = false
@export var spawn_delay: float = 0.25
@export var max_spawned_objects: int = 50
@export var spawn_container: Node
@export var one_shot_spawn: bool = false

var spawn_timer = spawn_delay
var do_spawn = false
var rng = RandomNumberGenerator.new()
var spawned_objects: int = 0

@onready var spawn_area = $CollisionShape3D.shape

func is_spawning() -> bool:
	return do_spawn and spawned_objects < max_spawned_objects

func _ready():
	if autostart:
		start_spawn()

func _process(delta):	
	if not do_spawn or spawned_objects >= max_spawned_objects or one_shot_spawn:
		return
	
	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn()
		spawn_timer = spawn_delay

func start_spawn():
	do_spawn = true
	spawn_timer = spawn_delay
	spawned_objects = 0
	
	if one_shot_spawn:
		do_one_shot_spawn()
	
	print("Start spawning")
	
func spawn():
	# select a random scene from the spawn list
	var to_spawn = spawn_list[randi() % spawn_list.size()]
	
	var instance: Node3D = to_spawn.instantiate()
	spawn_container.add_child(instance)
	
	instance.global_position = get_random_point_in_spawnarea()
	instance.global_rotation = global_rotation
	if randi_range(0, 1) == 0:
		instance.scale.z *= -1 

	spawned_objects += 1

func do_one_shot_spawn():
	for i in max_spawned_objects:
		spawn()

func get_random_point_in_spawnarea():
	var x = global_position.x + rng.randf_range(-spawn_area.size.x / 2, spawn_area.size.x / 2)
	var y = global_position.y + rng.randf_range(-spawn_area.size.y / 2, spawn_area.size.y / 2)
	var z = global_position.z + rng.randf_range(-spawn_area.size.z / 2, spawn_area.size.z / 2)
	return Vector3(x, y, z)
