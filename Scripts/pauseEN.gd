extends Node

onready var pressed = $buttonPressed
onready var hovered = $buttonHovered
onready var controls = $Panel
onready var Player = $"../../../Player"
var target_scales = {}
var lerp_speed = 15.0  # Velocidad de la interpolación (ajusta según necesites)
var tween = Tween.new()  # Crea un nodo Tween
var fade_speed = 0.2 

func _ready():
	add_child(tween)
	$Options.visible = true
	$Inventory.visible = false
	$Map.visible = false
	
	$Options/ControlsPanel.visible = false  # Invisible al inicio
	$Options/ControlsPanel.modulate = Color(1, 1, 1, 0)  # Completamente transparente
	$Options/ButtonsContainer.visible = true  # Visible al inicio
	$Options/ButtonsContainer.modulate = Color(1, 1, 1, 1)
	
func _process(delta):
	showItems()
	changePanel()
	# Botones dentro del contenedor
	for button in $Options/ButtonsContainer.get_children():
		if button.name in target_scales:
			button.rect_scale = lerp(
				button.rect_scale,
				target_scales[button.name],
				lerp_speed * delta
			)
	# Botón adicional fuera del contenedor
	if "ButtonBackControls" in target_scales:
		$Options/ControlsPanel/ButtonBackControls.rect_scale = lerp(
			$Options/ControlsPanel/ButtonBackControls.rect_scale,
			target_scales["ButtonBackControls"],
			lerp_speed * delta
		)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		self.visible = not get_tree().paused
		get_tree().paused = not get_tree().paused

func _on_ButtonContinueGame_mouse_entered():
	if !$Options/ButtonsContainer/ButtonContinueGame.disabled:
		target_scales["ButtonContinueGame"] = Vector2(1.1, 1.05)
		hovered.play()
func _on_ButtonContinueGame_mouse_exited():
	target_scales["ButtonContinueGame"] = Vector2(1, 1)
func _on_ButtonContinueGame_button_down():
	pressed.play()
	self.visible = not get_tree().paused
	get_tree().paused = not get_tree().paused

func _on_ButtonControls_mouse_entered():
	if !$Options/ButtonsContainer/ButtonControls.disabled:
		target_scales["ButtonControls"] = Vector2(1.1, 1.05)
		hovered.play()
func _on_ButtonControls_mouse_exited():
	target_scales["ButtonControls"] = Vector2(1, 1)
func _on_ButtonControls_button_down():
	pressed.play()
	$Options/ButtonsContainer/ButtonContinueGame.disabled = true
	$Options/ButtonsContainer/ButtonControls.disabled = true
	$Options/ButtonsContainer/ButtonQuitGame.disabled = true
	$Options/ControlsPanel.visible = true  # Activa el panel para que pueda ser interpolado

	# Animación de fade in para ControlsPanel
	tween.interpolate_property(
		$Options/ControlsPanel, "modulate",
		Color(1, 1, 1, 0), Color(1, 1, 1, 1),  # Desde transparente hasta visible
		fade_speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)

	tween.start()

func _on_ButtonQuitGame_mouse_entered():
	if !$Options/ButtonsContainer/ButtonQuitGame.disabled:
		target_scales["ButtonQuitGame"] = Vector2(1.1, 1.05)
		hovered.play()
func _on_ButtonQuitGame_mouse_exited():
	target_scales["ButtonQuitGame"] = Vector2(1, 1)
func _on_ButtonQuitGame_button_down():
	pressed.play()
	var timer = Timer.new()
	timer.wait_time = 0.6  # Espera 0.5 segundos
	timer.one_shot = true  # El Timer se detiene después de ejecutarse una vez
	add_child(timer)  # Añade el Timer a la escena
	timer.start()
	yield(timer, "timeout")
	get_tree().quit()
	
func _on_ButtonBackControls_mouse_entered():
	hovered.play()
	target_scales["ButtonBackControls"] = Vector2(0.35, 0.37)
func _on_ButtonBackControls_mouse_exited():
	target_scales["ButtonBackControls"] = Vector2(0.32, 0.32)
