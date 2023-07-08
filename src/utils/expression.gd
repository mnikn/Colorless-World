extends Node
class_name ExpressionUtils

static func eval_async(code: String, inner_args = {}, outer_args = {}):
	var script = GDScript.new()
	var arg_str = ""
	for key in inner_args.keys():
		var val = inner_args[key]
		var val_str = val
		arg_str += "var %s = %s\n" % [key, val_str]
	arg_str = arg_str.substr(0, len(arg_str) - 1)
	script.source_code += \
"""
func do_action(context):
	%s
	%s
""".replacen("\t", "    ") % [arg_str.replacen("\n", "\n\t").replacen("\t", "    "), code.replacen("\n", "\n\t").replacen("\t", "    ")]
#	print_debug(arg_str, "\nff\n", script.source_code)
	script.reload()
	var instance = Resource.new()
	instance.set_script(script)
	var result = null
	result = instance.call("do_action", outer_args)
	return result

static func eval(code: String, inner_args = {}, outer_args = {}):
	if len(code) == 0:
		return
	var script = GDScript.new()
	var arg_str = ""
	for key in inner_args.keys():
		var val = inner_args[key]
		var val_str = val
		arg_str += "var %s = %s\n" % [key, val_str]
	arg_str = arg_str.substr(0, len(arg_str) - 1)
	script.source_code += \
"""
func do_action(context):
	%s
	%s
""".replacen("\t", "    ") % [arg_str.replacen("\n", "\n\t").replacen("\t", "    "), code.replacen("\n", "\n\t").replacen("\t", "    ")]
#	print_debug(arg_str, "\nff\n", script.source_code)
	script.reload()
	var instance = Resource.new()
	instance.set_script(script)
	var result = null
	result = await instance.call("do_action", outer_args)
	return result

static func eval_expression(code: String, inner_args = {}, outer_args = {}):
	var script = GDScript.new()
	var arg_str = ""
	for key in inner_args.keys():
		var val = inner_args[key]
		var val_str = val
		arg_str += "var %s = %s\n" % [key, val_str]
	script.source_code += \
"""
func do_action(context):
	%s
	return %s
""" % [arg_str.replacen("\n", "\n\t"), code.replacen("\n", "\n\t")]
#	print_debug(script.source_code)
#	print_debug(outer_args)
	script.reload()
	var instance = Resource.new()
	instance.set_script(script)
	var result = instance.call("do_action", outer_args)
	return result

