extends KinematicBody2D

onready var direction = 1
var motion = Vector2()
var speed = 50
var angry_speed = 160
onready var health = global.level * 4
var damage = global.level * 5
const UP = Vector2(0, -1)
onready var check_right = $RightView
onready var check_left = $LeftView
onready var running = true
onready var wait = 0
var death = load("res://Other/Drops.gd").new()
var particles = preload("res://Scenes/Particles.tscn")

func _physics_process(delta):
	if direction == 1:
		$AnimatedSprite.flip_h = false
		$CollisionShape2D.position.x = -1
		$Area2D/CollisionShape2D.position.x = 0.5
		$RightView.enabled = true
		$LeftView.enabled = false
	elif direction == -1:
		$AnimatedSprite.flip_h = true
		$CollisionShape2D.position.x = 1
		$Area2D/CollisionShape2D.position.x = -1
		$RightView.enabled = false
		$LeftView.enabled = true
	if wait == 0:
		motion.x = direction * speed
	if $Right.is_colliding():
		pass
	else:
		if direction == 1:
			direction = -1
			wait = 0
	if $Left.is_colliding():
		pass
	else:
		if direction == -1:
			direction = 1
			wait = 0

	if $RightWall.is_colliding():
		if direction == 1:
			direction = -1
			wait = 0
	if $LeftWall.is_colliding():
		if direction == -1:
			direction = 1
			wait = 0
	if wait == 0:
		if check_left.get_collider() == global.ID:
			wait = 1
			running = false
			motion.x = 0
			$Timer2.start()
		if check_right.get_collider() == global.ID:
			wait = 1
			running = false
			motion.x = 0
			$Timer2.start()
		
	if running == true:
		$AnimatedSprite.animation = "Running"
	elif running == false:
		$AnimatedSprite.animation = "Idle"
	
	motion = move_and_slide(motion, UP)


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		$Timer3.start()
		wait = 0
		if global.invincibility == false:
			global.wait = 1
			global.hit(damage)
			if global.location > global_position.x:
				global.ID.motion.x = 600
			elif global.location < global_position.x:
				global.ID.motion.x = -600
			global.invincibility = true
			global.stun.start()
		
func die():
	death.coins = 10
	death.drops = get_node("../Drops")
	death.pos = get_global_position()
	death.die()
	$Timer.start()
	

func _on_Area2D_area_entered(area):
	if area.name == "Melee_weapon":
		health -= global.equipped_melee.damage
	elif area.name == "Arrow":
		health -= global.equipped_ranged.damage
	if health <= 0:
		die()

func _on_Timer_timeout():
	var particles_instance = particles.instance()
	particles_instance.dying = "Buffalo"
	particles_instance.position = get_global_position() + Vector2(0,8)
	get_tree().get_root().add_child(particles_instance)
	queue_free()


func _on_Timer2_timeout():
	running = true
	motion.x = direction * angry_speed


func _on_Timer3_timeout():
	global.hit(damage)


func _on_Area2D_body_exited(body):
	$Timer3.stop()
