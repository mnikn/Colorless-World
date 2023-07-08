extends Node
class_name MethodUtils

# Throttle implementation
static func throttle(callback, delay: float, tree) -> int:
	var method = func ():
		var timer = tree.create_timer(delay)
		timer.connect("timeout", callback, Timer.CONNECT_ONE_SHOT)
	return method

# Debounce implementation
#var debounce_timers = {}
#
#func debounce(callback, key: String, delay: float) -> void:
#	if debounce_timers.has(key):
#		debounce_timers[key].stop()
#
#	var timer
#	if not debounce_timers.has(key):
#		timer = Timer.new()
#		timer.set_one_shot(true)
#		debounce_timers[key] = timer
#		add_child(timer)
#	else:
#		timer = debounce_timers[key]
#
#	timer.set_wait_time(delay)
#	timer.connect("timeout", (func ():
#		callback.call()
#		debounce_timers[key].queue_free()
#		debounce_timers.erase(key)), Timer.CONNECT_ONE_SHOT)
#	timer.start()
	

static func debounce(callback, delay: float, tree):
	var method = func ():
		var timer = tree.create_timer(delay)
		timer.connect("timeout", func ():
			callback.call(), Timer.CONNECT_ONE_SHOT)
	return method
