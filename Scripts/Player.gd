extends KinematicBody2D

# Speed values for player
var canDash = false
var is_dashing = false
var dash_speed = 460
var dash_duration = 0.055
var dash_timer = 0
var dash_cooldown = 1.5
var dash_cooldown_timer = 0

var moveSpeed = 45
var maxSpeed = 95
# Gravity and jump values for player
var jumpHeight = -272
const up = Vector2(0, -1)
var gravity = 15
var cooldownAttack = 0.75

var camera_shake_timer = 0
var shake_intensity = 110
var shake_duration = 0.4
onready var camera = $PlayerCamera
var original_camera_position = Vector2() 
var HitPlayer = false
var player
var can_doublejump = true
var doubleJumpItem1 = false
var doubleJumpItem2 = false
var motion = Vector2()
onready var sprite = $AnimatedSprite
onready var timerRest = $TimerRest
onready var deadeffect = $deadeffect
onready var timercooldown = $cooldown
onready var deadAnim = $deadAnim
onready var attack_sound = $attack_sound
onready var attack_sound2 = $attack_sound2
onready var jump1_sound = $jump1_sound
onready var jump2_sound = $jump2_sound
onready var dragonslayer_desert_music = $dragonslayer_desert_music
onready var path_of_exile_music = $path_of_exile_music
onready var frostveil_Shrine_music = $frostveil_Shrine_music
onready var crimson_Abyss_Forge_music = $crimson_Abyss_Forge_music
onready var Cursed_Abyssal_Reef_music = $Cursed_Abyssal_Reef_music
onready var FinalBoss = $FinalBos
onready var hitsound = $hit
onready var rest = $rest_sound
onready var title = $AnimatedSprite2
onready var deadtp = $deadtp
onready var deadeff = $"../CanvasLayer/deadteffect"
onready var finalboss = $"../FinalBoss"
onready var door = $"../finalTileMap"
var downdoor = 5
var enter = false
var idle = true
var attack = true
var cooldown = true
var attanim = true
var dead = false
var StopMusic = false
var finalbossMusic = false
var bajarfinalbossMusic = 0.5
var startpos = Vector2()
var previous_player_lives = PlayerLives
var crab
var crab2
var crab3
var crab4
var crab5
var crab6
var crab7
var crab8
var bear
var bear2
var bear3
var bear4
var bear5
var bear6
var bear7
var bear8
var bear9
var iceMonster
var iceMonster2
var iceMonster3
var iceMonster4
var iceMonster5
var iceMonster6
var iceMonster7
var iceMonster8
var iceMonster9
var iceMonster10
var iceMonster11
var iceMonsterBoss
var iceMonsterBoss2
var iceMonsterBoss3
var iceMonsterBoss4
var bearWizard
var bearWizard2
var bearWizard3
var fireworm
var fireworm2
var fireworm3
var fireworm4
var fireWalker
var fireWalker2
var fireWalker3
onready var finalBoss = get_node("../FinalBoss")
var collision_disabled = false
func enemies():
	crab = get_node("../crab")
	crab.respawn()
	crab2 = get_node("../crab2")
	crab2.respawn()
	crab3 = get_node("../crab3")
	crab3.respawn()
	crab4 = get_node("../crab4")
	crab4.respawn()
	crab5 = get_node("../crab5")
	crab5.respawn()
	crab6 = get_node("../crab6")
	crab6.respawn()
	crab7 = get_node("../crab7")
	crab7.respawn()
	crab8 = get_node("../crab8")
	crab8.respawn()
	Crablives =2
	
	bear = get_node("../bear")
	bear.respawn()
	bear2 = get_node("../bear2")
	bear2.respawn()
	bear5 = get_node("../bear5")
	bear5.respawn()
	bear6 = get_node("../bear6")
	bear6.respawn()
	bear7 = get_node("../bear7")
	bear7.respawn()
	bear8 = get_node("../bear8")
	bear8.respawn()
	Bearlives = 3
	
	iceMonster = get_node("../iceMonster")
	iceMonster.respawn()
	iceMonster2 = get_node("../iceMonster2")
	iceMonster2.respawn()
	iceMonster3 = get_node("../iceMonster3")
	iceMonster3.respawn()
	iceMonster4 = get_node("../iceMonster4")
	iceMonster4.respawn()
	iceMonster5 = get_node("../iceMonster5")
	iceMonster5.respawn()
	iceMonster6 = get_node("../iceMonster6")
	iceMonster6.respawn()
	iceMonster7 = get_node("../iceMonster7")
	iceMonster7.respawn()
	iceMonster8 = get_node("../iceMonster8")
	iceMonster8.respawn()
	iceMonster9 = get_node("../iceMonster9")
	iceMonster9.respawn()
	iceMonster10 = get_node("../iceMonster10")
	iceMonster10.respawn()
	iceMonster11 = get_node("../iceMonster11")
	iceMonster11.respawn()
	iceMonsterBoss = get_node("../iceMonsterBoss")
	iceMonsterBoss.respawn()
	iceMonsterBoss2 = get_node("../iceMonsterBoss2")
	iceMonsterBoss2.respawn()
	iceMonsterBoss3 = get_node("../iceMonsterBoss3")
	iceMonsterBoss3.respawn()
	iceMonsterBoss4 = get_node("../iceMonsterBoss4")
	iceMonsterBoss4.respawn()
	IceMonsterLives = 4
	
	bearWizard = get_node("../bearWizard")
	bearWizard.respawn()
	bearWizard2 = get_node("../bearWizard2")
	bearWizard.respawn()
	bearWizard3 = get_node("../bearWizard3")
	bearWizard.respawn()
	bearWizardLives = 4
	
	fireworm = get_node("../fireWorm")
	fireworm.respawn()
	fireworm = get_node("../fireWorm2")
	fireworm.respawn()
	fireworm = get_node("../fireWorm3")
	fireworm.respawn()
	fireworm = get_node("../fireWorm4")
	fireworm.respawn()
	fireWormLives = 4
	
	fireWalker = get_node("../fireWalker")
	fireWalker.respawn()
	fireWalker2 = get_node("../fireWalker2")
	fireWalker.respawn()
	fireWalker3 = get_node("../fireWalker3")
	fireWalker.respawn()
	fireWalkerLives = 6
	
	
	StopMusic = false
	finalbossMusic = false
	bajarfinalbossMusic = 0.5
	downdoor = 5
