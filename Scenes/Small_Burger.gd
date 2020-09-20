extends KinematicBody2D

export var time = 2
export var timer = 1
var motion = Vector2()
var speed = 50
var angry_speed = 110
onready var health = global.level * 2
onready var damage = global.level * 2
const UP = Vector2(0, -1)
onready var direction = 1
onready var check_right = $RightView
onready var check_left = $LeftView
onready var angry = false
var death = load("res://Other/Drops.gd").new()
var particles = preload("res://Scenes/Particles.tscn")

func _ready():
	if timer == 0:
		$Timer.stop()
	$Timer.wait_time = time
	

func _physics_process(delta):
	angry = false
	motion.x = direction * speed
	if $Right.is_colliding():
		pass
	else:
		direction = -1
	if $Left.is_colliding():
		pass
	else:
		 direction = 1

	if direction == 1:
		$AnimatedSprite.flip_h = false
		$RightView.enabled = true
		$LeftView.enabled = false
	elif direction == -1:
		$AnimatedSprite.flip_h = true
		$RightView.enabled = false
		$LeftView.enabled = true

	if $RightWall.is_colliding():
		direction = -1
		if timer != 0:
			$Timer.stop()
			$Timer.start()
	elif $LeftWall.is_colliding():
		direction = 1
		if timer != 0:
			$Timer.stop()
			$Timer.start()
	
	if check_left.get_collider() == global.ID:
		angry = true
		motion.x = direction * angry_speed
	if check_right.get_collider() == global.ID:
		angry = true
		motion.x = direction * angry_speed
		
	if angry == true:
		$AnimatedSprite.animation = "Angry"
	elif angry == false:
		$AnimatedSprite.animation = "Normal"
	
	motion = move_and_slide(motion, UP)


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		$Timer3.start()
	if body.name == "Player" && global.invincibility == false:
		global.wait = 1
		global.hit(damage)
		if global.location > global_position.x:
			global.ID.motion.x = 400
		elif global.location < global_position.x:
			global.ID.motion.x = -400
		global.invincibility = true
		global.stun.start()
	
func die():
	death.coins = 6
	death.get_tree = get_tree()
	death.pos = get_global_position()
	death.die()
	$Timer2.start()
	

func _on_Area2D_area_entered(area):
	if area.name == "Melee_weapon":
		health -= global.equipped_melee.damage
	elif area.name == "Arrow":
		health -= global.equipped_ranged.damage
	if health <= 0:
		die()

func _on_Timer_timeout():
	if timer != 0:
		direction = -direction


func _on_Timer2_timeout():
	var particles_instance = particles.instance()
	particles_instance.dying = "Burgers"
	particles_instance.position = get_global_position()
	get_tree().get_root().add_child(particles_instance)
	queue_free()




func _on_Timer3_timeout():
	global.hit(damage)


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		$Timer3.stop()
