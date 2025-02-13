extends Node

onready var pressed = $buttonPressed
onready var hovered = $buttonHovered
onready var controls = $Panel

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		self.visible = not get_tree().paused
		get_tree().paused = not get_tree().paused
		$Panel.visible = false
		$VBoxContainer4/Button4.visible = true
		$Label.visible = true
		$VBoxContainer3/Button3.visible = true
		$VBoxContainer2/Button2.visible = true
	
func _on_Button_pressed():
	pressed.play()
	get_tree().change_scene("res://Scenes/worldES.tscn")
	
func _on_Button2_pressed():
	pressed.play()
	get_tree().quit()

func _on_Button_mouse_entered():
	hovered.play()

func _on_Button2_mouse_entered():
	hovered.play()

func _on_Button3_pressed():
	$VBoxContainer4/Button4.visible = false
	$Label.visible = false
	$VBoxContainer3/Button3.visible = false
	$VBoxContainer2/Button2.visible = false
	controls.visible = true
	pressed.play()

func _on_back_pressed():
	$VBoxContainer4/Button4.visible = true
	$Label.visible = true
	$VBoxContainer3/Button3.visible = true
	$VBoxContainer2/Button2.visible = true
	controls.visible = false
	pressed.play()


func _on_Button4_pressed():
	pressed.play()
	self.visible = not get_tree().paused
	get_tree().paused = not get_tree().paused
