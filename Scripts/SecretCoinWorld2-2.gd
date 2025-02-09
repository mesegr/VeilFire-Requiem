extends Area2D

export var teleport_destination: Vector2

func _on_Area2D2_body_entered(body):
	if body.get_name() == "Player":
		body.position = teleport_destination
