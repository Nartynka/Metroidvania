extends Control

var PlayerStats = ResourceLoader.PlayerStats

onready var empty = $Empty
onready var full = $Full

func _ready():
	PlayerStats.connect("player_health_change", self, "_on_player_health_change")
	empty.rect_size.x = 5 * PlayerStats.max_health + 1
	full.rect_size.x = empty.rect_size.x 

func _on_player_health_change(value):
	full.rect_size.x = 5 * value + 1
