extends Node

var save_path = "user://savegame.save"

func save_game():
	var current_scene = get_tree().current_scene
	var player = current_scene.get_node("Player")
	var startpos = current_scene.get_node("Startpos")
	var ui = current_scene.get_node("ControlCanvas/CanvasLayer")
	var altars = current_scene.get_tree().get_nodes_in_group("altar")
	var pickups = current_scene.get_tree().get_nodes_in_group("coin")
	var ButtonsTrader = current_scene.get_tree().get_nodes_in_group("ButtonsTrader")
	var powerups = current_scene.get_tree().get_nodes_in_group("powerups")
	
	if player:
		# Guardar el estado de los altares
		var altar_states = []
		for altar in altars:
			if is_instance_valid(altar):  # Verificar si el nodo existe
				altar_states.append({
					"path": altar.get_path(),  # Ruta única del altar
					"active": altar.active     # Estado del altar
				})
				
		var powerups_states = []
		for powerup in powerups:
			if is_instance_valid(powerup): 
				powerups_states.append({
					"path": powerup.get_path(),  
					"visible": powerup.visible     
				})
				
		var button_states = []
		for button in ButtonsTrader:
			if is_instance_valid(button):
				button_states.append({
					"path": button.get_path(),  
					"active": button.disabled, 
					"scale": button.rect_scale,
				})
			
		# Guardar el estado de los pickups
		var pickup_states = []
		for pickup in pickups:
			if is_instance_valid(pickup):  
				pickup_states.append({
					"path": pickup.get_path(),  
					"picked": pickup.position,
				})
		
		# Crear el diccionario de guardado
		var save_data = {
			"current_scene": current_scene.filename,
			"player_position": player.position,
			"player_lives": player.PlayerLives,
			"player_canDash": player.canDash,
			"player_doubleJumpItem1": player.doubleJumpItem1,
			"player_doubleJumpItem2": player.doubleJumpItem2,
			"player_cooldownAttack": player.cooldownAttack,
			"ui_coins": ui.coins,
			"altar_states": altar_states,  # Guardar el array de estados de los altares
			"pickup_states": pickup_states,
			"button_states": button_states,
			"powerups_states": powerups_states,
			"startpos": startpos.position
		}
		
		# Guardar en archivo
		var file = File.new()
		file.open(save_path, File.WRITE)
		file.store_var(save_data)
		file.close()
	else:
		print("Error: No se encontró el nodo del jugador en la escena actual.")

func load_game():
	var file = File.new()
	if not file.file_exists(save_path):
		return false
	
	file.open(save_path, File.READ)
	var save_data = file.get_var()
	file.close()
	
	# Cambiar a la escena guardada
	get_tree().change_scene(save_data["current_scene"])
	yield(get_tree(), "idle_frame")  # Esperar a que la escena esté lista
	
	# Restaurar datos del jugador y la UI
	var player = get_tree().current_scene.get_node("Player")
	var ui = get_tree().current_scene.get_node("ControlCanvas/CanvasLayer")
	var startpos = get_tree().current_scene.get_node("Startpos")
	
	if player:
		player.position = save_data["player_position"]
		player.PlayerLives = save_data["player_lives"]
		player.canDash = save_data["player_canDash"]
		player.doubleJumpItem1 = save_data["player_doubleJumpItem1"]
		player.doubleJumpItem2 = save_data["player_doubleJumpItem2"]
		player.cooldownAttack = save_data["player_cooldownAttack"]
		ui.coins = save_data["ui_coins"]
		startpos.position = save_data["startpos"]
	else:
		print("Error: No se encontró el nodo del jugador en la escena cargada.")
	
	# Restaurar el estado de los altares
	for altar_state in save_data["altar_states"]:
		var altar = get_tree().current_scene.get_node(altar_state["path"])
		if altar and is_instance_valid(altar):  # Verificar si el nodo existe
			altar.active = altar_state["active"]
		else:
			print("Error: No se encontró el altar con la ruta:", altar_state["path"])
	
	# Restaurar el estado de los pickups
	for pickup_state in save_data["pickup_states"]:
		var pickup = get_tree().current_scene.get_node(pickup_state["path"])
		if pickup and is_instance_valid(pickup):  # Verificar si el nodo existe
			pickup.position = pickup_state["picked"]
		else:
			print("Error: No se encontró el pickup con la ruta:", pickup_state["path"])
			
	for button_states in save_data["button_states"]:
		var ButtonsTrader = get_tree().current_scene.get_node(button_states["path"])
		if ButtonsTrader and is_instance_valid(ButtonsTrader):  # Verificar si el nodo existe
			ButtonsTrader.disabled = button_states["active"]
			ButtonsTrader.rect_scale = button_states["scale"]
		else:
			print("Error: No se encontró el pickup con la ruta:", button_states["path"])
			
	for powerups_states in save_data["powerups_states"]:
		var powerup = get_tree().current_scene.get_node(powerups_states["path"])
		if powerup and is_instance_valid(powerup):  # Verificar si el nodo existe
			powerup.visible = powerups_states["visible"]
		else:
			print("Error: No se encontró el pickup con la ruta:", powerups_states["path"])
	
	return true
	
func new_game():
	var dir = Directory.new()
	if dir.file_exists(save_path):  # Verifica si el archivo de guardado existe
		dir.remove(save_path)  # Elimina el archivo de guardado
		print("Archivo de guardado eliminado.")
	else:
		print("No se encontró un archivo de guardado para eliminar.")
