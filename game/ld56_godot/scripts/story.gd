class_name Story extends Label

@export var text_duration: float = 2.0

static var instance: Story

var is_playing: bool = false
var texts_to_display: Array[String] = []
var text_timer: float = 0.0
var current_text_index: int = 0

signal story_stopped

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self
	text = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_playing:
		return
	
	text_timer += delta
	if text_timer > text_duration:
		current_text_index += 1
		if current_text_index >= texts_to_display.size():
			stop_story()
			return
		
		text_timer = 0.0
		text = texts_to_display[current_text_index]

func play_custom(story_texts: Array[String]):
	if is_playing:
		stop_story()
		
	texts_to_display = story_texts
	text = texts_to_display[0]
	text_timer = 0.0
	current_text_index = 0
	is_playing = true

func stop_story():
	text = ""
	texts_to_display = []
	text_timer = 0.0
	current_text_index = 0
	is_playing = false
	story_stopped.emit()
	print("Story stopped")
