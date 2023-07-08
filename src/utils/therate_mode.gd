extends Node
class_name TherateModeUtils

static func show(tree: SceneTree, config = {}):
	var default_config = {
		"size": 64,
		"duration": 1.0
	}
	config = ObjectUtils.assign(default_config, config)
	var tween_duration = config.duration
	var node = load("res://src/components/therate_mode_bar.tscn").instantiate()
	node.name = "TherateModeBar"
	node.visible = false
	node.get_node("TherateModeBar/VBoxContainer/ColorRect").custom_minimum_size = Vector2(config.size, config.size)
	node.get_node("TherateModeBar/VBoxContainer/ColorRect").size = Vector2(config.size, config.size)
	node.get_node("TherateModeBar/VBoxContainer2/ColorRect").custom_minimum_size = Vector2(config.size, config.size)
	node.get_node("TherateModeBar/VBoxContainer2/ColorRect").size = Vector2(config.size, config.size)
#	node.get_node("TherateModeBar/VBoxContainer").scale.y = 0
#	node.get_node("TherateModeBar/VBoxContainer2").scale.y = 0
	tree.root.add_child(node)
	await tree.create_timer(0.0).timeout
	var origin_y1 = node.get_node("TherateModeBar/VBoxContainer").position.y
	var origin_y2 = node.get_node("TherateModeBar/VBoxContainer2").position.y
	node.get_node("TherateModeBar/VBoxContainer").position.y -= config.size
	node.get_node("TherateModeBar/VBoxContainer2").position.y += config.size
	node.get_node("TherateModeBar/VBoxContainer").set_meta("leave_y", node.get_node("TherateModeBar/VBoxContainer").position.y)
	node.get_node("TherateModeBar/VBoxContainer2").set_meta("leave_y", node.get_node("TherateModeBar/VBoxContainer2").position.y)
	
	node.visible = true
	var tween = tree.root.create_tween()
	tween.set_parallel(true)
#	tween.tween_property(node.get_node("TherateModeBar/VBoxContainer"), "scale:y", 1, tween_duration)
#	tween.tween_property(node.get_node("TherateModeBar/VBoxContainer2"), "scale:y", 1, tween_duration)
	tween.tween_property(node.get_node("TherateModeBar/VBoxContainer"), "position:y", origin_y1, tween_duration)
	tween.tween_property(node.get_node("TherateModeBar/VBoxContainer2"), "position:y", origin_y2, tween_duration)
#	tween.tween_property(node.get_node("TherateModeBar/VBoxContainer2"), "position:y", origin_pos_y, tween_duration)
	
#	tween.tween_property(node.get_node("TherateModeBar/VBoxContainer/ColorRect"), "size:y", config.size, tween_duration)
#	tween.tween_property(node.get_node("TherateModeBar/VBoxContainer2/ColorRect"), "size:y", config.size, tween_duration)
#
	
static func close(tree: SceneTree, duration = 0.5):
	var tween_duration = duration
	var node = tree.root.find_child("TherateModeBar", true, false)
	if node == null:
		return
	var tween = tree.create_tween()
	tween.set_parallel(true)
	var origin_y1 = node.get_node("TherateModeBar/VBoxContainer").get_meta("leave_y")
	var origin_y2 = node.get_node("TherateModeBar/VBoxContainer2").get_meta("leave_y")
	tween.tween_property(node.get_node("TherateModeBar/VBoxContainer"), "position:y", origin_y1, tween_duration)
	tween.tween_property(node.get_node("TherateModeBar/VBoxContainer2"), "position:y", origin_y2, tween_duration)
#	tween.tween_property(node.get_node("TherateModeBar/VBoxContainer/ColorRect"), "size:y", 0, tween_duration)
#	tween.tween_property(node.get_node("TherateModeBar/VBoxContainer2/ColorRect"), "size:y", 0, tween_duration)
	await tween.finished
	node.queue_free()
