extends Node

const SHAKE_LEVEL = {
	"light": 1,
	"normal": 3,
	"heavy": 7
}

const SHAKE_TIME = {
	"quick": 10,
	"medium": 20,
	"slow": 40,
	"long": 150,
	"forever": INF
}

var SHAKE_LEVEL_LIMIT = {
	"light": 5,
	"normal": 10,
	"heavy": 30
}

var default_shake_options = {
	"type": "both", # horz, vertical, both
	"level": "light", # light, normal, heavy
	"time": "quick" # quick, medium, slow
}

var is_shaking = false
func shake(target_node, options):
	self.is_shaking = true
	if not target_node is Array:
		target_node = [target_node] 
	var before_shake_pos = target_node.map(func (item): return item.position)
	var final_options = ObjectUtils.assign(default_shake_options, options)
	var shake_count = SHAKE_TIME[final_options.time]
	await self.do_shake(target_node, final_options, { "shake_count": shake_count, "limit": SHAKE_LEVEL_LIMIT[final_options.level] })
	
	var tween = self.create_tween()
	tween.set_parallel(true)
	for i in range(len(target_node)):
		var node = target_node[i]
		var before_pos = before_shake_pos[i]
		tween.tween_property(node, "position", before_pos, 0.2)
	await tween.finished
	self.is_shaking = false
#	target_node.position = before_shake_pos

func stop_shake():
	self.is_shaking = false

func do_shake(target_node, options, shake_data):
	if shake_data.shake_count <= 0 or not self.is_shaking:
		return
	var xshake_anmout = 0
	var yshake_anmout = 0
	
	if options.type == "horz":
		xshake_anmout = SHAKE_LEVEL[options.level]
	elif options.type == "both":
		xshake_anmout = SHAKE_LEVEL[options.level]
		yshake_anmout = SHAKE_LEVEL[options.level]
	elif options.type == "vert":
		yshake_anmout = SHAKE_LEVEL[options.level]
	
	var xshake = randf_range(-xshake_anmout, xshake_anmout)
	var yshake = randf_range(-yshake_anmout, yshake_anmout)
	
	if abs(ObjectUtils.get_value(shake_data, "xshake_num", 0) + xshake) > shake_data.limit:
		xshake = 0
	if abs(ObjectUtils.get_value(shake_data, "yshake_num", 0) + yshake) > shake_data.limit:
		yshake = 0
	
	ObjectUtils.set_value(shake_data, "xshake_num", ObjectUtils.get_value(shake_data, "xshake_num", 0) + xshake)
	ObjectUtils.set_value(shake_data, "yshake_num", ObjectUtils.get_value(shake_data, "yshake_num", 0) + yshake)
	
	for node in target_node:
		if node != null and not node.is_queued_for_deletion():
			node.position = Vector2(node.position.x + xshake, node.position.y + yshake)
	shake_data.shake_count -= 1
	
#		yield(target_node.get_tree().create_timer(0.001), "timeout")
	var timer = self.get_tree().create_timer(0.001)
	await timer.timeout
	await self.do_shake(target_node, options, shake_data)
