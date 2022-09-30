extends KinematicBody2D

const Bullet = preload("res://Player/Bullet.tscn")
const DustEffect = preload("res://Effects/DustEffect.tscn")
const JumpEffect = preload("res://Effects/JumpEffect.tscn")
const WallDustEffect = preload("res://Effects/WallDustEffect.tscn")

export(int) var ACCELERATION = 512
export(int) var MAX_SPEED = 64
export(float) var FRICTION = 0.25
export(int) var MAX_SLOOPE_ANGLE = 45
export(int) var SLIDE_SPEED = 48
export(int) var GRAVITY = 400
export(int) var JUMP_FORCE = 200
export(int) var BULLET_SPEED = 250

enum {
	MOVE,
	WALL_SLIDE
}

var state = MOVE
var previous_state = state
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
onready var wallGrabTimer = $WallGrabTimer
onready var gun = $Sprite/PlayerGun
onready var firePoint = $Sprite/PlayerGun/Sprite/Spawnpoint
onready var fireBulletTimer = $FireBulletTimer

func _ready():
	PlayerStats.connect("player_death", self, "on_death")

func set_invincible(new_value):
	invincible = new_value

func _physics_process(delta):
	just_jumped = false
	match state:
		MOVE:
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
			wall_check()
		WALL_SLIDE:
			spriteAnimation.play("Wall Slide")
			var wall_direction = get_wall_direction()
			if wall_direction:
				sprite.scale.x = wall_direction
			wall_slide(delta)
			wall_jump_check(wall_direction)
			move()
			wall_deatch_check(delta, wall_direction)
	previous_state = state
	if Input.is_action_pressed("fire_bullet") and fireBulletTimer.time_left == 0:
		fire_bullet()

func fire_bullet():
	var bullet = Utils.instance_on_main(Bullet, firePoint.global_position)
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
	if is_on_floor() or coyotoJumpTimer.time_left > 0 or previous_state == 1:
		if Input.is_action_just_pressed("ui_up"):
			$Node/Label.text = "Normal Jump"
			jump()
			just_jumped = true
			double_jump = true
	else:
		if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2:
			motion.y -= -JUMP_FORCE/2
		
		if Input.is_action_just_pressed("ui_up") and double_jump:
			$Node/Label.text = "Double Jump"
#			prints("in double: wall: ", is_on_wall(), previous_state)
			jump()
			double_jump = false
#			print("double jumped in move state")

func jump():
	Utils.instance_on_main(JumpEffect, global_position)
	motion.y = -JUMP_FORCE
	snap_vector = Vector2.ZERO

func apply_gravity(delta):
	if not is_on_floor():
		motion.y += GRAVITY * delta
		motion.y = min(motion.y, JUMP_FORCE)

func update_animation(input_vector):
	if Utils.controller_connected:
		var input = Input.get_joy_axis(0, JOY_AXIS_0)
		if abs(input) > 0.3:
			if input > 0:
				sprite.scale.x = 1
			else:
				sprite.scale.x = -1
	else:
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
	if was_on_floor and not (is_on_floor() or is_on_wall()) and not just_jumped:
		motion.y = 0
		position.y = last_position.y
		coyotoJumpTimer.start()

	# Prevent from sliding
	# Now character isn't sliding bc snap_vector is multiplied by 2 but if you multiply it by 4 it will slide
	# if is on not moving floor and motion is very small (when sliding from slope motion is very small)
	if is_on_floor() and get_floor_velocity().length() == 0 and abs(motion.x) < 1:
		position.x = last_position.x

##########################
#		WALL SLIDE	 	#
##########################

func wall_check():
	if !is_on_floor() and is_on_wall() and wallGrabTimer.time_left == 0:
		if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
				var timer = get_tree().create_timer(0.05)
				timer.connect("timeout", self, "wall_grab")

func wall_grab():
	if is_on_wall() and not is_on_floor():
		state = WALL_SLIDE
		double_jump = true
		create_dust_effect()

func get_wall_direction():
	var is_wall_right = test_move(transform, Vector2.RIGHT)
	var is_wall_left = test_move(transform, Vector2.LEFT)
	# return 1 if wall is on the left, return -1 if wall is on right
	return int(is_wall_left) - int(is_wall_right)

func wall_jump_check(wall_direction):
	if Input.is_action_just_pressed("ui_up"):
		motion.x = wall_direction * MAX_SPEED
		jump_check()
		if just_jumped:
			wallGrabTimer.start()
		state = MOVE
		var dust_position = global_position + Vector2(wall_direction*4, -2)
		var dust = Utils.instance_on_main(WallDustEffect, dust_position)
		dust.scale.x = wall_direction

func wall_slide(delta):
	var max_slide_speed = SLIDE_SPEED
	if Input.is_action_pressed("ui_down"):
		max_slide_speed = JUMP_FORCE
	motion.y = max(motion.y * delta, max_slide_speed)

func wall_deatch_check(delta, wall_direction):
	if int(Input.is_action_pressed("ui_left")) != wall_direction and -int(Input.is_action_pressed("ui_right")) != wall_direction:
		# is not holding direction key
		state = MOVE
	if wall_direction == 0 or is_on_floor():
		# is on floor or wall on both side
		state = MOVE

func _on_Hurtbox_hit(damage):
	if not invincible:
		PlayerStats.health -= damage
		blinkAnimation.play("Blink")

func on_death():
	queue_free()
