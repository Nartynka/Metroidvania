extends "res://Enemies/Enemy.gd"

export(int) var ACCELERATION = 400
onready var sprite = $Sprite
var player = null

func _physics_process(delta):
	player = Utils.find_player()
	if player != null:
		chase_player(delta)

func chase_player(delta):
	var direction = (player.global_position - global_position)
	if abs(direction.x) > 300 || abs(direction.y) > 300:
		return
	motion += direction * ACCELERATION * delta
	motion = motion.clamped(MAX_SPEED)
	sprite.flip_h = global_position < player.global_position
	motion = move_and_slide(motion)
