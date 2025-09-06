class_name StoryTriggerArea extends Area3D

@export var story_texts: Array[String] = []
@export var block_player_input: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  body_entered.connect(on_body_entered, CONNECT_ONE_SHOT)

func on_body_entered(body: Node3D):
  if !body.is_in_group("player"):
    return

  if block_player_input:
    Player.instance.can_be_controlled(false)
  
  Story.instance.play_custom(story_texts)
  Story.instance.story_stopped.connect(on_story_completed, CONNECT_ONE_SHOT)

func on_story_completed():
  if block_player_input:
    Player.instance.can_be_controlled(true)
