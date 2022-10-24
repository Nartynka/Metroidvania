extends Powerup

func _pick_up():
	._pick_up()
	if PlayerStats.missiles_unlocked:
		PlayerStats.missiles = PlayerStats.max_missiles
	else:
		PlayerStats.missiles_unlocked = true
	queue_free()
