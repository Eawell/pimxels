extends KinematicBody2D

onready var state = "Scared"
var motion = Vector2()
var direction
onready var health = global.level * 2
var damage = global.level * 7
var death = load("res://Other/Drops.gd").new()
var particles = preload("res://Scenes/Particles.tscn")

func die():
	death.coins = 15 
	death.drops = get_node("../Drops")
	death.pos = get_global_position()
	death.die()
	$Timer.start()

func _physics_process(delta):
	direction = (global.ID.global_position - global_position).normalized()
	$Sprites.animation = state
	if state == "Scared":
		$CollisionShape2D.disabled = false
		motion.x = 0
		motion.y = 0
	if state == "Attacking":
		$CollisionShape2D.disabled = false
		motion = 50 * direction
		if global.location < global_position.x:
			$Sprites.flip_h = false
		else:
			$Sprites.flip_h = true
		
	if $Detection.get_overlapping_bodies().has(global.ID):
		state = "Attacking"
	else:
		state = "Scared"
		
	move_and_slide(motion)


func _on_Area2D_area_entered(area):
	if state == "Scared":
		if area.name == "Melee_weapon":
			health -= global.equipped_melee.damage
		elif area.name == "Arrow":
			health -= global.equipped_ranged.damage
		if health <= 0:
			die()

func _on_Area2D_body_entered(body):
	if state == "Attacking":
		if body.name == "Player":
			$Timer2.start()
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
	var particles_instance = particles.instance()
	particles_instance.dying = "Ghost"
	particles_instance.position = get_global_position()
	get_tree().get_root().add_child(particles_instance)
	queue_free()


func _on_Timer2_timeout():
	global.hit(damage)


func _on_Area2D_body_exited(body):
	$Timer2.stop()
