extends "res://Enemies/Enemy.gd"

enum DIRECTION {LEFT = -1, RIGHT = 1}

export(DIRECTION) var direction = DIRECTION.RIGHT

onready var floorCast = $FloorCast
onready var wallCast = $WallCast

func _ready():
	wallCast.cast_to.x *= direction

func _physics_process(delta):
	if wallCast.is_colliding():
		global_position = wallCast.get_collision_point()
		var normal = wallCast.get_collision_normal()
		rotation = normal.rotated(rad2deg(90)).angle()
	else:
		floorCast.rotation_degrees = -MAX_SPEED * 10 * direction * delta
		if wallCast.is_colliding():
			global_position = floorCast.get_collision_point()
			var normal = floorCast.get_collision_normal()
			rotation = normal.rotated(rad2deg(90)).angle()
		else:
			rotation_degrees += 20 * direction
