extends KinematicBody2D

onready var state = "Idle"
var motion = Vector2()
onready var direction = 1
onready var can_shoot = true
var laser = preload("res://Scenes/Laser.tscn")
onready var shots = 0

func shoot():
	shots += 1
	var laser_instance = laser.instance()
	laser_instance.position = get_node("Laser_pos").get_global_position()
	get_tree().get_root().add_child(laser_instance)
	if shots >= 10:
		$Sprite.visible = false
		$CPUParticles2D.emitting = true
		state = "Dead"
		$Timer4.start()
		
func _ready():
	$Sprite.visible = true
	$CPUParticles2D.emitting = false

func _physics_process(delta):

	if state == "Idle":
		motion.x = 100 * direction
	if state == "Attack":
		if round(global.location / 10) == round(global_position.x / 10) && can_shoot:
			shoot()
			can_shoot = false
			$Timer2.start()
	if state == "Dead":
		motion.x = 0
	elif global.location < global_position.x + 64 && global.location > global_position.x - 64:
		state = "Attack"
	
	move_and_slide(motion)


func _on_Timer_timeout():
	direction = -direction


func _on_Timer2_timeout():
	can_shoot = true


func _on_Timer3_timeout():
	if state == "Attack":
		if global.location > global_position.x:
			motion.x = 50
		if global.location < global_position.x:
			motion.x = -50


func _on_Timer4_timeout():
	queue_free()
