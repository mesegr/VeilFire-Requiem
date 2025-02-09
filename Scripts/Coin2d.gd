extends Area2D

onready var pickup = $"../pickup"

func _on_Coin2d_body_entered(body):
	
	if body.get_name() == "Player":
		body.addCoin()
		pickup.play()
		queue_free()
		pass 


func _on_JumpBook_body_entered(body):
	if body.get_name() == "Player":
			body.doubleJumpItem2 = true
			pickup.play()
			queue_free()
			
