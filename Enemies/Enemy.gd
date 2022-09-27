extends KinematicBody2D

var deathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export(int) var MAX_SPEED = 15
var motion = Vector2.ZERO

onready var stats = $EnemyStats

func _on_Hurtbox_hit(damage):
	stats.health -= damage

func _on_EnemyStats_enemy_death():
	Utils.instance_on_main(deathEffect, global_position)
	queue_free()
