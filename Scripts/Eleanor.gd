extends Area2D

var text = 0
var enter = false
onready var next = $"../ControlCanvas/CanvasLayer/nextLabel"
onready var player = get_node("../Player")

func _on_Eleanor_body_entered(body):
	if body.name == "Player":
		enter = true
		$ECopia.visible = true
		
func _on_Eleanor_body_exited(body):
	if body.name == "Player":
		enter = false
		player.cooldown = true
		$ECopia.visible = false
		

func _process(delta):
	if Input.is_action_just_released("ui_accept") and enter:
		text += 1
		player.cooldown = false
		next.play()
	if text == 1:
		$"../ControlCanvas/CanvasLayer/PanelEleanor".visible = true
		$"../ControlCanvas/CanvasLayer/PanelEleanor/Eleanor1".visible = true
	if text == 2:
		$"../ControlCanvas/CanvasLayer/PanelEleanor/Eleanor1".visible = false
		$"../ControlCanvas/CanvasLayer/PanelEleanor/Eleanor2".visible = true
	if text == 3:
		$"../ControlCanvas/CanvasLayer/PanelEleanor/Eleanor2".visible = false
		$"../ControlCanvas/CanvasLayer/PanelEleanor/Eleanor3".visible = true
	if text == 4:
		$"../ControlCanvas/CanvasLayer/PanelEleanor/Eleanor3".visible = false
		$"../ControlCanvas/CanvasLayer/PanelEleanor".visible = false
		text = 0
				
	if enter == false:
		$"../ControlCanvas/CanvasLayer/PanelEleanor/Eleanor1".visible = false
		$"../ControlCanvas/CanvasLayer/PanelEleanor/Eleanor2".visible = false
		$"../ControlCanvas/CanvasLayer/PanelEleanor/Eleanor3".visible = false
		$"../ControlCanvas/CanvasLayer/PanelEleanor".visible = false
		text = 0
