extends Node

var controller_connected = false

func instance_on_main(Scene, position):
	var main = get_tree().current_scene
	var instance = Scene.instance()
	main.add_child(instance)
	instance.global_position = position
	return instance

func _ready():
	if Input.get_connected_joypads():
		controller_connected = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func find_player():
	return get_tree().get_nodes_in_group("Player")[0]
