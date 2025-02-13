extends KinematicBody2D
var gravity = 15
var velocity = Vector2(0,0)
var left = true
var free = false

onready var timerDead = $Timer
onready var fireball = $KinematicBody2D

var OriginalPositionFireball
var OriginalPositionY

func _ready():
	$KinematicBody2D/AudioStreamPlayer2D2.play()
	$AnimatedSprite.play("default")
	$KinematicBody2D/AnimatedSprite2.play("default")
	$AnimatedSprite.connect("frame_changed", self, "_on_frame_changed")
	OriginalPositionY = self.position.y
	OriginalPositionFireball = fireball.position.x
	
	timerDead.wait_time = 0.2
	timerDead.one_shot = true
	timerDead.connect("timeout", self, "dead_timeout")
	
func _process(delta):
	velocity.y += gravity
	fireball.position.x -= 280 * delta
	fireball.scale.x -= 0.58 * delta
	fireball.scale.y -= 0.58 * delta
	if free:
		self.position.y = 5000
		free = false
		
func _on_frame_changed():
	# Verifica si el frame actual es el 27
	if $AnimatedSprite.frame == 27:
		fireball.position.x = OriginalPositionFireball
		fireball.scale.x = 1.4
		fireball.scale.y = 1.4
		$AudioStreamPlayer2D.play()
		$CollisionShape2D2.disabled = false
	if $AnimatedSprite.frame == 34:
		$CollisionShape2D2.disabled = true
func dead_timeout():
	free = true
	
func hit():
	$AnimatedSprite.modulate = Color(5, 5, 5)  # Cambia el color del sprite a blanco (1, 1, 1)
	var timer = Timer.new()
	timer.wait_time = 0.1  # Duración del color blanco (0.1 segundos)
	timer.one_shot = true
	add_child(timer)
	timer.connect("timeout", self, "_on_hit_timeout")
	timer.start()

func _on_hit_timeout():
	$AnimatedSprite.modulate = Color(1, 1, 1, 1)
		
func dead():
	self.position.y = position.y + 25
	velocity = Vector2.ZERO
	timerDead.start()
	$AnimatedSprite.play("dead")
	$Area2D.position.y = 5000
	$deadsound.play()
	
func respawn():
	self.position.y = OriginalPositionY
	$AnimatedSprite.play("default")

func _on_Area2D2_body_entered(body):
	if body.name == "Player":
		scale.x = -scale.x

func _on_Area2D3_body_entered(body):
		print("pipupipu")
