extends Control

onready var row = 3
onready var column = 1
var equipped
var selected
var line
var box
var highlight

func _ready():
	visible = false

func clear():
	$"ArmourSlots/1".modulate = Color(1, 1, 1)
	$"ArmourSlots/2".modulate = Color(1, 1, 1)
	$"ArmourSlots/3".modulate = Color(1, 1, 1)
	$"ArmourSlots/4".modulate = Color(1, 1, 1)
	$"ArmourSlots/5".modulate = Color(1, 1, 1)
	$"RangedSlots/1".modulate = Color(1, 1, 1)
	$"RangedSlots/2".modulate = Color(1, 1, 1)
	$"RangedSlots/3".modulate = Color(1, 1, 1)
	$"RangedSlots/4".modulate = Color(1, 1, 1)
	$"RangedSlots/5".modulate = Color(1, 1, 1)
	$"MeleeSlots/1".modulate = Color(1, 1, 1)
	$"MeleeSlots/2".modulate = Color(1, 1, 1)
	$"MeleeSlots/3".modulate = Color(1, 1, 1)
	$"MeleeSlots/4".modulate = Color(1, 1, 1)
	$"MeleeSlots/5".modulate = Color(1, 1, 1)
	$"MeleeSlots/6".modulate = Color(1, 1, 1)
	$"MeleeSlots/7".modulate = Color(1, 1, 1)
	$"MeleeSlots/8".modulate = Color(1, 1, 1)
	$"MeleeSlots/9".modulate = Color(1, 1, 1)
	$"MeleeSlots/10".modulate = Color(1, 1, 1)
	
	$"MeleeSlots/1/AnimatedSprite".visible = false
	$"MeleeSlots/2/AnimatedSprite".visible = false
	$"MeleeSlots/3/AnimatedSprite".visible = false
	$"MeleeSlots/4/AnimatedSprite".visible = false
	$"MeleeSlots/5/AnimatedSprite".visible = false
	$"MeleeSlots/6/AnimatedSprite".visible = false
	$"MeleeSlots/7/AnimatedSprite".visible = false
	$"MeleeSlots/8/AnimatedSprite".visible = false
	$"MeleeSlots/9/AnimatedSprite".visible = false
	$"MeleeSlots/10/AnimatedSprite".visible = false
	$"RangedSlots/1/AnimatedSprite".visible = false
	$"RangedSlots/2/AnimatedSprite".visible = false
	$"RangedSlots/3/AnimatedSprite".visible = false
	$"RangedSlots/4/AnimatedSprite".visible = false
	$"RangedSlots/5/AnimatedSprite".visible = false
	$"ArmourSlots/1/AnimatedSprite".visible = false
	$"ArmourSlots/2/AnimatedSprite".visible = false
	$"ArmourSlots/3/AnimatedSprite".visible = false
	$"ArmourSlots/4/AnimatedSprite".visible = false
	$"ArmourSlots/5/AnimatedSprite".visible = false

