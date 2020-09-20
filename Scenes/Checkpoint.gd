extends Area2D



func _ready():
	$AnimatedSprite.animation = "Unlit"
	if global.hit_checkpoints.has(name):
		$AnimatedSprite.animation = "Lit"


func _on_Checkpoint_body_entered(body):
	if body.name == "Player":
		$AnimatedSprite.animation = "Lit"
		global.checkpoint = global_position
		global.hit_checkpoints.append(name)
