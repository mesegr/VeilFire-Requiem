extends Node2D

# --- CONFIGURACIÓN PRINCIPAL ---
export var radio_visible := 2000
export var intervalo_actualizacion := 2.5
export var distancia_minima_actualizacion := 200.0

# Exclusiones
export(Array, String) var nodos_excluidos = ["TileMap", "MountainsFather", "Sky","DeadZones","altar","DesertA5","DesertA2","DesertA4","DesertA3","Trees2"]
export(Array, String) var tipos_excluidos = ["TileMap", "CanvasLayer"]

# --- VARIABLES ---
var camera: Camera2D
var timer: Timer
var ultima_posicion_actualizacion := Vector2.ZERO

# --- INICIALIZACIÓN ---
func _ready():
	# Configurar cámara (ajusta la ruta según tu escena)
	camera = get_node("Player/PlayerCamera") if has_node("Player/PlayerCamera") else null
	
	# Crear Timer dinámicamente
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = intervalo_actualizacion
	timer.connect("timeout", self, "_on_Timer_timeout")
	timer.start()
	
	# Primera actualización
	_actualizar_visibilidad()

# --- TIMER ---
func _on_Timer_timeout():
	if !camera:
		return
	
	var distancia = camera.global_position.distance_to(ultima_posicion_actualizacion)
	if distancia > distancia_minima_actualizacion:
		_actualizar_visibilidad()
		ultima_posicion_actualizacion = camera.global_position

# --- LÓGICA DE VISIBILIDAD ---
func _actualizar_visibilidad():
	print("Actualizando visibilidad...")
	if !camera:
		printerr("Advertencia: Cámara no encontrada")
		return
	
	_recorrer_nodos(self)

func _recorrer_nodos(nodo):
	for child in nodo.get_children():
		if _debe_excluirse(child):
			continue
			
		if child is Node2D:
			var distancia = child.global_position.distance_to(camera.global_position)
			child.visible = (distancia <= radio_visible)
		
		if child.get_child_count() > 0:
			_recorrer_nodos(child)

# --- EXCLUSIONES ---
func _debe_excluirse(nodo: Node) -> bool:
	if nodo.name in nodos_excluidos:
		return true
			
	for tipo in tipos_excluidos:
		if nodo.get_class() == tipo:
			return true
			
	return false

# --- CONTROL MANUAL ---
func pausar_actualizaciones(pausar: bool):
	if timer:
		timer.paused = pausar  # Alternativa más limpia que stop()/start()
