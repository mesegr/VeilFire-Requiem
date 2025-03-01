extends Control

# Diccionario para almacenar la escala objetivo de cada botón
# Variables para controlar la transición
var target_scales = {}
var lerp_speed = 15.0  # Velocidad de la interpolación (ajusta según necesites)
var tween = Tween.new()  # Crea un nodo Tween
var fade_speed = 0.2  # Diccionario para almacenar el valor objetivo de modulate

func _ready():
	# Añade el Tween como hijo del nodo actual
	add_child(tween)

	# Asegúrate de que los paneles estén en el estado correcto al inicio
	$ControlsPanel.visible = false  # Invisible al inicio
	$ControlsPanel.modulate = Color(1, 1, 1, 0)  # Completamente transparente
	$ButtonsContainer.visible = true  # Visible al inicio
	$ButtonsContainer.modulate = Color(1, 1, 1, 1)  # Completamente visible


func _process(delta):
	# Botones dentro del contenedor
	for button in $ButtonsContainer.get_children():
		if button.name in target_scales:
			button.rect_scale = lerp(
				button.rect_scale,
				target_scales[button.name],
				lerp_speed * delta
			)
	# Botón adicional fuera del contenedor
	if "ButtonBackControls" in target_scales:
		$ControlsPanel/ButtonBackControls.rect_scale = lerp(
			$ControlsPanel/ButtonBackControls.rect_scale,
			target_scales["ButtonBackControls"],
			lerp_speed * delta
		)
	


# Funciones para manejar el hover de los botones
func _on_ButtonStartGame_mouse_entered():
	target_scales["ButtonStartGame"] = Vector2(1.1, 1.05)
	$buttonHovered.play()

func _on_ButtonStartGame_mouse_exited():
	target_scales["ButtonStartGame"] = Vector2(1, 1)

func _on_ButtonLoadGame_mouse_entered():
	target_scales["ButtonLoadGame"] = Vector2(1.1, 1.05)
	$buttonHovered.play()

func _on_ButtonLoadGame_mouse_exited():
	target_scales["ButtonLoadGame"] = Vector2(1, 1)

func _on_ButtonControls_mouse_entered():
	target_scales["ButtonControls"] = Vector2(1.1, 1.05)
	$buttonHovered.play()

func _on_ButtonControls_mouse_exited():
	target_scales["ButtonControls"] = Vector2(1, 1)

func _on_ButtonQuitGame_mouse_entered():
	target_scales["ButtonQuitGame"] = Vector2(1.1, 1.05)
	$buttonHovered.play()

func _on_ButtonQuitGame_mouse_exited():
	target_scales["ButtonQuitGame"] = Vector2(1, 1)

func _on_ButtonBackControls_mouse_entered():
	$buttonHovered.play()
	target_scales["ButtonBackControls"] = Vector2(0.35, 0.37)

func _on_ButtonBackControls_mouse_exited():
	target_scales["ButtonBackControls"] = Vector2(0.32, 0.32)

# Función para mostrar el panel de controles y ocultar los botones
func _on_ButtonControls_button_down():
	$buttonPressed.play()
	$ControlsPanel.visible = true  # Activa el panel para que pueda ser interpolado

	# Animación de fade in para ControlsPanel
	tween.interpolate_property(
		$ControlsPanel, "modulate",
		Color(1, 1, 1, 0), Color(1, 1, 1, 1),  # Desde transparente hasta visible
		fade_speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)

	# Animación de fade out para ButtonsContainer
	tween.interpolate_property(
		$ButtonsContainer, "modulate",
		Color(1, 1, 1, 1), Color(1, 1, 1, 0),  # Desde visible hasta transparente
		fade_speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)

	# Inicia las animaciones
	tween.start()
	$ButtonsContainer.visible = false

# Función para ocultar el panel de controles y mostrar los botones
func _on_ButtonBackControls_button_down():
	$buttonPressed.play()
	$ButtonsContainer.visible = true  # Activa el contenedor para que pueda ser interpolado

	# Animación de fade out para ControlsPanel
	tween.interpolate_property(
		$ControlsPanel, "modulate",
		Color(1, 1, 1, 1), Color(1, 1, 1, 0),  # Desde visible hasta transparente
		fade_speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)

	# Animación de fade in para ButtonsContainer
	tween.interpolate_property(
		$ButtonsContainer, "modulate",
		Color(1, 1, 1, 0), Color(1, 1, 1, 1),  # Desde transparente hasta visible
		fade_speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)

	# Inicia las animaciones
	tween.start()
	target_scales["ButtonControls"] = Vector2(1, 1)
	$ControlsPanel.visible = false
