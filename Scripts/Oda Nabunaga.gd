extends Area2D

var text = 0
var enter = false
onready var next = $"../ControlCanvas/CanvasLayer/nextLabel"
onready var player = get_node("../Player")

func _on_Oda_body_entered(body):
	if body.name == "Player":
		enter = true
		$ECopia.visible = true


func _on_Oda_body_exited(body):
	if body.name == "Player":
		enter = false
		$ECopia.visible = false
		player.cooldown = true
		
func _process(delta):
	if Input.is_action_just_released("ui_accept") and enter:
		text += 1
		next.play()
		player.cooldown = false
	if text == 1:
		$"../ControlCanvas/CanvasLayer/PanelOda".visible = true
		$"../ControlCanvas/CanvasLayer/PanelOda/Oda1".visible = true
	if text == 2:
		$"../ControlCanvas/CanvasLayer/PanelOda/Oda1".visible = false
		$"../ControlCanvas/CanvasLayer/PanelOda/Oda2".visible = true
	if text == 3:
		$"../ControlCanvas/CanvasLayer/PanelOda/Oda2".visible = false
		$"../ControlCanvas/CanvasLayer/PanelOda/Oda3".visible = true
	if text == 4:
		$"../ControlCanvas/CanvasLayer/PanelOda/Oda3".visible = false
		$"../ControlCanvas/CanvasLayer/PanelOda".visible = false
		text = 0
				
	if enter == false:
		$"../ControlCanvas/CanvasLayer/PanelOda/Oda1".visible = false
		$"../ControlCanvas/CanvasLayer/PanelOda/Oda2".visible = false
		$"../ControlCanvas/CanvasLayer/PanelOda/Oda3".visible = false
		$"../ControlCanvas/CanvasLayer/PanelOda".visible = false
		text = 0




