extends KinematicBody2D

onready var player = get_node("../Player")
var lives = 3
var gravity = 10
var speed = 45
var velocity = Vector2(0,0)
var left = true
var free = false
onready var timerDead = $Timer
var OriginalPositionY
var dead = false

func _ready():
	$AnimatedSprite.play("default")
	OriginalPositionY = self.position.y
	
	timerDead.wait_time = 0.2
	timerDead.one_shot = true
	timerDead.connect("timeout", self, "dead_timeout")
	$AnimatedSprite2.connect("animation_finished", self, "_on_animation_finished2")
	
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
	
func _on_animation_finished2():
	if $AnimatedSprite2.animation == "default":
		$AnimatedSprite2.play("inter")

func _on_hit_timeout():
	$AnimatedSprite.modulate = Color(1, 1, 1, 1)
	
func dead():
	if lives == 0:
		velocity = Vector2.ZERO
		timerDead.start()
		$AnimatedSprite.play("dead")
		$Area2D.position.y = 5000
		speed = 0
		$AudioStreamPlayer.play()
		dead = true
	
func respawn():
	self.position.y = OriginalPositionY
	$AnimatedSprite.play("default")
	speed = 45
	dead = false
	lives = 3
	
func chase():
	if $right.is_colliding():
		var obj = $right.get_collider()
		if obj.is_in_group("Player"):
			speed = 60
			left = !left
			scale.x = -scale.x
	else:
		speed = 45
			
	if $left.is_colliding():
		var obj = $left.get_collider()
		if obj.is_in_group("Player"):
			speed = 60

	else:
		speed = 40
		
	if dead:
		$AnimatedSprite.play("dead")
		speed = 0

func _on_Area2D2_body_entered(body):
	if body.is_in_group("hit"):
		$AnimatedSprite.modulate = Color(5, 5, 5)  # Cambia el color del sprite a blanco (1, 1, 1)
		var timer = Timer.new()
		timer.wait_time = 0.1  # Duración del color blanco (0.1 segundos)
		timer.one_shot = true
		add_child(timer)
		timer.connect("timeout", self, "_on_hit_timeout")
		timer.start()
		$AnimatedSprite2.play("default")
		lives -= 1
		dead()
		player.shake_camera()
		player.frameFreeze(0.04,0.25)
