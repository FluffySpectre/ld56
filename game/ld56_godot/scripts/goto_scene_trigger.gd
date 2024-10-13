extends Area3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_body_entered, CONNECT_ONE_SHOT)
	
func on_body_entered(body: Node3D):
	Main.instance.splash_complete()
