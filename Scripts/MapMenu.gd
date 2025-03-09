extends Control

var tween: Tween
var dragging := false
var last_mouse_pos := Vector2()
var zoom_factor := 1.0
var zoom_min := 0.5
var zoom_max := 2.0
var zoom_speed := 0.1
var zoom_duration := 0.2  # Duración de la animación en segundos
var drag_sensitivity := 0.4  # Cuanto menor, menos se moverá el panel

func _ready():
	create_tween()

func create_tween():
	if tween:
		remove_child(tween)
		tween.queue_free()
	
	tween = Tween.new()
	add_child(tween)

func _input(event):
	# Detectar clic para arrastrar el mapa
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			dragging = event.pressed
			last_mouse_pos = get_global_mouse_position()

	# Movimiento del mapa con suavidad
	if event is InputEventMouseMotion and dragging:
		var mouse_delta = get_global_mouse_position() - last_mouse_pos
		rect_position = lerp(rect_position, rect_position + mouse_delta * drag_sensitivity, 0.785)
		last_mouse_pos = get_global_mouse_position()

	# Detectar la rueda del ratón para hacer zoom
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			zoom(zoom_speed)
		elif event.button_index == BUTTON_WHEEL_DOWN:
			zoom(-zoom_speed)

# Función de zoom con límites corregidos
func zoom(amount):
	var new_zoom = clamp(zoom_factor + amount, zoom_min, zoom_max)
	
	if new_zoom != zoom_factor:
		var mouse_pos = get_local_mouse_position()
		zoom_factor = new_zoom  # Actualizamos el zoom absoluto

		create_tween()

		# Interpolamos `rect_scale` directamente al valor absoluto correcto
		tween.interpolate_property(self, "rect_scale", rect_scale, Vector2(zoom_factor, zoom_factor), zoom_duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
		
		# Ajustamos la posición para centrar el zoom en el cursor
		var scale_change = zoom_factor / rect_scale.x  # Cambio absoluto
		var new_position = rect_position + mouse_pos * (1 - scale_change)
		tween.interpolate_property(self, "rect_position", rect_position, new_position, zoom_duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
		
		tween.start()
