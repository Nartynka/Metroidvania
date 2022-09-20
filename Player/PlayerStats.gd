extends Resource
class_name PlayerStats

signal player_death

var max_health = 4
var health = max_health setget set_health

func set_health(new_value):
	health = clamp(new_value, 0, max_health)
	if health == 0:
		emit_signal("player_death")
