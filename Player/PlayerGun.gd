extends Node2D

func _process(_delta):
	var player = get_parent()
	rotation = player.get_local_mouse_position().angle()
