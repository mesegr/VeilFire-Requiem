extends KinematicBody2D

onready var player = get_node("../Player")
var lives = 4
var gravity = 15
var velocity = Vector2(0, 0)
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
	$AnimatedSprite2.connect("animation_finished", self, "_on_animation_finished2")

func _process(delta):
	# Llama a move_character() para detectar colisiones sin movimiento
	move_character()

	# Lógica de la fireball
	fireball.position.x -= 280 * delta
	fireball.scale.x -= 0.58 * delta
	fireball.scale.y -= 0.58 * delta

	if free:
		self.position.y = 5000
		free = false

func move_character():
	# Asegúrate de que el enemigo no se mueva
	velocity = Vector2.ZERO
	velocity.y += gravity  # Aplica gravedad si es necesario
	move_and_slide(velocity, Vector2.UP)  # Detecta colisiones sin movimiento

func _on_frame_changed():
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
	
func _on_animation_finished2():
	if $AnimatedSprite2.animation == "default":
		$AnimatedSprite2.play("inter")
		
func hit():
	$AnimatedSprite.modulate = Color(5, 5, 5)  # Cambia el color del sprite a blanco
	var timer = Timer.new()
	timer.wait_time = 0.1  # Duración del color blanco (0.1 segundos)
	timer.one_shot = true
	add_child(timer)
	timer.connect("timeout", self, "_on_hit_timeout")
	timer.start()

func _on_hit_timeout():
	$AnimatedSprite.modulate = Color(1, 1, 1, 1)

func dead():
	if lives == 0:
		velocity = Vector2.ZERO
		timerDead.start()
		$AnimatedSprite.play("dead")
		$Area2D.position.y = 5000
		$deadsound.play()
		var loot_scene = preload("res://Scenes/Coin.tscn")  # Carga la escena del loot

		for i in range(4):  # Repite el bloque 4 veces
			var loot_instance = loot_scene.instance()  # Instancia el nodo
			# Ajusta la posición en función de la iteración (i)
			loot_instance.position = self.position + Vector2(cos(i * PI / 2) * 40, sin(i * PI / 2) * 40)
			loot_instance.set_target(get_parent().get_node("Player"))  # Asigna el jugador como objetivo
			get_parent().add_child(loot_instance) 

func respawn():
	self.position.y = OriginalPositionY
	$AnimatedSprite.play("default")
	lives = 4

func _on_Area2D2_body_entered(body):
	if body.name == "Player":
		scale.x = -scale.x

func _on_Area2D3_body_entered(body):
	if body.is_in_group("hit"):
		hit()  # Llama a la función hit() para manejar el daño
		lives -= 1
		dead()
		$AnimatedSprite2.play("default")
		player.shake_camera()
		player.frameFreeze(0.1,0.30)
	if body.is_in_group("hitDown"):
		player.motion.y = -280
		hit()  # Llama a la función hit() para manejar el daño
		lives -= 1
		dead()
		$AnimatedSprite2.play("default")
		player.shake_camera()
		player.frameFreeze(0.1,0.30)
