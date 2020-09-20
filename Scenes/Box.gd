extends StaticBody2D

var death = load("res://Other/Drops.gd").new()
var particles = preload("res://Scenes/Particles.tscn")

func die():
	death.coins = 10
	death.drops = get_node("../Drops")
	death.pos = get_global_position()
	death.die()
	$Timer.start()

func _on_Area2D_area_entered(area):
	if area.name == "Melee_weapon":
		die()
	elif area.name == "Arrow":
		die()
	

func _on_Timer_timeout():
	var particles_instance = particles.instance()
	particles_instance.dying = "Box"
	particles_instance.position = get_global_position()
	get_tree().get_root().add_child(particles_instance)
	queue_free()
