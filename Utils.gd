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
	var player = get_tree().get_nodes_in_group("Player")
	if player:
		return player[0]

func _input(event):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
