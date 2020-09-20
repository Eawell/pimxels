extends Node2D

var type
var icon
var text
var talking

var bowman = ["bowman", "Elite bowmen that will try to out range your attacks with timed retreats. An easy foe if approached carefully, although if you run out of arrows, good luck even getting close!"]
var box = ["box", "An 'incredibly dangerous' foe that doesn't move or attack you and even gives you free loot or items."]
var buffalo = ["buffalo", "These quick and powerful animals are evil buffalo that became the dominant species on their home planet. All they want is to kill, and will send you flying if they hit you!"]
var burger = ["burger", "These killer burgers have gained sentience and are looking for revenge. You can try and ride on their heads, but Watch out for their ferocious bite!"]
var falcon = ["falcon", ""]
var ghost = ["ghost", ""]
var mole = ["mole", "Watch your feet! These normally docile creatures disperse huge amounts of dirt on their way to grind you up with their many teeth."]
var shopkeeper = ["shopkeeper", ""]
var slime = ["slime", ""]
var smallburger = ["smallburger", "Eventhough they are less dangerous than their larger brothers, don't underestimate "]
var thundercloud = ["thundercloud", ""]
var torch = ["torch", "Torches that "]
var warrior = ["warrior", ""]

var story1 = ["none", ""]
var story2 = ["none", ""]

func _ready():
	visible = false
	talking = false

func _process(delta):
	if Input.is_action_just_pressed("ui_end"):
		talk(buffalo)
	if type == "Announcement":
		$ColorRect.visible = true
		$ColorRect2.visible = false
	elif type == "Story":
		$ColorRect.visible = false
		$ColorRect2.visible = true
	if talking == true:
		if $Size/RichTextLabel.get_visible_characters() >= text.length():
			$Bob.playing = false
			$Bob.frame = 1
			if Input.is_action_just_pressed("ui_select"):
				visible = false
				get_tree().paused = false
				talking = false
				global.bob = false
		else:
			$Bob.playing = true
			if Input.is_action_just_pressed("ui_select"):
				$Size/RichTextLabel.visible_characters = text.length()

func talk(info):
	global.bob = true
	talking = true
	visible = true
	get_tree().paused = true
	icon = info[0]
	text = info[1]
	if icon == "none":
		type = "Story"
		$Icon.visible = false
	else:
		type = "Announcement"
		$Icon.visible = true
		$Icon.animation = icon
	$Size/RichTextLabel.text = info[1]
	$Size/RichTextLabel.visible_characters = 0
	$Timer.start()


func _on_Timer_timeout():
	$Size/RichTextLabel.visible_characters += 1
