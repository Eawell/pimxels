extends Node


var health = 10
onready var max_health = 10
var luck = 1
var direction
var coins = 10000
var paused
var level = 1
onready var melee_open_slot = melee2
onready var ranged_open_slot = ranged2
onready var armour_open_slot = armour2
onready var equipped_melee = melee1
onready var equipped_ranged = ranged1
onready var equipped_armour = armour1
var picked_up
onready var holding = "melee"
onready var arrows = 20
onready var can_attack = true
onready var can_fire = true
var ID
var location
var height
onready var wait = 0
var invincibility
var stun
onready var checkpoint = Vector2(0, -32)
var hit_checkpoints : Array
var shop
var camera_pos
var boost
var shield
var protection
var bob
var tree_health = 20

var weapon = load("res://Other/weaponstats.gd")
var armour = load("res://Other/armourstats.gd")


var armour1 = armour.new()
var armour2 = armour.new()
var armour3 = armour.new()
var armour4 = armour.new()
var armour5 = armour.new()

var ranged1 = weapon.new()
var ranged2 = weapon.new()
var ranged3 = weapon.new()
var ranged4 = weapon.new()
var ranged5 = weapon.new()

var melee1 = weapon.new()
var melee2 = weapon.new()
var melee3 = weapon.new()
var melee4 = weapon.new()
var melee5 = weapon.new()
var melee6 = weapon.new()
var melee7 = weapon.new()
var melee8 = weapon.new()
var melee9 = weapon.new()
var melee10 = weapon.new()

var melee_list = [melee1, melee2, melee3, melee4, melee5, melee6, melee7, melee8, melee9, melee10]
var ranged_list = [ranged1, ranged2, ranged3, ranged4, ranged5]
var armour_list = [armour1, armour2, armour3, armour4, armour5]

func fill():
	if picked_up.type == "armour":
		armour_open_slot.type = picked_up.type
		armour_open_slot.style = picked_up.style
		armour_open_slot.defense = picked_up.defense
		armour_open_slot.weight = picked_up.weight
	elif picked_up.type == "melee":
		melee_open_slot.type = picked_up.type
		melee_open_slot.style = picked_up.style
		melee_open_slot.damage = picked_up.damage
		melee_open_slot.speed = picked_up.speed
	elif picked_up.type == "ranged":
		ranged_open_slot.type = picked_up.type
		ranged_open_slot.style = picked_up.style
		ranged_open_slot.damage = picked_up.damage
		ranged_open_slot.speed = picked_up.speed
		
func _ready():
	melee1.type = "melee"
	melee1.style = "Stick"
	melee1.damage = 1
	melee1.speed = 1
	
	ranged1.type = "ranged"
	ranged1.style = "Bow"
	ranged1.damage = 1
	ranged1.speed = 1
	
	armour1.type = "armour"
	armour1.style = "Red"
	armour1.defense = 1
	armour1.weight = 26
		
func _physics_process(delta):
	camera_pos = Vector2(location, height - 2)
	coins = round(coins)
	if health > max_health:
		health = max_health
	if health <= 0:
		health = 0
	for i in range(10):
		var y = melee_list[i]
		if y.type == "none":
			melee_open_slot = melee_list[i]
			break
		else:
			if i == 9:
				melee_open_slot = "none"
			
	for i in range(5):
		var y = ranged_list[i]
		if y.type == "none":
			ranged_open_slot = ranged_list[i]
			break
		else:
			if i == 4:
				ranged_open_slot = "none"
			
	for i in range(5):
		var y = armour_list[i]
		if y.type == "none":
			armour_open_slot = armour_list[i]
			break
		else:
			if i == 4:
				armour_open_slot = "none"
	
	for i in range(10):
		var a = melee_list[i]
		a.number = i+1
	for i in range(5):
		var a = ranged_list[i]
		a.number = i+1
	for i in range(5):
		var a = armour_list[i]
		a.number = i+1
	
	if Input.is_action_just_pressed("one"):
		holding = "melee"
	elif Input.is_action_just_pressed("two"):
		holding = "ranged"
	
func hit(damage):
	if shield:
		protection -= 1
	else:
		health -= max(round(damage/ equipped_armour.defense), 1)
