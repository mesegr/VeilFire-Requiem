extends Area2D

export var teleport_destination: Vector2


func _on_Area2D_body_entered(body):
	if body.get_name() == "Player":
		body.position = teleport_destination
