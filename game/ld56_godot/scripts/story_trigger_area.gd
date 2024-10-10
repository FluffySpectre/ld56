class_name StoryTriggerArea extends Area3D

@export var story_texts: Array[String] = []
@export var story: Story

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_body_entered)

func on_body_entered(body: Node3D):
	if !body.is_in_group("player"):
		return
	
	story.play_custom(story_texts)

	body_entered.disconnect(on_body_entered)
