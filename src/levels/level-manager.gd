extends Node2D


func _ready():
	$Character.set_state("idle")
	$Character.position = $LevelContainer.get_children()[0].get_node("InitialCharacterPos").position
	for node in $LevelContainer.get_children():
		node.connect("on_exit_entered", func (target_scene_path):
			self.call_deferred("switch_level", target_scene_path)
		)

func tween_color_filter(target_val, duration = 2.0):
	var tween = self.create_tween()
	var prev_val = self.material.get_shader_parameter("filter_coff")
	tween.tween_method(func(val):
		self.material.set_shader_parameter("filter_coff", val), 
		prev_val, 
		target_val, 
		duration)
		
func switch_level(target_scene_path):
	var current_level = $LevelContainer.get_children()[0]
	if target_scene_path != null and len(target_scene_path) > 0:
		$Character.get_node("StateManager").stop()
		current_level.set_collision_enabled(false)
		
		var target_scene = ResourceManager.load_scene(target_scene_path)
		var target_scene_node = target_scene.instantiate()
		target_scene_node.set_collision_enabled(false)
		target_scene_node.position = Vector2(1280, 0)
		$LevelContainer.add_child(target_scene_node)
		
		var tween = self.create_tween()
		tween.set_parallel(true)
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(current_level, "position", Vector2(-1680, 0), 0.7)
		tween.tween_property(target_scene_node, "position", Vector2(0, 0), 0.7)
		tween.tween_property($Character, "position", target_scene_node.get_node("InitialCharacterPos").position, 0.3)
		await tween.finished
		current_level.queue_free()
		target_scene_node.set_collision_enabled(true)
		target_scene_node.connect("on_exit_entered", func (next_target_scene_path):
			self.call_deferred("switch_level", next_target_scene_path)
		)
		$Character.get_node("StateManager").start()
