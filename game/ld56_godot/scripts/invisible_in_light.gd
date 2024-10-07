class_name InvisibleInLight extends Node3D

@export var light_trigger_area: Area3D

func _ready() -> void:
	light_trigger_area.area_entered.connect(on_area_entered)
	light_trigger_area.area_exited.connect(on_area_exited)

func on_area_entered(area: Area3D) -> void:
	visible = false

func on_area_exited(area: Area3D) -> void:
	visible = true