extends Area2D

onready var camera = $"../Player/PlayerCamera"
onready var tween = $Tween

var zoom_in_size = Vector2(0.4, 0.4)

# Offset deseado cuando el jugador está en el área
var offset_in = Vector2(0, -50)

# Tamaño de zoom original (se inicializa al ready)
var original_zoom = Vector2(1, 1)

# Offset original (se inicializa al ready)
var original_offset = Vector2(0, 30)

func _ready():
	# Guardar el zoom y offset originales de la cámara
	if camera:
		original_zoom = camera.zoom
		original_offset = camera.offset
	
	# Conectar la señal del Tween para corregir valores finales si es necesario
	if tween:
		tween.connect("tween_completed", self, "_on_tween_completed")

func _on_Area2D3_body_entered(body):
	if body.is_in_group("Player") and camera:
		tween.stop_all()  # Detener cualquier tween previo
		tween.interpolate_property(camera, "zoom", camera.zoom, zoom_in_size, 1.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.interpolate_property(camera, "offset", camera.offset, offset_in, 1.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.start()

func _on_Area2D3_body_exited(body):
	if body.is_in_group("Player") and camera:
		tween.stop_all()  # Detener cualquier tween previo
		tween.interpolate_property(camera, "zoom", camera.zoom, original_zoom, 1.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.interpolate_property(camera, "offset", camera.offset, original_offset, 1.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		tween.start()

# Señal llamada cuando termina cualquier propiedad interpolada por el Tween
func _on_tween_completed(object, key):
	if object == camera and key == "offset":
		# Verificamos si el offset cambió inesperadamente y lo corregimos
		if camera.zoom == zoom_in_size:
			call_deferred("_set_correct_offset", offset_in)
		elif camera.zoom == original_zoom:
			call_deferred("_set_correct_offset", original_offset)

# Función para aplicar el offset de forma segura
func _set_correct_offset(target_offset):
	camera.offset = target_offset
	print("Offset corregido a:", target_offset)

# Debug opcional para verificar los valores actuales de zoom y offset
func _process(delta):
	if camera:
		# Forzar el offset correcto dependiendo del zoom
		if camera.zoom == zoom_in_size:
			camera.offset = offset_in
		elif camera.zoom == original_zoom:
			camera.offset = original_offset
