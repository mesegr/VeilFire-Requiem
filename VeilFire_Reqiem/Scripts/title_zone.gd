extends AnimatedSprite

onready var title = $"."
onready var bell = $AudioStreamPlayer
	
func _on_Area2D4_body_entered(body):
	if body.name == "Player":
		title.play("default")
		bell.play()
	
func _on_Area2D5_body_entered(body):
	if body.name == "Player":
		title.play("path")
		bell.play()

func _on_Area2D6_body_entered(body):
	if body.name == "Player":
		title.play("frostveil")
		bell.play()

func _on_Area2D7_body_entered(body):
	if body.name == "Player":
		title.play("crimson abyss")
		bell.play()

func _on_Area2D8_body_entered(body):
	if body.name == "Player":
		title.play("cursed abyssal")
		bell.play()
