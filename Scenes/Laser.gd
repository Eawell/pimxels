extends KinematicBody2D

var motion = Vector2()

	
func _physics_process(delta):
	motion.y = 100

	
	move_and_slide(motion)



func _on_Timer_timeout():
	queue_free()


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		global.hit(1)
	if body.name == "Millenium_Falcon":
		pass
	else:
		$Timer.start()
