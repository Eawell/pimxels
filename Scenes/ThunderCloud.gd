extends KinematicBody2D

var state
var motion = Vector2()
var direction
onready var zap = 0
var particles = preload("res://Scenes/Particles.tscn")

func _ready():
	randomize()
	$Timer.wait_time = randi()%12 + 3
	state = "Idle"

func _physics_process(delta):
	direction = (Vector2(global.ID.global_position.x,global.ID.global_position.y - 50) - global_position).normalized()
	
	if state == "Idle":
		motion.x = 0
		motion.y = 0
		$Sprite2.visible = false
		$Sprite.modulate = Color(1,1,1,1)
		$Area2D/CollisionShape2D.disabled = true
	if state == "Going_to":
		motion = direction * 120
		if round(global_position.x / 4) == round(global.ID.global_position.x / 4) && round(global_position.y / 4) == round((global.ID.global_position.y - 50) / 4):
			state = "Following"
	if state == "Following":
		global_position.x = global.ID.global_position.x
		global_position.y = global.ID.global_position.y - 50
		if zap == 0:
			zap = 1
			$Timer.start()
	
	if $Area2D.get_overlapping_bodies().has(global.ID):
		global.health = 0
	
	move_and_slide(motion)

func _on_Detector_body_entered(body):
	if state == "Idle":
		if body.name == "Player":
			state = "Going_to"

func _on_Timer_timeout():
	$Sprite.modulate = Color(0.5,0.5,0.5,1)
	state = "Wait"
	motion.x = 0
	motion.y = 0
	$Timer2.start()

func _on_Timer2_timeout():
	$Sprite2.visible = true
	$Area2D/CollisionShape2D.disabled = false
	$Timer3.start()

func _on_Timer3_timeout():
	var particles_instance = particles.instance()
	particles_instance.dying = "Thunder"
	particles_instance.position = get_global_position() + Vector2(0,5)
	get_tree().get_root().add_child(particles_instance)
	queue_free()
