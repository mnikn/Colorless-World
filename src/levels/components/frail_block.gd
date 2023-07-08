extends Area2D

@export var broken_time = 2.0
@export var recover_time = 2.0

var start_broken_count = false
var current_broken_count = 0
var is_broking = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Collision.shape.size.x = $Skin/StaticBody2D/Collision.shape.size.x - 10
	$Collision.shape.size.y = $Skin/StaticBody2D/Collision.shape.size.y + 10
#	$Collision.shape.position.y = $Skin/StaticBody2D/Collision.shape.size.y + 20

func _process(delta):
	if self.is_broking or not self.start_broken_count:
		return
	if self.start_broken_count:
		self.current_broken_count += delta
		
	if current_broken_count >= broken_time:
		self.start_broken()

func _on_body_entered(body):
	self.start_broken_count = true
#	$Collision.disabled = true
	$Collision.set_deferred("disabled", true)

func start_broken():
	self.is_broking = true
	$Skin/StaticBody2D/Collision.disabled = true
	$Skin.visible = false
	self.start_broken_count = false
	self.current_broken_count = 0
	self.is_broking = false
	await self.get_tree().create_timer(self.recover_time).timeout
	self.start_recover()
	
func start_recover():
	$Skin.visible = true
	$Collision.disabled = false
	$Skin/StaticBody2D/Collision.disabled = false
#	self.queue_free()