func _ready():

	original_camera_position = camera.position
	
	timerRest.wait_time = 2.8
	timerRest.one_shot = true
	timerRest.connect("timeout", self, "rest_timeout")
	
	deadeffect.wait_time = 0.5
	deadeffect.one_shot = true
	deadeffect.connect("timeout", self, "deadeffectF")
	
	sprite.connect("animation_finished", self, "_on_animation_finished")
	
	deadtp.wait_time = 1.65
	deadtp.one_shot = true
	deadtp.connect("timeout", self, "deadtpF")
	
	
	timercooldown.wait_time = cooldownAttack
	timercooldown.one_shot = true
	timercooldown.connect("timeout", self, "cooldown_timeout")
	
	startpos = get_parent().get_node("Startpos").position
	self.position = startpos

	
func _physics_process(delta):
	cooldownAttack = cooldownAttack
	if StopMusic:
		crimson_Abyss_Forge_music.volume_db -= 0.5
	if finalbossMusic:
		FinalBoss.volume_db += bajarfinalbossMusic
		door.position.y += downdoor
		if door.position.y >= 0:
			downdoor = 0
		if FinalBoss.volume_db >= -6:
			bajarfinalbossMusic = 0
	
	if camera_shake_timer > 0:
		camera_shake_timer -= delta  # Reduce el temporizador cada frame
		var random_offset = Vector2(rand_range(-shake_intensity, shake_intensity), rand_range(-shake_intensity, shake_intensity))
		camera.position = original_camera_position + random_offset  # Mantiene el movimiento de la cámara
	else:
		camera.position = original_camera_position  # Restaura la posición original de la cámara cuando termine el "shake"
	
	if PlayerLives != previous_player_lives:  # Solo si PlayerLives cambia
		match PlayerLives:
			4:
				$"../CanvasLayer/lives".play("4_4")
			3:
				$"../CanvasLayer/lives".play("3_4")
			2:
				$"../CanvasLayer/lives".play("2_4")
			1:
				$"../CanvasLayer/lives".play("1_4")   
		previous_player_lives = PlayerLives 
	
	if camera_shake_timer > 0:
		camera_shake_timer -= delta
		var random_offset = Vector2(rand_range(-shake_intensity, shake_intensity), rand_range(-shake_intensity, shake_intensity))
		camera.offset = random_offset
	else:
		camera.offset = Vector2(0, 0)  # Resetea la posición de la cámara cuando termine el temblor

	motion.y += gravity
	var friction = false
	if HitPlayer == false:
				
		if is_on_floor() and Input.is_action_just_pressed("attack") and idle and attack and cooldown and attanim:
			$Area2D/CollisionShape2D.disabled = false
			cooldown = false
			sprite.play("attack")
			attack = false
			timercooldown.start()
			attack_sound.play()
			attanim = false
			
		if is_on_floor() and Input.is_action_just_pressed("attack") and idle and attack and cooldown and attanim == false:
			$Area2D/CollisionShape2D.disabled = false
			cooldown = false
			sprite.play("attack 1")
			attack = false
			timercooldown.start()
			attack_sound2.play()
			attanim = true

		elif Input.is_action_pressed("ui_right") and idle and attack:
			sprite.flip_h = false
			$Area2D/CollisionShape2D.position.x = 43.5
			if is_on_floor():
				if sprite != null:
					sprite.play("walk")
				else:
					print("Error: 'sprite' es null en _physics_process")
			motion.x = min(motion.x + moveSpeed, maxSpeed)

		elif Input.is_action_pressed("ui_left") and idle and attack:
			sprite.flip_h = true
			$Area2D/CollisionShape2D.position.x = -43.5
			if is_on_floor():
				if sprite != null:
					sprite.play("walk")
				else:
					print("Error: 'sprite' es null en _physics_process")
			motion.x = max(motion.x - moveSpeed, -maxSpeed)
			
		elif Input.is_action_just_pressed("ui_accept") and enter and attack and is_on_floor():
			idle = false
			if sprite != null: 
				sprite.play("rest")
				rest.play()
				PlayerLives = 4
				enemies()
				startpos = self.position
			timerRest.start()


		elif idle and attack:
			if sprite != null:
				sprite.play("idle")
			else:
				print("Error: 'sprite' es null en _physics_process")
			friction = true

		if is_on_floor():
			if can_doublejump == false:
				moveSpeed = 43
				maxSpeed = 90
			can_doublejump = true
			if Input.is_action_just_pressed("ui_up") and idle and attack:
				sprite.play("jump")
				motion.y = jumpHeight
				jump1_sound.play()
			if friction == true:
				motion.x = lerp(motion.x, 0, 1)
		else:
			if friction == true:
				motion.x = lerp(motion.x, 0, 0.11)

		if can_doublejump and !is_on_floor() and Input.is_action_just_pressed("ui_up") and doubleJumpItem1 and doubleJumpItem2:
			jump2_sound.play()
			moveSpeed = 62
			maxSpeed = 124
			motion.y = jumpHeight - 28
			can_doublejump = false
			sprite.play("jump")
			
		if canDash:
			if dash_timer > 0:
				dash_timer -= delta
				motion.x = dash_speed if !sprite.flip_h else -dash_speed
				if dash_timer <= 0:
					is_dashing = false
					dash_cooldown_timer = dash_cooldown
			elif dash_cooldown_timer > 0:
				dash_cooldown_timer -= delta
			elif Input.is_action_just_pressed("shift") and is_on_floor() and !is_dashing and idle and attack:
				$Area2D2/CollisionShape2D.disabled = true
				idle = false
				is_dashing = true
				dash_timer = dash_duration
				sprite.play("dash")
	
	motion = move_and_slide(motion, up)
	
