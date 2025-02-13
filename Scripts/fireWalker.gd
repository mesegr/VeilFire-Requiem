extends KinematicBody2D
var lives = 6
var Playerlives = 4
var gravity = 10
var speed = 35
var velocity = Vector2(0,0)
var left = true
var free = false
var rage = false
var dead = false
onready var timerDead = $Timer
var OriginalPositionY

func _ready():
	$AudioStreamPlayer2D.play()
	$AnimatedSprite.play("default")
	OriginalPositionY = self.position.y
	
	timerDead.wait_time = 0.4
	timerDead.one_shot = true
	timerDead.connect("timeout", self, "dead_timeout")
	
	
func _process(delta):
	chase()
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
	

func _on_hit_timeout():
	$AnimatedSprite.modulate = Color(1, 1, 1, 1)
	
func dead():
	if lives == 0:
		velocity = Vector2.ZERO
		timerDead.start()
		dead = true
		$Area2D.position.y = 5000
		$deadsound.play()

	
func respawn():
	self.position.y = OriginalPositionY
	$AnimatedSprite.play("default")
	speed = 50
	dead = false
	lives = 6
	
func chase():
	if $right.is_colliding():
		var obj = $right.get_collider()
		if obj.is_in_group("Player"):
			speed = 75
			left = !left
			scale.x = -scale.x
			rage = true
	else:
		speed = 35
		rage = false
			
	if $left.is_colliding():
		var obj = $left.get_collider()
		if obj.is_in_group("Player"):
			speed = 75
			rage = true
	else:
		speed = 35
		rage = false
		
	if dead:
		$AnimatedSprite.play("dead")
		speed = 0
	elif rage:
		$AnimatedSprite.play("defaultAngry")
		$AudioStreamPlayer2D.pitch_scale = 0.35
	elif !rage:
		$AnimatedSprite.play("default")
		$AudioStreamPlayer2D.pitch_scale = 0.27

func _on_Area2D2_body_entered(body):
	if body.is_in_group("hit"):
		$AnimatedSprite.modulate = Color(5, 5, 5)  # Cambia el color del sprite a blanco (1, 1, 1)
		var timer = Timer.new()
		timer.wait_time = 0.1  # Duración del color blanco (0.1 segundos)
		timer.one_shot = true
		add_child(timer)
		timer.connect("timeout", self, "_on_hit_timeout")
		timer.start()
		lives -= 1
		dead()
