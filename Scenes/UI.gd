extends Control



func clear():
	$Hearts/Heart1.visible = false
	$Hearts/Heart2.visible = false
	$Hearts/Heart3.visible = false
	$Hearts/Heart4.visible = false
	$Hearts/Heart5.visible = false
	$Hearts/Heart6.visible = false
	$Hearts/Heart7.visible = false
	$Hearts/Heart8.visible = false
	$Hearts/Heart9.visible = false
	$Hearts/Heart10.visible = false
	$Hearts/Heart11.visible = false
	$Hearts/Heart12.visible = false
	$Hearts/Heart13.visible = false
	$Hearts/Heart14.visible = false
	$Hearts/Heart15.visible = false
	$Hearts/Heart16.visible = false
	$Hearts/Heart17.visible = false
	$Hearts/Heart18.visible = false
	$Hearts/Heart19.visible = false
	$Hearts/Heart20.visible = false

func empty():
	$Hearts/Heart1.animation = "Empty"
	$Hearts/Heart2.animation = "Empty"
	$Hearts/Heart3.animation = "Empty"
	$Hearts/Heart4.animation = "Empty"
	$Hearts/Heart5.animation = "Empty"
	$Hearts/Heart6.animation = "Empty"
	$Hearts/Heart7.animation = "Empty"
	$Hearts/Heart8.animation = "Empty"
	$Hearts/Heart9.animation = "Empty"
	$Hearts/Heart10.animation = "Empty"
	$Hearts/Heart11.animation = "Empty"
	$Hearts/Heart12.animation = "Empty"
	$Hearts/Heart13.animation = "Empty"
	$Hearts/Heart14.animation = "Empty"
	$Hearts/Heart15.animation = "Empty"
	$Hearts/Heart16.animation = "Empty"
	$Hearts/Heart17.animation = "Empty"
	$Hearts/Heart18.animation = "Empty"
	$Hearts/Heart19.animation = "Empty"
	$Hearts/Heart20.animation = "Empty"


func _ready():
	clear()

func _physics_process(delta):
	empty()

	for i in range(global.max_health):
		get_node("Hearts/Heart" + str(i+1)).visible = true
	
	for i in range(global.health):
		get_node("Hearts/Heart" + str(i+1)).animation = "Full"
	
	$Label.text = str(global.coins)
	$Label2.text = str(global.arrows)
	
	if global.can_attack:
		$X2.visible = false
	else:
		$X2.visible = true
	if global.can_fire:
		$X.visible = false
	else:
		$X.visible = true
	
	if global.holding == "melee":
		$ColorRect.visible = true
		$ColorRect2.visible = false
	if global.holding == "ranged":
		$ColorRect.visible = false
		$ColorRect2.visible = true
