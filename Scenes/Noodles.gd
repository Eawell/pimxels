extends Area2D


func _process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			global.ID.shield()
			global.shield = true
			queue_free()
