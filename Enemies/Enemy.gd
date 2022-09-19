extends KinematicBody2D

export(int) var MAX_SPEED = 15
var motion = Vector2.ZERO

onready var stats = $EnemyStats

func _on_Hurtbox_hit(damage):
	stats.health -= damage

func _on_EnemyStats_enemy_death():
	queue_free()