func _on_ButtonBackControls_button_down():
	pressed.play()
	$Options/ButtonsContainer/ButtonContinueGame.disabled = false
	$Options/ButtonsContainer/ButtonControls.disabled = false
	$Options/ButtonsContainer/ButtonQuitGame.disabled = false
	tween.interpolate_property(
		$Options/ControlsPanel, "modulate",
		Color(1, 1, 1, 1), Color(1, 1, 1, 0),  # Desde visible hasta transparente
		fade_speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)

	# Inicia las animaciones
	tween.start()
# Espera a que la animación del Tween termine
	yield(tween, "tween_completed")

	# Hace invisible el panel después de la transición
	$Options/ControlsPanel.visible = false

func changePanel():
	if Input.is_action_just_pressed("q"):
		
		if $Options.visible == true:
			$Options.visible = false
			$Options/ControlsPanel.visible = false
			$Map.visible = false
			$Inventory.visible = true
			print("options visible")
			
		elif $Inventory.visible == true:
			$Options.visible = false
			$Options/ControlsPanel.visible = false
			$Map.visible = true
			$Inventory.visible = false
			print("inventory visible")
			
		elif $Map.visible == true:
			$Options.visible = true
			$Map.visible = false
			$Inventory.visible = false
			print("map visible")
	if Input.is_action_just_pressed("ui_accept"):
		
		if $Options.visible == true:
			$Options.visible = false
			$Options/ControlsPanel.visible = false
			$Map.visible = true
			$Inventory.visible = false
			print("options visible")
			
		elif $Inventory.visible == true:
			$Options.visible = true
			$Map.visible = false
			$Inventory.visible = false
			print("inventory visible")
			
		elif $Map.visible == true:
			$Options.visible = false
			$Options/ControlsPanel.visible = false
			$Map.visible = false
			$Inventory.visible = true
			print("map visible")

func _on_Obj1_focus_entered():
	$InventorybuttonPressed.play()
	if $Inventory/Obj1/Bible1.visible:
		$Inventory/Obj1/Bible1Desc.visible = true
func _on_Obj1_focus_exited():
	$Inventory/Obj1/Bible1Desc.visible = false

func _on_Obj2_focus_entered():
	$InventorybuttonPressed.play()
	if 	$Inventory/Obj2/Bible2.visible:
		$Inventory/Obj2/Bible2Desc.visible = true
func _on_Obj2_focus_exited():
	$Inventory/Obj2/Bible2Desc.visible = false

func _on_Obj3_focus_entered():
	$InventorybuttonPressed.play()
	if $Inventory/Obj3/Sword.visible:
		$Inventory/Obj3/SwordDesc.visible = true
func _on_Obj3_focus_exited():
	$Inventory/Obj3/SwordDesc.visible = false

func _on_Obj4_focus_entered():
	$InventorybuttonPressed.play()
	if $Inventory/Obj4/Necklace.visible:
		$Inventory/Obj4/NeclaceDesc.visible =  true
func _on_Obj4_focus_exited():
	$Inventory/Obj4/NeclaceDesc.visible =  false

func _on_Obj5_focus_entered():
	$InventorybuttonPressed.play()
func _on_Obj5_focus_exited():
	pass # Replace with function body.

func _on_Obj6_focus_entered():
	$InventorybuttonPressed.play()
func _on_Obj6_focus_exited():
	pass # Replace with function body.

func _on_Obj7_focus_entered():
	$InventorybuttonPressed.play()
func _on_Obj7_focus_exited():
	pass # Replace with function body.

func _on_Obj8_focus_entered():
	$InventorybuttonPressed.play()
func _on_Obj8_focus_exited():
	pass # Replace with function body.

func showItems():
	if Player.doubleJumpItem1 == true:
		$Inventory/Obj1/Bible1.visible = true
	if Player.doubleJumpItem2 == true:
		$Inventory/Obj2/Bible2.visible = true
	if Player.canDash == true:
		$Inventory/Obj4/Necklace.visible = true
	if Player.cooldownAttack <= 0.40:
		$Inventory/Obj3/Sword.visible = true
