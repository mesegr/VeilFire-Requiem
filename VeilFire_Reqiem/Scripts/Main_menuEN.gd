extends Control

var loading_scene = null  # Almacenará la escena que se está cargando
var loading_progress = 0  # Para rastrear el progreso de la carga
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
		
	if loading_scene != null:
		# Carga un fragmento de la escena
		var status = loading_scene.poll()
		
		if status == ERR_FILE_EOF:
			# La escena ha terminado de cargarse
			var scene = loading_scene.get_resource()
			loading_scene = null  # Reinicia la variable
			get_tree().change_scene_to(scene)  # Cambia a la escena cargada
		elif status == OK:
			# Actualiza el progreso de la carga (opcional, para una barra de progreso)
			loading_progress = float(loading_scene.get_stage()) / loading_scene.get_stage_count()
		else:
			# Hubo un error al cargar la escena
			print("Error al cargar la escena: ", status)
			loading_scene = null

func _on_ButtonStartGame_mouse_entered():
	target_scales["ButtonStartGame"] = Vector2(1.1, 1.05)
	$buttonHovered.play()

func _on_ButtonStartGame_mouse_exited():
	target_scales["ButtonStartGame"] = Vector2(1, 1)

func _on_ButtonStartGame_button_down():
	$MenuTheme.stop()
	$buttonPressed.play()
	target_scales["ButtonStartGame"] = Vector2(1, 1)
	SaveSystem.new_game()
	
	$ColorRect.visible = true
	$AnimationPlayer.play("fade_to_black")
	$loading.play("default")
	
	# Comienza a cargar la escena de manera asíncrona
	loading_scene = ResourceLoader.load_interactive("res://Scenes/worldEN.tscn")
	if loading_scene == null:
		print("Error al cargar la escena.")
		return


func _on_ButtonLoadGame_mouse_entered():
	target_scales["ButtonLoadGame"] = Vector2(1.1, 1.05)
	$buttonHovered.play()

func _on_ButtonLoadGame_mouse_exited():
	target_scales["ButtonLoadGame"] = Vector2(1, 1)
	
func _on_ButtonLoadGame_button_down():
	$MenuTheme.stop()
	$buttonPressed.play()
	target_scales["ButtonStartGame"] = Vector2(1, 1)
	SaveSystem.load_game()
	
	$ColorRect.visible = true
	$AnimationPlayer.play("fade_to_black")
	$loading.play("default")
	
	# Comienza a cargar la escena de manera asíncrona
	loading_scene = ResourceLoader.load_interactive("res://Scenes/worldEN.tscn")
	if loading_scene == null:
		print("Error al cargar la escena.")
		return


func _on_ButtonControls_mouse_entered():
	target_scales["ButtonControls"] = Vector2(1.1, 1.05)
	$buttonHovered.play()

func _on_ButtonControls_mouse_exited():
	target_scales["ButtonControls"] = Vector2(1, 1)

func _on_ButtonControls_button_down():
	$buttonPressed.play()
	$ControlsPanel.visible = true  # Activa el panel para que pueda ser interpolado
	$ButtonsContainer/ButtonControls.disabled = true
	# Animación de fade in para ControlsPanel
	tween.interpolate_property(
		$ControlsPanel, "modulate",
		Color(1, 1, 1, 0), Color(1, 1, 1, 1),  # Desde transparente hasta visible
		fade_speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)

	tween.start()



func _on_ButtonQuitGame_mouse_entered():
	target_scales["ButtonQuitGame"] = Vector2(1.1, 1.05)
	$buttonHovered.play()

func _on_ButtonQuitGame_mouse_exited():
	target_scales["ButtonQuitGame"] = Vector2(1, 1)

func _on_ButtonQuitGame_button_down():
	$buttonPressed.play()  # Reproduce el sonido

	var timer = Timer.new()
	timer.wait_time = 0.6  # Espera 0.5 segundos
	timer.one_shot = true  # El Timer se detiene después de ejecutarse una vez
	add_child(timer)  # Añade el Timer a la escena
	timer.start()

	yield(timer, "timeout")

	get_tree().quit()


func _on_ButtonBackControls_mouse_entered():
	$buttonHovered.play()
	target_scales["ButtonBackControls"] = Vector2(0.35, 0.37)

func _on_ButtonBackControls_button_down():
	$buttonPressed.play()
	$ButtonsContainer/ButtonControls.disabled = false
	# Animación de fade out para ControlsPanel
	tween.interpolate_property(
		$ControlsPanel, "modulate",
		Color(1, 1, 1, 1), Color(1, 1, 1, 0),  # Desde visible hasta transparente
		fade_speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)

	# Inicia las animaciones
	tween.start()
# Espera a que la animación del Tween termine
	yield(tween, "tween_completed")

	# Hace invisible el panel después de la transición
	$ControlsPanel.visible = false

func _on_ButtonBackControls_mouse_exited():
	target_scales["ButtonBackControls"] = Vector2(0.32, 0.32)
	

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		get_tree().change_scene("res://Scenes/worldEN.tscn")
