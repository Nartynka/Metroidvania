extends ColorRect

var paused := false setget set_pause

func set_pause(new_value):
	paused = new_value
	get_tree().paused = paused
	visible = paused

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		self.paused = !paused

func _on_ResumeButton_pressed():
	self.paused = false


func _on_QuitButton_pressed():
	get_tree().quit()
