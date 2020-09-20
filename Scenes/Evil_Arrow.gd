extends KinematicBody2D

onready var x = 200
onready var y = 0.01
var dir
var motion = Vector2()

func _ready():
	if dir == -1:
		x = -x

	
func _physics_process(delta):
	y = 1.11*y
	x = x/1.002
	motion.y = y
	motion.x = x
	
	move_and_slide(motion)


func _on_Timer_timeout():
	queue_free()


func _on_Evil_Arrow_body_entered(body):
	if body.name == "Bowman":
		pass
	else:
		$Timer.start()
