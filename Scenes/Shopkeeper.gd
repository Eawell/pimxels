extends Area2D

onready var shop = false
onready var selected = 1
var price_1
var price_2
var price_3
var price_4
var price_5
var price_6
var price

func _ready():
	$AnimatedSprite.modulate = Color(1,1,1,1)
	$Shop.visible = false
	global.shop = false

func _physics_process(delta):
	$AnimatedSprite.modulate = Color(1,1,1,1)
	price = [price_1, price_2, price_3, price_4, price_5, price_6]
	price_1 = 60 + 20*global.max_health
	price_2 = 25
	price_3 = global.luck * 400
	if global.bob or global.shop or global.paused == "true":
		$AnimatedSprite.playing = false
	else:
		$AnimatedSprite.playing = true
	if global.equipped_melee.upgraded > 2:
		price_4 = 0
	else:
		price_4 = (global.equipped_melee.upgraded + 1) * 50 * global.level
	if global.equipped_ranged.upgraded > 2:
		price_5 = 0
	else:
		price_5 = (global.equipped_ranged.upgraded + 1) * 60 * global.level
	if global.equipped_armour.upgraded > 2:
		price_6 = 0
	else:
		price_6 = (global.equipped_armour.upgraded + 1) * 70 * global.level
	if shop:
		$"Shop/1/Price".text = str(price_1)
		$"Shop/2/Price".text = str(price_2)
		$"Shop/3/Price".text = str(price_3)
		$"Shop/4/Price".text = str(price_4)
		$"Shop/5/Price".text = str(price_5)
		$"Shop/6/Price".text = str(price_6)
		if Input.is_action_just_pressed("Inventory"):
			$Shop.visible = false
			shop = false
			get_tree().paused = false
			$Shop/Timer.start()
		$Shop/Coins.text = str(global.coins)
		$"Shop/1/Slot".modulate = Color(1,1,1,1)
		$"Shop/2/Slot".modulate = Color(1,1,1,1)
		$"Shop/3/Slot".modulate = Color(1,1,1,1)
		$"Shop/4/Slot".modulate = Color(1,1,1,1)
		$"Shop/5/Slot".modulate = Color(1,1,1,1)
		$"Shop/6/Slot".modulate = Color(1,1,1,1)
		if Input.is_action_just_pressed("ui_right"):
			selected += 1
		elif Input.is_action_just_pressed("ui_left"):
			selected -= 1
		if selected > 6:
			selected = 1
		if selected < 1:
			selected = 6
		get_node("Shop/"+str(selected)+"/Slot").modulate = Color(1,1,0.5,1)
		if Input.is_action_just_pressed("ui_select"):
			if global.coins >= price[selected - 1]:
				if selected == 1:
					if global.max_health < 20:
						global.coins -= price[selected-1]
						global.max_health += 1
				elif selected == 2:
					global.coins -= price[selected-1]
					global.arrows += 5
				elif selected == 3:
					global.coins -= price[selected-1]
					global.luck += 0.5
				elif selected == 4:
					if global.equipped_melee.upgraded < 3:
						global.coins -= price[selected-1]
						global.equipped_melee.speed += 1
						global.equipped_melee.damage += 1
						global.equipped_melee.upgraded += 1
				elif selected == 5:
					if global.equipped_ranged.upgraded < 3:
						global.coins -= price[selected-1]
						global.equipped_ranged.speed += 1
						global.equipped_ranged.damage += 1
						global.equipped_ranged.upgraded += 1
				elif selected == 6:
					if global.equipped_armour.upgraded < 3:
						global.coins -= price[selected-1]
						global.equipped_armour.weight -= 1
						global.equipped_armour.defense += 1
						global.equipped_armour.upgraded += 1
						
	if get_overlapping_bodies().has(global.ID) && shop == false:
		$AnimatedSprite.modulate = Color(0.64,0.64,0.64,1)
		if Input.is_action_just_pressed("ui_select") && global.paused != "true" && global.bob == false:
			$Shop.global_position = global.ID.global_position
			shop = true
			global.shop = true
			$Shop.visible = true
			get_tree().paused = true

func _on_Timer_timeout():
	global.shop = false
