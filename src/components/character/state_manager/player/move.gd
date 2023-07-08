extends "res://src/components/character/state_manager/base_state.gd"

@export var GRAVITY = 800
@export var ACCELERATION = 300
@export var MAX_SPEED = 200
@export var DECELERATION = 500
@export var JUMP_HEIGHT = -400
@export var MIN_JUMP_FORCE = 0
@export var MAX_JUMP_FORCE = -800

@export var JUMP_ACCELERATION = 2400
@export var AIR_ACCELERATION = 200
@export var AIR_CONTROL = 0.5
@export var AIR_BRAKE = 100
#@export var DASH_SPEED = 400
@export var DASH_SPEED = Vector2(1000, 300)
@export var DASH_DURATION = 0.2
@export var DASH_COOLDOWN = 1.0
@export var GROUND_FRICTION = 100

var velocity = Vector2.ZERO
var is_on_ground = false

var is_dashing = false
var dash_timer = 0.0
var dash_cooldown_timer = 0.0
var dash_direction = Vector2.ZERO
var initial_move_param = {}

var jump_start_velocity = 0
var is_jumping = false

func _ready():
	self.initial_move_param = {
		"DASH_SPEED": DASH_SPEED,
		"DASH_DURATION": DASH_DURATION,
		"DASH_COOLDOWN": DASH_COOLDOWN
	}

func approach(current, target, step):
	if current < target:
		return min(current + step, target)
	else:
		return max(current - step, target)

func map_range(value, input_min, input_max, output_min, output_max):
	return output_min + (output_max - output_min) * (value - input_min) / (input_max - input_min)

func do_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")
	input_vector.y = Input.get_action_strength("player_down") - Input.get_action_strength("player_up")
	self.is_on_ground = self.host.is_on_floor()
	if is_on_ground:
		velocity.x = approach(velocity.x, input_vector.x * MAX_SPEED, ACCELERATION * delta)
		velocity.y = 0
		
		if Input.is_action_just_pressed("player_jump"):
			is_jumping = true
			jump_start_velocity = map_range(Input.get_action_strength("player_jump"), 0, 1, MIN_JUMP_FORCE, MAX_JUMP_FORCE)
			velocity.y = jump_start_velocity
			is_on_ground = false
	else:
		velocity.x = approach(velocity.x, input_vector.x * MAX_SPEED, AIR_ACCELERATION * delta)
		
		if abs(velocity.x) < AIR_CONTROL:
			velocity.x = 0
		elif input_vector.x == 0:
			velocity.x = approach(velocity.x, 0, AIR_BRAKE * delta)
			
	if Input.is_action_just_pressed("player_dash") and dash_cooldown_timer <= 0.0:
		is_dashing = true
		dash_timer = DASH_DURATION
		dash_cooldown_timer = DASH_COOLDOWN
		dash_direction = input_vector.normalized()
		if is_jumping:
			self.is_jumping = false
	
	if is_on_ground:
		velocity.x = approach(velocity.x, 0, GROUND_FRICTION * delta)
	
	if is_dashing:
#		velocity = dash_direction * DASH_SPEED
		velocity.x = dash_direction.x * DASH_SPEED.x
		velocity.y = dash_direction.y * DASH_SPEED.y
		dash_timer -= delta
		
		if dash_timer <= 0.0:
			is_dashing = false
	
	if velocity.y < 0 and self.host.is_on_ceiling():
		velocity.y = 0
	
#	if not self.is_dashing:
	velocity.y += GRAVITY * delta
	
	if is_jumping:
		if velocity.y > 0 and !Input.is_action_pressed("player_dash"):
			is_jumping = false
		else:
			velocity.y = approach(velocity.y, 0, GRAVITY * delta)
	
	self.host.velocity = velocity
	self.host.move_and_slide()

func static_do_process(delta):
	if self.host.is_on_floor():
		self.dash_cooldown_timer = max(0.0, dash_cooldown_timer - delta)

func can_enter_state() -> bool:
	return (
		self.host.velocity != Vector2.ZERO or
		not self.host.is_on_floor() or
#		self.dash_cooldown_timer > 0 or
		Input.get_axis("player_left", "player_right") != 0 or 
		Input.get_action_strength("player_jump") != 0 or
		Input.get_action_strength("player_dash") != 0)
