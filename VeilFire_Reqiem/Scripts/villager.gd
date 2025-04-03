extends Area2D

var text = 0
var enter = false
var current_text = ""
var current_index = 0
var is_typing = false
var dialog_texts = [
	"Again? The chosen one to save us? The volcano is nothing but a farce; these mountains were sulfur and gold mines. Do you know what comes out of the crater? Gases from its rotten tunnels. But the people love the story of a hero coming to save us. The first so-called chosen ones were just poor devils they made disappear to keep the tale alive. What do you think? That you’re different?",
	"Well, go ahead and keep believing the tales from the villagers of Albion and what the church tries to instill in all the inhabitants of the lands under its rule. After all, you’ll just be another one they make disappear to make it seem like you failed on your quest... What are you still staring at? The priestess and the leader of the army’s assault squad are waiting for you to begin your so-called adventure."
]

onready var next = $"../ControlCanvas/CanvasLayer/nextLabel"
onready var player = get_node("../Player")
var timer = null  # Declaramos el Timer como variable

# Referencias a los RichTextLabel
onready var rich_text_labels = [
	$"../ControlCanvas/CanvasLayer/PanelVillager/Villager1",
	$"../ControlCanvas/CanvasLayer/PanelVillager/Villager2"
]

# Señales
func _ready():
	create_timer()  # Creamos el Timer dinámicamente

# Crear el Timer dinámicamente
func create_timer():
	timer = Timer.new()  # Creamos una nueva instancia de Timer
	timer.wait_time = 0.1  # Velocidad del texto (ajusta según necesites)
	timer.connect("timeout", self, "_on_Timer_timeout")  # Conectamos la señal timeout
	add_child(timer)  # Añadimos el Timer a la escena

# Lógica del diálogo
func _process(delta):
	if Input.is_action_just_released("ui_accept") and enter:
		if not is_typing:
			text += 1
			player.cooldown = false
			next.play()
			start_dialog()
		else:
			# Si el jugador presiona "Aceptar" mientras se escribe, completar el texto
			complete_text()

	update_dialog_visibility()

# Iniciar el diálogo
func start_dialog():
	if text <= dialog_texts.size():
		current_text = ""
		current_index = 0
		is_typing = true
		timer.start()

# Completar el texto actual
func complete_text():
	var active_label = get_active_rich_text_label()  # Obtenemos el RichTextLabel activo
	if active_label:
		current_text = dialog_texts[text - 1]
		active_label.bbcode_text = current_text
		is_typing = false
		timer.stop()

# Obtener el RichTextLabel activo
func get_active_rich_text_label():
	if text == 1:
		return rich_text_labels[0]  
	elif text == 2:
		return rich_text_labels[1] 
	return null

# Actualizar la visibilidad de los diálogos
func update_dialog_visibility():
	if text == 1:
		$"../ControlCanvas/CanvasLayer/PanelVillager".visible = true
		rich_text_labels[0].visible = true
		rich_text_labels[0].bbcode_text = current_text
	elif text == 2:
		rich_text_labels[0].visible = false
		rich_text_labels[1].visible = true
		rich_text_labels[1].bbcode_text = current_text
	elif text == 3:
		rich_text_labels[1].visible = false
		$"../ControlCanvas/CanvasLayer/PanelVillager".visible = false
		text = 0

	if not enter:
		reset_dialog()

# Reiniciar el diálogo
func reset_dialog():
	for label in rich_text_labels:
		label.visible = false
	$"../ControlCanvas/CanvasLayer/PanelVillager".visible = false
	text = 0
	current_text = ""
	current_index = 0
	is_typing = false
	if timer:
		timer.stop()

# Lógica del Timer para mostrar letra por letra
func _on_Timer_timeout():
	var active_label = get_active_rich_text_label()  # Obtenemos el RichTextLabel activo
	if active_label and current_index < dialog_texts[text - 1].length():
		# Obtenemos el siguiente grupo de 12 caracteres
		var next_group = dialog_texts[text - 1].substr(current_index, 6)
		
		# Buscar signos de puntuación dentro del grupo
		var pause_index = -1  # Índice donde se debe hacer la pausa
		for i in range(next_group.length()):
			if next_group[i] in [".", ":", "!", "?"]:
				pause_index = i  # Guardamos la posición del signo de puntuación
				break  # Salimos del bucle al encontrar el primer signo

		# Si se encontró un signo de puntuación, ajustamos el grupo
		if pause_index != -1:
			next_group = next_group.substr(0, pause_index + 1)  # Cortamos el grupo hasta el signo
			current_index += pause_index + 1  # Avanzamos el índice hasta después del signo
		else:
			current_index += 6  # Si no hay signos, avanzamos 12 caracteres

		# Añadimos el grupo al texto actual
		current_text += next_group
		active_label.bbcode_text = current_text

		# Reproducir el sonido con un pitch predefinido aleatorio
		var talking_sound = $"../ControlCanvas/CanvasLayer/Talking"
		var pitch_values = [0.7, 0.8, 0.9]  # Valores predefinidos
		talking_sound.pitch_scale = pitch_values[randi() % pitch_values.size()]  # Selecciona un valor aleatorio
		talking_sound.play()

		# Si se encontró un signo de puntuación, hacemos una pausa
		if pause_index != -1:
			timer.stop()  # Detener el Timer temporalmente
			yield(get_tree().create_timer(0.25), "timeout")  # Pausa de 0.5 segundos
			timer.start()  # Reanudar el Timer
	else:
		is_typing = false
		timer.stop()

func _on_Villager_body_entered(body):
	if body.name == "Player":
		enter = true
		$ECopia.visible = true


func _on_Villager_body_exited(body):
	if body.name == "Player":
		enter = false
		player.cooldown = true
		$ECopia.visible = false
		reset_dialog()
