extends "res://Player/Projectile.gd"

func _ready():
	SoundFx.play("Bullet", -15, 0.5)
	set_process(false)

