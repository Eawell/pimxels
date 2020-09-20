extends Area2D








func _on_Heart_body_entered(body):
	if body.name == "Player":
		global.health += 1
		queue_free()
