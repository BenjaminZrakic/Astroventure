extends Area2D

@onready var animated_sprite_2d = $AnimatedSprite2D

signal checkpoint_activated(new_position) 



func _on_body_entered(body):
	animated_sprite_2d.play("Active")
	checkpoint_activated.emit(global_position)
