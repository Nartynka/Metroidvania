extends Area2D

export(Resource) var connection = null
export(String, FILE, "*.tscn") var new_level_path = ""

var active = true

func _on_Door_body_entered(player):
	if active:
		print("aaaa")
		player.emit_signal("door_entered", self)
		active = false
