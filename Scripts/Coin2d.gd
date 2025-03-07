extends Area2D

onready var pickup = $pickup
onready var sprite = $Sprite
var canPick = true
var speed: float = 160.0  # Velocidad de movimiento
var target: Node2D = null  # Objetivo a perseguir (el jugador)

func set_target(new_target: Node2D) -> void:
	target = new_target

# Función de procesamiento por frame
func _process(delta: float) -> void:
	if target:  # Si hay un objetivo asignado
		var direction = (target.position - position).normalized()  # Dirección hacia el jugador
		position += direction * speed * delta  # Mueve la moneda hacia el jugador

func _on_JumpBook_body_entered(body):
	if body.get_name() == "Player" and canPick:
		sprite.scale.x -= 0.5
		sprite.scale.y -= 0.5
		body.doubleJumpItem2 = true
		sprite.play("pickup")
		pickup.play()
		canPick = false
		yield(sprite, "animation_finished")
		self.position.y = 5000
		speed = 0
			

func _on_Coin_body_entered(body):
	if body.get_name() == "Player" and canPick:
		body.addCoin()
		sprite.play("pickup")
		pickup.play()
		canPick = false
		yield(sprite, "animation_finished")
		self.position.y = 5000
		speed = 0

		
