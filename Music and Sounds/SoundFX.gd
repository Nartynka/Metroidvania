extends Node

var sound_path = "res://Music and Sounds/"
var sounds = {
	"Bullet": load(sound_path + "Bullet.wav"),
	"Click": load(sound_path + "Click.wav"),
	"EnemyDie": load(sound_path + "EnemyDie.wav"),
	"Explosion": load(sound_path + "Explosion.wav"),
	"Hurt": load(sound_path + "Hurt.wav"),
	"Jump": load(sound_path + "Jump.wav"),
	"Pause": load(sound_path + "Pause.wav"),
	"Powerup": load(sound_path + "Powerup.wav"),
	"Step": load(sound_path + "Step.wav"),
	"Unpause": load(sound_path + "Unpause.wav"),
}

onready var soundPlayers = get_children()

func play(sound, volume = 0, pitch_scale = 1):
	for soundPlayer in soundPlayers:
		if not soundPlayer.playing:
			soundPlayer.pitch_scale = pitch_scale
			soundPlayer.volume_db = volume
			soundPlayer.stream = sounds[sound]
			soundPlayer.play()
			return
	print("Too many sounds palying at once")
