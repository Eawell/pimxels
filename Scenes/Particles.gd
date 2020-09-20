extends Node

var dying

func _ready():
	$Burgers.visible = false
	$Buffalo.visible = false
	$Box.visible = false
	$Slime.visible = false
	$Mole.visible = false
	$Ghost.visible = false
	$Thunder.visible = false
	$Warrior.visible = false
	$Bowman.visible = false
	
	get_node(dying).visible = true
	get_node(dying).emitting = true

func _physics_process(delta):
	if get_node(dying).emitting == false:
		queue_free()
	
