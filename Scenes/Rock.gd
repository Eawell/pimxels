extends KinematicBody2D


var motion = Vector2()
const UP = Vector2(0, -1)

func _on_Damage_body_entered(body):
	if body.name == "Player":
		global.health = 0


func _on_Detector_body_entered(body):
	if is_on_floor():
		if body.name == "Player":
			jump()

func jump():
	motion.y = -400
	
func _physics_process(delta):
	if is_on_floor() == false:
		motion.y += 20
	move_and_slide(motion, UP)
