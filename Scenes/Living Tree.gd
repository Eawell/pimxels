extends KinematicBody2D

var stick = preload("res://Scenes/Stick.tscn")
var can_fire = true
var side
var health = 20
var damage = 5

func _process(delta):
	global.tree_health = health
	$Sight.look_at(global.ID.global_position)
	if $Sight/RayCast2D.get_collider() == global.ID:
		shoot()
	if global.ID.global_position.x < global_position.x:
		side = "Left"
	else:
		side = "Right"

func _on_Area2D_area_entered(area):
	if area.name == "Melee_weapon":
		health -= global.equipped_melee.damage
	elif area.name == "Arrow":
		health -= global.equipped_ranged.damage
	if health <= 0:
		die()

func _on_Area2D_body_entered(body):
	if body.name == "Player" && global.invincibility == false:
		global.wait = 1
		global.hit(damage)
		if global.location > global_position.x:
			global.ID.motion.x = 400
		elif global.location < global_position.x:
			global.ID.motion.x = -400
		global.invincibility = true
		global.stun.start()

func shoot():
	if can_fire:
		var stick_instance = stick.instance()
		stick_instance.position = get_node(side + " shot").get_global_position()
		stick_instance.rotation_degrees = $Sight.rotation_degrees
		get_node("../Drops").add_child(stick_instance)
		$Timer.start()
		can_fire = false

func die():
	queue_free()

func _on_Timer_timeout():
	can_fire = true
