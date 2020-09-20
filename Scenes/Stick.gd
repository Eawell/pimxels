extends KinematicBody2D

var damage = 10
var motion = Vector2()

func _ready():
	motion = 200 * ($Front.global_position - global_position).normalized()

func _physics_process(delta):
	move_and_slide(motion)

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		$Timer.start()
	if body.name == "Player" && global.invincibility == false:
		global.wait = 1
		global.hit(damage)
		if global.location > global_position.x:
			global.ID.motion.x = 400
		elif global.location < global_position.x:
			global.ID.motion.x = -400
		global.invincibility = true
		global.stun.start()


func _on_Timer_timeout():
		queue_free()
