extends Area2D

var stats = load("res://Other/weaponstats.gd").new()
var ranged = ["Bow", "Crossbow", "PowerBow", "RapidCrossbow"]
var melee = ["Stick", "Dagger", "Spear", "BigSword", "Sword", "Hammer", "Axe", "Pipe", "Pitchfork", "Lance"]
var rarity

func _ready():
	$Sprite.visible = false
	$Sprite2.visible = false
	$CollisionShape2D.disabled = true
	$CollisionShape2D2.disabled = true
	
	randomize()
	rarity = randi()%(global.level * 3) + 1
	randomize()
	if randi()%3 == 0:
		randomize()
		stats.type = "ranged"
		stats.style = ranged[randi()%4]
		$Sprite2.visible = true
		$Sprite2.animation = stats.style
		$CollisionShape2D2.disabled = false
	else:
		randomize()
		stats.type = "melee"
		stats.style = melee[randi()%10]
		$Sprite.visible = true
		$Sprite.animation = stats.style
		$CollisionShape2D.disabled = false
		
	
	
	if stats.style == "Bow":
		randomize()
		stats.damage = rarity + randi()%3
		stats.speed = rarity * 2
	elif stats.style == "Crossbow":
		randomize()
		stats.damage = rarity + randi()%4
		stats.speed = rarity + 1
	elif stats.style == "PowerBow":
		randomize()
		stats.damage = rarity * (randi()%2 + 2)
		stats.speed = rarity 
	elif stats.style == "RapidCrossbow":
		randomize()
		stats.damage = rarity
		stats.speed = rarity * (randi()%3 + 2)
	
	elif stats.style == "Stick":
		stats.damage = rarity
		stats.speed = rarity
	elif stats.style == "Dagger":
		randomize()
		stats.damage = rarity + randi()%3
		randomize()
		stats.speed = rarity * (randi()%3 + 2)
	elif stats.style == "Spear":
		randomize()
		stats.damage = rarity + (randi()%3 + 1)
		randomize()
		stats.speed = rarity + 3
	elif stats.style == "BigSword":
		randomize()
		stats.damage = rarity * (randi()%3 + 1) + 1
		stats.speed = rarity
	elif stats.style == "Sword":
		stats.damage = rarity * 2
		stats.speed = rarity * 2
	elif stats.style == "Hammer":
		randomize()
		stats.damage = rarity + (randi()%3 + 1)
		randomize()
		stats.speed = rarity * (randi()%2 + 1)
	elif stats.style == "Axe":
		randomize()
		stats.damage = rarity * (randi()%3 + 1) - 1
		if stats.damage == 0:
			stats.damage = 1
		stats.speed = rarity * 2 + 1
	elif stats.style == "Pipe":
		randomize()
		stats.damage = rarity + (randi()%3 + 1)
		stats.speed = rarity * 2 - 1
	elif stats.style == "Pitchfork":
		randomize()
		stats.damage = rarity * 2
		stats.speed = rarity + 2
	elif stats.style == "Lance":
		randomize()
		stats.damage = rarity * (randi()%3 + 1)
		stats.speed = rarity

func _on_Weapon_body_entered(body):
	if body.name == "Player":
		if stats.type == "melee":
			if typeof(global.melee_open_slot) == TYPE_OBJECT:
				global.picked_up = stats
				global.fill()
				queue_free()
		else:
			if typeof(global.ranged_open_slot) == TYPE_OBJECT:
				global.picked_up = stats
				global.fill()
				queue_free()
		
		
