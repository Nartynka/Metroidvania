extends KinematicBody2D

export(int) var ACCELERATION = 512
export(int) var MAX_SPEED = 64
export(float) var FRICTION = 0.25
export(int) var MAX_SLOOPE_ANGLE = 45
export(int) var GRAVITY = 400
export(int) var JUMP_FORCE = 200

var motion = Vector2.ZERO
var snap_vector = Vector2.ZERO
var just_jumped = false

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer

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
	if is_on_floor(): 
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE
			snap_vector = Vector2.ZERO
			just_jumped = true
	else:
		if Input.is_action_just_released("ui_up"):
			motion.y -= -JUMP_FORCE/2

func apply_gravity(delta):
	if not is_on_floor():
		motion.y += GRAVITY * delta
		motion.y = min(motion.y, JUMP_FORCE)

func update_animation(input_vector):
	if input_vector.x!=0:
		sprite.scale.x = input_vector.x
		animationPlayer.play("Run")
	else:
		animationPlayer.play("Idle")
	if not is_on_floor():
		animationPlayer.play("Jump")

func move():
	var was_on_floor = is_on_floor()
	var last_position = position
	var last_motion = motion
	
	motion = move_and_slide_with_snap(motion, snap_vector*2, Vector2.UP, true, 4, deg2rad(MAX_SLOOPE_ANGLE))
	
	# LANDING = Prevent from losing motion after landing on slopes
	# if was in the air and now is on floor (just landed)
	if not was_on_floor and is_on_floor():
		motion.x = last_motion.x
	
	# Prevent from yeeting yourself at the end of clif
	# if just left floor and was not jumping (end of clif)
	if was_on_floor and not is_on_floor() and not just_jumped:
		motion.y = 0
		position.y = last_position.y

	# Prevent from sliding
	# Now character isn't sliding bc snap_vector is multiplied by 2 but if you multiply it by 4 it will slide
	# if is on not moving floor and motion is very small (when sliding from slope motion is very small)
#	if is_on_floor() and get_floor_velocity().length() == 0 and abs(motion.x) < 1:
#		position.x = last_position.x
