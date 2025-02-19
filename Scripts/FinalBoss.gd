extends KinematicBody2D

onready var player = get_node("../Player")
var lives = 25
var respawnP = false
var gravity = 0
var speed = 0
var velocity = Vector2(0,0)
var left = true
var free = false
var rage = false
var dead = false
var attack =  false
var canAttack = true
var fireAtt = false
var up = false
var fireUP = 250
var fireUP2 = 250
var fireUP3 = 250
var fireUP4 = 250
var down = false
var numero_aleatorio = 0
onready var camera = $"../Player/PlayerCamera"
onready var sprite = $AnimatedSprite
onready var fire = $fire1
onready var fire2 = $fire2
onready var fire3 = $fire3
onready var fire4 = $fire4
onready var cooldown = $cooldown
var OriginalPositionY
var OriginalPositionX
var fireOGposition
var AttCoolRan = rand_range(4, 5.5)


func _ready():
	$FootSteps.play()
	randomize()
	fireOGposition = fire.position.y
	$AnimatedSprite.play("Idle")
	OriginalPositionY = self.position.y
	OriginalPositionX = self.position.x
	
	sprite.connect("animation_finished", self, "_on_animation_finished")
	sprite.connect("frame_changed", self, "_on_frame_changed")
	
	cooldown.wait_time = AttCoolRan
	cooldown.one_shot = true
	cooldown.connect("timeout", self, "cooldown_attack")

func _process(delta):
	if !dead and !respawnP:  # Asegurarse de que no esté en respawn
		if fireAtt:
			fireAttack(delta)

		if canAttack:
			attack()

		if !attack:
			chase()
			move_character()
	else:
		# Si el boss está muerto o en respawn, no hacer nada
		pass

func move_character():
	velocity.y += gravity
	if left:
		velocity.x = -speed
		velocity = move_and_slide(velocity,Vector2.UP)
	else:
		velocity.x = speed
		velocity = move_and_slide(velocity,Vector2.UP)
		
func dead_timeout():
	free = true

func fireAttack(delta):
	
	if fire.position.y <= 3:
		fireUP = 0
		$fire4/Fire.play()
	if fire2.position.y <= 3:
		fireUP2 = 0
	if fire3.position.y <= 3:
		fireUP3 = 0
	if fire4.position.y <= 3:
		fireUP4 = 0
		up = false
		
	if up:
		fire.position.y -= fireUP * delta
		if fire.position.y <= 17:
			fire2.position.y -= fireUP2 * delta
		if fire2.position.y <= 17:
			fire3.position.y -= fireUP3 * delta
		if fire3.position.y <= 17:
			fire4.position.y -= fireUP4 * delta
			
	if fire4.position.y <= 3:
		down = true
		
	if down:
		fire.position.y +=150 * delta
		fire2.position.y += 150 * delta
		fire3.position.y += 150 * delta
		fire4.position.y += 150 * delta
		if fire4.position.y >= 52:
			down = false
			fireUP = 250
			fireUP2 = 250
			fireUP3 = 250
			fireUP4 = 250
			numero_aleatorio = 0

func _on_hit_timeout():
	sprite.modulate = Color(1, 1, 1, 1)
	  # Restaura el color original (1, 1, 1, 1 es el valor por defecto)
func reset_fire_positions():
	fire.position.y = fireOGposition
	fire2.position.y = fireOGposition
	fire3.position.y = fireOGposition
	fire4.position.y = fireOGposition
	fireUP = 250
	fireUP2 = 250
	fireUP3 = 250
	fireUP4 = 250
	up = false
	down = false
	
func dead():
	if lives == 0:
		$CollisionShape2D.disabled = true
		$Area2D2/CollisionShape2D2.disabled = true
		velocity = Vector2.ZERO
		dead = true
		$AnimatedSprite.play("dead") 
		speed = 0  
		attack = false  
		fireAtt = false 
		$FootSteps.stop() 
		cooldown.stop()  # Detén el temporizador de cooldown 
	
func respawn():
	self.position.y = OriginalPositionY
	self.position.x = OriginalPositionX
	speed = 0
	velocity = Vector2.ZERO
	rage = false
	dead = false
	attack = false
	canAttack = true
	fireAtt = false
	up = false
	down = false
	reset_fire_positions()
	$AnimatedSprite.play("Idle")
	$CollisionShape2D.disabled = false
	$Area2D2/CollisionShape2D2.disabled = false
	$FootSteps.stop()
	cooldown.stop()
	sprite.modulate = Color(1, 1, 1, 1)
	
	# Asegurarse de que los ataques estén deshabilitados
	$Attack.enabled = false
	$LongAttack.enabled = false
	$Right.enabled = false
	$Left.enabled = false
	
	# Reactivar las detecciones después de un breve retraso
	var timer = Timer.new()
	timer.wait_time = 0.5  # Esperar 0.5 segundos antes de reactivar las detecciones
	timer.one_shot = true
	add_child(timer)
	timer.connect("timeout", self, "_enable_detections")
	timer.start()

