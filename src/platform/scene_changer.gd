extends Node
signal after_scene_changed()
var scene
var is_changing = false

#const CombatScene = preload("res://src/modules/combat/combat.tscn")

var default_change_scene_options = {
	"color": Color("#000000"),
	"before_change_speed": 0.5,
	"change_wait_time": 1.0,
	"after_change_speed": 0.5,
	"remove_bgm": true,
	"change_scene_sound_effect": null,
	"story_next": true
}

func _ready():
#	$ColorRect.size = Vector2(0,0)
	$ColorRect.set_deferred("size", Vector2(1280, 720))
	$ColorRect.color = Color(255,255,255,0)
	$ColorRect.visible = false
	
func change_scene(target_scene: String, options = default_change_scene_options):
	self.is_changing = true
	options = ObjectUtils.assign(default_change_scene_options, options)
	if options.remove_bgm:
		SoundManager.remove_all_bgm_players()
	if options.change_scene_sound_effect:
		SoundManager.play_sound_effect(options.change_scene_sound_effect)
	var final_options = ObjectUtils.assign(default_change_scene_options, options)
	var tween = self.create_tween()
	tween.set_parallel(true)
	SceneChanger.get_node("ColorRect").color = Color(final_options.color.r, final_options.color.g, final_options.color.b, 0)
	SceneChanger.get_node("ColorRect").visible = true
	tween.tween_property(self.get_node("ColorRect"), "color", final_options.color, final_options.before_change_speed)
#	tween.tween_property(self.get_node("ColorRect"), "size", Vector2(1280, 720), final_options.before_change_speed)
	await tween.finished
	self._do_change_scene(target_scene)
	
	await self.get_tree().create_timer(final_options.change_wait_time).timeout
	
	tween = self.create_tween()
	tween.tween_property(SceneChanger.get_node("ColorRect"), "color", Color(0,0,0,0), final_options.after_change_speed)
	await tween.finished
	SceneChanger.get_node("ColorRect").visible = false
	
#	await self.get_tree().create_timer(0.5).timeout
	self.emit_signal("after_scene_changed")
	self.is_changing = false

func tween_screen_color(options = default_change_scene_options):
	var final_options = ObjectUtils.assign(default_change_scene_options, options)
	var tween = self.create_tween()
	tween.set_parallel(true)
	SceneChanger.get_node("ColorRect").color = Color(final_options.color.r, final_options.color.g, final_options.color.b, 0)
	SceneChanger.get_node("ColorRect").visible = true
	tween.tween_property(self.get_node("ColorRect"), "color", final_options.color, final_options.before_change_speed)
	tween.tween_property(self.get_node("ColorRect"), "size", Vector2(1280, 720), final_options.before_change_speed)
	await tween.finished
	
	await self.get_tree().create_timer(final_options.change_wait_time).timeout
	tween = self.create_tween()
	tween.tween_property(SceneChanger.get_node("ColorRect"), "color", Color(0,0,0,0), final_options.after_change_speed)
	await tween.finished
	SceneChanger.get_node("ColorRect").visible = false

func light_flash():
	await self.tween_screen_color({
		"color": Color("#ffffff"),
		"before_change_speed": 0.02,
		"change_wait_time": 0.0,
		"after_change_speed": 0.02
	})
	await self.tween_screen_color({
		"color": Color("#ffffff00"),
		"before_change_speed": 0.02,
		"change_wait_time": 0.0,
		"after_change_speed": 0.02
	})

func _do_change_scene(target_scene: String):
	self.scene = target_scene
	TherateModeUtils.close(self.get_tree())
	self._next_scene()

func _next_scene():
	self.get_tree().change_scene_to_file(scene)
	await self.get_tree().root.child_entered_tree
	self.emit_signal("after_scene_changed")
