extends Area2D

onready var ui = get_node("../ControlCanvas/CanvasLayer")
onready var player = get_node("../Player")
var text = 0
var enter = false
onready var next = $"../ControlCanvas/CanvasLayer/nextLabel"
var target_scales = {}
var lerp_speed = 15.0

func _ready():
	$AnimatedSprite.play("idle")

func _on_TraderCave_body_entered(body):
	if body.name == "Player":
		enter = true
		$ECopia.visible = true

func _on_TraderCave_body_exited(body):
	if body.name == "Player":
		enter = false
		$ECopia.visible = false
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader2".visible = false
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader2/LabelBible".visible = false
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader2/LabelNeckles".visible = false
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader2/LabelSword".visible = false
		player.cooldown = true

func _process(delta):
	# Aplicar la interpolación de escala a los botones
	for button in $"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTader2".get_children():
		if button.name in target_scales:
			button.rect_scale = lerp(
				button.rect_scale,
				target_scales[button.name],
				lerp_speed * delta
			)
	
	# Lógica del diálogo
	if Input.is_action_just_released("ui_accept") and enter:
		player.cooldown = false
		text += 1
		next.play()
	
	if text == 1:
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader".visible = true
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTrader1".visible = true
	elif text == 2:
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTrader1".visible = false
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTader2".visible = true
	elif text == 3:
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTader2".visible = false
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader".visible = false
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader2".visible = false
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader2/LabelBible".visible = false
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader2/LabelNeckles".visible = false
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader2/LabelSword".visible = false
		text = 0
	
	if not enter:
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTrader1".visible = false
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTader2".visible = false
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader".visible = false
		text = 0

func _on_Button_button_down():
	if ui.coins >= 25 and not $"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTader2/Button".disabled:
		target_scales["Button"] = Vector2(0.22, 0.20)

func _on_Button2_button_down():
	if ui.coins >= 15 and not $"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTader2/Button2".disabled:
		target_scales["Button2"] = Vector2(0.4, 0.4)

func _on_Button3_button_down():
	if ui.coins >= 15 and not $"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTader2/Button3".disabled:
		target_scales["Button3"] = Vector2(0.4, 0.4)

func _on_Button_mouse_entered():
	$"../ControlCanvas/CanvasLayer/PanelSnowTrader2".visible = true
	$"../ControlCanvas/CanvasLayer/PanelSnowTrader2/LabelBible".visible = true
	if not $"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTader2/Button".disabled:
		target_scales["Button"] = Vector2(0.26, 0.23)
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader/buttonHovered".play()
		
func _on_Button_mouse_exited():
	$"../ControlCanvas/CanvasLayer/PanelSnowTrader2".visible = false
	$"../ControlCanvas/CanvasLayer/PanelSnowTrader2/LabelBible".visible = false
	if not $"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTader2/Button".disabled:
		target_scales["Button"] = Vector2(0.25, 0.22)

func _on_Button2_mouse_entered():
	$"../ControlCanvas/CanvasLayer/PanelSnowTrader2".visible = true
	$"../ControlCanvas/CanvasLayer/PanelSnowTrader2/LabelNeckles".visible = true
	if not $"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTader2/Button2".disabled:
		target_scales["Button2"] = Vector2(0.46, 0.46)
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader/buttonHovered".play()

func _on_Button2_mouse_exited():
	$"../ControlCanvas/CanvasLayer/PanelSnowTrader2".visible = false
	$"../ControlCanvas/CanvasLayer/PanelSnowTrader2/LabelNeckles".visible = false
	if not $"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTader2/Button2".disabled:
		target_scales["Button2"] = Vector2(0.44, 0.44)

func _on_Button3_mouse_entered():
	$"../ControlCanvas/CanvasLayer/PanelSnowTrader2".visible = true
	$"../ControlCanvas/CanvasLayer/PanelSnowTrader2/LabelSword".visible = true
	if not $"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTader2/Button3".disabled:
		target_scales["Button3"] = Vector2(0.46, 0.46)
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader/buttonHovered".play()

func _on_Button3_mouse_exited():
	$"../ControlCanvas/CanvasLayer/PanelSnowTrader2".visible = false
	$"../ControlCanvas/CanvasLayer/PanelSnowTrader2/LabelSword".visible = false
	if not $"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTader2/Button3".disabled:
		target_scales["Button3"] = Vector2(0.44, 0.44)


func _on_Button_pressed():
	if ui.coins >= 25 and not $"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTader2/Button".disabled:
		target_scales["Button"] = Vector2(0.22, 0.20)
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTader2/Button".disabled = true
		ui.coins -= 25
		$"../ControlCanvas/CanvasLayer/Book06c".visible = true
		player.doubleJumpItem1 = true
		print("presed")
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader/buttonPressed".play()

func _on_Button2_pressed():
	if ui.coins >= 15 and not $"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTader2/Button2".disabled:
		target_scales["Button2"] = Vector2(0.4, 0.4)
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTader2/Button2".disabled = true
		ui.coins -= 15
		$"../ControlCanvas/CanvasLayer/Necklace02d".visible = true
		player.canDash = true
		print("presed")
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader/buttonPressed".play()


func _on_Button3_pressed():
	if ui.coins >= 15 and not $"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTader2/Button3".disabled:
		target_scales["Button3"] = Vector2(0.4, 0.4)
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTader2/Button3".disabled = true
		ui.coins -= 15
		$"../ControlCanvas/CanvasLayer/Item06".visible = true
		player.updateCooldown(0.5)
		print("presed")
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader/buttonPressed".play()
