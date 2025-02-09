extends Area2D

var text = 0
var enter = false
onready var next = $"../CanvasLayer/nextLabel"

func _on_Oda_body_entered(body):
	if body.name == "Player":
		enter = true
		$ECopia.visible = true


func _on_Oda_body_exited(body):
	if body.name == "Player":
		enter = false
		$ECopia.visible = false
		
func _process(delta):
	if Input.is_action_just_released("ui_accept") and enter:
		text += 1
		next.play()
	if text == 1:
		$"../CanvasLayer/PanelOda".visible = true
		$"../CanvasLayer/PanelOda/Oda1".visible = true
	if text == 2:
		$"../CanvasLayer/PanelOda/Oda1".visible = false
		$"../CanvasLayer/PanelOda/Oda2".visible = true
	if text == 3:
		$"../CanvasLayer/PanelOda/Oda2".visible = false
		$"../CanvasLayer/PanelOda/Oda3".visible = true
	if text == 4:
		$"../CanvasLayer/PanelOda/Oda3".visible = false
		$"../CanvasLayer/PanelOda".visible = false
		text = 0
				
	if enter == false:
		$"../CanvasLayer/PanelOda/Oda1".visible = false
		$"../CanvasLayer/PanelOda/Oda2".visible = false
		$"../CanvasLayer/PanelOda/Oda3".visible = false
		$"../CanvasLayer/PanelOda".visible = false
		text = 0




