extends KinematicBody2D

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
var fireUP = 1.5
var fireUP2 = 1.5
var fireUP3 = 1.5
var fireUP4 = 1.5
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
var AttCoolRan = rand_range(2, 4)


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
	if !dead:
		if fireAtt:
			fireAttack()

		if canAttack:
			attack()

		if !attack and !respawnP:
			chase()
			move_character()

	else:
		# Si el boss está muerto, no hacer nada más que la animación de muerte
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

func fireAttack():
	
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
		fire.position.y -= fireUP
		if fire.position.y <= 17:
			fire2.position.y -= fireUP2
		if fire2.position.y <= 17:
			fire3.position.y -= fireUP3
		if fire3.position.y <= 17:
			fire4.position.y -= fireUP4
			
	if fire4.position.y <= 3:
		down = true
		
	if down:
		fire.position.y += 1.4
		fire2.position.y += 1.4
		fire3.position.y += 1.4
		fire4.position.y += 1.4
		if fire4.position.y >= 52:
			down = false
			fireUP = 1.5
			fireUP2 = 1.5
			fireUP3 = 1.5
			fireUP4 = 1.5
			numero_aleatorio = 0
	
func hit():
	sprite.modulate = Color(5, 5, 5)  # Cambia el color del sprite a blanco (1, 1, 1)
	var timer = Timer.new()
	timer.wait_time = 0.1  # Duración del color blanco (0.1 segundos)
	timer.one_shot = true
	add_child(timer)
	timer.connect("timeout", self, "_on_hit_timeout")
	timer.start()

func _on_hit_timeout():
	sprite.modulate = Color(1, 1, 1, 1)
	  # Restaura el color original (1, 1, 1, 1 es el valor por defecto)
func reset_fire_positions():
	fire.position.y = fireOGposition
	fire2.position.y = fireOGposition
	fire3.position.y = fireOGposition
	fire4.position.y = fireOGposition
	fireUP = 1.5
	fireUP2 = 1.5
	fireUP3 = 1.5
	fireUP4 = 1.5
	up = false
	down = false
	
func dead():
	print($CollisionShape2D)  # Verifica que no sea null
	print($CollisionShape2D2)  # Verifica que no sea null
	$CollisionShape2D.disabled = true
	$CollisionShape2D2.disabled = true
	velocity = Vector2.ZERO
	dead = true
	$AnimatedSprite.play("dead") 
	speed = 0  
	attack = false  
	fireAtt = false 
	$FootSteps.stop() 
	
func respawn():
	self.position.y = OriginalPositionY
	self.position.x = OriginalPositionX
	$AnimatedSprite.play("Idle")
	attack = false
	dead = false
	respawnP = true
	reset_fire_positions()
	$AttackFlame.disabled = true
	$attack.disabled = true
	
func _on_frame_changed():
	if sprite.animation == "attackFire" and sprite.frame == 14:
		up = true
	if sprite.animation == "attackFire" and sprite.frame == 1:
		$attackFireRawr.play()
	if sprite.animation == "attackFire" and sprite.frame == 12:
		$CleaveSound.play()
	if sprite.animation == "attackFire" and sprite.frame == 13:
		$attack.disabled = false
	if sprite.animation == "attackFire" and sprite.frame == 18:
		$attack.disabled = true
	if sprite.animation == "attackcleave" and sprite.frame == 1:
		$attackcleaveRawr.play()
	if sprite.animation == "attackcleave" and sprite.frame == 10:
		$CleaveSound.play()
	if sprite.animation == "attackcleave" and sprite.frame == 11:
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
	if !attack and $Attack.is_colliding():  # Solo atacar si no está atacando ya
		var obj = $Attack.get_collider()
		if obj.is_in_group("Player"):
			numero_aleatorio = randi() % 10 + 1
			AttCoolRan = rand_range(3.5, 5) 

			if numero_aleatorio <= 4:
				$AnimatedSprite.play("Flames")
			else:
				$AnimatedSprite.play("attackcleave")

			attack = true
			canAttack = false
			cooldown.start()
	if !attack and $LongAttack.is_colliding():  # Solo atacar si no está atacando ya
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
		$CollisionShape2D2.disabled = true

func chase():
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
		
	if dead:
		$AnimatedSprite.play("dead")
		speed = 0
	elif rage:
		$AnimatedSprite.play("Walk")

