extends KinematicBody2D
var Playerlives = 4
var gravity = 10
var speed = 0
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
	fireball.position.x -= 2.2
	fireball.scale.x -= 0.004
	fireball.scale.y -= 0.004
	move_character()
	if free:
		self.position.y = 5000
		free = false
func move_character():
	if left:
		velocity.x = -speed
		velocity = move_and_slide(velocity,Vector2.UP)
	else:
		velocity.x = speed
		velocity = move_and_slide(velocity,Vector2.UP)
		
func _on_frame_changed():
	# Verifica si el frame actual es el 27
	if $AnimatedSprite.frame == 27:
		fireball.position.x = OriginalPositionFireball
		fireball.scale.x = 1.4
		fireball.scale.y = 1.4
		$AudioStreamPlayer2D.play()
		
func dead_timeout():
	free = true
	
func hit():
	if !$AnimatedSprite.flip_h:
		velocity = Vector2(-0,-200)

	else:
		velocity = Vector2(0,-200)
		
func dead():
	self.position.y = position.y + 25
	velocity = Vector2.ZERO
	timerDead.start()
	$AnimatedSprite.play("dead")
	$Area2D.position.y = 5000
	speed = 0
	$deadsound.play()
	
func respawn():
	self.position.y = OriginalPositionY
	$AnimatedSprite.play("default")

func _on_Area2D2_body_entered(body):
	if body.name == "Player":
		scale.x = -scale.x

