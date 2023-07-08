extends Node
class_name AbilityUtils

const DIFFICULT_LEVELS = {
	"easy": {
		"match_level": 6,
		"match_rate": 0.9,
		"unmatch_rate": 0.6
	},
	"normal": {
		"match_level": 8,
		"match_rate": 0.7,
		"unmatch_rate": 0.4
	},
	"hard": {
		"match_level": 10,
		"match_rate": 0.5,
		"unmatch_rate": 0.2
	},
	"impossible": {
		"match_level": 12,
		"match_rate": 0.3,
		"unmatch_rate": 0.05
	}
}

static func is_ability_pass(ability_num, level: String) -> bool:
	var level_item = DIFFICULT_LEVELS[level]
	var final_rate = 0
	if ability_num >= level_item.match_level:
		final_rate = level_item.match_rate + (ability_num - level_item.match_level) / 2 * 0.1
	else:
		final_rate = level_item.unmatch_rate - (level_item.match_level - ability_num - 2) / 2 * 0.1
	print_debug("[ability_check]:", "final-rate:%s" % final_rate, " ability-num: %s" % ability_num, " level-item: %s" % level_item)
	return RandomUtils.dice(final_rate)
