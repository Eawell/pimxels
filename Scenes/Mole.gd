extends KinematicBody2D

var motion = Vector2()
var speed = 60
var direction 
onready var state = "Idle"
onready var RDetect = $DetectorRight
onready var LDetect = $DetectorLeft
onready var going_to = -10000
onready var wait = 0
onready var health = global.level * 2
onready var damage = global.level * 2
var particles = preload("res://Scenes/Particles.tscn")
var death = load("res://Other/Drops.gd").new()

func follow():
	if direction == "Right":
		motion.x = 70
	elif direction == "Left":
		motion.x = -70

func _physics_process(delta):
	print(going_to)
	if $LeftWall.is_colliding():
		motion.x = 0
		state = "Idle"
	elif $LeftFloor.is_colliding() == false:
		motion.x = 0
		state = "Idle"	
	elif wait == 0:
		if LDetect.get_collider() == global.ID:
			direction = "Left"
			going_to = global.location
			follow()
	if $RightWall.is_colliding():
		motion.x = 0
		state = "Idle"
	elif $RightFloor.is_colliding() == false:
		motion.x = 0
		state = "Idle"
	elif wait == 0:
		if RDetect.get_collider() == global.ID:
			direction = "Right"
			going_to = global.location
			follow()
	if motion.x != 0:
		state = "Moving"
	if round(global_position.x / 4) == round(going_to / 4):
		going_to = -10000
		motion.x = 0
		state = "Angry"
		wait = 1
		$Timer.start()
	if state == "Idle":
		$Particles.emitting = false
		$Hitbox/CollisionShape2D.disabled = false
		$CollisionShape2D.disabled = false
	elif state == "Angry":
		$Particles.emitting = false
		$Hitbox/CollisionShape2D.disabled = false
		$CollisionShape2D.disabled = false
	elif state == "Moving":
		$Particles.emitting = true
		$Hitbox/CollisionShape2D.disabled = true
		$CollisionShape2D.disabled = true
		
	$Sprite.animation = state
	move_and_slide(motion)


func _on_Timer_timeout():
	wait = 0
	state = "Idle"


func _on_Hitbox_body_entered(body):
	if body.name == "Player" && global.invincibility == false:
		global.wait = 1
		global.hit(damage)
		if global.location > global_position.x:
			global.ID.motion.x = 200
		elif global.location < global_position.x:
			global.ID.motion.x = -200
		if global.height < global_position.y:
			global.ID.motion.y = -400
		global.invincibility = true
		global.stun.start()


func _on_Hitbox_area_entered(area):
	if area.name == "Melee_weapon":
		health -= global.equipped_melee.damage
	elif area.name == "Arrow":
		health -= global.equipped_ranged.damage
	if health <= 0:
		death.coins = 8
		death.drops = get_node("../Drops")
		death.pos = get_global_position()
		death.die()
		$Timer2.start()

func _on_Timer2_timeout():
	var particles_instance = particles.instance()
	particles_instance.dying = "Mole"
	particles_instance.position = get_global_position() + Vector2(0,2)
	get_tree().get_root().add_child(particles_instance)
	queue_free()


