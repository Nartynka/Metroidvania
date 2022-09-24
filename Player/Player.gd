extends KinematicBody2D

const DustEffect = preload("res://Effects/DustEffect.tscn")
const Bullet = preload("res://Player/Bullet.tscn")
const JumpEffect = preload("res://Effects/JumpEffect.tscn")

export(int) var ACCELERATION = 512
export(int) var MAX_SPEED = 64
export(float) var FRICTION = 0.25
export(int) var MAX_SLOOPE_ANGLE = 45
export(int) var GRAVITY = 400
export(int) var JUMP_FORCE = 200
export(int) var BULLET_SPEED = 250

var motion = Vector2.ZERO
var snap_vector = Vector2.ZERO
var just_jumped = false
var invincible = false setget set_invincible
var double_jump = false

var PlayerStats = ResourceLoader.PlayerStats

onready var sprite = $Sprite
onready var spriteAnimation = $SpriteAnimation
onready var blinkAnimation = $BlinkAnimation
onready var coyotoJumpTimer = $CoyoteJumpTimer
onready var gun = $Sprite/PlayerGun
onready var missle = $Sprite/PlayerGun/Sprite/Missle
onready var fireBulletTimer = $FireBulletTimer

func _ready():
	PlayerStats.connect("player_death", self, "on_death")

func set_invincible(new_value):
	invincible = new_value

func _physics_process(delta):
	just_jumped = false
	
	var input_vector = get_input_vector()
	# Add to motion (move player)
	apply_horizontal_force(input_vector, delta)
	# Friction to not slide like on ice
	apply_friction(input_vector)
	update_snap_vector()
	jump_check()
	# To always touche the ground and fall down after jump
	apply_gravity(delta)
	update_animation(input_vector)
	move()


	if Input.is_action_pressed("fire_bullet") and fireBulletTimer.time_left == 0:
		fire_bullet()

func fire_bullet():
	var bullet = Utils.instance_on_main(Bullet, missle.global_position)
	bullet.velocity = Vector2.RIGHT.rotated(gun.rotation) * BULLET_SPEED
	bullet.velocity.x *= sprite.scale.x
	bullet.rotation = bullet.velocity.angle()
	fireBulletTimer.start()
	
	
func create_dust_effect():
	var dust_position = global_position
	dust_position.x += rand_range(-4, 4)
	var dustEffect = Utils.instance_on_main(DustEffect, dust_position)
#	dustEffect.queue_free()
	
func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	return input_vector
	
func apply_horizontal_force(input_vector, delta):
	if input_vector.x != 0:
		motion.x += input_vector.x * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)

func apply_friction(input_vector):
	if input_vector.x == 0:
		motion.x = lerp(motion.x, 0, FRICTION)

func update_snap_vector():
	if is_on_floor():
		snap_vector = Vector2.DOWN

func jump_check():
	if is_on_floor() or coyotoJumpTimer.time_left > 0: 
		if Input.is_action_just_pressed("ui_up"):
			jump(JUMP_FORCE)
			just_jumped = true
			double_jump = true
	else:
		if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2:
			motion.y -= -JUMP_FORCE/2
#			double_jump = false
		
		if Input.is_action_just_pressed("ui_up") and double_jump: 
			jump(JUMP_FORCE/2)
			double_jump = false

func jump(force):
	Utils.instance_on_main(JumpEffect, global_position)
	motion.y = -JUMP_FORCE
	snap_vector = Vector2.ZERO

func apply_gravity(delta):
	if not is_on_floor():
		motion.y += GRAVITY * delta
		motion.y = min(motion.y, JUMP_FORCE)

func update_animation(input_vector):
	sprite.scale.x = sign(get_local_mouse_position().x)
	if input_vector.x!=0:
		spriteAnimation.play("Run")
		# Play backwards if player is going backward
		spriteAnimation.playback_speed = input_vector.x * sprite.scale.x
	else:
		spriteAnimation.play("Idle")
	if not is_on_floor():
		spriteAnimation.playback_speed = 1
		spriteAnimation.play("Jump")

func move():
	var was_on_floor = is_on_floor()
	var last_position = position
	var last_motion = motion
	
	motion = move_and_slide_with_snap(motion, snap_vector*2, Vector2.UP, true, 4, deg2rad(MAX_SLOOPE_ANGLE))
	
	# Just landed (was in the air and now is on ground)
	# prevent from losing motion after landing on slopes
	if not was_on_floor and is_on_floor():
		motion.x = last_motion.x
		Utils.instance_on_main(JumpEffect, global_position)
	
	# Just left ground and was not jumping (end of clif)
	# prevent from yeeting yourself at the end of clif
	if was_on_floor and not is_on_floor() and not just_jumped:
		motion.y = 0
		position.y = last_position.y
		coyotoJumpTimer.start()

	# Prevent from sliding
	# Now character isn't sliding bc snap_vector is multiplied by 2 but if you multiply it by 4 it will slide
	# if is on not moving floor and motion is very small (when sliding from slope motion is very small)
	if is_on_floor() and get_floor_velocity().length() == 0 and abs(motion.x) < 1:
		position.x = last_position.x

func _on_Hurtbox_hit(damage):
	if not invincible:
		PlayerStats.health -= damage
		blinkAnimation.play("Blink")

func on_death():
	queue_free()
