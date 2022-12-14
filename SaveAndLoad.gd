extends Node

var custom_data = {
	missiles_unlocked = false,
	boss_defeated = false
}


var is_loading : bool = false

func save_game():
	var save_file = File.new()
	save_file.open("user://savegame.save", File.WRITE)
	
	save_file.store_line(to_json(custom_data))
	
	var persistingNodes = get_tree().get_nodes_in_group("Persists")
	for node in persistingNodes:
		var node_data = node.save()
		save_file.store_line(to_json(node_data))	
	save_file.close()
	
func load_game():
	var save_file = File.new()
	if !save_file.file_exists("user://savegame.save"):
		return
	
	var persistingNodes = get_tree().get_nodes_in_group("Persists")
	for node in persistingNodes:
		node.queue_free()
	
	save_file.open("user://savegame.save", File.READ)

	if not save_file.eof_reached():
		custom_data = parse_json(save_file.get_line())
	
	while not save_file.eof_reached():
		var current_line = parse_json(save_file.get_line())
		if current_line != null:
			var newNode = load(current_line["filename"]).instance()
			get_node(current_line["parent"]).add_child(newNode, true)
			newNode.position = Vector2(current_line["pos_x"], current_line["pos_y"])
			for property in current_line.keys():
				if (property == "filename" or property == "parent" or property == "pos_x" or property == "pox_y"):
					continue
				newNode.set(property, current_line[property])
	save_file.close()
