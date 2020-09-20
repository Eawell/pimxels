extends Node2D


func clear():
	$Bow.visible = false
	$PowerBow.visible = false
	$Crossbow.visible = false
	$RapidCrossbow.visible = false

func _ready():
	clear()

func _physics_process(delta):
	if global.direction == "right":
		position.x = 6
		get_node(global.equipped_ranged.style).flip_h = false
		get_node(global.equipped_ranged.style).flip_v = false
	else:
		position.x = -5
		get_node(global.equipped_ranged.style).flip_h = true
		get_node(global.equipped_ranged.style).flip_v = true
		
	position.y = 5
	
func shoot():
		get_node(global.equipped_ranged.style).visible = true
		$Timer.start()

func _on_Timer_timeout():
	clear()
