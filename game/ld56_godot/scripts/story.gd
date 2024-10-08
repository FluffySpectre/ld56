class_name Story extends Label

@export var text_duration: float = 2.0
@export var intro_texts: Array[String] = []
@export var ending_texts: Array[String] = []
	
var is_playing: bool = false
var texts_to_display
var text_timer: float = 0.0
var current_text_index: int = 0
var is_playing_ending = false

signal ending_stopped

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_playing:
		return
	
	text_timer += delta
	if text_timer > text_duration:
		current_text_index += 1
		if current_text_index >= texts_to_display.size():
			if is_playing_ending:
				ending_stopped.emit()
			stop_story()
			return
		
		text_timer = 0.0
		text = texts_to_display[current_text_index]

func play_intro():
	texts_to_display = intro_texts
	text = texts_to_display[0]
	text_timer = 0.0
	current_text_index = 0
	is_playing = true
	is_playing_ending = false

func play_ending():
	texts_to_display = ending_texts
	text = texts_to_display[0]
	text_timer = 0.0
	current_text_index = 0
	is_playing = true
	is_playing_ending = true

func stop_story():
	text = ""
	texts_to_display = []
	text_timer = 0.0
	current_text_index = 0
	is_playing = false
	is_playing_ending = false
	print("Stop story")
