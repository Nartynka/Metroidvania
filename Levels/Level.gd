extends Node2D

const WORLD = preload("res://World/World.gd")

func _ready():
	var parent = get_parent()
	if parent is WORLD:
		parent.currentLevel = self

func save() -> Dictionary: 
	var save_dict = {
		"filename": get_filename(),
		"parent": get_parent().get_path(),
		"pos_x": position.x,
		"pos_y": position.y
	}
	return save_dict
