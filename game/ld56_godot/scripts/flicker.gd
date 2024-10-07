class_name Flicker extends Node3D

# Exportierte Variablen
@export var flicker_speed : float = 5.0   # Basis-Flicker-Geschwindigkeit
@export var min_intensity : float = 0.5   # Minimale Lichtintensität
@export var max_intensity : float = 1.5   # Maximale Lichtintensität

# Referenzen zu den Nodes
@export var spotlight : Light3D
@export var mesh_instance : MeshInstance3D

# Lokale Variablen
var time : float = 0.0
var target_intensity : float = 1.0
var current_intensity : float = 1.0
var change_timer : float = 0.0
var change_interval : float = 0.2  # Zeit zwischen Intensitätsänderungen
var rng = RandomNumberGenerator.new()

var enable_flicker = false

func _ready():
	# Initialisiere den Zufallszahlengenerator
	rng.randomize()

func _process(delta):
	if !enable_flicker:
		return
	
	# Inkrementiere die Timer
	time += delta
	change_timer += delta

	# Ändere die Zielintensität in zufälligen Intervallen
	if change_timer >= change_interval:
		change_timer = 0.0
		# Wähle eine neue Zielintensität zufällig zwischen 0 und 1
		target_intensity = rng.randf()
		# Optional: Randomisiere das Änderungsintervall für mehr Zufälligkeit
		change_interval = rng.randf_range(0.1, 0.5)
	
	# Interpoliere die aktuelle Intensität sanft zur Zielintensität
	var interpolation_speed = flicker_speed
	current_intensity = lerp(current_intensity, target_intensity, interpolation_speed * delta)

	# Anwendung der Intensität auf das Spotlight
	var light_intensity = lerp(min_intensity, max_intensity, current_intensity)
	spotlight.light_energy = light_intensity

	# Umschalten der Sichtbarkeit der MeshInstance3D basierend auf der Intensität
	if current_intensity > 0.5:
		mesh_instance.visible = true
	else:
		mesh_instance.visible = false