var PlayerLives = 4
func hit(damage):
	PlayerLives -= damage
	hitsound.play()
	shake_camera()
	HitPlayer = true
	motion = Vector2.ZERO
	if !sprite.flip_h:
		motion = Vector2(-100,-250)
	else:
		motion = Vector2(100,-250)
	sprite.play("hurt")
	
func updateCooldown(newCool):
	cooldownAttack = newCool
	timercooldown.wait_time = newCool
	timercooldown.stop()  # Detenemos el temporizador
	timercooldown.start()  # Lo volvemos a iniciar
	print(cooldownAttack)
	
func _on_animation_finished():
	if sprite.animation == "hurt":
		HitPlayer = false
		motion = Vector2.ZERO
		
	if sprite.animation == "dash":
		idle = true
		$Area2D2/CollisionShape2D.disabled = false
		
	if sprite.animation == "dead":
		HitPlayer = false
		self.position = startpos
		gravity = 15
		$Area2D2.position.y = 6
		deadeff.play("t")
		enemies()
		door.position.y = -165
		finalBoss.respawn()
		finalbossLives = 25
		
		
	if sprite.animation == "attack":
		$Area2D/CollisionShape2D.disabled = true
		attack = true
		
	if sprite.animation == "attack 1":
		$Area2D/CollisionShape2D.disabled = true
		attack = true
		
