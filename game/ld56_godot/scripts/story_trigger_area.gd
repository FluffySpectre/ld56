class_name StoryTriggerArea extends Area3D

@export var story_texts: Array[String] = []
@export var story: Story
@export var block_player_input: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_body_entered)

func on_body_entered(body: Node3D):
	if !body.is_in_group("player"):
		return
	
	body_entered.disconnect(on_body_entered)
	
	if block_player_input:
		Player.instance.can_be_controlled(false)
	
	story.play_custom(story_texts)
	story.story_stopped.connect(on_story_completed)

func on_story_completed():
	story.story_stopped.disconnect(on_story_completed)
	
	if block_player_input:
		Player.instance.can_be_controlled(true)
