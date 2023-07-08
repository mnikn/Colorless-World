extends Area2D

@export var spike_interval = 1.0
@export var delay_start = 0.0

func _ready():
	await self.get_tree().create_timer(self.delay_start).timeout
	if self.spike_interval != 0:
		self.start_interval()


func start_interval():
	$Collision.disabled = false
	await self.get_tree().create_timer(self.spike_interval).timeout
	$Collision.disabled = true
	await self.get_tree().create_timer(self.spike_interval).timeout
	self.start_interval()

func _on_body_entered(body):
	self.get_parent().emit_signal("on_dead_entered")
