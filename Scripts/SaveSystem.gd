extends Node

var save_path = "user://savegame.save"

func save_game():
	var current_scene = get_tree().current_scene
	var player = current_scene.get_node("Player")
	
	if player:
		var save_data = {
			"current_scene": current_scene.filename,
			"player_position": player.position,
			# Añade más datos que quieras guardar
		}
		
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
	
	get_tree().change_scene(save_data["current_scene"])
	yield(get_tree(), "idle_frame")
	
	var player = get_tree().current_scene.get_node("Player")
	
	if player:
		player.position = save_data["player_position"]
		# Restaurar más datos
	else:
		print("Error: No se encontró el nodo del jugador en la escena cargada.")
	
	return true
