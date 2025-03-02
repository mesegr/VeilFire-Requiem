extends Area2D

onready var ui = get_node("../CanvasLayer")
onready var player = get_node("../Player")
var text = 0
var enter = false
onready var next = $"../ControlCanvas/CanvasLayer/nextLabel"

func _ready():
	$AnimatedSprite.play("idle")


func _on_TraderCave_body_entered(body):
	if body.name == "Player":
		enter = true
		$ECopia.visible = true
		print("wiwi")

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
	if Input.is_action_just_released("ui_accept") and enter:
		player.cooldown = false
		text += 1
		next.play()
	if text == 1:
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader".visible = true
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTrader1".visible = true
	if text == 2:
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTrader1".visible = false
		$"../ControlCanvas//CanvasLayer/PanelSnowTrader/SnowTader2".visible = true
	if text == 3:
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTader2".visible = false
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader".visible = false
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader2".visible = false
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader2/LabelBible".visible = false
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader2/LabelNeckles".visible = false
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader2/LabelSword".visible = false
		text = 0
		
	if enter == false:
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTrader1".visible = false
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTader2".visible = false
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader".visible = false
		text = 0
		
func _on_Button_button_down():
	if ui.coins >= 25:
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTader2/Button".disabled = true
		ui.coins -= 25
		$"../ControlCanvas/CanvasLayer/Book06c".visible = true
		player.doubleJumpItem1 = true
	else:
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTader2/Button".disabled = false

func _on_Button2_button_down():
	if ui.coins >= 15:
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTader2/Button2".disabled = true
		ui.coins -= 15
		$"../ControlCanvas/CanvasLayer/Necklace02d".visible = true
		player.canDash = true
		
	else:
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTader2/Button2".disabled = false

func _on_Button3_button_down():
	if ui.coins >= 15:
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTader2/Button3".disabled = true
		ui.coins -= 15
		$"../ControlCanvas/CanvasLayer/Item06".visible = true
		player.updateCooldown(0.5)
	else:
		$"../ControlCanvas/CanvasLayer/PanelSnowTrader/SnowTader2/Button3".disabled = false


func _on_Button_mouse_entered():
	$"../ControlCanvas/CanvasLayer/PanelSnowTrader2".visible = true
	$"../ControlCanvas/CanvasLayer/PanelSnowTrader2/LabelBible".visible = true

func _on_Button_mouse_exited():
	$"../ControlCanvas/CanvasLayer/PanelSnowTrader2".visible = false
	$"../ControlCanvas/CanvasLayer/PanelSnowTrader2/LabelBible".visible = false


func _on_Button2_mouse_entered():
	$"../ControlCanvas/CanvasLayer/PanelSnowTrader2".visible = true
	$"../ControlCanvas/CanvasLayer/PanelSnowTrader2/LabelNeckles".visible = true

func _on_Button2_mouse_exited():
	$"../ControlCanvas/CanvasLayer/PanelSnowTrader2".visible = false
	$"../ControlCanvas/CanvasLayer/PanelSnowTrader2/LabelNeckles".visible = false

func _on_Button3_mouse_entered():
	$"../ControlCanvas/CanvasLayer/PanelSnowTrader2".visible = true
	$"../ControlCanvas/CanvasLayer/PanelSnowTrader2/LabelSword".visible = true

func _on_Button3_mouse_exited():
	$"../ControlCanvas/CanvasLayer/PanelSnowTrader2".visible = false
	$"../ControlCanvas/CanvasLayer/PanelSnowTrader2/LabelSword".visible = false
