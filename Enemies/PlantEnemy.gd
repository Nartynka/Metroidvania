extends "res://Enemies/Enemy.gd"

export(int) var BULLET_SPEED = 30
export(float) var SPREAD = 30

var EnemyBullet = preload("res://Enemies/EnemyBullet.tscn")

onready var bulletSpawn = $BulletSpawn
onready var fireDirection = $FireDirection

func fire_bullet():
	var bullet = Utils.instance_on_main(EnemyBullet, bulletSpawn.global_position)
	var velocity = (fireDirection.global_position - global_position).normalized() * BULLET_SPEED
	velocity = velocity.rotated(rad2deg(rand_range(-SPREAD/2, SPREAD/2)))
	bullet.velocity = velocity
