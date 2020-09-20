extends KinematicBody2D

var motion = Vector2()
var speed = 50
var charging_speed = 150
onready var health = global.level * 7
var damage = global.level * 10
onready var direction = 1
onready var state = "Walking"
var death = load("res://Other/Drops.gd").new()
var particles = preload("res://Scenes/Particles.tscn")


func _physics_process(delta):
	print(health)
	if direction == 1:
		$Sprite.flip_h = true
		if state == "Walking" or state == "Charge":
			if $RightWall.is_colliding() or $RightGround.is_colliding() == false:
				state = "Walking"
				direction = -1
	elif direction == -1:
		$Sprite.flip_h = false
		if state == "Walking" or state == "Charge":
			if $LeftWall.is_colliding() or $LeftGround.is_colliding() == false:
				state = "Walking"
				direction = 1
	if state == "Walking":
		$Sword/Sprite.visible = false
		$Sword/CollisionShape2D.disabled = true
		$Sprite.animation = "Moving"
		motion.x = speed * direction
		if $CheckLeft.get_collider() == global.ID && direction == -1:
			state = "Charge"
		elif $CheckRight.get_collider() == global.ID && direction == 1:
			state = "Charge"
	elif state == "Idle":
		$Sprite.animation = "Idle"
		motion.x = 0
		$Sword/Sprite.visible = true
		$Sword/CollisionShape2D.disabled = false
		if direction == 1:
			$Sword/AnimationPlayer.play("Right")
		elif direction == -1:
			$Sword/AnimationPlayer.play("Left")
	elif state == "Charge":
		$Sword/Sprite.visible = false
		$Sword/CollisionShape2D.disabled = true
		$Sprite.animation = "Moving"
		motion.x = charging_speed * direction
		if $LeftAttack.get_collider() == global.ID && direction == -1:
			state = "Idle"
		elif $RightAttack.get_collider() == global.ID && direction == 1:
			state = "Idle"
		

	move_and_slide(motion)


func _on_Sword_body_entered(body):
	if body.name == "Player" && global.invincibility == false:
		global.wait = 1
		global.hit(damage)
		if global.location > global_position.x:
			global.ID.motion.x = 400
		elif global.location < global_position.x:
			global.ID.motion.x = -400
		global.invincibility = true
		global.stun.start()


func _on_AnimationPlayer_animation_finished(anim_name):
	direction = -direction
	state = "Charge"

func _on_Hitbox_area_entered(area):
	print("yes")
	if area.name == "Melee_weapon":
		health -= global.equipped_melee.damage
	elif area.name == "Arrow":
		health -= global.equipped_ranged.damage
	if health <= 0:
		die()

func die():
	death.coins = 20
	death.pos = get_global_position()
	death.drops = get_node("../Drops")
	death.die()
	$Timer.start()
	

func _on_Timer_timeout():
	var particles_instance = particles.instance()
	particles_instance.dying = "Warrior"
	particles_instance.position = get_global_position()
	get_tree().get_root().add_child(particles_instance)
	queue_free()
