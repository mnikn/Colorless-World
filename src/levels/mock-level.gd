extends Node2D

func _ready():
	$Character.set_state("idle")
#	self.tween_color_filter(Vector3(0.0,0.0,0.0))
#	await self.get_tree().create_timer(2.0).timeout


func tween_color_filter(target_val, duration = 2.0):
	var tween = self.create_tween()
	var prev_val = self.material.get_shader_parameter("filter_coff")
#	var target_val = Vector3(0.0,0.0,0.0)
	tween.tween_method(func(val):
		self.material.set_shader_parameter("filter_coff", val), 
		prev_val, 
		target_val, 
		duration)
