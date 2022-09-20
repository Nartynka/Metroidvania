extends Resource
class_name PlayerStats

signal player_death

var max_health = 4
var health = max_health setget set_health

func set_health(new_value):
	if new_value < health:
		Events.emit_signal("add_screenshake", 0.4, 0.5)
	health = clamp(new_value, 0, max_health)
	if health == 0:
		emit_signal("player_death")
