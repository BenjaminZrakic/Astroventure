extends Area2D

@onready var animated_sprite_2d = $AnimatedSprite2D

signal checkpoint_activated(global_position) 



func _on_body_entered(body):
	animated_sprite_2d.play("Active")
	emit_signal("checkpoint_activated")
