extends KinematicBody2D

onready var player = get_node("../Player")
var lives = 7
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
	
	$AnimatedSprite2.connect("animation_finished", self, "_on_animation_finished")
	
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
	
func _on_animation_finished():
	if $AnimatedSprite2.animation == "default":
		$AnimatedSprite2.play("inter")
		
func _on_hit_timeout():
	$AnimatedSprite.modulate = Color(1, 1, 1, 1)
	
func dead():
	if lives == 0:
		velocity = Vector2.ZERO
		timerDead.start()
		dead = true
		$Area2D.position.y = 5000
		$deadsound.play()
		
		# Crear un nodo en la posición de muerte
		var loot_scene = preload("res://Scenes/Coin.tscn")  # Carga la escena del loot
		var loot_instance = loot_scene.instance()  # Instancia el nodo
		loot_instance.position = self.position + Vector2(0,-50)  # Inicia un poco más arriba
		get_parent().add_child(loot_instance)  # Añadirlo a la escena

		# Añadir un Tween manualmente
		var tween = Tween.new()
		get_parent().add_child(tween)  # Añadir el Tween a la escena
		tween.interpolate_property(loot_instance, "position", loot_instance.position, self.position, 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
		tween.start()

	
func respawn():
	self.position.y = OriginalPositionY
	$AnimatedSprite.play("default")
	speed = 50
	dead = false
	lives = 7
	
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
		$AnimatedSprite.modulate = Color(5, 5, 5) 
		$AnimatedSprite2.play("default") 
		var timer = Timer.new()
		timer.wait_time = 0.1  # Duración del color blanco (0.1 segundos)
		timer.one_shot = true
		add_child(timer)
		timer.connect("timeout", self, "_on_hit_timeout")
		timer.start()
		lives -= 1
		dead()
		player.shake_camera()
		player.frameFreeze(0.04,0.25)
	if body.is_in_group("hitDown"):
		player.motion.y = -280
		$AnimatedSprite.modulate = Color(5, 5, 5) 
		$AnimatedSprite2.play("default") 
		var timer = Timer.new()
		timer.wait_time = 0.1  # Duración del color blanco (0.1 segundos)
		timer.one_shot = true
		add_child(timer)
		timer.connect("timeout", self, "_on_hit_timeout")
		timer.start()
		lives -= 1
		dead()
		player.shake_camera()
		player.frameFreeze(0.04,0.25)
