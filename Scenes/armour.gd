extends Node

var stats = load("res://Other/armourstats.gd").new()
var armour = ["Red", "Black", "Blue", "Purple", "White"]
var rarity

func _ready():
	randomize()
	rarity = randi()%(global.level * 3) + 1
	
	stats.type = "armour"
	stats.style = armour[randi()%5]
	$AnimatedSprite.animation = stats.style
	
	randomize()
	var x = randi()%5 + 1
	randomize()
	stats.defense = (rarity * randi()%3) + x
	randomize()
	var y = randi()%7 + 1
	randomize()
	stats.weight = 26 - (rarity * randi()%3) - y
		
func _on_Armour_body_entered(body):
	if body.name == "Player":
		if typeof(global.armour_open_slot) == TYPE_OBJECT:
			global.picked_up = stats
			global.fill()
			queue_free()





