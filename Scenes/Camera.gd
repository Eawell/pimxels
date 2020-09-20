extends Camera2D

func _physics_process(delta):
	global_position = global.camera_pos
	if global.health <= 0:
		current = true
