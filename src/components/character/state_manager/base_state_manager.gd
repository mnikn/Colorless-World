extends Node
class_name GameStateTree

@export var enabled = true

var host = null
var current_state = null

var prev_state_enabled = {} 

func _ready():
	self.host = self.get_parent()
	for state in self.get_children():
		state.state_manager = self
		state.host = self.host
	
func _process(_delta):
	if not self.enabled:
		return
	for state in self.get_children():
		if state.can_enter_state():
			if not state.enabled:
				state.enabled = true
				if self.current_state != null:
					self.current_state.enabled = false
					self.current_state.on_exit(state)
				self.current_state = state
				state.on_enter(self.current_state)
				break
		elif state.enabled:
			state.enabled = false
			state.on_exit(self.current_state)
			self.current_state = null

func change_state(state):
	var target_state = ArrayUtils.find(self.get_children(), func (item): return item.name == state.capitalize())
	if target_state == null:
		return
	for prev_state in self.get_children():
		if prev_state.name != state.to_lower():
			prev_state.enabled = false
			prev_state.on_exit(self.current_state)
	target_state.enabled = true
	target_state.on_enter(self.current_state)
	self.current_state = target_state

func stop():
	self.enabled = false
	for state in self.get_children():
		self.prev_state_enabled[state.name] = state.enabled
		state.enabled = false

func start():
	self.enabled = true
	for state in self.get_children():
		if state.name in self.prev_state_enabled:
			state.enabled = self.prev_state_enabled[state.name]

func reset():
	self.prev_state_enabled = {}
	self.stop()
	self.start()
