extends "res://src/levels/base-level.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	if not GameManager.levels.green_enemy:
		$Enemy.queue_free()
	if not GameManager.levels.hammer2:
		$Hammer.queue_free()

func _process(delta):
	if self.has_node("Enemy"):
		$Enemy/Collision.disabled = GameManager.has_hammer

func _on_touch_body_entered(body):
	GameManager.colors.green = true
	GameManager.levels.green_enemy = false
	await TweenUtils.hide($Enemy, 0.2, { "modulate": true })
	
