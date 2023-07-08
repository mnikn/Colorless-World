extends "res://src/levels/base-level.gd"

func _ready():
	super._ready()
	$Enemy/Collision.disabled = GameManager.has_hammer
	if not GameManager.levels.blue_enemy:
		$Enemy.queue_free()

func _on_touch_body_entered(body):
	GameManager.colors.blue = true
	GameManager.levels.blue_enemy = false
	await TweenUtils.hide($Enemy, 0.2, { "modulate": true })
