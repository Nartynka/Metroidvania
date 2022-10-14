extends "res://Enemies/Enemy.gd"

onready var leftWallCheck = $LeftWallCheck
onready var rightWallCheck = $RightWallCheck

const Bullet = preload("res://Enemies/EnemyBullet.tscn")
export(int) var ACCELERATION = 70

signal boss_died
	
func _process(delta):
	chase_player(delta)

func chase_player(delta):
	var player = Utils.get_player()
	if player != null:
		var direction = sign(player.global_position.x - global_position.x)
		motion.x += ACCELERATION * delta * direction
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		global_position.x += motion.x * delta
		rotation_degrees = lerp(rotation_degrees, (motion.x / MAX_SPEED) * 5, 0.3)
		
		if (rightWallCheck.is_colliding() or leftWallCheck.is_colliding()) and motion.x != 0:
			motion.x *= -0.5

func fire_bullet():
	var bullet = Utils.instance_on_main(Bullet, global_position)
	var velocity = Vector2.DOWN * 50
	velocity = velocity.rotated(deg2rad(rand_range(-40, 40)))
	bullet.velocity = velocity
	

func _on_FireTimer_timeout():
	fire_bullet()

func _on_EnemyStats_enemy_death():
	emit_signal("boss_died")
	._on_EnemyStats_enemy_death()
