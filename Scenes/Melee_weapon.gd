extends Node2D

onready var time = $Timer

func _ready():
	global.can_attack = true
	clear()

func clear():
	$Axe.visible = false
	$BigSword.visible = false
	$Dagger.visible = false
	$Lance.visible = false
	$Pipe.visible = false
	$Spear.visible = false
	$Stick.visible = false
	$Sword.visible = false
	$Hammer.visible = false
	$Pitchfork.visible = false
	
	$AxeHitbox.disabled = true
	$BigSwordHitbox.disabled = true
	$DaggerHitbox.disabled = true
	$LanceHitbox.disabled = true
	$PipeHitbox.disabled = true
	$StickHitbox.disabled = true
	$SpearHitbox.disabled = true
	$SwordHitbox.disabled = true
	$HammerHitbox.disabled = true
	$PitchforkHitbox.disabled = true

func attack():
	get_node(global.equipped_melee.style).visible = true
	get_node(global.equipped_melee.style + "Hitbox").disabled = false
	get_node("AnimationPlayer").play(global.equipped_melee.style + " " + global.direction)
	global.can_attack = false
	var wait = 2.6-pow(10 * global.equipped_melee.speed, 0.5) / 6.4
	if wait <= 0:
		wait = 0.01
	time.wait_time = wait
	$Timer.start()

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept") && global.can_attack:
		if global.holding == "melee":
			if global.wait != 1:
				attack()


func _on_AnimationPlayer_animation_finished(anim_name):
	clear()

func _on_Timer_timeout():
	global.can_attack = true
