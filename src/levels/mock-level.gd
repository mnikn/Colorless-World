extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	await self.get_tree().create_timer(2.0).timeout
	var coff = Vector3(0.0,0.0,0.0)
	var tween = self.create_tween()
#	tween.tween_property(self.material, "shader_param/filter_coff", coff, 3.0)
	tween.tween_method(func(val):
		self.material.set_shader_parameter("filter_coff", val), 
		Vector3(1.0,1.0,1.0), 
		Vector3(0.0,0.0,0.0), 
		3.0)
#	self.material.set_shader_parameter("filter_coff", coff)
#	shader_param = 0.5
#	sprite.material.set_shader_param("param_name", shader_param)