func deadtpF():
	self.position = startpos
	deadeff.play("t")
	enemies()
		
func deadeffectF():
	deadeff.play("default") 

func rest_timeout():
	idle = true
	
func cooldown_timeout():
	cooldown = true
	
func deadAnimF():
	dead = true

func addCoin():
	var canvasLayer = get_tree().get_root().find_node("CanvasLayer", true, false)
	canvasLayer.handleCoinCollected()

func _on_rest_body_entered(body):
	if body.name == "altar":
		enter = true
		$"../altar/ECopia".visible = true

func _on_rest_body_exited(body):
	if body.name == "altar":
		enter = false
		$"../altar/ECopia".visible = false
		
func dead():
	PlayerLives = 4
	sprite.play("dead")
	deadeffect.start()
	$Area2D2.position.y = -5000
	motion = Vector2.ZERO
	gravity = 0
	enemies()
	

func revive(body):
	if body.get_name() == "Player":
		deadtp.start()
		PlayerLives = 4
		deadeff.play("default")

func _on_DeadZones_body_entered(body):
	revive(body)
func _on_IceSpikeDown_body_entered(body):
	revive(body)
func _on_IceSpikeUp_body_entered(body):
	revive(body)
func _on_IceSpikeRight_body_entered(body):
	revive(body)
func _on_IceSpikeLeft_body_entered(body):
	revive(body)
func _on_FireSpikeRight_body_entered(body):
	revive(body)
func _on_FireSpikeLeft_body_entered(body):
	revive(body)
func _on_FireSpikeUp_body_entered(body):
	revive(body)

func _on_Area2D4_body_entered(body):
	if body.name == "Player":
		dragonslayer_desert_music.play()
		path_of_exile_music.stop()
		frostveil_Shrine_music.stop()
		crimson_Abyss_Forge_music.stop()
		Cursed_Abyssal_Reef_music.stop()
		
func _on_Area2D5_body_entered(body):
	if body.name == "Player":
		path_of_exile_music.play()
		dragonslayer_desert_music.stop()
		frostveil_Shrine_music.stop()
		crimson_Abyss_Forge_music.stop()
		Cursed_Abyssal_Reef_music.stop()
		
func _on_Area2D6_body_entered(body):
	if body.name == "Player":
		frostveil_Shrine_music.play()
		path_of_exile_music.stop()
		dragonslayer_desert_music.stop()
		crimson_Abyss_Forge_music.stop()
		Cursed_Abyssal_Reef_music.stop()

func _on_Area2D7_body_entered(body):
	if body.name == "Player":
		crimson_Abyss_Forge_music.play()
		crimson_Abyss_Forge_music.volume_db = -21
		FinalBoss.stop()
		frostveil_Shrine_music.stop()
		path_of_exile_music.stop()
		dragonslayer_desert_music.stop()
		Cursed_Abyssal_Reef_music.stop()
		

