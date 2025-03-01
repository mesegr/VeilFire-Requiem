extends Control

# Diccionario para almacenar la escala objetivo de cada botón
var target_scales = {}
var lerp_speed = 10.0  # Velocidad de la interpolación (ajusta según necesites)

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

func _on_ButtonStartGame_mouse_entered():
	target_scales["ButtonStartGame"] = Vector2(1.1, 1.05)
func _on_ButtonStartGame_mouse_exited():
	target_scales["ButtonStartGame"] = Vector2(1, 1)
func _on_ButtonLoadGame_mouse_entered():
	target_scales["ButtonLoadGame"] = Vector2(1.1, 1.05)
func _on_ButtonLoadGame_mouse_exited():
	target_scales["ButtonLoadGame"] = Vector2(1, 1)
func _on_ButtonControls_mouse_entered():
	target_scales["ButtonControls"] = Vector2(1.1, 1.05)
func _on_ButtonControls_mouse_exited():
	target_scales["ButtonControls"] = Vector2(1, 1)
func _on_ButtonQuitGame_mouse_entered():
	target_scales["ButtonQuitGame"] = Vector2(1.1, 1.05)
func _on_ButtonQuitGame_mouse_exited():
	target_scales["ButtonQuitGame"] = Vector2(1, 1)
func _on_ButtonBackControls_mouse_entered():
	target_scales["ButtonBackControls"] = Vector2(0.35, 0.37)
func _on_ButtonBackControls_mouse_exited():
	target_scales["ButtonBackControls"] = Vector2(0.32, 0.32)
