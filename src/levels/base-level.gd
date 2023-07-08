extends Node2D
signal on_exit_entered(target_scene, area_node)
signal on_dead_entered()

var collision_enabled = true

func _ready():
	for node in $Exits.get_children():
		node.connect("body_entered", func (body):
			self.emit_signal("on_exit_entered", node.target_scene, node))
	for node in $Deads.get_children():
		node.connect("body_entered", func (body):
			self.emit_signal("on_dead_entered"))
	self.set_collision_enabled(self.collision_enabled)
	
func set_collision_enabled(val):
	self.collision_enabled = val
	for node in $Exits.get_children():
		node.monitoring = val
	for node in $Deads.get_children():
		node.monitoring = val
