extends "res://src/components/character/state_manager/base_state.gd"

@export var GRAVITY = 800

func on_enter(_prev_state):
	self.host.play_animation("idle")

func on_exit(_current_state):
	pass

func can_enter_state():
	return (self.host.is_on_floor() and 
		self.host.velocity == Vector2.ZERO and
		not Input.is_action_pressed("player_left") and 
		not Input.is_action_pressed("player_right") and 
		not Input.is_action_pressed("player_jump") and 
		not Input.is_action_pressed("player_dash"))
