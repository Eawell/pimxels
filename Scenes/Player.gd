extends KinematicBody2D

var max_speed
var speed = 25
var motion = Vector2()
var gravity = 10
var jump_height = -230
const UP = Vector2(0, -1)
var armour 
var colour
var arrow = preload("res://Scenes/Arrow.tscn")
var arrow_speed = 200
var rotate
onready var time = $Timer
var particles = preload("res://Scenes/Particles.tscn")
var wings
var jumps
var transparency

func clear():
	$Animations/Red.visible = false
	$Animations/Blue.visible = false
	$Animations/Black.visible = false
	$Animations/Purple.visible = false
	$Animations/White.visible = false

func _ready():
	global.bob = false
	transparency = 0.7
	$Redbull.value = 0
	$Car.value = 0
	global.shield = false
	global.boost = 1
	jumps = 1
	wings = false
	$Animations/Wings.visible = false
	global.wait = 0
	global.invincibility = false
	global.health = global.max_health
	global_position = global.checkpoint
	global.location = global_position.x
	global.height = global_position.y
	global.stun = $Timer2
	global.invincibility = false
	global.can_fire = true
	global.paused = "False"
	global.direction = "left"

func shoot():
	if global.wait != 1:
		var arrow_instance = arrow.instance()
		arrow_instance.position = get_node("Arrow_pos " + global.direction).get_global_position()
		if global.direction == "left":
			rotate = 180
		else:
			rotate = 0
		arrow_instance.rotation_degrees = rotate
		get_tree().get_root().add_child(arrow_instance)
		var wait = 2.2-pow(10 * global.equipped_ranged.speed, 0.5) / 6.4
		if wait <= 0:
			wait = 0.01
		time.wait_time = wait
		time.start()
		global.can_fire = false
		global.arrows -= 1

func _physics_process(delta):
	if global.health <= 0:
		die()
	global.location = global_position.x
	global.height = global_position.y
	max_speed = (156 - global.equipped_armour.weight * 3) * global.boost
	clear()
	armour = global.equipped_armour
	colour = armour.style
	motion.y += gravity
	get_node("Animations/" + colour).visible = true
	if global.shield:
		$Node/Shield.modulate = Color(1,1,1,transparency)
		$Node/Shield.visible = true
		if global.protection <= 0:
			global.shield = false
	else:
		$Node/Shield.visible = false
	if global.wait == 0:
		if Input.is_action_pressed("ui_right"):
			motion.x = min(motion.x + speed, max_speed)
			global.direction = "right"
			get_node("Animations/"+colour).animation = "Walking"
			get_node("Animations/"+colour).flip_h = true
		elif Input.is_action_pressed("ui_left"):
			motion.x = max(motion.x - speed, -max_speed)
			global.direction = "left"
			get_node("Animations/"+colour).animation = "Walking"
			get_node("Animations/"+colour).flip_h = false
		else:
			motion.x = lerp(motion.x, 0, 0.2)
			get_node("Animations/"+colour).animation = "Idle"
	
		if is_on_floor():
			jumps = 1
			if Input.is_action_just_pressed("ui_up"):
				motion.y = jump_height
			else:
				motion.x = lerp(motion.x, 0, 0.05)
		else:
			if motion.y < 0:
				get_node("Animations/"+colour).animation = "Jumping"
			if wings == true && jumps == 1:
				if Input.is_action_just_pressed("ui_up"):
					$Animations/Wings.visible = true
					$Animations/Wings.play()
					motion.y = jump_height
					jumps = 0

	
	if global.holding == "ranged":
		if Input.is_action_just_pressed("ui_accept") && global.can_fire:
			if global.arrows > 0:
				shoot()
				$Node/Ranged_weapon.shoot()
	motion = move_and_slide(motion, UP)

func wings():
	wings = true
	$Redbull.value = 100
	$Timer3.start()

func die():
	get_tree().reload_current_scene()

func _on_Timer_timeout():
	global.can_fire = true

func _on_Timer2_timeout():
	global.ID.motion.x = lerp(global.ID.motion.x,0,0.5)
	global.ID.motion.y = lerp(global.ID.motion.y,100,0.5)
	if global.ID.motion.x < 30 && global.ID.motion.x > -30:
		$Timer2.stop()
		global.wait = 0
		global.invincibility = false



func _on_Area2D_area_entered(area):
	if area.name == "Evil_Arrow":
		global.hit(1)


func _on_Wings_animation_finished():
	$Animations/Wings.visible = false
	$Animations/Wings.stop()


func _on_Timer3_timeout():
	wings = false

func boost():
	$Car.value = 100
	$Timer4.start()

func _on_Timer4_timeout():
	global.boost = 1

func shield():
	global.protection = 3
	transparency = 0.7
	$Timer5.start()

func _on_Timer5_timeout():
	global.shield = false


func _on_ATenth_timeout():
	if wings:
		$Redbull.value -= 1
	if global.boost:
		$Car.value -= 1
	if global.shield:
		transparency -= 0.005
