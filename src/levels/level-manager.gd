extends Node2D

const intial_scene = "res://src/levels/level-3.tscn"
var changing_color = false

func _ready():
#	self.tween_color_filter(Vector3(1.0,1.0,1.0),0.0)
#	self.tween_color_filter(Vector3(0.0,0.0,0.0),0.0)
	$Character.set_state("idle")
	$UI/HBoxContainer/DashBar.max_value = $Character.get_node("StateManager/Move").DASH_COOLDOWN
	$UI/HBoxContainer/DashBar.value = $Character.get_node("StateManager/Move").DASH_COOLDOWN - $Character.get_node("StateManager/Move").dash_cooldown_timer
	$LevelContainer.add_child(ResourceManager.load_scene(intial_scene).instantiate())
	
	$Character.position = $LevelContainer.get_children()[0].get_node("InitialCharacterPos").position
	for node in $LevelContainer.get_children():
		node.connect("on_exit_entered", func (target_scene_path, area_node):
			self.call_deferred("switch_level", target_scene_path, area_node)
		)
		node.connect("on_dead_entered", func ():
			self.call_deferred("on_dead"))

func tween_color_filter(target_val, duration = 0.5):
	var tween = self.create_tween()
	var prev_val = self.material.get_shader_parameter("filter_coff")
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_method(func(val):
		self.material.set_shader_parameter("filter_coff", val), 
		prev_val, 
		target_val, 
		duration)

func _process(delta):
	$UI/HBoxContainer/DashBar.max_value = $Character.get_node("StateManager/Move").DASH_COOLDOWN
	$UI/HBoxContainer/DashBar.value = $Character.get_node("StateManager/Move").DASH_COOLDOWN - $Character.get_node("StateManager/Move").dash_cooldown_timer
	$UI/DebugLabel.text = "Velocity: %s, on_wall: %s, on_ceil: %s" % [
		str($Character.velocity),
		str($Character.is_on_wall()),
		str($Character.is_on_ceiling()),
	]

func _input(event):
	if changing_color:
		return
		
	if Input.is_action_just_pressed("player_select_red"):
		self.changing_color = true
		await self.tween_color_filter(Vector3(0,1,1))
		self.character_recover()
		$Character/StateManager/Move.DASH_DURATION *= 3
		self.changing_color = false
	elif Input.is_action_just_pressed("player_select_green"):
		self.changing_color = true
		await self.tween_color_filter(Vector3(1,0,1))
		self.character_recover()
		$Character/StateManager/Move.DASH_COOLDOWN *= 0.5
		self.changing_color = false
	elif Input.is_action_just_pressed("player_select_blue"):
		self.changing_color = true
		await self.tween_color_filter(Vector3(1,1,0))
		self.character_recover()
		$Character/StateManager/Move.DASH_SPEED *= 3
		$Character/StateManager/Move.DASH_DURATION *= 0.05
		$Character/StateManager/Move.DASH_COOLDOWN *= 2
		self.changing_color = false


func character_recover():
	$Character/StateManager/Move.DASH_DURATION = $Character/StateManager/Move.initial_move_param.DASH_DURATION
	$Character/StateManager/Move.DASH_SPEED = $Character/StateManager/Move.initial_move_param.DASH_SPEED
	$Character/StateManager/Move.DASH_COOLDOWN = $Character/StateManager/Move.initial_move_param.DASH_COOLDOWN

func switch_level(target_scene_path, area_node):
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
		
		var character_initial_pos = $Character.position
		if area_node.direction == "right":
			character_initial_pos.x = 40
		elif area_node.direction == "left":
#			character_initial_pos.x = 1230
			character_initial_pos.x = 1250
		tween.tween_property($Character, "position", character_initial_pos, 0.3)
		await tween.finished
		current_level.queue_free()
		target_scene_node.set_collision_enabled(true)
		target_scene_node.connect("on_exit_entered", func (next_target_scene_path, next_area_node):
			self.call_deferred("switch_level", next_target_scene_path, next_area_node)
		)
		target_scene_node.connect("on_dead_entered", func ():
			self.call_deferred("on_dead"))
		$Character.get_node("StateManager").start()

func on_dead():
	$Character.get_node("StateManager").stop()
	var current_level = $LevelContainer.get_children()[0]
	$Character.position = current_level.get_node("InitialCharacterPos").position
	$Character.get_node("StateManager").reset()
	$Character.set_state("idle")
