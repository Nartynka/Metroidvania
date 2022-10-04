extends Powerup

func _pick_up():
	PlayerStats.missiles_unlocked = true
	queue_free()
