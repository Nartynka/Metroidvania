extends StaticBody2D

onready var animationPlayer = $AnimationPlayer
onready var PlayerStats = ResourceLoader.PlayerStats
func _on_SaveArea_body_entered(body):
	if body is Player: 
		animationPlayer.play("Save")
		SaveAndLoad.save_game()
		PlayerStats.refill_stats()
		SoundFx.play("Powerup", 0, 0.6)
