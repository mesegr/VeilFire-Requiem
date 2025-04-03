extends Node

onready var pressed = $buttonPressed
onready var hovered = $buttonHovered
onready var controls = $Panel
onready var Player = $"../../../Player"
var target_scales = {}
var lerp_speed = 15.0  # Velocidad de la interpolación (ajusta según necesites)
var tween = Tween.new()  # Crea un nodo Tween
var fade_speed = 0.2 
var mapPositions = {}
var pos
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
	madeMapVisible()
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
	if Input.is_action_just_pressed("q") and self.visible:
		$changePage.play()
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
			
	if Input.is_action_just_pressed("ui_accept") and self.visible:
		$changePage.play()
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

func madeMapVisible():
	if Player != null:
		pos = Player.position
	if pos.y <= 120:
		if pos.x >= -4585 and pos.x <= -3500:
			$"Map/ScrollContainer/Control/Sprite-0004".visible = true
		if pos.x >= -3500 and pos.x <= -2400:
			$"Map/ScrollContainer/Control/Sprite-0003".visible = true
		if pos.x >= -2400 and pos.x <= -1400:
			$"Map/ScrollContainer/Control/Sprite-0005".visible = true
			if pos.y >= 61 and pos.y <= 250:
				$"Map/ScrollContainer/Control/Sprite-0006".visible = true
		if pos.x >= -1400 and pos.x <= -500:
			$"Map/ScrollContainer/Control/Sprite-0007".visible = true
		if pos.x >= -500 and pos.x <= 200:
			$"Map/ScrollContainer/Control/Sprite-0008".visible = true
		if pos.x >= 200 and pos.x <= 675:
			$"Map/ScrollContainer/Control/Sprite-0009".visible = true
		if pos.x >= 675 and pos.x <= 1350:
			$"Map/ScrollContainer/Control/Sprite-0010".visible = true
		if pos.x >= 1350 and pos.x <= 2050:
			$"Map/ScrollContainer/Control/Sprite-0030".visible = true
		if pos.x >= 2050 and pos.x <= 2590:
			$"Map/ScrollContainer/Control/Sprite-0011".visible = true
		if pos.x >= 2590 and pos.x <= 3200:
			$"Map/ScrollContainer/Control/Sprite-0012".visible = true
		if pos.y >= - 600:
			if pos.x >= 3200 and pos.x <= 3600:
				$"Map/ScrollContainer/Control/Sprite-0027".visible = true
			if pos.x >= 4127 and pos.x <= 5000:
				$"Map/ScrollContainer/Control/Sprite-0021".visible = true
			if pos.x >= 5000 and pos.x <= 5835:
				$"Map/ScrollContainer/Control/Sprite-0022".visible = true
	if pos.x >= -2400 and pos.x <= -1400 and pos.y >= 250 and pos.y <= 580:
		$"Map/ScrollContainer/Control/Sprite-0002".visible = true
	if pos.y >= 190 and pos.y <= 200:
		if pos.x >= 200 and pos.x <= 675:
			$"Map/ScrollContainer/Control/Sprite-0013".visible = true
		if pos.x >= 2050 and pos.x <= 2590:
			$"Map/ScrollContainer/Control/Sprite-0014".visible = true
	if pos.y >= 200 and pos.y <= 800:
		if pos.x >= 200 and pos.x <= 675:
			$"Map/ScrollContainer/Control/Sprite-0015".visible = true
		if pos.x >= 675 and pos.x <= 1350:
			$"Map/ScrollContainer/Control/Sprite-0017".visible = true
		if pos.x >= 1350 and pos.x <= 2050:
			$"Map/ScrollContainer/Control/Sprite-0029".visible = true
		if pos.x >= 2050 and pos.x <= 2590:
			$"Map/ScrollContainer/Control/Sprite-0016".visible = true
	if pos.y <= - 600:
		if pos.x >= 3600 and pos.x <= 4050:
			$"Map/ScrollContainer/Control/Sprite-0028".visible = true
			$"Map/ScrollContainer/Control/Sprite-0018".visible = true
		if pos.x >= 4050 and pos.x <= 4900:
			$"Map/ScrollContainer/Control/Sprite-0019".visible = true
		if pos.x >= 4900 and pos.x <= 6300:
			$"Map/ScrollContainer/Control/Sprite-0020".visible = true
		if pos.x >= 6300 and pos.x <= 7500:
			$"Map/ScrollContainer/Control/Sprite-0031".visible = true
		if pos.x >= 7500 and pos.x <= 9050:
			$"Map/ScrollContainer/Control/Sprite-0023".visible = true
		if pos.x >= 9050 and pos.x <= 10730:
			$"Map/ScrollContainer/Control/Sprite-0024".visible = true
		if pos.x >= 10730 and pos.x <= 12000:
			$"Map/ScrollContainer/Control/Sprite-0025".visible = true
		if pos.x >= 12000 and pos.x <= 13260:
			$"Map/ScrollContainer/Control/Sprite-0032".visible = true
		if pos.x >= 13260 and pos.x <= 15000:
			$"Map/ScrollContainer/Control/Sprite-0026".visible = true
