extends Node

var current_players = []

var volume = {
	"sound_effect": MusicUtils.volume_db_to_value(0),
	"bgm": MusicUtils.volume_db_to_value(0),
	"sound_effect_mute": false,
	"bgm_mute": false,
}

func play_bgm(path: String, fade_time = 0.0):
	var db = MusicUtils.value_to_volume_db(self.volume.bgm)
	var player = AudioStreamPlayer.new()
	player.volume_db = db if not self.volume.bgm_mute else -INF
	player.stream = ResourceManager.load_file(path)
	player.add_to_group("bgm_player")
	player.set_meta("type", "bgm")
	player.set_meta("id", UUID.generate())
	player.set_meta("path", path)
	player.set_meta("origin_volume", player.volume_db)
	self.add_child(player)
	player.play()
	if fade_time != 0:
		TweenUtils.audio_fade_in(player, fade_time)
	current_players.push_back(player)

func play_sound_effect(path: String):
	var db = MusicUtils.value_to_volume_db(self.volume.sound_effect)
	var player = AudioStreamPlayer.new()
	player.volume_db = db if not self.volume.sound_effect_mute else -INF
	player.stream = ResourceManager.load_file(path)
	player.add_to_group("sound_effect_player")
	player.set_meta("type", "sound_effect")
	player.set_meta("path", path)
	player.set_meta("id", UUID.generate())
	player.set_meta("origin_volume", player.volume_db)
	self.add_child(player)
	player.play()
	current_players.push_back(player)
	await player.finished
	self.remove_player_by_id(path, 0.0)

func play_sound_effect_without_finished(path: String, volume_db = 0):
	var db = MusicUtils.value_to_volume_db(self.volume.sound_effect)
	var player = AudioStreamPlayer.new()
	player.volume_db = db if not self.volume.sound_effect_mute else -INF
	player.stream = ResourceManager.load_file(path)
	player.set_meta("type", "sound_effect")
	player.set_meta("id", UUID.generate())
	player.set_meta("path", path)
	player.set_meta("origin_volume", player.volume_db)
	self.add_child(player)
	player.play()
	current_players.push_back(player)
	return player

func play_sound_effect_loop(path: String):
	var db = MusicUtils.value_to_volume_db(self.volume.sound_effect)
	var player = AudioStreamPlayer.new()
	player.stream = ResourceManager.load_file(path)
	player.volume_db = db if not self.volume.sound_effect_mute else -INF
	player.set_meta("type", "sound_effect")
	player.set_meta("id", UUID.generate())
	player.set_meta("path", path)
	player.set_meta("origin_volume", player.volume_db)
	self.add_child(player)
	player.play()
	current_players.push_back(player)
	return player

func get_player(path: String):
	var player = ArrayUtils.find(self.current_players, func (p): return p.get_meta("path") == path)
	return player
	
func remove_player(path: String, fade_time = 1.0):
	self.current_players = self.current_players.filter(func (p):
		if not p.is_queued_for_deletion() and p != null and p.get_meta("path") == path:
			if fade_time != 0:
				TweenUtils.audio_fade_out(p, fade_time)
				self.get_tree().create_timer(fade_time).connect("timeout", func ():
					p.queue_free())
			else:
				p.queue_free()
			return false
		return true)
		
func remove_player_by_node(node, fade_time = 1.0):
	self.current_players = self.current_players.filter(func (p):
		if not p.is_queued_for_deletion() and p != null and p == node:
			if fade_time != 0:
				TweenUtils.audio_fade_out(p, fade_time)
				self.get_tree().create_timer(fade_time).connect("timeout", func ():
					p.queue_free())
			else:
				p.queue_free()
			return false
		return true)

func remove_player_by_id(id: String, fade_time = 1.0):
	self.current_players = self.current_players.filter(func (p):
		if not p.is_queued_for_deletion() and p != null and p.get_meta("id") == id:
			if fade_time != 0:
				TweenUtils.audio_fade_out(p, fade_time)
				self.get_tree().create_timer(fade_time).connect("timeout", func ():
					p.queue_free())
			else:
				p.queue_free()
			return false
		return true)

func remove_all_players(fade_time = 5.0):
	for player in self.current_players:
		if fade_time != 0:
			TweenUtils.audio_fade_out(player, fade_time)
			self.get_tree().create_timer(fade_time).connect("timeout", func ():
				player.queue_free())
		else:
			player.queue_free()
	self.current_players = []

func remove_all_bgm_players(fade_time = 5.0):
	for player in self.current_players.filter(func (d): return d != null and d.get_meta("type") == "bgm"):
		if fade_time != 0:
			TweenUtils.audio_fade_out(player, fade_time)
			self.get_tree().create_timer(fade_time).connect("timeout", func ():
				player.queue_free())
		else:
			player.queue_free()
	self.current_players = []

func sync_volume_changed(settings):
	self.volume = ObjectUtils.assign(self.volume, settings)
	var bgm_val_db = MusicUtils.value_to_volume_db(self.volume.bgm)
	var sound_effect_db = MusicUtils.value_to_volume_db(self.volume.sound_effect)
	for player in get_tree().get_nodes_in_group("bgm_player"):
		player.volume_db = bgm_val_db if not self.volume.bgm_mute else -INF
	for player in get_tree().get_nodes_in_group("sound_effect_player"):
		player.volume_db = sound_effect_db if not self.volume.sound_effect_mute else -INF
