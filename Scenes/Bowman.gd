extends KinematicBody2D

var motion = Vector2()
var speed = 150
onready var health = global.level * 7
var damage = global.level * 6
onready var direction = 1
onready var state = "Idle"
var fire_rate = 0.8
var arrow_speed = 200
onready var can_fire = true
var bow
var arrow_pos
var turn
var death = load("res://Other/Drops.gd").new()
var particles = preload("res://Scenes/Particles.tscn")
var arrow = preload("res://Scenes/Evil_Arrow.tscn")

func _ready():
	$Shoot.wait_time = fire_rate
	$RightBow.visible = false
	$LeftBow.visible = false

func _physics_process(delta):
	if direction == 1:
		$AnimatedSprite.flip_h = true
		bow = $RightBow
		arrow_pos = $RightPos
	elif direction == -1:
		$AnimatedSprite.flip_h = false
		bow = $LeftBow
		arrow_pos = $LeftPos
		
	if state == "Idle":
		turn = 1
		$AnimatedSprite.animation = "Idle"
		motion.x = 0
		if global.ID.global_position > global_position:
			direction = 1
		elif global.ID.global_position < global_position:
			direction = -1
		if $RightCheck.get_collider() == global.ID && direction == 1:
			shoot()
		elif $LeftCheck.get_collider() == global.ID && direction == -1:
			shoot()
		if $RightClose.get_collider() == global.ID && direction == 1:
			$Retreat.start()
			state = "Walking"
		elif $LeftClose.get_collider() == global.ID && direction == -1:
			$Retreat.start()
			state = "Walking"
	elif state == "Walking":
		$AnimatedSprite.animation = "Moving"
		if turn == 1:
			if direction == 1:
				direction = -1
				turn = 0
			else:
				direction = 1
				turn = 0
		if direction == 1:
			if $RightWall.is_colliding() or $RightGround.is_colliding() == false:
				if global.ID.global_position > global_position:
					direction = 1
				elif global.ID.global_position < global_position:
					direction = -1
				state = "Idle"
			else:
				motion.x = direction * speed
		elif direction == -1:
			if $LeftWall.is_colliding() or $LeftGround.is_colliding() == false:
				if global.ID.global_position > global_position:
					direction = 1
				elif global.ID.global_position < global_position:
					direction = -1
				state = "Idle"
			else:
				motion.x = direction * speed
	
	
	move_and_slide(motion)


func _on_Shoot_timeout():
	can_fire = true

func shoot():
	if can_fire:
		bow.visible = true
		$Timer.start()
		var rotate
		can_fire = false
		var arrow_instance = arrow.instance()
		arrow_instance.position = arrow_pos.get_global_position()
		if direction == -1:
			rotate = 180
		else:
			rotate = 0
		arrow_instance.dir = direction
		arrow_instance.rotation_degrees = rotate
		get_tree().get_root().add_child(arrow_instance)
		$Shoot.start()


func _on_Retreat_timeout():
	state = "Idle"

func _on_Timer_timeout():
	$RightBow.visible = false
	$LeftBow.visible = false


func _on_Area2D_area_entered(area):
	if area.name == "Melee_weapon":
		health -= global.equipped_melee.damage
	elif area.name == "Arrow":
		health -= global.equipped_ranged.damage
	if health <= 0:
		die()

func die():
	death.coins = 12
	death.get_tree = get_tree()
	death.pos = get_global_position()
	death.die()
	$Timer2.start()

func _on_Timer2_timeout():
	var particles_instance = particles.instance()
	particles_instance.dying = "Bowman"
	particles_instance.position = get_global_position()
	get_tree().get_root().add_child(particles_instance)
	queue_free()