func _enable_detections():
	$Attack.enabled = true
	$LongAttack.enabled = true
	$Right.enabled = true
	$Left.enabled = true
	
func _on_frame_changed():
	if sprite.animation == "attackFire" and sprite.frame == 14:
		up = true
	if sprite.animation == "attackFire" and sprite.frame == 1:
		$attackFireRawr.play()
	if sprite.animation == "attackFire" and sprite.frame == 12:
		$CleaveSound.play()
	if sprite.animation == "attackFire" and sprite.frame == 13:
		$attack.disabled = false
		player.shake_camera()
	if sprite.animation == "attackFire" and sprite.frame == 18:
		$attack.disabled = true
	if sprite.animation == "attackcleave" and sprite.frame == 1:
		$attackcleaveRawr.play()
	if sprite.animation == "attackcleave" and sprite.frame == 10:
		$CleaveSound.play()
	if sprite.animation == "attackcleave" and sprite.frame == 11:
		player.shake_camera()
		$attack.disabled = false
	if sprite.animation == "attackcleave" and sprite.frame == 14:
		$attack.disabled = true
	if sprite.animation == "Flames" and sprite.frame == 7:
		$FlameThrow.play()
	if sprite.animation == "Flames" and sprite.frame == 17:
		$AttackFlame.disabled = false
	if sprite.animation == "Flames" and sprite.frame == 21:
		$AttackFlame.disabled = true

func attack():
	if !dead and !attack and canAttack and !respawnP:  # Asegurarse de que no esté en respawn
		if $Attack.is_colliding():  # Verifica el rango de ataque cercano
			var obj = $Attack.get_collider()
			if obj.is_in_group("Player"):
				numero_aleatorio = randi() % 10 + 1
				AttCoolRan = rand_range(4, 5.5)

				if numero_aleatorio <= 4:
					$AnimatedSprite.play("Flames")
				else:
					$AnimatedSprite.play("attackcleave")

				attack = true
				canAttack = false
				cooldown.start()

		elif $LongAttack.is_colliding():  # Verifica el rango de ataque lejano
			var obj = $LongAttack.get_collider()
			if obj.is_in_group("Player"):
				$AnimatedSprite.play("attackFire")
				fireAtt = true
				attack = true
				canAttack = false
				cooldown.start()

func cooldown_attack():
	canAttack = true
	print("attack")
			
func _on_animation_finished():
	if sprite.animation == "Flames" or sprite.animation == "attackcleave" or sprite.animation == "attackFire":
		attack = false 
		$LongAttack.enabled = true 
		reset_fire_positions()
	
	if sprite.animation == "Flames":
		attack = false
		reset_fire_positions()
	
	if sprite.animation == "attackFire":
		fireAtt =  false
		attack = false
		reset_fire_positions()
	
	if sprite.animation == "hit":
		speed = 25
		attack = false
	
	if sprite.animation == "dead":
		$CollisionShape2D.disabled = true
		$Area2D2/CollisionShape2D2.disabled = true

func chase():
	if !dead and !respawnP:  # Asegurarse de que no esté en respawn
		if $Right.is_colliding():
			var obj = $Right.get_collider()
			if obj.is_in_group("Player"):
				left = !left
				scale.x = -scale.x
				rage = true
				speed = 25
				
		if $Left.is_colliding():
			var obj = $Left.get_collider()
			if obj.is_in_group("Player"):
				rage = true
				speed = 25
		
		if rage:
			$AnimatedSprite.play("Walk")

func _on_Area2D2_body_entered(body):
	if body.is_in_group("hit"):
		sprite.modulate = Color(5, 5, 5)  # Cambia el color del sprite a blanco (1, 1, 1)
		var timer = Timer.new()
		timer.wait_time = 0.1  # Duración del color blanco (0.1 segundos)
		timer.one_shot = true
		add_child(timer)
		timer.connect("timeout", self, "_on_hit_timeout")
		timer.start()
		lives -= 1
		dead()
		player.shake_camera()
		