func _on_Area2D8_body_entered(body):
	if body.name == "Player":
		Cursed_Abyssal_Reef_music.play()
		crimson_Abyss_Forge_music.stop()
		frostveil_Shrine_music.stop()
		path_of_exile_music.stop()
		dragonslayer_desert_music.stop()
		moveSpeed = 20
		maxSpeed = 40
		jumpHeight = -123
		gravity = 2

func _on_Area2D8_body_exited(body):
	moveSpeed = 43
	maxSpeed = 90
	jumpHeight = -270
	gravity = 15

var Crablives = 2
var Bearlives = 3
var IceMonsterLives = 4
var bearWizardLives = 4
var fireWormLives = 5
var fireWalkerLives = 6
var finalbossLives = 25

func _on_Area2D_body_entered(body):
	if body.is_in_group("enemie"):
		shake_camera()
		Crablives -= 1
		body.hit()
		if Crablives == 0:
			body.dead()
			Crablives = 2
	if body.is_in_group("enemie1"):
		shake_camera()
		Bearlives -= 1
		body.hit()
		if Bearlives == 0:
			body.dead()
			Bearlives = 3
	if body.is_in_group("enemie2"):
		shake_camera()
		IceMonsterLives -= 1
		body.hit()
		if IceMonsterLives == 0:
			body.dead()
			IceMonsterLives = 4
	if body.is_in_group("enemie3"):
		shake_camera()
		IceMonsterLives -= 1
		body.hit()
		if IceMonsterLives == 0:
			body.dead()
			IceMonsterLives = 4
	if body.is_in_group("enemie4"):
		shake_camera()
		bearWizardLives -= 1
		body.hit()
		if bearWizardLives == 0:
			body.dead()
			bearWizardLives = 4
	if body.is_in_group("enemie5"):
		shake_camera()
		fireWormLives -= 1
		body.hit()
		if fireWormLives == 0:
			body.dead()
			fireWormLives = 5
	if body.is_in_group("enemie6"):
		shake_camera()
		fireWalkerLives -= 1
		body.hit()
		if fireWalkerLives == 0:
			body.dead()
			fireWalkerLives = 6
	if body.is_in_group("finalBoss"):
		shake_camera()
		finalbossLives -= 1
		body.hit()
		if finalbossLives == 0:
			body.dead()
			finalbossLives = 25
	

func shake_camera():
	camera_shake_timer = shake_duration  # Inicia el temporizador
	var random_offset = Vector2(rand_range(-shake_intensity, shake_intensity), rand_range(-shake_intensity, shake_intensity))
	camera.position = original_camera_position + random_offset  # Agita la cámara


func _on_Area2D2_body_entered(body):
	if body.is_in_group("enemie"):
		if PlayerLives != 0:
			hit(1)
	if body.is_in_group("enemie1"):
		if PlayerLives != 0:
			hit(1)
	if body.is_in_group("enemie2"):
		if PlayerLives != 0:
			hit(1)
	if body.is_in_group("enemie3"):
		if PlayerLives != 0:
			hit(2)
	if body.is_in_group("enemie4"):
		if PlayerLives != 0:
			hit(1)
	if body.is_in_group("fireball"):
		if PlayerLives != 0:
			hit(1)
	if body.is_in_group("enemie5"):
		if PlayerLives != 0:
			hit(2)
	if body.is_in_group("enemie6"):
		if PlayerLives != 0:
			hit(2)
	if body.is_in_group("finalBoss"):
		if PlayerLives != 0:
			hit(0)
	if PlayerLives == 0:
		dead()
		$"../CanvasLayer/lives".stop()

func _on_Area2D9_body_entered(body):
	if body.name == "Player":
		Cursed_Abyssal_Reef_music.stop()
		frostveil_Shrine_music.stop()
		path_of_exile_music.stop()
		dragonslayer_desert_music.stop()
		StopMusic = true
		finalBoss.respawnP = false

func _on_Area2D10_body_entered(body):
	if body.name == "Player":
		FinalBoss.play()
		finalbossMusic = true
