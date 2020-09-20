extends KinematicBody2D

var weapon  = preload("res://Scenes/Weapon.tscn")
var armour = preload("res://Scenes/Armour.tscn")
var heart = preload("res://Scenes/Heart.tscn")
var arrow_pack = preload("res://Scenes/Arrow_pack.tscn")

var pos
var coins = 10
var drops

func die():
	randomize()
	global.coins += (randi()%coins + 1) * global.level * global.luck
	randomize()
	var x = randi()%15
	if x < 2:
		var weapon_instance = weapon.instance()
		weapon_instance.position = pos
		weapon_instance.z_index = -1
		drops.add_child(weapon_instance)
	elif x == 2:
		var armour_instance = armour.instance()
		armour_instance.position = pos
		armour_instance.z_index = -1
		drops.add_child(armour_instance)
	elif x == 3:
		var arrow_instance = arrow_pack.instance()
		arrow_instance.position = pos
		arrow_instance.z_index = -1
		drops.add_child(arrow_instance)
	elif x >= 12:
		var heart_instance = heart.instance()
		heart_instance.position = pos
		heart_instance.z_index = -1
		drops.add_child(heart_instance)
