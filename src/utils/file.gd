extends Node
class_name FileUtils

static func read_json_file(path: String, password = ""):
	var file = null
	if len(password) > 0:
		file = FileAccess.open_encrypted(path, FileAccess.READ, password.to_utf8_buffer())
	else:
		file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		return null
	var content = file.get_as_text()
	var parser = JSON.new()
	var res = parser.parse(content)
	return parser.get_data()

static func write_json_file(path: String, data: Dictionary, password = ""):
	var file = null
	
	if len(password) > 0:
#		file = FileAccess.open_encrypted(path, FileAccess.WRITE_READ, password.to_utf8_buffer())
		file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE_READ, password)
#		print_debug(FileAccess.get_open_error())
#		file = FileAccess.open(path, FileAccess.WRITE_READ)
	else:
		file = FileAccess.open(path, FileAccess.WRITE_READ)
	var content = JSON.stringify(data, "  ")
	file.store_string(content)
	return content

static func exits_json_file(path: String):
	return FileAccess.file_exists(path)

static func delete_file(path: String):
#	var dir  DirAccess.new()
#	dir.remove(path)
	DirAccess.remove_absolute(path)


static func load_external_img(path):
	if path == null or len(path) <= 0:
		return null
	var f = FileAccess.open(path, FileAccess.READ)
	var buffer = f.get_buffer(f.get_length())
	f.close()
	var img := Image.new()
	var err = img.load_png_from_buffer(buffer)
	if err != 0:
		printerr("load img %s error" % path, err)
		return null
	
#	var text := ImageTexture.new()
	var text = ImageTexture.create_from_image(img)
	return text

static func convert_to_resource_path(path):
	if path == null:
		return ""
	var res = path
	res = res.replace("\\", "/")
	var game_name = "colorless-world"
	res = "res:/" + res.substr(res.find(game_name) + len(game_name))
	return res

static func read_dir(path):
	var files = []
	var dir = DirAccess.open(path)
	if not dir:
		return []
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files
