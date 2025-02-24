extends Control

onready var pressed = $buttonPressed
onready var hovered = $buttonHovered
onready var controls = $Panel
	
func _on_Button_pressed():
	pressed.play()
	get_tree().change_scene("res://Scenes/worldEN.tscn")
	SaveSystem.load_game()
	$MenuTheme.stop()
	
func _on_Button2_pressed():
	pressed.play()
	get_tree().quit()

func _on_Button_mouse_entered():
	hovered.play()

func _on_Button2_mouse_entered():
	hovered.play()

func _on_Button3_pressed():
	$VBoxContainer/Button.visible = false
	$VBoxContainer3/Button3.visible = false
	$VBoxContainer2/Button2.visible = false
	controls.visible = true
	pressed.play()

func _on_back_pressed():
	$VBoxContainer/Button.visible = true
	$VBoxContainer3/Button3.visible = true
	$VBoxContainer2/Button2.visible = true
	controls.visible = false
	pressed.play()


func _on_Button4_pressed():
	$Language.visible = !$Language.visible
	pressed.play()


func _on_EN_pressed():
	pressed.play()


func _on_ES_pressed():
	pressed.play()
	get_tree().change_scene("res://Scenes/Main_menuES.tscn")
