extends Area2D

var text = 0
var enter = false
onready var next = $"../CanvasLayer/nextLabel"
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
		$"../CanvasLayer/PanelEleanor".visible = true
		$"../CanvasLayer/PanelEleanor/Eleanor1".visible = true
	if text == 2:
		$"../CanvasLayer/PanelEleanor/Eleanor1".visible = false
		$"../CanvasLayer/PanelEleanor/Eleanor2".visible = true
	if text == 3:
		$"../CanvasLayer/PanelEleanor/Eleanor2".visible = false
		$"../CanvasLayer/PanelEleanor/Eleanor3".visible = true
	if text == 4:
		$"../CanvasLayer/PanelEleanor/Eleanor3".visible = false
		$"../CanvasLayer/PanelEleanor".visible = false
		text = 0
				
	if enter == false:
		$"../CanvasLayer/PanelEleanor/Eleanor1".visible = false
		$"../CanvasLayer/PanelEleanor/Eleanor2".visible = false
		$"../CanvasLayer/PanelEleanor/Eleanor3".visible = false
		$"../CanvasLayer/PanelEleanor".visible = false
		player.cooldown = true
		text = 0
