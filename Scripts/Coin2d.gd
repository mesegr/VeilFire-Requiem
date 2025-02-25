extends Area2D

onready var pickup = $"../pickup"
onready var sprite = $Sprite
var canPick = true
var isPicked = false


func _on_JumpBook_body_entered(body):
	if body.get_name() == "Player" and canPick:
		body.doubleJumpItem2 = true
		sprite.play("pickup")
		pickup.play()
		canPick = false
		yield(sprite, "animation_finished")
		isPicked = true
			

func _on_Coin_body_entered(body):
	if body.get_name() == "Player" and canPick:
		body.addCoin()
		sprite.play("pickup")
		pickup.play()
		canPick = false
		yield(sprite, "animation_finished")
		isPicked = true
		
func _process(delta):
	if isPicked:
		visible = false  
		set_process(false)
