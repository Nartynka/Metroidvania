extends CenterContainer

func _on_LoadBtn_pressed():
	SoundFx.play("Click", -20)
	SaveAndLoad.is_loading = true
	get_tree().change_scene("res://World/World.tscn")


func _on_QuitBtn_pressed():
	SoundFx.play("Click", -20)
	get_tree().quit()
