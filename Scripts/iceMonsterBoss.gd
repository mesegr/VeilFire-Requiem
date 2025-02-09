extends KinematicBody2D
var Playerlives = 4
var gravity = 10
var speed = 40
var velocity = Vector2(0,0)
var left = true
var free = false
onready var timerDead = $Timer
var OriginalPositionY

func _ready():
	$AnimatedSprite.play("default")
	$AudioStreamPlayer2D.play()
	OriginalPositionY = self.position.y
	
	timerDead.wait_time = 0.2
	timerDead.one_shot = true
	timerDead.connect("timeout", self, "dead_timeout")
	
	
func _process(delta):
	move_character()
	turn()
	if free:
		self.position.y = 5000
		free = false
func move_character():
	velocity.y += gravity
	if left:
		velocity.x = -speed
		velocity = move_and_slide(velocity,Vector2.UP)
	else:
		velocity.x = speed
		velocity = move_and_slide(velocity,Vector2.UP)

func turn():
	if not $RayCast2D.is_colliding() or $RayCast2D2.is_colliding():
		left = !left
		scale.x = -scale.x
		
func dead_timeout():
	free = true
	
func hit():
	if !$AnimatedSprite.flip_h:
		velocity = Vector2(-0,-200)
	else:
		velocity = Vector2(0,-200)
	
func dead():
	velocity = Vector2.ZERO
	timerDead.start()
	$AnimatedSprite.play("dead")
	$Area2D.position.y = 5000
	speed = 0
	$deadsound.play()
	
func respawn():
	self.position.y = OriginalPositionY
	$AnimatedSprite.play("default")
	speed = 40


func _on_Area2D2_body_entered(body):
	if body.name == "Player":
		left = !left
		scale.x = -scale.x
