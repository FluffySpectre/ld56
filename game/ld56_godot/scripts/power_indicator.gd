extends Node3D

@onready var theSphere: TheSphere = get_parent()

func update_power_status():
	for i in range(0, 8):
		var s = get_child(i) as Sprite3D
		if i < theSphere.num_fireflies:
			s.modulate = Color(1, 1, 1, 1)
		else:
			s.modulate = Color(0.3, 0.3, 0.3, 1)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_power_status()
