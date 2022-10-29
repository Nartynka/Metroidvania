extends Node

onready var currentLevel = $Level_00

func _ready():
	VisualServer.set_default_clear_color(Color.black)
	Music.play_queue()
	
	if SaveAndLoad.is_loading:
		SaveAndLoad.load_game()
		SaveAndLoad.is_loading = false

	var player = Utils.get_player()
	player.connect("door_entered", self, "_on_door_entered")
	player.connect("player_death", self, "_on_Player_player_death")

func change_levels(door):
	var offset = currentLevel.position
	currentLevel.queue_free()
	var NewLevel = load(door.new_level_path)
	var newLevel = NewLevel.instance()
	add_child(newLevel)
	var newDoor = get_door(door, door.connection)
	var exit_position = newDoor.position - offset
	newLevel.position = door.position - exit_position
	
func get_door(ignore_door, connection):
	var doors = get_tree().get_nodes_in_group("Door")
	for door in doors:
		if door.connection == connection and door != ignore_door:
			return door
	return null

func _on_door_entered(door):
	call_deferred("change_levels", door)


func _on_Player_player_death():
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://Menus/GameOverMenu.tscn")
