extends Node
class_name NodeUtils

static func clear_children(node: Node):
	for child in node.get_children():
		child.queue_free()

static func get_all_children(node: Node):
	var arr = []
	_do_get_all_children(node, arr)
	return arr
	

static func _do_get_all_children(node: Node, arr: Array):
	if node == null:
		return arr
	arr.push_back(node)
	for child in node.get_children():
		_do_get_all_children(child, arr)
	return arr

static func get_control_children(node: Node, arr: Array):
	if node == null:
		return arr
	for child in node.get_children():
		if child is Control:
			arr.push_back(child)
		if child.get_child_count() > 0:
			get_control_children(child, arr)
	return arr

static func children_ready(node):
	for child_node in node.get_children():
		await child_node.ready
	await node.get_tree().create_timer(0.00001).timeout
