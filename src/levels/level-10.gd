extends "res://src/levels/base-level.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	if not GameManager.levels.hammer3:
		$Hammer.queue_free()
