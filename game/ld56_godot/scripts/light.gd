extends Area3D

@export var is_player_flashlight: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_player_flashlight:
		add_to_group("player_light")
	else:
		add_to_group("light")
