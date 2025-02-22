extends StaticBody2D

onready var sprite = $AnimatedSprite

func _ready():
	yield(get_tree(), "idle_frame")  # Esperar un frame para que todo cargue
	var player = get_node("../Player")
	if player:
		player.connect("playerRest", self, "_on_playerRest")

func _on_playerRest(altar):
	if altar != self:  # Si el altar recibido NO es este, salir
		return
	
	sprite.play("default")
	yield(sprite, "animation_finished")
	sprite.play("new")
