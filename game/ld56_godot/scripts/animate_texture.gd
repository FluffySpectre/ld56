class_name AnimateTexture extends Node

@export var frames: Array[Texture2D] = []
@export var fps: float = 10.0

var _mesh_instance: MeshInstance3D
var _frame_counter: int = 0
var _frame_time_counter: float = 0.0
var _material: StandardMaterial3D

func _ready() -> void:
  _mesh_instance = get_parent() as MeshInstance3D
  _material = _mesh_instance.get_active_material(0) as StandardMaterial3D

func _process(delta: float) -> void:
  if frames.is_empty():
    return
  
  _frame_time_counter += delta
  
  var time_per_frame: float = 1.0 / fps
  
  if _frame_time_counter >= time_per_frame:
    _frame_time_counter = 0.0
    _frame_counter = (_frame_counter + 1) % frames.size()
  
  _material.albedo_texture = frames[_frame_counter]
