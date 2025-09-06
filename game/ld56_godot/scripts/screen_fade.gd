class_name ScreenFade extends ColorRect

@export var fade_speed: float = 2.0

signal fade_in_complete
signal fade_out_complete

static var instance: ScreenFade

var running: bool = false
var fade_dir: int = 1
var fade_back_in: bool = false
var display_loading_text: bool = true

func fade_in():
  fade_dir = -1
  fade_back_in = false
  running = true

func fade_out():
  fade_dir = 1
  fade_back_in = false
  running = true
  
func fade_out_in():
  fade_dir = 1
  fade_back_in = true
  running = true

func _ready() -> void:
  instance = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  if !running:
    return
  
  $LoadingLabel.visible = display_loading_text
  
  modulate.a += delta * fade_speed * fade_dir
  if (fade_dir == -1 && modulate.a <= 0.0) || (fade_dir == 1 && modulate.a >= 1.0):
    if fade_dir == -1:
      fade_out_complete.emit()
    elif fade_dir == 1:
      fade_in_complete.emit()
    
    if fade_dir == 1 && fade_back_in:
      fade_dir = -1
      fade_back_in = false
    else:
      running = false
