extends StaticBody2D

onready var animationPlayer = $AnimationPlayer

func _on_SaveArea_body_entered(body):
	if body is Player: 
		animationPlayer.play("Save")
		SaveAndLoad.save_game()
