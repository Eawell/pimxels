extends KinematicBody2D

var motion = Vector2()
const UP = Vector2(0, -1)
var health = global.level * 3
var damage = global.level * 2
onready var jump = "false"
var speed
var death = load("res://Other/Drops.gd").new()
var particles = preload("res://Scenes/Particles.tscn")

func jump():
	$Sprite.play("Jump")
	jump = "true"
	motion.x = speed
	motion.y = -200

func _physics_process(delta):
	if is_on_floor() && jump == "true":
		$Sprite.play("Fall")
	if is_on_floor() && motion.y > 0:
		jump = "false"
	if is_on_floor() && jump == "false":
		motion.x = 0
		if $Left.get_collider() == global.ID:
			speed = -20
			jump()
		if $Right.get_collider() == global.ID:
			speed = 20
			jump()
	else:
		motion.y += 10
	move_and_slide(motion, UP)


func _on_Hurtbox_body_entered(body):
	if body.name == "Player" && global.invincibility == false:
		global.wait = 1
		global.hit(damage)
		if global.location > global_position.x:
			global.ID.motion.x = 400
		elif global.location < global_position.x:
			global.ID.motion.x = -400
		if global.height < global_position.y:
			global.ID.motion.y = -400
		global.invincibility = true
		global.stun.start()


func _on_Sprite_animation_finished():
	if $Sprite.animation == "Jump":
		$Sprite.play("Air")
	if $Sprite.animation == "Fall":
		$Sprite.play("Idle")

func die():
	death.coins = 6
	death.drops = get_node("../Drops")
	death.pos = get_global_position()
	death.die()
	$Timer.start()

func _on_Hurtbox_area_entered(area):
	if area.name == "Melee_weapon":
		health -= global.equipped_melee.damage
	elif area.name == "Arrow":
		health -= global.equipped_ranged.damage
	if health <= 0:
		die()


func _on_Timer_timeout():
	var particles_instance = particles.instance()
	particles_instance.dying = "Slime"
	particles_instance.position = get_global_position() + Vector2(0,3)
	get_tree().get_root().add_child(particles_instance)
	queue_free()

