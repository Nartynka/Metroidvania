extends KinematicBody2D

export(int) var ACCELERATION = 512
export(int) var MAX_SPEED = 64
export(float) var FRICTION = 0.25

export(int) var GRAVITY = 400
export(int) var JUMP_FORCE = 200

var motion = Vector2.ZERO

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer

func _physics_process(delta):
	var input_vector = get_input_vector()
	# Add to motion (move player)
	apply_horizontal_force(input_vector, delta)
	# Friction to not slide like on ice
	apply_friction(input_vector)
	jump_check()
	# To always touche the ground and fall down after jump
	apply_gravity(delta)
	update_animation(input_vector)
	motion = move_and_slide(motion, Vector2.UP)
	
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

func jump_check():
	if is_on_floor(): 
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE
	else:
		if Input.is_action_just_released("ui_up"):
			motion.y -= -JUMP_FORCE/2

func apply_gravity(delta):
	motion.y += GRAVITY * delta
	motion.y = min(motion.y, JUMP_FORCE)

func update_animation(input_vector):
	if input_vector.x!=0:
		sprite.scale.x = input_vector.x
		animationPlayer.play("Move")
	else:
		animationPlayer.play("Idle")
	if not is_on_floor():
		animationPlayer.play("Jump")










