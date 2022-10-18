extends HBoxContainer

onready var label = $Label

var PlayerStats = ResourceLoader.PlayerStats

func _ready():
	PlayerStats.connect("missiles_unlocked", self, "_on_missiles_unlocked")
	PlayerStats.connect("missiles_change", self, "_on_missiles_change")
	label.text = str(PlayerStats.max_missiles)

func _on_missiles_change(amount):
	label.text = str(amount)

func _on_missiles_unlocked(visable):
	visible = visable
