extends "res://Enemies/Enemy.gd"

export(int) var ACCELERATION = 400
onready var sprite = $Sprite
var player = null

func _ready():
	player = Utils.find_player()
	
func _physics_process(delta):
	if player != null:
		chase_player(delta)

func chase_player(delta):
	var direction = (player.global_position - global_position)
	if direction.x > 400 || direction.y > 400 :
		return
	motion += direction * ACCELERATION * delta
	motion = motion.clamped(MAX_SPEED)
	sprite.flip_h = global_position < player.global_position
	motion = move_and_slide(motion)
