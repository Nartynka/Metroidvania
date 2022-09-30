extends HBoxContainer

onready var label = $Label

var PlayerStats = ResourceLoader.PlayerStats

func _ready():
	PlayerStats.connect("player_missiles_change", self, "_on_missiles_change")
	label.text = str(PlayerStats.max_missiles)

func _on_missiles_change(amount):
	label.text = str(amount)
