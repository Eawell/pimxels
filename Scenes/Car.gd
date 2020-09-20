extends Area2D


func _process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			global.ID.boost()
			global.boost = 1.8
			queue_free()
