extends ColorRect

var paused := false setget set_pause

func set_pause(new_value):
	paused = new_value
	get_tree().paused = paused
	visible = paused
	$"%ResumeButton".grab_focus()
	if paused:
		SoundFx.play("Pause", -10)
	else:
		SoundFx.play("Unpause", -10)
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") and Utils.get_player():
		self.paused = !paused

func _on_QuitButton_pressed():
	SoundFx.play("Click", -20)
	get_tree().quit()
	
func _on_ResumeButton_pressed():
	SoundFx.play("Click", -20)
	self.paused = false
