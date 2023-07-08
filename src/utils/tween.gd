extends Node
class_name TweenUtils

static func hide(target_node: Node, duration = 0.3, config = { "modulate" = true, "scale" = true, "origin_pivot" = false }):
	var tween = ObjectUtils.get_value(config, "tween", target_node.create_tween())
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_parallel(true)
	
	if ObjectUtils.get_value(config, "modulate", false):
		tween.tween_property(target_node, "modulate", Color("ffffff00"), duration)
	if ObjectUtils.get_value(config, "scale", false):
		if target_node is Control:
			tween.tween_property(target_node, "scale", Vector2(0.0, 0.0), duration)
			if not ObjectUtils.get_value(config, "origin_pivot", false):
				tween.tween_property(target_node, "pivot_offset", Vector2(target_node.size.x / 2, target_node.size.y / 2), duration)
		else:
			tween.tween_property(target_node, "scale", Vector2(0.0, 0.0), duration)
	await tween.finished
	return tween

static func hide_async(target_node: Node, duration = 0.3, config = { "modulate" = true, "scale" = true, tween = null }):
	var tween = ObjectUtils.get_value(config, "tween", target_node.create_tween())
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_parallel(true)
	
	if ObjectUtils.get_value(config, "modulate", false):
		tween.tween_property(target_node, "modulate", Color("ffffff00"), duration)
	if ObjectUtils.get_value(config, "scale", false):
		if target_node is Control:
			tween.tween_property(target_node, "scale", Vector2(0.0, 0.0), duration)
			if not ObjectUtils.get_value(config, "origin_pivot", false):
				tween.tween_property(target_node, "pivot_offset", Vector2(target_node.size.x / 2, target_node.size.y / 2), duration)
		else:
			tween.tween_property(target_node, "scale", Vector2(0.0, 0.0), duration)
	return tween

static func show(target_node: Node, duration = 0.3, config = { "modulate" = true, "scale" = true, tween = null, origin_pivot = false }) -> Variant:
	var tween = ObjectUtils.get_value(config, "tween", target_node.create_tween())
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_LINEAR)
	if ObjectUtils.get_value(config, "modulate", false):
		target_node.modulate = Color("ffffff00")
		tween.tween_property(target_node, "modulate", Color("ffffff"), duration)
	
	if ObjectUtils.get_value(config, "scale", false):
		if target_node is Control:
			target_node.scale = Vector2(0.0, 0.0)
			tween.tween_property(target_node, "scale", Vector2(1.0, 1.0), duration)
			if not ObjectUtils.get_value(config, "origin_pivot", false):
				target_node.pivot_offset = Vector2(target_node.size.x / 2, target_node.size.y / 2)
				tween.tween_property(target_node, "pivot_offset", Vector2(0.0, 0.0), duration)
		else:
			target_node.scale = Vector2(0.0, 0.0)
			tween.tween_property(target_node, "scale", Vector2(1.0, 1.0), duration)
	await tween.finished
	return tween

static func show_async(target_node: Node, duration = 0.3, config = { "modulate" = true, "scale" = true, tween = null, origin_pivot = false }) -> Variant:
	var tween = ObjectUtils.get_value(config, "tween", target_node.create_tween())
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_LINEAR)
	if ObjectUtils.get_value(config, "modulate", false):
		target_node.modulate = Color("ffffff00")
		tween.tween_property(target_node, "modulate", Color("ffffff"), duration)
	
	if ObjectUtils.get_value(config, "scale", false):
		if target_node is Control:
			target_node.scale = Vector2(0.0, 0.0)
			tween.tween_property(target_node, "scale", Vector2(1.0, 1.0), duration)
			if not ObjectUtils.get_value(config, "origin_pivot", false):
				target_node.pivot_offset = Vector2(target_node.size.x / 2, target_node.size.y / 2)
				tween.tween_property(target_node, "pivot_offset", Vector2(0.0, 0.0), duration)
		else:
			target_node.scale = Vector2(0.0, 0.0)
			tween.tween_property(target_node, "scale", Vector2(1.0, 1.0), duration)
	return tween

static func move(target_node, target_pos, config = {}):
	var default_config = { "duration": 0.2, "ease": Tween.EASE_IN, "trans": Tween.TRANS_LINEAR }
	var final_config = ObjectUtils.assign(default_config, config)
	var tween = target_node.create_tween()
	tween.set_ease(final_config.ease)
	tween.set_trans(final_config.trans)
	await tween.tween_property(target_node, "position", target_pos, final_config.duration)

static func lighten(target_node: Node, coff = 1.2, duration = 0.1):
	var tween = target_node.create_tween()
	tween.tween_property(target_node, "modulate", Color(coff, coff, coff, 1), duration)
	tween.set_trans(Tween.TRANS_LINEAR)
	await tween.finished

static func horizontal_fill(target_node: Node, color: Color, duration = 0.3):
#	if not "material" in target_node:
#		return
	var shader_material = ShaderMaterial.new()
	shader_material.shader = load("res://src/shaders/horizontal_fill.gdshader")
	shader_material.set_shader_parameter("range", 0.0)
	shader_material.set_shader_parameter("color", color)
	target_node.material = shader_material
	pass


static func audio_fade_out(stream_player: AudioStreamPlayer, duration = 2.0):
	var tween = stream_player.create_tween()
	var origin_volume = stream_player.volume_db
	tween.tween_property(stream_player, "volume_db", -100, duration)
	await tween.finished

static func audio_fade_in(stream_player, duration = 2.0):
	var tween = stream_player.create_tween()
	var origin_volume = stream_player.volume_db
	stream_player.volume_db = -100
	tween.tween_property(stream_player, "volume_db", origin_volume, duration)
	await tween.finished
