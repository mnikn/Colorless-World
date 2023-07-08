extends Area2D

@export_file("*.tscn") var target_scene: String
@export_enum("left", "right", "up", "down", "up_left", "up_right") var direction = "right"
