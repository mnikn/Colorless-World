extends Node
class_name MusicUtils

# 将 volume_db 映射到 [0-1] 的值
static func volume_db_to_value(volume_db):
	var value = pow(10, (volume_db - 6) / 20.0)
	return value

# 从 [0-1] 的值中映射为 volume_db
static func value_to_volume_db(value):
	if value == 0:
		return -INF
	else:
		var volume_db = log(value) / log(10) * 20.0 + 6
		return volume_db
