extends Area2D


func _on_Arrow_pack_body_entered(body):
	if body.name == "Player":
		randomize()
		global.arrows += randi()%5 + 1
		queue_free()
