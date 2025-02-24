extends StaticBody2D

onready var sprite = $AnimatedSprite
var firstAnim = true
var active = false

func _ready():
	yield(get_tree(), "idle_frame")  # Esperar un frame para que todo cargue
	var player = get_node("../Player")
	if player:
		player.connect("playerRest", self, "_on_playerRest")

func _on_playerRest(altar):
	if altar != self:  # Si el altar recibido NO es este, salir
		return
	if firstAnim:
		sprite.play("default")
		yield(sprite, "animation_finished")
		$AudioStreamPlayer2D.play()
	active = true
	firstAnim = false
	
func _process(delta):
	if active:
		sprite.play("new")
