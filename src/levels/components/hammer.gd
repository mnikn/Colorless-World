extends Area2D

@export var hammer_id = "hammer1"

func _on_body_entered(body):
	if GameManager.has_hammer:
		return
	self.set_deferred("monitoring", false)
	await TweenUtils.hide(self, 0.2, { "modulate": true, "scale": true })
	self.queue_free()
	GameManager.has_hammer = true
	GameManager.levels[hammer_id] = false
	