func _physics_process(delta):
	if global.shop == false && global.bob == false:
		if Input.is_action_just_pressed("Inventory"):
			if global.paused == "true":
				get_tree().paused = false
				global.paused = "false"
				visible = false
			else:
				get_tree().paused = true
				global.paused = "true"
				visible = true
	if global.paused == "true":
		if Input.is_action_just_pressed("ui_select"):
			if selected.type == "armour":
				global.equipped_armour = selected
			elif selected.type == "ranged":
				global.equipped_ranged = selected
			elif selected.type == "melee":
				global.equipped_melee = selected
	
		if Input.is_action_just_pressed("ui_down"):
			row += 1
		elif Input.is_action_just_pressed("ui_up"):
			row -= 1
		elif Input.is_action_just_pressed("ui_right"):
			column += 1
		elif Input.is_action_just_pressed("ui_left"):
			column -= 1
	
		if Input.is_action_just_pressed("sell"):
			if selected == global.equipped_armour:
				pass
			elif selected == global.equipped_ranged:
				pass
			elif selected == global.equipped_melee:
				pass
			elif selected.type == "armour":
				global.coins += selected.defense + 27 - selected.weight
				selected.defense = 0
				selected.weight = 0
				selected.type = "none"
				selected.style = "none"
				selected.upgraded = 0
			elif selected.type == "ranged":
				global.coins += selected.damage + selected.speed
				selected.damage = 0
				selected.speed = 0
				selected.type = "none"
				selected.style = "none"
				selected.upgraded = 0
			elif selected.type == "melee":
				global.coins += selected.damage + selected.speed
				selected.damage = 0
				selected.speed = 0
				selected.type = "none"
				selected.style = "none"
				selected.upgraded = 0
	
	if row > 4:
		row = 1
	if row < 1:
		row = 4
	if column > 5:
		column = 1
	if column < 1:
		column = 5
	
	$Labels/Damage_left.visible = false
	$Labels/Defense_left.visible = false
	$Labels/Speed_left.visible = false
	$Labels/Weight_left.visible = false
	$Labels/Damage_right.visible = false
	$Labels/Defense_right.visible = false
	$Labels/Speed_right.visible = false
	$Labels/Weight_right.visible = false
	
	if row == 1:
		line = "ArmourSlots"
		box = column
		selected = global.armour_list[column - 1]
		equipped = global.equipped_armour
		$Labels/Defense_right.visible = true
		$Labels/Weight_right.visible = true
		$Labels/Defense_left.visible = true
		$Labels/Weight_left.visible = true
		$Labels/Topleft.text = str(equipped.defense)
		$Labels/Bottomleft.text = str(equipped.weight)
		$Labels/Topright.text = str(selected.defense)
		$Labels/Bottomright.text = str(selected.weight)
	elif row == 2:
		line = "RangedSlots"
		box = column
		selected = global.ranged_list[column - 1]
		equipped = global.equipped_ranged
		$Labels/Damage_right.visible = true
		$Labels/Speed_right.visible = true
		$Labels/Damage_left.visible = true
		$Labels/Speed_left.visible = true
		$Labels/Topleft.text = str(equipped.damage)
		$Labels/Bottomleft.text = str(equipped.speed)
		$Labels/Topright.text = str(selected.damage)
		$Labels/Bottomright.text = str(selected.speed)
	else:
		line = "MeleeSlots"
		box = column + (row-3) * 5
		selected = global.melee_list[column - 1 + ((row - 3) * 5)]
		equipped = global.equipped_melee
		$Labels/Damage_right.visible = true
		$Labels/Speed_right.visible = true
		$Labels/Damage_left.visible = true
		$Labels/Speed_left.visible = true
		$Labels/Topleft.text = str(equipped.damage)
		$Labels/Bottomleft.text = str(equipped.speed)
		$Labels/Topright.text = str(selected.damage)
		$Labels/Bottomright.text = str(selected.speed)
	
	
	clear()
	highlight = get_node(line + "/" + str(box))
	highlight.modulate = Color(1, 1, 0.65)
	
	get_node("ArmourSlots/" + str(global.equipped_armour.number)).modulate = Color(0.69, 1, 0.69)
	get_node("RangedSlots/" + str(global.equipped_ranged.number)).modulate = Color(0.69, 1, 0.69)
	get_node("MeleeSlots/" + str(global.equipped_melee.number)).modulate = Color(0.69, 1, 0.69)
	
	if highlight == get_node("ArmourSlots/" + str(global.equipped_armour.number)):
		highlight.modulate = Color(0.8, 0.9, 0.3)
	elif highlight == get_node("RangedSlots/" + str(global.equipped_ranged.number)):
		highlight.modulate = Color(0.8, 0.9, 0.3)
	elif highlight == get_node("MeleeSlots/" + str(global.equipped_melee.number)):
		highlight.modulate = Color(0.8, 0.9, 0.3)
		
	for i in range(10):
		var y = global.melee_list[i]
		if y.type == "none":
			pass
		else:
			get_node("MeleeSlots/" + str(i+1) + "/AnimatedSprite").visible = true
			get_node("MeleeSlots/" + str(i+1) + "/AnimatedSprite").animation = y.style
			
			
	for i in range(5):
		var y = global.ranged_list[i]
		if y.type == "none":
			pass
		else:
			get_node("RangedSlots/" + str(i+1) + "/AnimatedSprite").visible = true
			get_node("RangedSlots/" + str(i+1) + "/AnimatedSprite").animation = y.style
	
	for i in range(5):
		var y = global.armour_list[i]
		if y.type == "none":
			pass
		else:
			get_node("ArmourSlots/" + str(i+1) + "/AnimatedSprite").visible = true
			get_node("ArmourSlots/" + str(i+1) + "/AnimatedSprite").animation = y.style
