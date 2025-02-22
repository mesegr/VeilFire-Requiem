extends Area2D

onready var pickup = $"../pickup"
onready var sprite = $Sprite
func _on_Coin2d_body_entered(body):
	if body.get_name() == "Player":
		body.addCoin()
		sprite.play("pickup")
		pickup.play()
		yield(sprite, "animation_finished")
		queue_free()
		pass 

func _on_JumpBook_body_entered(body):
	if body.get_name() == "Player":
			body.doubleJumpItem2 = true
			sprite.play("pickup")
			pickup.play()
			yield(sprite, "animation_finished")
			queue_free()
			
