extends Area2D

export(Resource) var connection = null
export(String, FILE, "*.tscn") var new_level_path = ""
func _ready():
	pass


func _on_Door_body_entered(player):
	print("hit door")
	player.emit_signal("door_entered", self)
