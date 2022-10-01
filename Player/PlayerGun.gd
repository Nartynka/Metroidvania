extends Node2D

var opposite = false
func _input(event):
#	opposite = false
	var player = get_parent()
	var rs_look = Vector2(0,0)
	var deadzone = 0.3
	if event is InputEventJoypadMotion:
		rs_look.y = Input.get_joy_axis(0, JOY_AXIS_3)
		rs_look.x = Input.get_joy_axis(0, JOY_AXIS_2) * player.scale.x
		if rs_look.length() >= deadzone:
			rotation_degrees = rad2deg(rs_look.angle())
			if rs_look.x < 0:
				player.scale.x = -player.scale.x
				opposite = true
		else:
			opposite = false
				
	elif event is InputEventMouseMotion:
		rotation = player.get_local_mouse_position().angle()
