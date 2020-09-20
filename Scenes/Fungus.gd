extends Area2D




func _on_Fungus_body_entered(body):
	if body.name == "Player":
		global.hit(1)
		$Timer.start()




func _on_Fungus_body_exited(body):
	if body.name == "Player":
		$Timer.stop()


func _on_Timer_timeout():
	global.hit(1)
