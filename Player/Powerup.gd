extends Area2D
class_name Powerup

var PlayerStats = ResourceLoader.PlayerStats

func _pick_up():
	SoundFx.play("Powerup", -15)
