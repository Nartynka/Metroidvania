extends Node

export(String) var sound_name = ""
export(float) var volume = 0
export(float) var pitchscale = 1

func _ready():
	SoundFx.play(sound_name, volume, pitchscale)
