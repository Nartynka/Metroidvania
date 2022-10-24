extends Control


onready var buttons = [$"%StartButton", $"%LoadButton", $"%QuitButton"]
#var focus = -1
func _ready():
	VisualServer.set_default_clear_color(Color.black)
	buttons[0].grab_focus()

func _input(event):
	if Utils.controller_connected:
		for i in buttons:
			i.mouse_filter = MOUSE_FILTER_IGNORE

func _on_StartButton_pressed():
	SoundFx.play("Click", -20)
	get_tree().change_scene("res://World/World.tscn")


func _on_LoadButton_pressed():
	SoundFx.play("Click", -20)
	SaveAndLoad.is_loading = true
	get_tree().change_scene("res://World/World.tscn")


func _on_QuitButton_pressed():
	SoundFx.play("Click", -20)
	get_tree().quit()
