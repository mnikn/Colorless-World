extends "res://src/components/character/state_manager/base_state.gd"

@export var GRAVITY = 800
@export var ACCELERATION = 300
@export var MAX_SPEED = 200
@export var DECELERATION = 500
@export var JUMP_HEIGHT = -400
@export var AIR_ACCELERATION = 200
@export var AIR_CONTROL = 0.5
@export var AIR_BRAKE = 100

var velocity = Vector2.ZERO
var is_on_ground = false

func approach(current, target, step):
	if current < target:
		return min(current + step, target)
	else:
		return max(current - step, target)

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")
	self.is_on_ground = (self.host as CharacterBody2D).is_on_floor()
	if is_on_ground:
		velocity.x = approach(velocity.x, input_vector.x * MAX_SPEED, ACCELERATION * delta)
		velocity.y = 0
		if Input.is_action_just_pressed("player_jump"):
			velocity.y = JUMP_HEIGHT
			is_on_ground = false
	else:
		velocity.x = approach(velocity.x, input_vector.x * MAX_SPEED, AIR_ACCELERATION * delta)
		if abs(velocity.x) < AIR_CONTROL:
			velocity.x = 0
		elif input_vector.x == 0:
			velocity.x = approach(velocity.x, 0, AIR_BRAKE * delta)
		velocity.y += GRAVITY * delta
	self.host.velocity = velocity
	self.host.move_and_slide()

func _on_Area2D_body_entered(body):
	is_on_ground = true

func _on_Area2D_body_exited(body):
	is_on_ground = false

func can_enter_state() -> bool:
	return Input.get_axis("player_left", "player_right") != 0 or Input.get_action_strength("player_jump") != 0
