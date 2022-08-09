extends Node

func instance_on_main(Scene, position):
	var main = get_tree().current_scene
	var instance = Scene.instance()
	main.add_child(instance)
	instance.global_position = position
	return instance
