extends "res://src/levels/base-level.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	$Enemy/Collision.disabled = GameManager.has_hammer
	if not GameManager.levels.red_enemy:
		$Enemy.queue_free()

func _on_touch_body_entered(body):
	GameManager.colors.red = true
	GameManager.levels.red_enemy = false
	await TweenUtils.hide($Enemy, 0.2, { "modulate": true })
	
